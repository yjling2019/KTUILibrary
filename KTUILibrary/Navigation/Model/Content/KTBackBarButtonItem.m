//
//  KTBackBarButtonItem.m
//  VOVA
//
//  Created by fwzhou on 2020/6/6.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTBackBarButtonItem.h"
#import <UIKit/UIKit.h>

@implementation KTBackBarButtonItem

+ (instancetype)backBarButtonItemTarget:(nullable id)target
                                 action:(nullable SEL)action
{
    UIImage *lightImage = [UIImage imageNamed:@"Navigation_Back_White_No_Dark"];
    UIImage *darkImage = [UIImage imageNamed:@"Navigation_Back_Black_No_Dark"];
    KTBackBarButtonItem *item =
    [[KTBackBarButtonItem alloc] initWithText:nil
                                    darkImage:darkImage
                                   lightImage:lightImage
                                       target:target
                                       action:action];
    return item;
}

@end
