//
//  VVBackBarButtonItem.h
//  VOVA
//
//  Created by fwzhou on 2020/6/6.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVBarButtonItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface VVBackBarButtonItem : VVBarButtonItem

+ (instancetype)backBarButtonItemTarget:(nullable id)target
                                 action:(nullable SEL)action;

@end

NS_ASSUME_NONNULL_END
