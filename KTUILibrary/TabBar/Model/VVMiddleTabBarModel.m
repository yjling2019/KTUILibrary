//
//  VVMiddleTabBarModel.m
//  VOVA
//
//  Created by fwzhou on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVMiddleTabBarModel.h"
#import "VVMiddleTabBarButton.h"

@implementation VVMiddleTabBarModel

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
    return [VVMiddleTabBarButton class];
}

@end
