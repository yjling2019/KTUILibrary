//
//  VVTabBar.m
//  VOVA
//
//  Created by fwzhou on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVTabBar.h"
#import "VVTabBarConfigModel.h"
#import "VVTabBarModel.h"
#import "VVMiddleTabBarModel.h"
#import "VVTabBarBaseButton.h"
#import "VVTabBarButton.h"
#import "VVMiddleTabBarButton.h"
#import "VVTabBarBackgroundView.h"
//#import <vv_rootlib_ios/VVDataHelper.h>
#import <Masonry/Masonry.h>
//#import <vv_rootlib_ios/VVDeviceUtils.h>

@interface VVTabBar ()

@property (nonatomic, strong) VVTabBarBackgroundView *backgroundView;

@property (nonatomic, strong) NSArray<__kindof VVTabBarBaseModel *> *tabBarModels;

@property (nonatomic, strong) __kindof VVMiddleTabBarModel *middleTabBarModel;

@property (nonatomic, strong) VVTabBarConfigModel *tabBarConfigModel;

@property (nonatomic, strong) NSMutableArray<__kindof VVTabBarBaseButton *> *buttons;

@property (nonatomic, strong) __kindof VVMiddleTabBarButton *middleButton;

@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation VVTabBar

- (instancetype)initWithTabBarModels:(NSArray<__kindof VVTabBarBaseModel *> *)tabBarModels
                   middleTabBarModel:(nullable __kindof VVMiddleTabBarModel *)middleTabBarModel
                   tabBarConfigModel:(VVTabBarConfigModel *)tabBarConfigModel
{
    self = [super init];
    if (self) {
        self.tabBarConfigModel = tabBarConfigModel;
        
        if (middleTabBarModel) {
#if DEBUG
            NSAssert(middleTabBarModel.className, @"middleTabBarModel未设置className");
#endif
            if (!middleTabBarModel.className) {
                middleTabBarModel.className = [VVMiddleTabBarButton class];
            }
        }
        [tabBarModels enumerateObjectsUsingBlock:^(__kindof VVTabBarBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#if DEBUG
            NSAssert(obj.className, @"VVTabBarBaseModel未设置className");
#endif
            if (!obj.className) {
                obj.className = [VVTabBarButton class];
            }
        }];
        
        if (middleTabBarModel &&
            middleTabBarModel.increaseIndex) {
            // 中间按钮的位置
            NSUInteger middleIndex = tabBarModels.count / 2;
            NSMutableArray<__kindof VVTabBarBaseModel *> *mTabBarModels = tabBarModels.mutableCopy;
            // 中间按钮影响tabbar的index，插入中间按钮
            [mTabBarModels insertObject:middleTabBarModel atIndex:middleIndex];
            self.tabBarModels = mTabBarModels.copy;
#if DEBUG
            NSAssert(self.tabBarModels.count <= 5, @"tabBar上button的数量应该少于5");
#endif
        } else {
            // 中间按钮不影响tabbar的index
            self.tabBarModels = tabBarModels;
            if (middleTabBarModel) {
#if DEBUG
                NSAssert(self.tabBarModels.count <= 4, @"tabBar上button的数量应该少于5");
#endif
            } else {
#if DEBUG
                NSAssert(self.tabBarModels.count <= 5, @"tabBar上button的数量应该少于5");
#endif
            }
        }
        self.middleTabBarModel = middleTabBarModel;
        self.selectedIndex = 0;
    }
    
    [self setUpUI];
    [self setUpConstraints];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self bindUIActions];
    [self refreshUI];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:VVTabBarBaseButton.class] ||
            [subView isKindOfClass:VVTabBarBackgroundView.class]) {
            continue;
        }
        [subView removeFromSuperview];
    }
    
    [self setUpConstraints];
}

- (void)setUpUI
{
    [self addSubview:self.backgroundView];
    
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.tabBarModels.count];
    [self.tabBarModels enumerateObjectsUsingBlock:^(__kindof VVTabBarBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.selectedIndex) {
            // 选中
            obj.selected = YES;
        }
        if ([obj isKindOfClass:[self.middleTabBarModel class]]) {
            // 中间按钮影响tabbar的index
            [self addSubview:self.middleButton];
            [self.buttons addObject:self.middleButton];
        } else {
            __kindof VVTabBarButton *barButton = [VVTabBarBaseButton configTabBarButtonWithModel:obj];
            [self addSubview:barButton];
            [self.buttons addObject:barButton];
        }
    }];
    
    if (self.middleTabBarModel &&
        !self.middleTabBarModel.increaseIndex) {
        [self addSubview:self.middleButton];
    }
}

- (void)setUpConstraints
{
    // 除中间按钮的按钮总个数
    NSUInteger excludeMiddleCount;
    if (self.middleTabBarModel &&
        self.middleTabBarModel.increaseIndex) {
        excludeMiddleCount = self.tabBarModels.count - 1;
    } else {
        excludeMiddleCount = self.tabBarModels.count;
    }
    NSUInteger middleIndex = excludeMiddleCount / 2;
    
    CGFloat screen_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat bottomSafeAreaHeight = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    CGFloat tabBarWidth;
    CGFloat middleWidth;
    if (self.middleTabBarModel) {
        // 有中间按钮
        tabBarWidth = (screen_w - self.middleTabBarModel.width) / (excludeMiddleCount > 0 ? excludeMiddleCount : 4);

        CGFloat height = CGRectGetHeight(self.frame) - bottomSafeAreaHeight + self.middleTabBarModel.convexHeight;
        
        self.middleButton.frame = CGRectMake(middleIndex * tabBarWidth,
                                             -self.middleTabBarModel.convexHeight,
                                             self.middleTabBarModel.width,
                                             height);
        middleWidth = self.middleTabBarModel.width;
    } else {
        tabBarWidth = screen_w / (excludeMiddleCount > 0 ? excludeMiddleCount : 4);
        middleWidth = 0;
    }
    
    __block NSUInteger index = 0;
    [self.buttons enumerateObjectsUsingBlock:^(__kindof VVTabBarBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[self.middleButton class]]) {
            CGFloat height = CGRectGetHeight(self.frame) - bottomSafeAreaHeight;
            if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
                if (index >= middleIndex) {
                    obj.frame = CGRectMake(index * tabBarWidth + middleWidth, 0, tabBarWidth, height);
                } else {
                    obj.frame = CGRectMake(index * tabBarWidth, 0, tabBarWidth, height);
                }
            } else {
                if (index >= middleIndex) {
                    obj.frame = CGRectMake(screen_w - (index * tabBarWidth + middleWidth) - tabBarWidth, 0, tabBarWidth, height);
                } else {
                    obj.frame = CGRectMake(screen_w - index * tabBarWidth - tabBarWidth, 0, tabBarWidth, height);
                }
            }
            index = index + 1;
        } else {
            // 跳过中间按钮的frame设置
        }
    }];
}

- (void)bindUIActions
{
    [self.buttons enumerateObjectsUsingBlock:^(__kindof VVTabBarBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTarget:self action:@selector(tabBarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    if (self.middleTabBarModel &&
        !self.middleTabBarModel.increaseIndex) {
        [self.middleButton addTarget:self action:@selector(middleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)tabBarButtonTapped:(VVTabBarBaseButton *)tabBarButton
{
    // 当前选中按钮
    NSUInteger selectedIndex = [self.buttons indexOfObject:tabBarButton];
    [self tabBarSelectedIndex:selectedIndex];
}

- (void)tabBarSelectedIndex:(NSUInteger)selectedIndex
{
    if (_tabBarDelegate &&
        [_tabBarDelegate respondsToSelector:@selector(selectedIndex:tabBar:)]) {
        [_tabBarDelegate selectedIndex:selectedIndex tabBar:self];
    }
}

- (void)refreshSelectedIndex:(NSUInteger)selectedIndex
{
    // 原选中按钮
    __kindof VVTabBarBaseModel *model = [self.tabBarModels objectAtIndex:self.selectedIndex];
    model.selected = NO;
    
    __kindof VVTabBarBaseButton *button = [self.buttons objectAtIndex:self.selectedIndex];
    // 刷新ui
    [button updateWithModel:model];
    
    // 即将选中按钮
    __kindof VVTabBarBaseModel *selectedModel = [self.tabBarModels objectAtIndex:selectedIndex];
    selectedModel.selected = YES;
    
    __kindof VVTabBarBaseButton *selectedButton = [self.buttons objectAtIndex:selectedIndex];
    // 刷新ui
    [selectedButton updateWithModel:selectedModel];
    
    self.selectedIndex = selectedIndex;
}

- (void)middleButtonTapped
{
    [self middleSelected];
}

- (void)middleSelected
{
    if (self.middleTabBarModel &&
        self.middleTabBarModel.increaseIndex) {
        NSUInteger selectedIndex = [self.buttons indexOfObject:self.middleButton];
        [self tabBarSelectedIndex:selectedIndex];
    } else {
        if (_tabBarDelegate &&
            [_tabBarDelegate respondsToSelector:@selector(middleSelected:)]) {
            [_tabBarDelegate middleSelected:self];
        }
    }
}

- (void)refreshUI
{
    [self.buttons enumerateObjectsUsingBlock:^(__kindof VVTabBarBaseButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj updateWithModel:[self.tabBarModels objectAtIndex:idx]];
    }];
    
    if (self.middleTabBarModel &&
        !self.middleTabBarModel.increaseIndex) {
        [self.middleButton updateWithModel:self.middleTabBarModel];
    }
    
    [self.backgroundView updateWithModel:self.tabBarConfigModel];
}

- (__kindof VVTabBarBaseModel *)tabBarModel:(NSUInteger)index
{
    return [self.tabBarModels objectAtIndex:index];
}

- (void)addRedPointView:(UIView *)redPointView
                  index:(NSUInteger)index
{
    __kindof VVTabBarBaseButton *tabBarButton = [self.buttons objectAtIndex:index];
    __kindof VVTabBarBaseModel *model = [self.tabBarModels objectAtIndex:index];
    [tabBarButton setUpRedPointView:redPointView model:model];
}

- (UIView *)getRedPointViewWithIndex:(NSUInteger)index
{
    __kindof VVTabBarBaseButton *tabBarButton = [self.buttons objectAtIndex:index];
    return tabBarButton.redPointView;
}

- (void)addMiddleRedPointView:(UIView *)redPointView
{
    [self.middleButton setUpRedPointView:redPointView model:self.middleTabBarModel];
}

- (UIView *)getMiddleRedPointView
{
    return self.middleButton.redPointView;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.isHidden) {
        CGPoint newPoint = [self convertPoint:point toView:self.middleButton];
        if ([self.middleButton pointInside:newPoint withEvent:event]) {
            return self.middleButton;
        } else {
            return [super hitTest:point withEvent:event];
        }
    } else {
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark - 懒加载
- (VVMiddleTabBarButton *)middleButton
{
    if (!_middleButton) {
        _middleButton = [VVMiddleTabBarButton configTabBarButtonWithModel:self.middleTabBarModel];
    }
    return _middleButton;
}

- (VVTabBarBackgroundView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[VVTabBarBackgroundView alloc] init];
    }
    return _backgroundView;
}

@end
