//
//  VVTabBarBaseButton.h
//  VOVA
//
//  Created by fwzhou on 2020/3/16.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVViewProtocol.h"
//#import <Lottie/Lottie.h>
//#import <FLAnimatedImage/FLAnimatedImageView.h>
//#import <FLAnimatedImage/FLAnimatedImage.h>
#import "VVTabBarBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VVTabBarBaseButton : UIButton <VVViewProtocol>

/// 背景图
@property (nonatomic, strong, readonly) UIImageView *bgImageView;

/// tabbar为VVTabBarImageTypeLot使用
//@property (nonatomic, strong, readonly) LOTAnimationView *lotImageView;
/// tabbar为VVTabBarImageTypeImage使用
@property (nonatomic, strong, readonly) UIImageView *normalImageView;
/// tabbar为VVTabBarImageTypeGif使用
//@property (nonatomic, strong, readonly) FLAnimatedImageView *gifImageView;

/// tabbar文字
@property (nonatomic, strong, readonly) UILabel *tabBartitleLabel;

/// 红点
@property (nonatomic, strong, readonly) UIView *redPointView;

+ (id)configTabBarButtonWithModel:(VVTabBarBaseModel *)model;

- (void)setUpRedPointView:(UIView *)redPointView model:(VVTabBarBaseModel *)model;

@end

NS_ASSUME_NONNULL_END
