//
//  KTTabBarBaseButton.h
//  VOVA
//
//  Created by fwzhou on 2020/3/16.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTViewProtocol.h"
//#import <Lottie/Lottie.h>
//#import <FLAnimatedImage/FLAnimatedImageView.h>
//#import <FLAnimatedImage/FLAnimatedImage.h>
#import "KTTabBarBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTTabBarBaseButton : UIButton <KTViewProtocol>

/// 背景图
@property (nonatomic, strong, readonly) UIImageView *bgImageView;

/// tabbar为KTTabBarImageTypeLot使用
//@property (nonatomic, strong, readonly) LOTAnimationView *lotImageView;
/// tabbar为KTTabBarImageTypeImage使用
@property (nonatomic, strong, readonly) UIImageView *normalImageView;
/// tabbar为KTTabBarImageTypeGif使用
//@property (nonatomic, strong, readonly) FLAnimatedImageView *gifImageView;

/// tabbar文字
@property (nonatomic, strong, readonly) UILabel *tabBartitleLabel;

/// 红点
@property (nonatomic, strong, readonly) UIView *redPointView;

+ (id)configTabBarButtonWithModel:(KTTabBarBaseModel *)model;

- (void)setUpRedPointView:(UIView *)redPointView model:(KTTabBarBaseModel *)model;

@end

NS_ASSUME_NONNULL_END
