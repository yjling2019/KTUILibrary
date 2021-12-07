//
//  NavigationController.m
//  Test-yjling
//
//  Created by 凌永剑 on 2021/12/2.
//

#import "NavigationController.h"

@interface NavigationController ()
@property (strong, nonatomic) UIImage *customBackImage;
@end

@implementation NavigationController

//- (instancetype)init
//{
//    if (self = [super init]) {
//        self.navigationBar.delegate = self;
//    }
//    return self;
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]
                                     initWithImage:self.customBackImage
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(back)];
        backItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        viewController.navigationItem.leftBarButtonItem = backItem;
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];

    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

//#pragma mark - UINavigationBarDelegate
//- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
//{
//    return UIBarPositionTopAttached;
//}

#pragma mark - lazy load
- (UIImage *)customBackImage
{
    if (!_customBackImage) {
        _customBackImage = [[UIImage imageNamed:@"Navigation_Back_Black_No_Dark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _customBackImage;
}

@end
