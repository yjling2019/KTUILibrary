//
//  KTTabBarController.m
//  KOTU
//
//  Created by KOTU on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTTabBarController.h"
#import "KTTabBar.h"

@interface KTTabBarController () <KTTabBarDelegate>

@property (nonatomic, strong) KTTabBar *kt_tabBar;

@property (nonatomic, strong) NSArray<__kindof UIViewController *> *vcs;

@end

@implementation KTTabBarController

@synthesize selectedIndex = _selectedIndex;

- (instancetype)init
{
	if (self = [super init]) {
		_selectedIndex = 0;
	}
	return self;
}

- (void)refreshWithViewControllers:(NSArray<__kindof UIViewController *> *)vcs
                      tabBarModels:(NSArray<KTTabBarModel *> *)tabBarModels
                 middleTabBarModel:(nullable KTMiddleTabBarModel *)middleTabBarModel
                 tabBarConfigModel:(KTTabBarConfigModel *)tabBarConfigModel
{
#if DEBUG
    NSAssert(tabBarModels.count > 0, @"tabbar数量必需大于0");
    NSAssert(vcs.count > 0, @"至少传一个viewController");
#endif
    if (middleTabBarModel.increaseIndex) {
        if (tabBarModels.count + 1 != vcs.count) {
#if DEBUG
            NSAssert(NO, @"中间按钮影响index，需保证tabBarModels数量+1=vcs的数量");
#endif
            middleTabBarModel.increaseIndex = NO;
        }
    } else {
#if DEBUG
        NSAssert(tabBarModels.count == vcs.count, @"中间按钮不影响index，需保证tabBarModels数量=vcs的数量");
#endif
    }
    
    UIViewController *originSelectedVC = nil;
    if (self.vcs) {
        UIViewController *tempSelectedVC = [self externClassNameViewController:[self.vcs objectAtIndex:self.selectedIndex]];
        for (UIViewController *vc in vcs) {
            UIViewController *selectedVC = [self externClassNameViewController:vc];
            if ([NSStringFromClass(selectedVC.class) isEqualToString:NSStringFromClass(tempSelectedVC.class)]) {
                // 重建tab选中原来选中的vc
                originSelectedVC = tempSelectedVC;
                break;
            }
        }
    }
    
    self.vcs = vcs;
    
    [self.kt_tabBar removeFromSuperview];
    self.kt_tabBar = [[KTTabBar alloc] initWithTabBarModels:tabBarModels middleTabBarModel:middleTabBarModel tabBarConfigModel:tabBarConfigModel];
    self.kt_tabBar.tabBarDelegate = self;
    
    [self setUpKTTabBar];
    
    [self setUpViewControllers];
    
    if (originSelectedVC) {
        [self selectedIndexWithClassName:originSelectedVC.class];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
#warning TODO 0303
//    self.view.backgroundColor = [KTColorManager colorWithLightColor:@"#ffffff" darkColor:@"#101112"];
}

- (void)setUpKTTabBar
{
    [self setValue:self.kt_tabBar forKeyPath:@"tabBar"];
    
    // translucent会引起页面大小变化
    self.kt_tabBar.translucent = false;
    
    [self.kt_tabBar refreshUI];
}

- (void)setUpViewControllers
{
    [self.vcs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [self externClassNameViewController:obj];
        SEL getSelector = NSSelectorFromString(@"kt_tabBarController");
        SEL setSelector = NSSelectorFromString(@"setVv_tabBarController:");
        if ([vc conformsToProtocol:@protocol(KTTabBarProtocol)] &&
            [vc respondsToSelector:getSelector] &&
            [vc respondsToSelector:setSelector]) {
            id<KTTabBarProtocol> tabBarProtocol = (id<KTTabBarProtocol>)vc;
            tabBarProtocol.kt_tabBarController = self;
        }
    }];
    self.viewControllers = self.vcs;
}

#pragma mark - KTTabBarDelegate
- (void)selectedIndex:(NSUInteger)selectedIndex tabBar:(KTTabBar *)tabBar
{
    self.selectedIndex = selectedIndex;
}

- (void)middleSelected:(KTTabBar *)tabBar
{
    if (self.middleDelegate &&
        [self.middleDelegate respondsToSelector:@selector(tabBarMiddleSelect:)]) {
        [self.middleDelegate tabBarMiddleSelect:self];
    }
}

#pragma mark - 设置selectedIndex
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self.kt_tabBar refreshSelectedIndex:selectedIndex];
    
    UIViewController *originVC = [self.vcs objectAtIndex:self.selectedIndex];
    originVC = [self externClassNameViewController:originVC];
    
    UIViewController *selectedVC = [self.vcs objectAtIndex:selectedIndex];
    selectedVC = [self externClassNameViewController:selectedVC];
    
    if ([selectedVC conformsToProtocol:@protocol(KTTabBarSelectProtocol)]) {
        id<KTTabBarSelectProtocol> tabBarProtocol = (id<KTTabBarSelectProtocol>)selectedVC;
        BOOL shouldSelect = YES;
        if ([tabBarProtocol respondsToSelector:@selector(tabBarController:originSelectViewController:shouldSelectViewController:)]) {
            shouldSelect = [tabBarProtocol tabBarController:self
                  originSelectViewController:originVC
                     shouldSelectViewController:selectedVC];
        }
        
        if (shouldSelect) {
            [super setSelectedIndex:selectedIndex];
            
            if ([tabBarProtocol respondsToSelector:@selector(tabBarController:originSelectViewController:didSelectViewController:)]) {
                [tabBarProtocol tabBarController:self
                      originSelectViewController:originVC
                         didSelectViewController:selectedVC];
            }
        }
    } else {
        [super setSelectedIndex:selectedIndex];
    }
}

#pragma mark - 外部调用
/// 选中某个tab
/// @param className 类名
- (void)selectedIndexWithClassName:(Class)className
{
#if DEBUG
    __block BOOL selectedSuccess = false;
#endif
    [self.vcs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [self externClassNameViewController:obj];
        if ([vc isKindOfClass:className]) {
            [self.kt_tabBar tabBarSelectedIndex:idx];
#if DEBUG
            selectedSuccess = true;
#endif
            *stop = YES;
        }
    }];
#if DEBUG
    NSAssert(selectedSuccess, @"类名错误");
#endif
}

/// 中间按钮选择
/// 如果中间按钮影响tabBar的index个数，可以调用selectedIndexWithClassName来切换tab
- (void)middleSelected
{
    [self.kt_tabBar middleSelected];
}

/// 刷新某个tab的ui
/// @param className 类名
/// @param block 返回的KTTabBarBaseModel
- (void)refreshTabBarWithClassName:(Class)className
                             block:(void(^)(__kindof KTTabBarBaseModel *tabBarModel))block
{
    [self.vcs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [self externClassNameViewController:obj];
        if ([vc isKindOfClass:className]) {
            if (block) {
                __kindof KTTabBarBaseModel *tabBarModel = [self.kt_tabBar tabBarModel:idx];
                block(tabBarModel);
                [self.kt_tabBar refreshUI];
            }
            *stop = YES;
        }
    }];
}

/// 刷新中间按钮的ui
/// @param block 返回KTMiddleTabBarModel
- (void)refreshMiddleTabBarButtonWithBlock:(void(^)(KTMiddleTabBarModel *tabBarModel))block
{
    if (block) {
        block(self.kt_tabBar.middleTabBarModel);
        [self.kt_tabBar refreshUI];
    }
}

/// 某个tab加红点
/// @param className 类名
/// @param redPointView 红点视图
- (void)addRedPointViewWithClassName:(Class)className
                        redPointView:(UIView *)redPointView
{
    [self.vcs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [self externClassNameViewController:obj];
        if ([vc isKindOfClass:className]) {
            [self.kt_tabBar addRedPointView:redPointView index:idx];
            *stop = YES;
        }
    }];
}

/// 获取某个tab红点
/// @param className 类名
- (UIView *)getRedPointViewWithClassName:(Class)className
{
    __block UIView *view = nil;
    [self.vcs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [self externClassNameViewController:obj];
        if ([vc isKindOfClass:className]) {
            view = [self.kt_tabBar getRedPointViewWithIndex:idx];
            *stop = YES;
        }
    }];
    return view;
}

/// 中间按钮加红点
/// @param redPointView 红点视图
- (void)addMiddleRedPointView:(UIView *)redPointView
{
    [self.kt_tabBar addMiddleRedPointView:redPointView];
}

/// 获取中间按钮红点
- (void)getMiddleRedPointView
{
    [self.kt_tabBar getMiddleRedPointView];
}

/// 获取当前选中tab
- (UIViewController *)getSelectedIndexFirstViewController
{
    UIViewController *vc = [self.vcs objectAtIndex:self.selectedIndex];
    vc = [self externClassNameViewController:vc];
    return vc;
}

/// 获取某个tab
/// @param className 类名
- (UIViewController *)getViewControllerWithClassName:(Class)className
{
    __block UIViewController *viewController = nil;
    [self.vcs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [self externClassNameViewController:obj];
        if ([vc isKindOfClass:className]) {
            viewController = vc;
            *stop = YES;
        }
    }];
    return viewController;
}

#pragma mark - 获取tabBar的“第一个”UIViewController
- (UIViewController *)externClassNameViewController:(__kindof UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        return nav.viewControllers.firstObject;
    } else {
        return viewController;
    }
}

#pragma mark - 隐藏tabBar
- (void)tabbarHidden:(BOOL)hidden animated:(BOOL)animation
{
    // TODO: 隐藏tabBar待实现
}

- (void)dealloc
{
    
}

@end
