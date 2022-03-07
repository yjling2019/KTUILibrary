//
//  KTTabBarModel.m
//  KOTU
//
//  Created by KOTU on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTTabBarModel.h"
#import "KTTabBarButton.h"

@implementation KTTabBarModel

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
    return [KTTabBarButton class];
}

@end
