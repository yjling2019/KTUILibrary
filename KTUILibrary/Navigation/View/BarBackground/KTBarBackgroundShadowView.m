//
//  KTBarBackgroundShadowView.m
//  VOVA
//
//  Created by KOTU on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTBarBackgroundShadowView.h"
#import "KTNavigationItem.h"
#import <KTFoundation/KTMacros.h>
#import <Masonry/Masonry.h>
#import <KVOController/KVOController.h>

@interface KTBarBackgroundShadowView ()

@property (nonatomic, strong) KTNavigationItem *model;

@end

@implementation KTBarBackgroundShadowView

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
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 0;
    self.layer.shadowPath = nil;
}

- (void)updateWithModel:(KTNavigationItem *)model
{
    if (![model isKindOfClass:KTNavigationItem.class]) {
        return;
    }
    
    if (self.model != model) {
        self.model = model;
    }
    
    [self setUpDividingStyle];
}

- (void)addObservers
{	
	@weakify(self);
	[self.KVOController observe:self
						keyPath:@"model.barBGModel.dividingStyle"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self)
		[self setUpDividingStyle];
	}];
}

- (void)setUpDividingStyle
{
    switch (self.model.barBGModel.dividingStyle) {
        case KTNavigationBarDividingStyleLine:
        {
            if (self.model.barBGModel.dividingColor) {
                self.backgroundColor = self.model.barBGModel.dividingColor;
            } else {
#warning TODO 0303
//                self.backgroundColor = [KTColorManager colorWithLightColor:@"#e0e0e0" darkColor:@"#1affffff"];
            }

            self.layer.shadowColor = [UIColor clearColor].CGColor;
            self.layer.shadowPath = nil;
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            break;
        }
            
        case KTNavigationBarDividingStyleShadow:
        {
            if (self.model.barBGModel.dividingColor) {
                self.layer.shadowColor = self.model.barBGModel.dividingColor.CGColor;
            } else {
#warning TODO 0303
//                self.layer.shadowColor = [KTColorManager colorWithLightColor:@"#e0e0e0" darkColor:@"#1affffff"].CGColor;
            }
            self.backgroundColor = [UIColor clearColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
            });
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            break;
        }
            
        case KTNavigationBarDividingStyleCustom:
        {
            self.backgroundColor = [UIColor clearColor];
            self.layer.shadowColor = [UIColor clearColor].CGColor;
            self.layer.shadowPath = nil;
            if (self.model.barBGModel.dividingView &&
                !self.model.barBGModel.dividingView.superview) {
                [self.model.barBGModel.dividingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(self);
                }];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (self.model.barBGModel.dividingStyle == KTNavigationBarDividingStyleShadow) {
        if (self.model.barBGModel.dividingColor) {
            self.layer.shadowColor = self.model.barBGModel.dividingColor.CGColor;
        } else {
#warning TODO 0303
//            self.layer.shadowColor = [KTColorManager colorWithLightColor:@"#e0e0e0" darkColor:@"#1affffff"].CGColor;
        }
    }
}

@end
