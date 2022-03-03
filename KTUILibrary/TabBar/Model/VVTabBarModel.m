//
//  VVTabBarModel.m
//  VOVA
//
//  Created by fwzhou on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVTabBarModel.h"
#import "VVTabBarButton.h"

@implementation VVTabBarModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleShow = YES;
        self.selectedTitleShow = YES;
    }
    return self;
}

- (Class)className
{
    return [VVTabBarButton class];
}

@end
