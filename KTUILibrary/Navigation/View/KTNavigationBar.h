//
//  KTNavigationBar.h
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTNavigationBar : UINavigationBar <KTViewProtocol>

@property (nonatomic, weak) UIViewController *viewController;

@end

NS_ASSUME_NONNULL_END
