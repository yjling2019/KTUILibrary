//
//  VVNavigationBar.m
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVNavigationBar.h"
#import "VVNavigationBaseView.h"
#import "VVBarBackgroundView.h"
#import "VVNavigationBarContentView.h"
#import "VVNavigationItem.h"
//#import "VVUIMacros.h"
//#import <vv_rootlib_ios/TDScope.h>
//#import <vv_rootlib_ios/NSObject+VVKVOHelper.h>
//#import <vv_rootlib_ios/NSDictionary+DataProtect.h>
#import <Masonry/Masonry.h>
#import "KTMacros.h"

@interface VVNavigationBar ()

/// 背景图片
@property (nonatomic, strong) VVBarBackgroundView *barBGView;

/// 两侧按钮、标题view
@property (nonatomic, strong) VVNavigationBarContentView *barContentView;

/// 自定义view的背景
@property (nonatomic, strong) VVNavigationBaseView *customBGView;

@property (nonatomic, strong) VVNavigationItem *model;

@end

@implementation VVNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        [self setUpConstraints];
        
#warning TODO 0303
        @weakify(self)
//        [self vv_addObserverOptionsNewForKeyPath:@"model" block:^{
//            @strongify(self)
//            [self addObservers];
//        }];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.barBGView];
    [self addSubview:self.barContentView];
    [self addSubview:self.customBGView];
}

- (void)setUpConstraints
{
    [self.barBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-[[UIApplication sharedApplication] statusBarFrame].size.height);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
    }];
    
    [self.barContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.customBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.barBGView updateWithModel:model];
    [self.barContentView updateWithModel:model];
    
    [self.viewController setNeedsStatusBarAppearanceUpdate];
    [self setUpCustomView];
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
//        [self.viewController setNeedsStatusBarAppearanceUpdate];
//    }];
//
//    [self.model.barBGModel vv_addObserverForKeyPath:@"darkColor"
//                                            options:NSKeyValueObservingOptionNew
//                                            context:(__bridge void * _Nullable)self
//                                          withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self.viewController setNeedsStatusBarAppearanceUpdate];
//    }];
//
//    [self.model.barBGModel vv_addObserverForKeyPath:@"bgColor"
//                                            options:NSKeyValueObservingOptionNew
//                                            context:(__bridge void * _Nullable)self
//                                          withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self.viewController setNeedsStatusBarAppearanceUpdate];
//    }];
//
//    [self.model vv_addObserverForKeyPath:@"customView"
//                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                                 context:(__bridge void * _Nullable)self
//                               withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        UIView *oldCustomView = [change vv_objectForKey:@"old" verifyClass:UIView.class];
//        [oldCustomView removeFromSuperview];
//        [self setUpCustomView];
//    }];
//
//    [self.model vv_addObserverForKeyPath:@"containStatusBar"
//                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                                 context:(__bridge void * _Nullable)self
//                               withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpCustomBGView];
//    }];
}

- (void)setUpCustomView
{
    if (self.model.customView) {
        [self.barContentView removeFromSuperview];
        if (!self.model.customView.superview) {
            if (!self.customBGView.superview) {
                [self addSubview:self.customBGView];
            }
            [self setUpCustomBGView];
            [self.customBGView addSubview:self.model.customView];
            [self.model.customView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.customBGView);
            }];
        }
    } else {
        if (!self.barContentView.superview) {
            [self addSubview:self.barContentView];
            [self.barContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }
        [self.barContentView updateWithModel:self.model];
        [self.customBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.customBGView removeFromSuperview];
    }
}

- (void)setUpCustomBGView
{
    if (!self.customBGView.superview) {
        return;
    }
    if (self.model.containStatusBar) {
        [self.customBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.barBGView);
        }];
    } else {
        [self.customBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:VVNavigationBaseView.class]) {
            continue;
        } else {
            [subView removeFromSuperview];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (self.model.viewMoveDown &&
        (self.barContentView == view ||
         self.model.customView == view)) {
        return nil;
    }
    if (self.model.alpha == 0 &&
        self.model.passThroughTouches &&
        (self.barContentView == view ||
        self.model.customView == view)) {
        return nil;
    }
    return view;
}

#pragma mark - 懒加载

- (VVBarBackgroundView *)barBGView
{
    if (!_barBGView) {
        _barBGView = [[VVBarBackgroundView alloc] init];
    }
    return _barBGView;
}

- (VVNavigationBarContentView *)barContentView
{
    if (!_barContentView) {
        _barContentView = [[VVNavigationBarContentView alloc] init];
    }
    return _barContentView;
}

- (VVNavigationBaseView *)customBGView
{
    if (!_customBGView) {
        _customBGView = [[VVNavigationBaseView alloc] init];
    }
    return _customBGView;
}

#pragma mark - dealloc
- (void)dealloc
{
    
}

@end
