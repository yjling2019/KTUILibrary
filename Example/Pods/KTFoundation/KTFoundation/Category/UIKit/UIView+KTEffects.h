//
//  UIView+Effects.h
//  KOTU
//
//  Created by KOTU on 2017/9/8.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KTRectCornerTop (UIRectCornerTopLeft | UIRectCornerTopRight)
#define KTRectCornerBottom (UIRectCornerBottomLeft | UIRectCornerBottomRight)

typedef UIView *(^KTCornerCornerBlock ) (UIRectCorner  corner );
typedef UIView *(^KTCornerRadiusBlock ) (CGFloat       radius );

typedef UIView *(^KTBorderColorBlock  ) (UIColor      *color  );
typedef UIView *(^KTBorderWidthBlock  ) (CGFloat       width  );

typedef UIView *(^KTShadowColorBlock  ) (UIColor      *color  );
typedef UIView *(^KTShadowOffsetBlock ) (CGSize        size   );
typedef UIView *(^KTShadowRadiusBlock ) (CGFloat       radius );
typedef UIView *(^KTShadowOpacityBlock) (CGFloat       opacity);

typedef UIView *(^KTBezierPathBlock) (UIBezierPath    *path   );
typedef UIView *(^KTViewBoundsBlock) (CGRect           rect   );

typedef UIView *(^KTOptimiseBlock) (BOOL);

typedef UIView *(^KTShowVisualBlock) (void);
typedef UIView *(^KTClearVisualBlock) (void);

/**
 注意：在设置圆角和阴影时会去获取视图控件的bounds，所以在视图控件的bounds变化后，需要重新设置
 */
@interface UIView (KTEffects)

// 圆角
@property(nonatomic, strong, readonly) KTCornerCornerBlock kt_corner;  // UIRectCorner 默认 UIRectCornerAllCorners
@property(nonatomic, strong, readonly) KTCornerRadiusBlock kt_cornerRadius;  // 圆角半径 默认 0.0

// 边框
@property(nonatomic, strong, readonly) KTBorderColorBlock   kt_borderColor;    // 边框颜色 默认 black
@property(nonatomic, strong, readonly) KTBorderWidthBlock   kt_borderWidth;    // 边框宽度 默认 0.0

// 阴影
@property(nonatomic, strong, readonly) KTShadowColorBlock   kt_shadowColor;    // 阴影颜色 默认 black
@property(nonatomic, strong, readonly) KTShadowOffsetBlock  kt_shadowOffset;   // 阴影偏移方向和距离 默认 {0.0，0.0}
@property(nonatomic, strong, readonly) KTShadowRadiusBlock  kt_shadowRadius;   // 阴影模糊度 默认 0.0
@property(nonatomic, strong, readonly) KTShadowOpacityBlock kt_shadowOpacity;  // (0~1] 默认 0.0

// 路径
@property(nonatomic, strong, readonly) KTBezierPathBlock kt_bezierPath; // 贝塞尔路径 默认 nil (有值时，radius属性将失效)
@property(nonatomic, strong, readonly) KTViewBoundsBlock kt_viewBounds; // 设置圆角时，会去获取视图的bounds属性，如果此时获取不到，则需要传入该参数，默认为 nil，如果传入该参数，则不会去回去视图的bounds属性了

/// 是否使用优化， 默认否
@property (nonatomic, strong, readonly) KTOptimiseBlock kt_willOptimise;

// 调用
@property(nonatomic, strong, readonly) KTShowVisualBlock kt_showVisual; // 展示
@property(nonatomic, strong, readonly) KTClearVisualBlock kt_clearVisual; // 隐藏

@end
