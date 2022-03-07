//
//  KTTabBar.h
//  VOVA
//
//  Created by KOTU on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KTTabBarBaseModel;
@class KTMiddleTabBarModel;
@class KTTabBarConfigModel;
@class KTTabBar;

@protocol KTTabBarDelegate <NSObject>

- (void)selectedIndex:(NSUInteger)selectedIndex tabBar:(KTTabBar *)tabBar;

@optional
/// 不影响tabBar的index时，中间按钮点击
- (void)middleSelected:(KTTabBar *)tabBar;

@end

@interface KTTabBar : UITabBar

@property (nonatomic, weak) id<KTTabBarDelegate> tabBarDelegate;

@property (nonatomic, strong, readonly) __kindof KTMiddleTabBarModel *middleTabBarModel;

- (instancetype)initWithTabBarModels:(NSArray<__kindof KTTabBarBaseModel *> *)tabBarModels
                   middleTabBarModel:(nullable __kindof KTMiddleTabBarModel *)middleTabBarModel
                   tabBarConfigModel:(KTTabBarConfigModel *)tabBarConfigModel;

/// 刷新tabBar按钮ui
- (void)refreshUI;

/// tabBar选中
/// @param selectedIndex 选中的index
- (void)tabBarSelectedIndex:(NSUInteger)selectedIndex;

/// 刷新选中状态
/// @param selectedIndex 选中的index
- (void)refreshSelectedIndex:(NSUInteger)selectedIndex;

/// 选中中间按钮
- (void)middleSelected;

/// 刷新tabBarModel
/// @param index index
- (__kindof KTTabBarBaseModel *)tabBarModel:(NSUInteger)index;

/// 添加红点
/// @param redPointView 外部红点view
/// @param index index
- (void)addRedPointView:(UIView *)redPointView
                  index:(NSUInteger)index;

/// 获取红点
/// @param index index
- (UIView *)getRedPointViewWithIndex:(NSUInteger)index;

/// 中间按钮添加红点
/// @param redPointView 外部红点view
- (void)addMiddleRedPointView:(UIView *)redPointView;

/// 获取中间红点
- (UIView *)getMiddleRedPointView;

@end

NS_ASSUME_NONNULL_END
