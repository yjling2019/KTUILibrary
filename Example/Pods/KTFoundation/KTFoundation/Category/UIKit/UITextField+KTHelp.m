//
//  UITextField+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 14/5/12.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UITextField+KTHelp.h"
#import "KTScope.h"
#import <objc/runtime.h>

@interface KTWeakReferenceTextField : NSObject

@property (nonatomic, assign) NSInteger mode;

@property (nonatomic, assign, readonly) NSInteger limitLength;

@property (nonatomic, assign) NSInteger limitStringLength;
@property (nonatomic, assign) NSInteger limitChineseStringLength;

@end

@implementation KTWeakReferenceTextField

- (void)kt_textFieldDidChange:(UITextField *)textField
{
	NSString *toBeString = textField.text;
	NSString *lang = textField.textInputMode.primaryLanguage;
	
	if ([lang isEqualToString:@"zh-Hans"]) {
		//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
		if (toBeString.length > self.limitLength) {
			textField.text = [toBeString substringToIndex:self.limitLength];
		}
		return;
	}
	
	//中文输入
	UITextRange *selectedRange = [textField markedTextRange];
	//获取高亮部分
	UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
	
	if (position) {
		return;
	}
		
	// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
	if (toBeString.length > self.limitLength) {
		textField.text = [toBeString substringToIndex:self.limitLength];
	}
}

- (NSInteger)limitLength
{
	if (self.mode == 1) {
		return self.limitStringLength;
	} else if (self.mode == 2) {
		return self.limitChineseStringLength;
	} else {
		return NSIntegerMax;
	}
}

@end

@interface UITextField (Help)

@property (nonatomic, strong) KTWeakReferenceTextField *weakReference;

@end

@implementation UITextField (KTHelp)

- (void)kt_selectAllText
{
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)kt_setSelectedRange:(NSRange)range
{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

#pragma mark - text limit
- (KTWeakReferenceTextField *)weakReference
{
	KTWeakReferenceTextField *wf = objc_getAssociatedObject(self, @"weakReference");
	if (!wf) {
		wf = [[KTWeakReferenceTextField alloc] init];
		objc_setAssociatedObject(self, @"weakReference", wf, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return wf;
}

- (void)kt_setLimitTextLength:(NSInteger)length
{
	[self removeTarget:self.weakReference action:@selector(kt_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	if (length < 1) {
		return;
	}
	
	self.weakReference.limitStringLength = length;
	self.weakReference.mode = 1;
	[self addTarget:self.weakReference action:@selector(kt_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)kt_setLimitChineseStringLength:(NSInteger)length
{
	[self removeTarget:self.weakReference action:@selector(kt_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	if (length < 1) {
		return;
	}
	
	self.weakReference.limitChineseStringLength = length;
	self.weakReference.mode = 2;
	[self addTarget:self.weakReference action:@selector(kt_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

@end
