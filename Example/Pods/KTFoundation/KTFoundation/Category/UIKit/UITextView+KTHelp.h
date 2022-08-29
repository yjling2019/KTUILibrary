//
//  UITextView+KTHelp.h
//  KTFoundation
//
//  Created by KOTU on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (KTHelp)

@property (nonatomic, strong, readonly) UITextView *kt_placeholderView;


/// set place holder text for the textview
/// @param string place holder text
- (void)kt_setPlaceHolder:(NSString *)string;

/// limit input length. If length less than 1, then no limit
/// @param length limit text length
- (void)kt_setLimitTextLength:(NSInteger)length;

/// limit chinese string length. If length less than 1, then no limit
/// @param length limit string length
- (void)kt_setLimitChineseStringLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
