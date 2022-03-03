//
//  VVNavigationController.h
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBackButtonHandlerProtocol.h"
#import "VVNavigationControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (VVBackButtonHandler)
<VVBackButtonHandlerProtocol,
VVNavigationControllerProtocol>

@end

@interface VVNavigationController : UINavigationController

@end

NS_ASSUME_NONNULL_END
