//
//  KTNavigationBar.h
//  KOTU
//
//  Created by KOTU on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTNavigationBar : UINavigationBar

@property (nonatomic, weak) UIViewController *viewController;

- (void)updateWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
