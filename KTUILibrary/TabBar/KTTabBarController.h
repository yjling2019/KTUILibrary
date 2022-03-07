//
//  KTTabBarController.h
//  VOVA
//
//  Created by KOTU on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTTabBarConfigModel.h"
#import "KTTabBarBaseModel.h"
#import "KTTabBarModel.h"
#import "KTMiddleTabBarModel.h"
#import "KTTabBarProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTTabBarController : UITabBarController

@property (nonatomic, weak) id<KTTabBarMiddleSelectProtocol> middleDelegate;

- (void)refreshWithViewControllers:(NSArray<__kindof UIViewController *> *)vcs
                      tabBarModels:(NSArray<KTTabBarModel *> *)tabBarModels
                 middleTabBarModel:(nullable KTMiddleTabBarModel *)middleTabBarModel
                 tabBarConfigModel:(KTTabBarConfigModel *)tabBarConfigModel;

/// 选中某个tab
/// @param className 类名
- (void)selectedIndexWithClassName:(Class)className;

/// 中间按钮选择
/// 如果中间按钮影响tabBar的index个数，可以调用selectedIndexWithClassName来切换tab
- (void)middleSelected;

/// 刷新某个tab的ui
/// @param className 类名
/// @param block 返回的KTTabBarBaseModel
- (void)refreshTabBarWithClassName:(Class)className
                             block:(void(^)(__kindof KTTabBarBaseModel *tabBarModel))block;

/// 刷新中间按钮的ui
/// @param block 返回KTMiddleTabBarModel
- (void)refreshMiddleTabBarButtonWithBlock:(void(^)(KTMiddleTabBarModel *tabBarModel))block;

/// 某个tab加红点
/// @param className 类名
/// @param redPointView 红点视图
- (void)addRedPointViewWithClassName:(Class)className
                        redPointView:(UIView *)redPointView;

/// 获取某个tab红点
/// @param className 类名
- (UIView *)getRedPointViewWithClassName:(Class)className;

/// 中间按钮加红点
/// @param redPointView 红点视图
- (void)addMiddleRedPointView:(UIView *)redPointView;

/// 获取中间按钮红点
- (void)getMiddleRedPointView;

/// 获取当前选中tab
- (UIViewController *)getSelectedIndexFirstViewController;

/// 获取某个tab
/// @param className 类名
- (UIViewController *)getViewControllerWithClassName:(Class)className;

- (void)tabbarHidden:(BOOL)hidden animated:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
