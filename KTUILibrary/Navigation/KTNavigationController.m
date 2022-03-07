//
//  KTNavigationController.m
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTNavigationController.h"
//#import <vv_rootlib_ios/NSObject+Swizzle.h>
#import "KTEmptyNavigationBar.h"
//#import <vv_bodylib_ios/KTDelay.h>
//#import "KTPopupManager_N.h"
#import <KTFoundation/KTMacros.h>
#import <objc/runtime.h>

static NSString *const kOriginDelegate = @"kOriginDelegate";

@implementation UIViewController (KTBackButtonHandler)

@end

@interface KTNavigationController ()

@property (nonatomic, strong) KTEmptyNavigationBar *vv_navigationBar;

@end

@implementation KTNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    objc_setAssociatedObject(self, [kOriginDelegate UTF8String], kt_delay(self.interactivePopGestureRecognizer.delegate), OBJC_ASSOCIATION_COPY);
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    [self setValue:self.vv_navigationBar forKey:@"navigationBar"];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if ([viewController respondsToSelector:@selector(useCustomNavigationBar)] &&
        [viewController respondsToSelector:@selector(setUseCustomNavigationBar:)]) {
        viewController.useCustomNavigationBar = true;
    }
}

#pragma mark - 手势
// 此方法可能被回调多次
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count == 1) {
            return false;
        }
        
        UIViewController *vc = [self topViewController];
        if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
            return [vc navigationShouldPopOnBackButton];
        }
#if DEBUG
        NSAssert(false, @"vc没有继承BaseViewController");
#endif
        id<UIGestureRecognizerDelegate> originDelegate = kt_force(objc_getAssociatedObject(self, [kOriginDelegate UTF8String]));
        return [originDelegate gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return true;
}

#pragma mark - status bar
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

- (KTEmptyNavigationBar *)vv_navigationBar
{
    if (!_vv_navigationBar) {
        _vv_navigationBar = [[KTEmptyNavigationBar alloc] init];
        _vv_navigationBar.navController = self;
    }
    return _vv_navigationBar;
}

@end
