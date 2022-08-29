//
//  UIWindow+KTHelp.m
//  KTFoundation
//
//  Created by KOTU on 2022/3/8.
//

#import "UIWindow+KTHelp.h"

@implementation UIWindow (KTHelp)

+ (UIViewController *)kt_currentViewController {
	return [self kt_currentViewControllerWithDefault:[UIApplication sharedApplication].delegate.window.rootViewController];
}

+ (UIViewController *)kt_currentViewControllerWithDefault:(UIViewController *)defaultViewController {
	UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
	while (viewController) {
		if (viewController.presentedViewController) {
			viewController = viewController.presentedViewController;
		} else if ([viewController isKindOfClass:[UINavigationController class]]) {
			UINavigationController *nvc = (UINavigationController*)viewController;
			viewController = nvc.topViewController;
		} else if ([viewController isKindOfClass:[UITabBarController class]]) {
			UITabBarController *tbvc = (UITabBarController*)viewController;
			viewController = tbvc.selectedViewController;
		}  else if ([viewController isKindOfClass:[UISplitViewController class]] &&
					((UISplitViewController *)viewController).viewControllers.count > 0) {
			UISplitViewController *svc = (UISplitViewController *)viewController;
			viewController = svc.viewControllers.lastObject;
		} else  {
			return viewController;
		}
	}
	
	if (!viewController) {
		return defaultViewController;
	}
	return viewController;
}

@end
