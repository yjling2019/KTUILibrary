//
//  VVBarBackgroundModel.m
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVBarBackgroundModel.h"
//#import <vv_rootlib_ios/UIColor+TDHelp.h>
//#import <vv_rootlib_ios/TDScope.h>
//#import <vv_rootlib_ios/VVColorManager.h>
#import <KTFoundation/KTMacros.h>

@interface VVBarBackgroundModel ()

/// 导航栏背景色是否暗色系
@property (nonatomic, assign) BOOL darkColor;

@end

@implementation VVBarBackgroundModel

- (instancetype)init
{
    self = [super init];
    if (self) {
#warning TODO
//        self.bgColor = [VVColorManager colorWithLightColor:@"#ffffff" darkColor:@"#212223"];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor
{
    if (!bgColor) {
        self.darkColor = true;
    } else {
#warning TODO
//        self.darkColor = [bgColor vv_isDarkColor];
    }
    
    if (@available(iOS 13.0, *)) {
        @weakify(self)
        _bgColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            @strongify(self)
            if (!bgColor) {
                self.darkColor = true;
            } else {
#warning TODO
//                self.darkColor = [bgColor vv_isDarkColor];
            }
            return bgColor;
        }];
    } else {
        _bgColor = bgColor;
    }
}

@end
