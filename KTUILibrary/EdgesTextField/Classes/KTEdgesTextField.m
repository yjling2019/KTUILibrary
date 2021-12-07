//
//  KTEdgesTextField.m
//  KTUILibrary
//
//  Created by KOTU on 2019/12/10.
//  Copyright © 2019 Lebbay. All rights reserved.
//

#import "KTEdgesTextField.h"

@implementation KTEdgesTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textEdgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, self.textEdgeInsets);
}

// Text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, self.textEdgeInsets);
}

@end
