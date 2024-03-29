//
//  KTTabBarRedPointViewProtocol.h
//  KOTU
//
//  Created by KOTU on 2020/3/16.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KTTabBarRedPointViewProtocol <NSObject>

@optional
- (void)didSelectRedPointView;

@optional
- (void)playAnimation;

@optional
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
