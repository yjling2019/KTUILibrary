//
//  UIControl+KTHelp.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/5.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef _Nullable id(^KTControlDataBlock)(void);

/**
 Provides extensions for `UIControl`.
 */
@interface UIControl (KTHelp)

- (void)kt_addRouterEventWithName:(NSString *)name data:(nullable KTControlDataBlock)data;

/**
 Removes all targets and actions for a particular event (or events)
 from an internal dispatch table.
 */
- (void)kt_removeAllTargets;

/**
 Adds or replaces a target and action for a particular event (or events)
 to an internal dispatch table.
 
 @param target         The target object—that is, the object to which the
                       action message is sent. If this is nil, the responder
                       chain is searched for an object willing to respond to the
                       action message.
 
 @param action         A selector identifying an action message. It cannot be NULL.
 
 @param controlEvents  A bitmask specifying the control events for which the
                       action message is sent.
 */
- (void)kt_setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 Adds a block for a particular event (or events) to an internal dispatch table.
 It will cause a strong reference to @a block.
 
 @param block          The block which is invoked then the action message is
                       sent  (cannot be nil). The block is retained.
 
 @param controlEvents  A bitmask specifying the control events for which the
                       action message is sent.
 */
- (void)kt_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/**
 Adds or replaces a block for a particular event (or events) to an internal
 dispatch table. It will cause a strong reference to @a block.
 
 @param block          The block which is invoked then the action message is
                       sent (cannot be nil). The block is retained.
 
 @param controlEvents  A bitmask specifying the control events for which the
                       action message is sent.
 */
- (void)kt_setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/**
 Removes all blocks for a particular event (or events) from an internal
 dispatch table.
 
 @param controlEvents  A bitmask specifying the control events for which the
                       action message is sent.
 */
- (void)kt_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
