//
//  UIView+Effects.m
//  KOTU
//
//  Created by KOTU on 2017/9/8.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import "UIView+KTEffects.h"
#import <objc/runtime.h>

#define kConrnerCorner  "UIView.privateConrnerCorner"
#define kConrnerBounds  "UIView.privateConrnerBounds"
#define kConrnerRadius  "UIView.privateConrnerRadius"

#define kBorderColor    "UIView.privateBorderColor"
#define kBorderWidth    "UIView.privateBorderWidth"

#define kShadowOpacity  "UIView.privateShadowOpacity"
#define kShadowRadius   "UIView.privateShadowRadius"
#define kShadowOffset   "UIView.privateShadowOffset"
#define kShadowColor    "UIView.privateShadowColor"

#define kBezierPath     "UIView.privateBezierPath"
#define kViewBounds     "UIView.privateViewBounds"

#define kBackgroundView "UIView.BackgroundView"

#define kViewVVOptimise "UIView.VVOptimise"

@implementation UIView (KTEffects)
@dynamic kt_corner,
         kt_cornerRadius,
         kt_borderColor,
         kt_borderWidth,
         kt_shadowColor,
         kt_shadowOffset,
         kt_shadowRadius,
         kt_shadowOpacity,
         kt_showVisual,
         kt_clearVisual,
         kt_bezierPath,
         kt_viewBounds;

#pragma mark - 添加私有属性
// mark - 圆角 矩形 默认 AllCorners
- (void)setPrivateConrnerCorner:(UIRectCorner)corner {
    objc_setAssociatedObject(self, kConrnerCorner, [NSNumber numberWithInteger:corner], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIRectCorner)privateConrnerCorner {
    id corner = objc_getAssociatedObject(self, kConrnerCorner);
    return corner ? [corner integerValue] : UIRectCornerAllCorners;
}

// mark - 圆角 半径 默认 0.0
- (void)setPrivateConrnerRadius:(CGFloat)radius {
    objc_setAssociatedObject(self, kConrnerRadius, [NSNumber numberWithFloat:radius], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)privateConrnerRadius {
    id radius = objc_getAssociatedObject(self, kConrnerRadius);
    return radius ? [radius floatValue] : 0.0;
}

// mark - 边框 宽度 默认 0.0
- (void)setPrivateBorderWidth:(CGFloat)width {
    objc_setAssociatedObject(self, kBorderWidth, [NSNumber numberWithFloat:width], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)privateBorderWidth {
    id width = objc_getAssociatedObject(self, kBorderWidth);
    return width ? [width floatValue] : 0.0;
}

// mark - 边框 颜色 默认 黑色
- (void)setPrivateBorderColor:(UIColor *)color {
    objc_setAssociatedObject(self, kBorderColor, color, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)privateBorderColor {
    id color = objc_getAssociatedObject(self, kBorderColor);
    return color ? color : [UIColor blackColor];
}

// mark - 阴影 半径 默认 0.0
- (void)setPrivateShadowRadius:(CGFloat)opacity {
    objc_setAssociatedObject(self, kShadowOpacity, [NSNumber numberWithFloat:opacity], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)privateShadowRadius {
    id radius = objc_getAssociatedObject(self, kShadowOpacity);
    return radius ? [radius floatValue] : 0.0;
}

// mark - 阴影 模糊度 默认 0.0
- (void)setPrivateShadowOpacity:(CGFloat)radius {
    objc_setAssociatedObject(self, kShadowRadius, [NSNumber numberWithFloat:radius], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)privateShadowOpacity {
    id opacity = objc_getAssociatedObject(self, kShadowRadius);
    return opacity ? [opacity floatValue] : 0.0;
}

// mark - 阴影 偏移方向和距离 默认 {0.0，0.0}
- (void)setPrivateShadowOffset:(CGSize)offset {
    objc_setAssociatedObject(self, kShadowOffset, NSStringFromCGSize(offset), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGSize)privateShadowOffset {
    id offset = objc_getAssociatedObject(self, kShadowOffset);
    return offset ? CGSizeFromString(offset) : CGSizeZero;
}

// mark - 阴影 颜色 默认 black
- (void)setPrivateShadowColor:(UIColor *)color {
    objc_setAssociatedObject(self, kShadowColor, color, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)privateShadowColor {
    id color = objc_getAssociatedObject(self, kShadowColor);
    return color ? color : [UIColor blackColor];
}

// mark - 路径 默认 nil
- (void)setPrivateBezierPath:(UIBezierPath *)path {
    objc_setAssociatedObject(self, kBezierPath, path, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIBezierPath *)privateBezierPath {
    id path = objc_getAssociatedObject(self, kBezierPath);
    return path ? path : nil;
}

// mark - 视图 大小 默认 nil
- (void)setPrivateViewBounds:(CGRect)rect {
    objc_setAssociatedObject(self, kViewBounds, NSStringFromCGRect(rect), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)privateViewBounds {
    id path = objc_getAssociatedObject(self, kViewBounds);
    return path ? CGRectFromString(path) : CGRectZero;
}

// 阴影空视图，只在有圆角的时候使用
- (UIView *)shadowBackgroundView {
    return objc_getAssociatedObject(self, kBackgroundView);
}

- (void)setShadowBackgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, kBackgroundView, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)privateOptimise {
    return [objc_getAssociatedObject(self, kViewVVOptimise) boolValue];
}

- (void)setPrivateOptimise:(BOOL)optimise {
    objc_setAssociatedObject(self, kViewVVOptimise, [NSNumber numberWithBool:optimise], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 链式属性实现
- (KTCornerCornerBlock)kt_corner {
    return ^(UIRectCorner corner) {
        self.privateConrnerCorner = corner;
        return self;
    };
}

- (KTCornerRadiusBlock)kt_cornerRadius {
    return ^(CGFloat radius) {
        self.privateConrnerRadius = radius;
        return self;
    };
}

- (KTBorderColorBlock)kt_borderColor {
    return ^(UIColor *color) {
        self.privateBorderColor = color;
        return self;
    };
}

- (KTBorderWidthBlock)kt_borderWidth {
    return ^(CGFloat width) {
        self.privateBorderWidth = width;
        return self;
    };
}

- (KTShadowOpacityBlock)kt_shadowOpacity {
    return ^(CGFloat opacity) {
        self.privateShadowOpacity = opacity;
        return self;
    };
}

- (KTShadowRadiusBlock)kt_shadowRadius {
    return ^(CGFloat radius) {
        self.privateShadowRadius = radius;
        return self;
    };
}

- (KTShadowOffsetBlock)kt_shadowOffset {
    return ^(CGSize size) {
        self.privateShadowOffset = size;
        return self;
    };
}

- (KTShadowColorBlock)kt_shadowColor {
    return ^(UIColor *color) {
        self.privateShadowColor = color;
        return self;
    };
}

- (KTBezierPathBlock)kt_bezierPath {
    return ^(UIBezierPath *path) {
        self.privateBezierPath = path;
        return self;
    };
}

- (KTViewBoundsBlock)kt_viewBounds {
    return ^(CGRect rect) {
        self.privateViewBounds = rect;
        return self;
    };
}

- (KTOptimiseBlock)kt_willOptimise {
    return ^ (BOOL willOptimis) {
        self.privateOptimise = willOptimis;
        return self;
    };
}

#pragma mark - 方法实现
- (KTClearVisualBlock)kt_clearVisual {
    return ^{
        // 阴影
        if (self.shadowBackgroundView) {
            [self.shadowBackgroundView removeFromSuperview];
            self.shadowBackgroundView = nil;
        }
        
        // 圆角、边框
        for (CALayer *layer in self.layer.sublayers) {
            if ([layer.name isEqualToString:@"CCViewEffects"]) {
                [layer removeFromSuperlayer];
            }
        }
        
        // 恢复默认设置
        self.privateConrnerCorner = UIRectCornerAllCorners;
        self.privateConrnerRadius = 0.0;
        self.privateBorderColor   = [UIColor blackColor];
        self.privateBorderWidth   = 0.0;
        self.privateShadowOpacity = 0.0;
        self.privateShadowRadius  = 0.0;
        self.privateShadowOffset  = CGSizeZero;
        self.privateViewBounds    = CGRectZero;
        self.privateShadowColor   = [UIColor blackColor];
        self.shadowBackgroundView = nil;
        
        self.layer.masksToBounds  = NO;
        self.layer.cornerRadius   = 0.0;
        self.layer.borderWidth    = 0.0;
        self.layer.borderColor    = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity  = 0.0;
        self.layer.shadowPath     = nil;
        self.layer.shadowRadius   = 0.0;
        self.layer.shadowColor    = [UIColor blackColor].CGColor;
        self.layer.shadowOffset   = CGSizeZero;
        self.layer.mask           = nil;
        return self;
    };
}

- (KTShowVisualBlock)kt_showVisual {
    return ^{
        // 阴影
        [self addShadow];
        // 边框、圆角
        [self addBorderAndRadius];
        return self;
    };
}

#pragma mark - Private methods
-(CGRect)drawBounds {
    // 1.如果传入了大小，则直接返回
    if (!CGRectEqualToRect(self.privateViewBounds, CGRectZero)) {
        return self.privateViewBounds;
    }
    // 2.获取在自动布局时的视图大小
    if (self.superview != nil) {
        [self.superview layoutIfNeeded];
    }
    return self.bounds;
}

-(UIBezierPath *)drawBezierPath {
    if (self.privateBezierPath != nil) {
        return self.privateBezierPath;
    }
    return [UIBezierPath bezierPathWithRoundedRect:[self drawBounds]
                                 byRoundingCorners:self.privateConrnerCorner
                                       cornerRadii:CGSizeMake(self.privateConrnerRadius, self.privateConrnerRadius)];
}

// 添加阴影
-(void)addShadow {
    UIView *shadowView = self;
    // 同时存在阴影和圆角
    if ((self.privateShadowOpacity > 0 && self.privateConrnerRadius > 0) || self.privateBezierPath) {
        if (self.shadowBackgroundView) {
            [self.shadowBackgroundView removeFromSuperview];
            self.shadowBackgroundView = nil;
        }
        NSAssert(self.superview, @"添加阴影和圆角时，请先将view加到父视图上");
        shadowView = [[UIView alloc] initWithFrame:self.frame];
        shadowView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview insertSubview:shadowView belowSubview:self];
        [self.superview addConstraints:@[[NSLayoutConstraint constraintWithItem:shadowView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0],
                                         [NSLayoutConstraint constraintWithItem:shadowView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0],
                                         [NSLayoutConstraint constraintWithItem:shadowView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:0],
                                         [NSLayoutConstraint constraintWithItem:shadowView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:0]]];
        self.shadowBackgroundView = shadowView;
    }
    // 圆角
    if (self.privateConrnerRadius > 0 || self.privateBezierPath) {
        UIBezierPath *shadowPath = [self drawBezierPath];
        shadowView.layer.shadowPath = shadowPath.CGPath;
    }
    // 阴影
    shadowView.layer.masksToBounds = NO;
    shadowView.layer.shadowOpacity = self.privateShadowOpacity;
    shadowView.layer.shadowRadius  = self.privateShadowRadius;
    shadowView.layer.shadowOffset  = self.privateShadowOffset;
    shadowView.layer.shadowColor   = self.privateShadowColor.CGColor;
}

// 添加圆角和边框
-(void)addBorderAndRadius {
    // 圆角或阴影或自定义曲线
    if (self.privateConrnerRadius > 0 || self.privateShadowOpacity > 0 || self.privateBezierPath) {
        // 圆角
        if (self.privateConrnerRadius > 0 || self.privateBezierPath) {
            BOOL notEnableClass = [self isKindOfClass:UIButton.class] || [self isKindOfClass:UILabel.class];
            if (self.privateOptimise && !notEnableClass) {
                if ([self isKindOfClass:UIImageView.class]) {
                    
                    CGRect rect = self.drawBounds;
                    UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:rect.size];
                    UIImage *img = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                        /* 在当前位图上下文添加圆角绘制路径 */
                        CGContextAddPath(rendererContext.CGContext, [self drawBezierPath].CGPath);
                        /* 当前绘制路径和原绘制路径相交得到最终裁剪绘制路径 */
                        CGContextClip(rendererContext.CGContext);
                        /* 绘制 */
                        [((UIImageView *)self).image drawInRect:rect];
                    }];
                    ((UIImageView *)self).image = img;
                    // 防止加了图片背景色
                    self.layer.cornerRadius = self.privateConrnerRadius;
                } else if (self.privateConrnerCorner == UIRectCornerAllCorners) {
                    self.layer.cornerRadius = self.privateConrnerRadius;
                } else {
                    CAShapeLayer *shapeLayer;
                    for (CALayer *layer in self.layer.sublayers) {
                        if ([layer.name isEqualToString:@"CCViewRadiusEffects"]) {
                            shapeLayer = (CAShapeLayer *)layer;
                            break;
                        }
                    }
                    
                    if (!shapeLayer) {
                        shapeLayer = [CAShapeLayer layer];
                        shapeLayer.name = @"CCViewRadiusEffects";
                        shapeLayer.fillColor = self.layer.backgroundColor;
                        self.backgroundColor = UIColor.clearColor;
                        [self.layer addSublayer:shapeLayer];
                    }
                    UIBezierPath *path = [self drawBezierPath];
                    shapeLayer.frame = self.bounds;
                    shapeLayer.path  = path.CGPath;
                }
            } else {
                UIBezierPath *path = [self drawBezierPath];
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.frame = self.bounds;
                maskLayer.path  = path.CGPath;
                self.layer.mask = maskLayer;
            }
        }
        // 边框
        if (self.privateBorderWidth > 0 || self.privateBezierPath) {
            for (CALayer *layer in self.layer.sublayers) {
                if ([layer.name isEqualToString:@"CCViewEffects"]) {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
            UIBezierPath *path = [self drawBezierPath];
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            layer.name  = @"CCViewEffects";
            layer.frame = self.bounds;
            layer.path  = path.CGPath;
            layer.lineWidth   = self.privateBorderWidth;
            layer.strokeColor = self.privateBorderColor.CGColor;
            layer.fillColor   = [UIColor clearColor].CGColor;
            [self.layer addSublayer:layer];
        }
    } else {
        // 只有边框
        self.layer.masksToBounds = true;
        self.layer.borderWidth   = self.privateBorderWidth;
        self.layer.borderColor   = self.privateBorderColor.CGColor;
    }
}

@end
