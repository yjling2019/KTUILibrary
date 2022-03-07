//
//  KTMiddleTabBarModel.m
//  KOTU
//
//  Created by KOTU on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTMiddleTabBarModel.h"
#import "KTMiddleTabBarButton.h"

@implementation KTMiddleTabBarModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleShow = NO;
        self.selectedTitleShow = NO;
        self.increaseIndex = NO;
    }
    return self;
}

- (Class)className
{
    return [KTMiddleTabBarButton class];
}

@end
