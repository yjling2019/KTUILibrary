//
//  UIAlertController+KTHelp.m
//  KTFoundation
//
//  Created by KOTU on 2022/6/8.
//

#import "UIAlertController+KTHelp.h"

@implementation UIAlertController (KTHelp)

+ (instancetype)kt_actionSheetWithTitle:(nullable NSString *)title
{
	UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	return vc;
}

+ (instancetype)kt_alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
	UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	return vc;
}

- (void)kt_addCancelButtonWithTitle:(NSString *)title action:(void(^)(UIAlertAction *action))handler
{
	UIAlertAction *action = [UIAlertAction actionWithTitle:title
													 style:UIAlertActionStyleCancel
												   handler:handler];
	[self addAction:action];
}

- (void)kt_addDestructiveButtonWithTitle:(NSString *)title action:(void(^)(UIAlertAction *action))handler
{
	UIAlertAction *action = [UIAlertAction actionWithTitle:title
													 style:UIAlertActionStyleDestructive
												   handler:handler];
	[self addAction:action];
}

- (void)kt_addButtonWithTitle:(NSString *)title action:(void(^)(UIAlertAction *action))handler
{
	UIAlertAction *action = [UIAlertAction actionWithTitle:title
													 style:UIAlertActionStyleDefault
												   handler:handler];
	[self addAction:action];
}

- (void)kt_addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler
{
	[self addTextFieldWithConfigurationHandler:configurationHandler];
}

@end
