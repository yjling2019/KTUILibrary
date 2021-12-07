//
//  KTImageLabel.h
//  KTUILibrary
//
//  Created by KOTU on 2020/3/12.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KTImageLabelContentImagePosition) {
	KTImageLabelContentImagePositionTop,
	KTImageLabelContentImagePositionLeading, /// 这是leading 不是left
	KTImageLabelContentImagePositionBottom,
	KTImageLabelContentImagePositionTrailing,
	KTImageLabelContentImagePositionOverlap,//重叠，图片在文字上方(图片暂时以leading，top，size为准)
};

typedef NS_ENUM(NSUInteger, KTImageLabelContentImageAlign) {
    KTImageLabelContentImageAlignCenter, //整体居中
    KTImageLabelContentImageAlignTextLeading, //和文字开头对齐
    KTImageLabelContentImageAlignTextCenter, //和文字中间对齐
    KTImageLabelContentImageAlignTextTrailing, //和文字结尾对齐
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^KTImageDownloadBlock)(UIImageView *imageView, NSString * urlString);

@class KTImageLabel;

typedef KTImageLabel *_Nonnull(^KTImageLabelConfigBlock)(id __nullable value);
typedef KTImageLabel *_Nonnull(^KTImageLabelConfigEdgeBlock)(UIEdgeInsets edge);
typedef KTImageLabel *_Nonnull(^KTImageLabelConfigSizeBlock)(CGSize edge);
typedef KTImageLabel *_Nonnull(^KTImageLabelConfigTextAlignBlock)(NSTextAlignment textAlign);
typedef KTImageLabel *_Nonnull(^KTImageLabelConfigPositionBlock)(KTImageLabelContentImagePosition position);
typedef KTImageLabel *_Nonnull(^KTImageLabelConfigAlignBlock)(KTImageLabelContentImageAlign align);

@interface KTImageLabel : UIView

#pragma mark - config
+ (void)configImageLoader:(KTImageDownloadBlock)block;

#pragma mark - UI Property
@property (strong, nonatomic, readonly) UILabel *label;
@property (strong, nonatomic, readonly) UIImageView *contentImageView;
@property (strong, nonatomic, readonly) UIImageView *backgroundImageView;

#pragma mark - content
/// 设置text
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock text;
/// 设置attributeText
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock attributeText;
/// 设置font
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock font;
/// 设置textColor
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock textColor;
/// 设置textAlign，默认居中
@property (strong, nonatomic, readonly) KTImageLabelConfigTextAlignBlock textAlign;
/// 设置行间距
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock lineSpacing;
/// 设置行数
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock numberOfLines;

/// 设置图片
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock contentImage;
/// 设置图片urlstring
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock contentImageUrlString;
/// 设置背景图
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock backgroundImage;

#pragma mark - style

/// 内容图片的位置，默认KTImageLabelContentImagePositionLeft
@property (strong, nonatomic, readonly) KTImageLabelConfigPositionBlock contentImagePosition;
/// 内容图片的对齐方式，默认KTImageLabelContentImageAlignCenter.
/// ⚠️KTImageLabelContentImagePositionOverlap模式下不生效⚠️
@property (strong, nonatomic, readonly) KTImageLabelConfigAlignBlock align;
/// align的偏移量
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock alignOffset;
/// label距边框的距离，默认UIEdgeInsetsZero
@property (strong, nonatomic, readonly) KTImageLabelConfigEdgeBlock textEdge;
/// 内容图片距边框的距离，默认UIEdgeInsetsZero
@property (strong, nonatomic, readonly) KTImageLabelConfigEdgeBlock contentImageEdge;
/// 图文间距，默认0
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock contentSpace;
/// 自动换行，默认NO
@property (strong, nonatomic, readonly) KTImageLabelConfigBlock autoWrap;
/// 内容图片的尺寸，默认CGSizeZero
@property (strong, nonatomic, readonly) KTImageLabelConfigSizeBlock contentImageSize;

@end

NS_ASSUME_NONNULL_END
