//
//  KTNavigationController.h
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTBackButtonHandlerProtocol.h"
#import "KTNavigationControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (KTBackButtonHandler)
<KTBackButtonHandlerProtocol,
KTNavigationControllerProtocol>

@end

@interface KTNavigationController : UINavigationController

@end

NS_ASSUME_NONNULL_END
