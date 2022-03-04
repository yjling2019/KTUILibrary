//
//  VVTabBarController.m
//  VOVA
//
//  Created by fwzhou on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVTabBarController.h"
#import "VVTabBar.h"
//#import <vv_rootlib_ios/NSArray+DataProtect.h>
//#import <vv_rootlib_ios/VVColorManager.h>

@interface VVTabBarController () <VVTabBarDelegate>

@property (nonatomic, strong) VVTabBar *vvTabBar;

@property (nonatomic, strong) NSArray<__kindof UIViewController *> *vcs;

@end

@implementation VVTabBarController

@synthesize selectedIndex = _selectedIndex;

- (instancetype)init
{
	if (self = [super init]) {
		_selectedIndex = 0;
	}
	return self;
}

- (void)refreshWithViewControllers:(NSArray<__kindof UIViewController *> *)vcs
                      tabBarModels:(NSArray<VVTabBarModel *> *)tabBarModels
                 middleTabBarModel:(nullable VVMiddleTabBarModel *)middleTabBarModel
                 tabBarConfigModel:(VVTabBarConfigModel *)tabBarConfigModel
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
    
    [self.vvTabBar removeFromSuperview];
    self.vvTabBar = [[VVTabBar alloc] initWithTabBarModels:tabBarModels middleTabBarModel:middleTabBarModel tabBarConfigModel:tabBarConfigModel];
    self.vvTabBar.tabBarDelegate = self;
    
    [self setUpVVTabBar];
    
    [self setUpViewControllers];
    
    if (originSelectedVC) {
        [self selectedIndexWithClassName:originSelectedVC.class];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
#warning TODO 0303
//    self.view.backgroundColor = [VVColorManager colorWithLightColor:@"#ffffff" darkColor:@"#101112"];
}

- (void)setUpVVTabBar
{
    [self setValue:self.vvTabBar forKeyPath:@"tabBar"];
    
    // translucent会引起页面大小变化
    self.vvTabBar.translucent = false;
    
    [self.vvTabBar refreshUI];
}

- (void)setUpViewControllers
{
    [self.vcs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [self externClassNameViewController:obj];
        SEL getSelector = NSSelectorFromString(@"vv_tabBarController");
        SEL setSelector = NSSelectorFromString(@"setVv_tabBarController:");
        if ([vc conformsToProtocol:@protocol(VVTabBarProtocol)] &&
            [vc respondsToSelector:getSelector] &&
            [vc respondsToSelector:setSelector]) {
            id<VVTabBarProtocol> tabBarProtocol = (id<VVTabBarProtocol>)vc;
            tabBarProtocol.vv_tabBarController = self;
        }
    }];
    self.viewControllers = self.vcs;
}

#pragma mark - VVTabBarDelegate
- (void)selectedIndex:(NSUInteger)selectedIndex tabBar:(VVTabBar *)tabBar
{
    self.selectedIndex = selectedIndex;
}

- (void)middleSelected:(VVTabBar *)tabBar
{
    if (self.middleDelegate &&
        [self.middleDelegate respondsToSelector:@selector(tabBarMiddleSelect:)]) {
        [self.middleDelegate tabBarMiddleSelect:self];
    }
}

#pragma mark - 设置selectedIndex
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self.vvTabBar refreshSelectedIndex:selectedIndex];
    
    UIViewController *originVC = [self.vcs objectAtIndex:self.selectedIndex];
    originVC = [self externClassNameViewController:originVC];
    
    UIViewController *selectedVC = [self.vcs objectAtIndex:selectedIndex];
    selectedVC = [self externClassNameViewController:selectedVC];
    
    if ([selectedVC conformsToProtocol:@protocol(VVTabBarSelectProtocol)]) {
        id<VVTabBarSelectProtocol> tabBarProtocol = (id<VVTabBarSelectProtocol>)selectedVC;
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
            [self.vvTabBar tabBarSelectedIndex:idx];
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
    [self.vvTabBar middleSelected];
}

/// 刷新某个tab的ui
/// @param className 类名
/// @param block 返回的VVTabBarBaseModel
- (void)refreshTabBarWithClassName:(Class)className
                             block:(void(^)(__kindof VVTabBarBaseModel *tabBarModel))block
{
    [self.vcs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [self externClassNameViewController:obj];
        if ([vc isKindOfClass:className]) {
            if (block) {
                __kindof VVTabBarBaseModel *tabBarModel = [self.vvTabBar tabBarModel:idx];
                block(tabBarModel);
                [self.vvTabBar refreshUI];
            }
            *stop = YES;
        }
    }];
}

/// 刷新中间按钮的ui
/// @param block 返回VVMiddleTabBarModel
- (void)refreshMiddleTabBarButtonWithBlock:(void(^)(VVMiddleTabBarModel *tabBarModel))block
{
    if (block) {
        block(self.vvTabBar.middleTabBarModel);
        [self.vvTabBar refreshUI];
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
            [self.vvTabBar addRedPointView:redPointView index:idx];
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
            view = [self.vvTabBar getRedPointViewWithIndex:idx];
            *stop = YES;
        }
    }];
    return view;
}

/// 中间按钮加红点
/// @param redPointView 红点视图
- (void)addMiddleRedPointView:(UIView *)redPointView
{
    [self.vvTabBar addMiddleRedPointView:redPointView];
}

/// 获取中间按钮红点
- (void)getMiddleRedPointView
{
    [self.vvTabBar getMiddleRedPointView];
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
