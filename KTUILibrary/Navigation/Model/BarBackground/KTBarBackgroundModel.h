//
//  KTBarBackgroundModel.h
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KTNavigationBarDividingStyle) {
    /// 分割线
    KTNavigationBarDividingStyleLine = 0,
    /// 阴影
    KTNavigationBarDividingStyleShadow = 1,
    /// 自定义
    KTNavigationBarDividingStyleCustom = 2,
};

@interface KTBarBackgroundModel : NSObject

/// 导航栏背景图
@property (nonatomic, strong, nullable) UIImage *bgImage;

/// 导航栏背景色
@property (nonatomic, strong, nonnull) UIColor *bgColor;

/// 导航栏背景色是否暗色系
@property (nonatomic, assign, readonly) BOOL darkColor;

/// 导航栏分割
@property (nonatomic, assign) KTNavigationBarDividingStyle dividingStyle;

/// 导航栏分割线颜色
@property (nonatomic, strong, nullable) UIColor *dividingColor;

/// 自定义的分割视图
@property (nonatomic, strong, nullable) UIView *dividingView;

@end

NS_ASSUME_NONNULL_END
