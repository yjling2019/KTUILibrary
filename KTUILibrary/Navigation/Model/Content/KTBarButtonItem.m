//
//  KTBarButtonItem.m
//  KOTU
//
//  Created by KOTU on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTBarButtonItem.h"
#import "KTButtonBarButton.h"

@implementation KTBarButtonItem

- (instancetype)initWithText:(nullable NSString *)text
                   darkImage:(nullable UIImage *)darkImage
                  lightImage:(nullable UIImage *)lightImage
                      target:(nullable id)target
                      action:(nullable SEL)action
{
    self = [super init];
    if (self) {
        self.text = text;
        self.darkImage = darkImage;
        self.lightImage = lightImage;
        self.target = target;
        self.action = action;
        self.enabled = true;
    }
    return self;
}

- (NSAttributedString *)realityAttrText
{
    if (self.statusBarStyle == UIStatusBarStyleLightContent) {
        return self.lightAttrText;
    } else {
        return self.darkAttrText;
    }
}

- (UIImage *)realityImage
{
    if (self.statusBarStyle == UIStatusBarStyleLightContent) {
        return self.lightImage;
    } else {
        return self.darkImage;
    }
}

- (NSAttributedString *)lightAttrText
{
    if (!_lightAttrText &&
        self.text) {
        NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        textDict[NSParagraphStyleAttributeName] = paraStyle;
        textDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        textDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        _lightAttrText = [[NSAttributedString alloc] initWithString:self.text attributes:textDict];
    }
    return _lightAttrText;
}

- (NSAttributedString *)darkAttrText
{
    if (!_darkAttrText &&
        self.text) {
        NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        textDict[NSParagraphStyleAttributeName] = paraStyle;
        textDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
#warning TODO 0303
//        textDict[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x999999];
        _darkAttrText = [[NSAttributedString alloc] initWithString:self.text attributes:textDict];
    }
    return _darkAttrText;
}

- (void)setText:(NSString *)text
{
	_darkAttrText = nil;
	_lightAttrText = nil;
	_text = text;
}

- (__kindof KTButtonBarButton *)itemGetButton
{
    return [[KTButtonBarButton alloc] init];
}

@end
