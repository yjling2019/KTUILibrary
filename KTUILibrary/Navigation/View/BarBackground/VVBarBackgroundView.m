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
#import <KVOController/KVOController.h>

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
        
		@weakify(self);
		[self.KVOController observe:self
							keyPath:@"model"
							options:NSKeyValueObservingOptionNew
							  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
			@strongify(self);
			[self addObservers];
		}];
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
	@weakify(self);
	[self.KVOController observe:self
						keyPath:@"model.alpha"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self);
		[self setUpAlpha];
	}];

	[self.KVOController observe:self
						keyPath:@"model.translucent"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self);
		[self setUpTranslucent];
	}];
	
	[self.KVOController observe:self
						keyPath:@"model.barBGModel.bgImage"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self);
		[self setUpBgImage];
	}];
	
	[self.KVOController observe:self
						keyPath:@"model.barBGModel.bgColor"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self);
		[self setUpBgColor];
	}];
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
