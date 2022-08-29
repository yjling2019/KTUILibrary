//
//  UIAlertController+KTHelp.h
//  KTFoundation
//
//  Created by KOTU on 2022/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (KTHelp)

+ (instancetype)kt_actionSheetWithTitle:(nullable NSString *)title;
+ (instancetype)kt_alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (void)kt_addCancelButtonWithTitle:(nullable NSString *)title action:(nullable void(^)(UIAlertAction *action))handler;
- (void)kt_addDestructiveButtonWithTitle:(NSString *)title action:(void(^)(UIAlertAction *action))handler;
- (void)kt_addButtonWithTitle:(NSString *)title action:(nullable void(^)(UIAlertAction *action))handler;
- (void)kt_addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

@end

NS_ASSUME_NONNULL_END
