//
//  UIResponder+KTHelp.m
//  KOTU
//
//  Created by KOTU on 2017/12/28.
//  Copyright © 2017年 KOTU. All rights reserved.
//

#import "UIResponder+KTHelp.h"

@implementation UIResponder (KTHelp)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

- (__kindof UIResponder *)nextResponderOfClass:(Class)cls
{
	UIResponder *targetResponder = nil;

	UIResponder *next = self.nextResponder;
	while (next) {
		if ([next isKindOfClass:cls]) {
			targetResponder = next;
			break;;
		}
		next = next.nextResponder;
	}
	
	return targetResponder;
}

- (__kindof UIResponder *)nextResponderOfClassName:(NSString *)clsName
{
	UIResponder *targetResponder = nil;

	UIResponder *next = self.nextResponder;
	while (next) {
		if ([clsName isEqualToString:NSStringFromClass([next class])]) {
			targetResponder = next;
			break;;
		}
		next = next.nextResponder;
	}
	
	return targetResponder;
}

- (__kindof UIResponder *)nextResponderConformsToProtocol:(Protocol *)prtcol
{
	UIResponder *targetResponder = nil;

	UIResponder *next = self.nextResponder;
	while (next) {
		if ([next conformsToProtocol:prtcol]) {
			targetResponder = next;
			break;;
		}
		next = next.nextResponder;
	}
	
	return targetResponder;
}

@end
