//
//  KTBackBarButtonItem.h
//  VOVA
//
//  Created by fwzhou on 2020/6/6.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTBarButtonItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTBackBarButtonItem : KTBarButtonItem

+ (instancetype)backBarButtonItemTarget:(nullable id)target
                                 action:(nullable SEL)action;

@end

NS_ASSUME_NONNULL_END
