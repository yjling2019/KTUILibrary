//
//  KTBarBackgroundModel.m
//  KOTU
//
//  Created by KOTU on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTBarBackgroundModel.h"
#import <KTFoundation/KTMacros.h>

@interface KTBarBackgroundModel ()

/// 导航栏背景色是否暗色系
@property (nonatomic, assign) BOOL darkColor;

@end

@implementation KTBarBackgroundModel

- (instancetype)init
{
    self = [super init];
    if (self) {
#warning TODO
//        self.bgColor = [KTColorManager colorWithLightColor:@"#ffffff" darkColor:@"#212223"];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor
{
    if (!bgColor) {
        self.darkColor = true;
    } else {
#warning TODO
//        self.darkColor = [bgColor kt_isDarkColor];
    }
    
    if (@available(iOS 13.0, *)) {
        @weakify(self)
        _bgColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            @strongify(self)
            if (!bgColor) {
                self.darkColor = true;
            } else {
#warning TODO
//                self.darkColor = [bgColor kt_isDarkColor];
            }
            return bgColor;
        }];
    } else {
        _bgColor = bgColor;
    }
}

@end
