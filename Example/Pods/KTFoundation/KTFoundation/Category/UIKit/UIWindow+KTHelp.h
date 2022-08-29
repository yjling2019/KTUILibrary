//
//  UIWindow+KTHelp.h
//  KTFoundation
//
//  Created by KOTU on 2022/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (KTHelp)

+ (UIViewController *)kt_currentViewController;
+ (UIViewController *)kt_currentViewControllerWithDefault:(UIViewController *)defaultViewController;

@end

NS_ASSUME_NONNULL_END
