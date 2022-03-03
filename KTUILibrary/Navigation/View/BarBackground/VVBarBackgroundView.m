//
//  VVBarBackgroundView.m
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVBarBackgroundView.h"
#import "VVBarBackgroundVisualEffectView.h"
#import "VVBarBackgroundShadowView.h"
#import "VVNavigationItem.h"
//#import <vv_rootlib_ios/VVDataHelper.h>
//#import <vv_rootlib_ios/UIColor+TDHelp.h>
//#import <vv_rootlib_ios/TDScope.h>
//#import <vv_rootlib_ios/NSObject+VVKVOHelper.h>
#import <Masonry/Masonry.h>
#import <KTFoundation/KTMacros.h>

@interface VVBarBackgroundView ()

/// 背景图片
@property (nonatomic, strong) UIImageView *imageView;

/// 毛玻璃效果
@property (nonatomic, strong) VVBarBackgroundVisualEffectView *effectView;

/// 底部阴影或者分割线
@property (nonatomic, strong) VVBarBackgroundShadowView *bgShadowView;

@property (nonatomic, strong) VVNavigationItem *model;

@end

@implementation VVBarBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        
#warning TODO 0303
//        @weakify(self)
//        [self vv_addObserverOptionsNewForKeyPath:@"model" block:^{
//            @strongify(self)
//            [self addObservers];
//        }];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.bgShadowView];
    [self addSubview:self.imageView];
}

- (void)setUpConstraints
{
    [self.bgShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)updateWithModel:(VVNavigationItem *)model
{
    if (![model isKindOfClass:VVNavigationItem.class]) {
        return;
    }
    
    if (self.model != model) {
        self.model = model;
    }
    
    [self.bgShadowView updateWithModel:model];
    
    [self setUpAlpha];
    [self setUpTranslucent];
    [self setUpBgImage];
    [self setUpBgColor];
}

- (void)addObservers
{
#warning TODO 0303
//    @weakify(self)
//    [self.model vv_addObserverForKeyPath:@"alpha"
//                                 options:NSKeyValueObservingOptionNew
//                                 context:(__bridge void * _Nullable)self
//                               withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpAlpha];
//    }];
//
//    [self.model vv_addObserverForKeyPath:@"translucent"
//                                 options:NSKeyValueObservingOptionNew
//                                 context:(__bridge void * _Nullable)self
//                               withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpTranslucent];
//    }];
//
//    [self.model.barBGModel vv_addObserverForKeyPath:@"bgImage"
//                                            options:NSKeyValueObservingOptionNew
//                                            context:(__bridge void * _Nullable)self
//                                          withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpBgImage];
//    }];
//
//    [self.model.barBGModel vv_addObserverForKeyPath:@"bgColor"
//                                            options:NSKeyValueObservingOptionNew
//                                            context:(__bridge void * _Nullable)self
//                                          withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpBgColor];
//    }];
}

- (void)setUpAlpha
{
    self.imageView.alpha = self.model.alpha;
    self.bgShadowView.alpha = self.model.alpha;
    self.effectView.alpha = self.model.alpha;
}

- (void)setUpTranslucent
{
    if (self.model.translucent) {
        // 半透明
        if (!self.effectView.superview) {
            [self addSubview:self.effectView];
            [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }
    } else {
        [self.effectView removeFromSuperview];
    }
}

- (void)setUpBgImage
{
    self.imageView.image = self.model.barBGModel.bgImage;
}

- (void)setUpBgColor
{
    self.imageView.backgroundColor = self.model.barBGModel.bgColor;
}

#pragma mark - 懒加载
- (VVBarBackgroundVisualEffectView *)effectView
{
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[VVBarBackgroundVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (VVBarBackgroundShadowView *)bgShadowView
{
    if (!_bgShadowView) {
        _bgShadowView = [[VVBarBackgroundShadowView alloc] init];
    }
    return _bgShadowView;
}

@end
