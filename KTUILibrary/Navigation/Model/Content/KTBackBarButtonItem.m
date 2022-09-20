//
//  KTBackBarButtonItem.m
//  KOTU
//
//  Created by KOTU on 2020/6/6.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTBackBarButtonItem.h"
#import <UIKit/UIKit.h>
#import <KTFoundation/KTSandBoxManager.h>

@implementation KTBackBarButtonItem

+ (instancetype)backBarButtonItemTarget:(nullable id)target
                                 action:(nullable SEL)action
{
	UIImage *lightImage = [KTSandBoxManager imageNamed:@"Navigation_Back_White_No_Dark" inPod:@"KTUILibrary_Navigation"];
    UIImage *darkImage = [KTSandBoxManager imageNamed:@"Navigation_Back_Black_No_Dark" inPod:@"KTUILibrary_Navigation"];
    KTBackBarButtonItem *item =
    [[KTBackBarButtonItem alloc] initWithText:nil
                                    darkImage:darkImage
                                   lightImage:lightImage
                                       target:target
                                       action:action];
    return item;
}

@end
