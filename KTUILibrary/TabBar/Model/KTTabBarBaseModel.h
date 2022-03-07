//
//  KTTabBarBaseModel.h
//  VOVA
//
//  Created by KOTU on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const kKTTabBarSchemeKey;

#define KTTABBARFILE(host) \
[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", kKTTabBarSchemeKey, host]]

typedef NS_ENUM(NSUInteger, KTTabBarImageType) {
    /// lottie动画
    KTTabBarImageTypeLot,
    /// image
    KTTabBarImageTypeImage,
    /// gif动画
    KTTabBarImageTypeGif,
};

/// KTTabBar按钮配置项基类
@interface KTTabBarBaseModel : NSObject

/// tabbar图片加载方式
@property (nonatomic, assign) KTTabBarImageType imageType;

/// 未选中背景图
@property (nonatomic, strong, nullable) NSURL *bgImgURL;

/// 选中背景图
@property (nonatomic, strong, nullable) NSURL *selectedBGImgURL;

/// 未选中图片名
@property (nonatomic, strong) NSURL *imgURL;

/// 选中图片名
@property (nonatomic, strong) NSURL *selectedImgURL;

/// 未选中gif图片名
@property (nonatomic, strong) NSURL *gifURL;

/// 选中gif图片名
@property (nonatomic, strong, nullable) NSURL *selectedGifURL;

/// lottie文件名
@property (nonatomic, strong) NSURL *lottieURL;

/// 图片大小
@property (nonatomic, assign) CGSize size;

/// 选中图片大小
@property (nonatomic, assign) CGSize selectedSize;

/// 右没用到
/// 上 ： 图片上边距
/// 左：  图片左边距（负的居中）
/// 下： 文字下边距
/// 右： 暂未使用（可传0） 
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/// 选中大小 右没用到
/// 上 ： 图片上边距
/// 左：  图片左边距（负的居中）
/// 下： 文字下边距
/// 右： 暂未使用（可传0）
@property (nonatomic, assign) UIEdgeInsets selectedEdgeInsets;

/// 显示tabbar文字
@property (nonatomic, assign) BOOL titleShow;

/// 选中显示tabbar文字
@property (nonatomic, assign) BOOL selectedTitleShow;

/// 未选中tabbar文字
@property (nonatomic, copy) NSAttributedString *attributedString;
/// 选中tabbar文字
@property (nonatomic, copy) NSAttributedString *selectedAttributedString;

/// 是否选中
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong, readonly, nonnull) Class className;

+ (instancetype)imageTypeLot:(NSURL *)lottie;

+ (instancetype)imageTypeImage:(NSURL *)img
                 selectedImage:(NSURL *)selectedImg;

+ (instancetype)imageTypeGif:(NSURL *)gif
             selectedGifName:(nullable NSURL *)selectedGif;

- (void)setClassName:(Class _Nonnull)className;

- (BOOL)isNeedUpdate:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
