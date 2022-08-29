//
//  UITextView+KTHelp.m
//  KTFoundation
//
//  Created by KOTU on 2022/8/1.
//

#import "UITextView+KTHelp.h"
#import "KTScope.h"
#import <objc/runtime.h>

@interface KTWeakReferenceTextView : NSObject

@property (nonatomic, assign) NSInteger mode;

@property (nonatomic, assign, readonly) NSInteger limitLength;

@property (nonatomic, assign) NSInteger limitStringLength;
@property (nonatomic, assign) NSInteger limitChineseStringLength;

@end

@implementation KTWeakReferenceTextView

- (void)kt_textViewDidChange:(NSNotification *)notification
{
	UITextView *textView = notification.object;
	UITextView *placeholderView = objc_getAssociatedObject(textView, @"kt_placeholderView");
	if (placeholderView) {
		placeholderView.hidden = (textView.text.length > 0);
	}

	NSString *toBeString = textView.text;
	NSString *lang = textView.textInputMode.primaryLanguage;
	
	if ([lang isEqualToString:@"zh-Hans"]) {
		//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
		if (toBeString.length > self.limitLength) {
			textView.text = [toBeString substringToIndex:self.limitLength];
		}
		return;
	}
	
	//中文输入
	UITextRange *selectedRange = [textView markedTextRange];
	//获取高亮部分
	UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
	
	if (position) {
		return;
	}
		
	// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
	if (toBeString.length > self.limitLength) {
		textView.text = [toBeString substringToIndex:self.limitLength];
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

@interface UITextView (Help)

@property (nonatomic, strong) KTWeakReferenceTextView *weakReference;
@property (nonatomic, strong) UITextView *kt_placeholderView;

@property (nonatomic, assign) BOOL isAddNotificationObserver;

@end

@implementation UITextView (KTHelp)

- (KTWeakReferenceTextView *)weakReference
{
	KTWeakReferenceTextView *wf = objc_getAssociatedObject(self, @"weakReference");
	if (!wf) {
		wf = [[KTWeakReferenceTextView alloc] init];
		objc_setAssociatedObject(self, @"weakReference", wf, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return wf;
}

- (void)setIsAddNotificationObserver:(BOOL)isAddNotificationObserver
{
	objc_setAssociatedObject(self, @"isAddNotificationObserver", @(isAddNotificationObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAddNotificationObserver
{
	NSNumber *num = objc_getAssociatedObject(self, @"isAddNotificationObserver");
	if (!num) {
		return NO;
	}
	return num.boolValue;
}

- (UITextView *)kt_placeholderView
{
	UITextView *placeholderView = objc_getAssociatedObject(self, @"kt_placeholderView");
	
	if (!placeholderView) {
		placeholderView = [[UITextView alloc] init];
		objc_setAssociatedObject(self, @"kt_placeholderView", placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		
		[self addNotificationObserverIfNeeded];
		
		placeholderView.scrollEnabled = NO;
		placeholderView.userInteractionEnabled = NO;
		placeholderView.textColor = [UIColor lightGrayColor];
		placeholderView.backgroundColor = [UIColor clearColor];
		placeholderView.translatesAutoresizingMaskIntoConstraints = NO;

		[self kt_refreshPlaceholderView];
		[self addSubview:placeholderView];
		
		[self addConstraint:[NSLayoutConstraint
							constraintWithItem:placeholderView
							attribute:NSLayoutAttributeLeading
							relatedBy:NSLayoutRelationEqual
							toItem:self
							attribute:NSLayoutAttributeLeading
							multiplier:1
							constant:0]];
		
		[self addConstraint:[NSLayoutConstraint
							constraintWithItem:placeholderView
							attribute:NSLayoutAttributeTrailing
							relatedBy:NSLayoutRelationEqual
							toItem:self
							attribute:NSLayoutAttributeTrailing
							multiplier:1
							constant:0]];

		[self addConstraint:[NSLayoutConstraint
							constraintWithItem:placeholderView
							attribute:NSLayoutAttributeTop
							relatedBy:NSLayoutRelationEqual
							toItem:self
							attribute:NSLayoutAttributeTop
							multiplier:1
							constant:0]];

		[self addConstraint:[NSLayoutConstraint
							constraintWithItem:placeholderView
							attribute:NSLayoutAttributeBottom
							relatedBy:NSLayoutRelationEqual
							toItem:self
							attribute:NSLayoutAttributeBottom
							multiplier:1
							constant:0]];
	}
	return placeholderView;
}

- (void)kt_refreshPlaceholderView
{
	UITextView *placeholderView = objc_getAssociatedObject(self, @"kt_placeholderView");
	if (!placeholderView) {
		return;
	}
	
	self.kt_placeholderView.font = self.font;
	self.kt_placeholderView.textAlignment = self.textAlignment;
	self.kt_placeholderView.textContainerInset = self.textContainerInset;
	self.kt_placeholderView.hidden = (self.text.length > 0);
}

#pragma mark - place holder
- (void)kt_setPlaceHolder:(NSString *)string
{
	self.kt_placeholderView.text = string;
}

#pragma mark - text limit
- (void)kt_setLimitTextLength:(NSInteger)length
{
	[self addNotificationObserverIfNeeded];
	
	self.weakReference.limitStringLength = length;
	self.weakReference.mode = 1;
}

- (void)kt_setLimitChineseStringLength:(NSInteger)length
{
	[self addNotificationObserverIfNeeded];
	
	self.weakReference.limitChineseStringLength = length;
	self.weakReference.mode = 2;
}

- (void)addNotificationObserverIfNeeded
{
	if (self.isAddNotificationObserver) {
		return;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self.weakReference
											 selector:@selector(kt_textViewDidChange:)
												 name:UITextViewTextDidChangeNotification
											   object:self];
}

@end

