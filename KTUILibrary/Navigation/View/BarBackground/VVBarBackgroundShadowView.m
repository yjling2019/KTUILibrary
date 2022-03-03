//
//  VVBarBackgroundShadowView.m
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVBarBackgroundShadowView.h"
#import "VVNavigationItem.h"
#import <KTFoundation/KTMacros.h>
//#import <vv_rootlib_ios/NSObject+VVKVOHelper.h>
#import <Masonry/Masonry.h>
//#import <vv_rootlib_ios/UIColor+TDHelp.h>
//#import <vv_rootlib_ios/VVColorManager.h>

@interface VVBarBackgroundShadowView ()

@property (nonatomic, strong) VVNavigationItem *model;

@end

@implementation VVBarBackgroundShadowView

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
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 0;
    self.layer.shadowPath = nil;
}

- (void)updateWithModel:(VVNavigationItem *)model
{
    if (![model isKindOfClass:VVNavigationItem.class]) {
        return;
    }
    
    if (self.model != model) {
        self.model = model;
    }
    
    [self setUpDividingStyle];
}

- (void)addObservers
{
#warning TODO 0303
	
//    @weakify(self)
//    [self.model.barBGModel vv_addObserverForKeyPath:@"dividingStyle"
//                                            options:NSKeyValueObservingOptionNew
//                                            context:(__bridge void * _Nullable)self
//                                          withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpDividingStyle];
//    }];
}

- (void)setUpDividingStyle
{
    switch (self.model.barBGModel.dividingStyle) {
        case VVNavigationBarDividingStyleLine:
        {
            if (self.model.barBGModel.dividingColor) {
                self.backgroundColor = self.model.barBGModel.dividingColor;
            } else {
#warning TODO 0303
//                self.backgroundColor = [VVColorManager colorWithLightColor:@"#e0e0e0" darkColor:@"#1affffff"];
            }

            self.layer.shadowColor = [UIColor clearColor].CGColor;
            self.layer.shadowPath = nil;
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            break;
        }
            
        case VVNavigationBarDividingStyleShadow:
        {
            if (self.model.barBGModel.dividingColor) {
                self.layer.shadowColor = self.model.barBGModel.dividingColor.CGColor;
            } else {
#warning TODO 0303
//                self.layer.shadowColor = [VVColorManager colorWithLightColor:@"#e0e0e0" darkColor:@"#1affffff"].CGColor;
            }
            self.backgroundColor = [UIColor clearColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
            });
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            break;
        }
            
        case VVNavigationBarDividingStyleCustom:
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
    
    if (self.model.barBGModel.dividingStyle == VVNavigationBarDividingStyleShadow) {
        if (self.model.barBGModel.dividingColor) {
            self.layer.shadowColor = self.model.barBGModel.dividingColor.CGColor;
        } else {
#warning TODO 0303
//            self.layer.shadowColor = [VVColorManager colorWithLightColor:@"#e0e0e0" darkColor:@"#1affffff"].CGColor;
        }
    }
}

@end
