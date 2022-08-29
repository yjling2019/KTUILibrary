//
//  NSTimer+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 14/15/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSTimer+KTHelp.h"

@implementation NSTimer (KTHelp)

+ (void)_kt_ExecBlock:(NSTimer *)timer
{
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)kt_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
										 block:(void (^)(NSTimer *timer))block
									   repeats:(BOOL)repeats
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_kt_ExecBlock:) userInfo:[block copy] repeats:repeats];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	return timer;
}

+ (NSTimer *)kt_timerWithTimeInterval:(NSTimeInterval)seconds
								block:(void (^)(NSTimer *timer))block
							  repeats:(BOOL)repeats
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_kt_ExecBlock:) userInfo:[block copy] repeats:repeats];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	return timer;
}

- (void)kt_resume
{
	[self setFireDate:[NSDate distantPast]];
}

- (void)kt_pause
{
	[self setFireDate:[NSDate distantFuture]];
}

@end
