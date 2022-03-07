//
//  KTTabBarProtocol.h
//  KOTU
//
//  Created by KOTU on 2020/3/14.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KTTabBarController;

@protocol KTTabBarProtocol <NSObject>

@property (nonatomic, weak) KTTabBarController *kt_tabBarController;

@end

@protocol KTTabBarSelectProtocol <NSObject>

/// 将要选择tabBarController某个viewcontroller
/// @param tabBarController 当前tabBarController
/// @param originViewController 上一次选择的viewcontroller
/// @param viewController 将要选择的viewcontroller
- (BOOL)tabBarController:(KTTabBarController *)tabBarController
originSelectViewController:(UIViewController *)originViewController
shouldSelectViewController:(UIViewController *)viewController;

/// 选择tabBarController某个viewcontroller
/// @param tabBarController 当前tabBarController
/// @param originViewController 上一次选择的viewcontroller
/// @param viewController 选择的viewcontroller
- (void)tabBarController:(KTTabBarController *)tabBarController
originSelectViewController:(UIViewController *)originViewController
 didSelectViewController:(UIViewController *)viewController;

@end

@protocol KTTabBarMiddleSelectProtocol <NSObject>

/// 不影响tabBar的index时，中间按钮点击
/// @param tabBarController 当前tabBarController
- (void)tabBarMiddleSelect:(KTTabBarController *)tabBarController;

@end

NS_ASSUME_NONNULL_END
