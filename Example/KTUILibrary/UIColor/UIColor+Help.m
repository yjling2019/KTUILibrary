//
//  UIColor+Help.m
//  KTUILibrary_Example
//
//  Created by KOTU on 2021/12/7.
//  Copyright © 2021 KOTU. All rights reserved.
//

#import "UIColor+Help.h"

@implementation UIColor (Help)

+ (UIColor *)randomColor
{
    int r = arc4random() % 256;
    int g = arc4random() % 256;
    int b = arc4random() % 256;

    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
