//
//  VVNavigationItem.m
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVNavigationItem.h"
//#import "UIFont+Helpers.h"
//#import <vv_rootlib_ios/UIColor+TDHelp.h>

@interface VVNavigationItem ()

/// 根据背景颜色计算出的状态栏的样式
@property (nonatomic, assign) UIStatusBarStyle bgColorStatusBarStyle;

@end

@implementation VVNavigationItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = false;
        self.translucent = false;
        self.viewMoveDown = true;
        self.barBGModel = [[VVBarBackgroundModel alloc] init];
        
        self.alpha = 1;
    }
    return self;
}

- (NSAttributedString *)realityAttrTitle
{
    if (self.realityStatusBarStyle == UIStatusBarStyleLightContent) {
        return self.lightAttrTitle;
    } else {
        return self.darkAttrTitle;
    }
}

- (NSAttributedString *)lightAttrTitle
{
    if (!_lightAttrTitle &&
        self.title) {
        NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        textDict[NSParagraphStyleAttributeName] = paraStyle;
#warning TODO 0303
        textDict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
        textDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        _lightAttrTitle = [[NSAttributedString alloc] initWithString:self.title attributes:textDict];
    }
    return _lightAttrTitle;
}

- (NSAttributedString *)darkAttrTitle
{
    if (!_darkAttrTitle &&
        self.title) {
        NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        textDict[NSParagraphStyleAttributeName] = paraStyle;
#warning TODO 0303
        textDict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
//        textDict[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x1c1c1c];
		textDict[NSForegroundColorAttributeName] = [UIColor blackColor];
		_darkAttrTitle = [[NSAttributedString alloc] initWithString:self.title attributes:textDict];
    }
    return _darkAttrTitle;
}

- (UIStatusBarStyle)bgColorStatusBarStyle
{
    if (self.barBGModel.darkColor) {
        return UIStatusBarStyleLightContent;
    } else {
        if (@available(iOS 13.0, *)) {
            return UIStatusBarStyleDarkContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    }
}

- (UIStatusBarStyle)realityStatusBarStyle
{
    if (self.alpha > 0.8) {
        return self.bgColorStatusBarStyle;
    } else {
        return self.originStatusBarStyle;
    }
}

- (BOOL)viewMoveDown
{
    if (_hidden) {
        return false;
    } else {
        return _viewMoveDown;
    }
}

- (void)setTitle:(NSString *)title
{
    self.darkAttrTitle = nil;
    self.lightAttrTitle = nil;
    _title = title;
}

@end
