//
//  VVTabBarProtocol.h
//  VOVA
//
//  Created by fwzhou on 2020/3/14.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VVTabBarController;

@protocol VVTabBarProtocol <NSObject>

@property (nonatomic, weak) VVTabBarController *vv_tabBarController;

@end

@protocol VVTabBarSelectProtocol <NSObject>

/// 将要选择tabBarController某个viewcontroller
/// @param tabBarController 当前tabBarController
/// @param originViewController 上一次选择的viewcontroller
/// @param viewController 将要选择的viewcontroller
- (BOOL)tabBarController:(VVTabBarController *)tabBarController
originSelectViewController:(UIViewController *)originViewController
shouldSelectViewController:(UIViewController *)viewController;

/// 选择tabBarController某个viewcontroller
/// @param tabBarController 当前tabBarController
/// @param originViewController 上一次选择的viewcontroller
/// @param viewController 选择的viewcontroller
- (void)tabBarController:(VVTabBarController *)tabBarController
originSelectViewController:(UIViewController *)originViewController
 didSelectViewController:(UIViewController *)viewController;

@end

@protocol VVTabBarMiddleSelectProtocol <NSObject>

/// 不影响tabBar的index时，中间按钮点击
/// @param tabBarController 当前tabBarController
- (void)tabBarMiddleSelect:(VVTabBarController *)tabBarController;

@end

NS_ASSUME_NONNULL_END
