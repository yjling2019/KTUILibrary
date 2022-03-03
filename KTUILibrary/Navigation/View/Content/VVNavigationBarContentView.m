//
//  VVNavigationBarContentView.m
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVNavigationBarContentView.h"
#import "VVNavigationItem.h"
#import "VVButtonBarButton.h"
#import <Masonry/Masonry.h>
#import <KVOController/KVOController.h>
#import "KTMacros.h"

//#import <vv_rootlib_ios/TDScope.h>
//#import <vv_rootlib_ios/NSObject+VVKVOHelper.h>
//#import <vv_rootlib_ios/VVDataHelper.h>

@interface VVNavigationBarContentView ()

/// “左侧”stackView
@property (nonatomic, strong) UIStackView *leadingStackView;

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/// “右侧”stackView
@property (nonatomic, strong) UIStackView *trailingStackView;

@property (nonatomic, strong) VVNavigationItem *model;

@property (nonatomic, strong) NSMapTable<VVBarButtonItem *, VVButtonBarButton *> *barButtonItems;

@end

@implementation VVNavigationBarContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        
        @weakify(self)
#warning TODO 0303
//		[self.KVOController observe:]
		
//        [self vv_addObserverOptionsNewForKeyPath:@"model" block:^{
//            @strongify(self)
//            [self addObservers];
//        }];

        self.barButtonItems = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.titleLabel];
}

- (void)setUpConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.trailing.mas_lessThanOrEqualTo(-80);
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
    
    [self setUpAlpha];
    [self setUpTitle];
    [self arrangeBackBarButtonItem];
    
    if (self.model.rightBarButtonItems) {
        [self arrangeRightBarButtonItems];
    } else {
        [self arrangeRightBarButtonItem];
    }
}

- (void)addObservers
{
#warning TODO O303
//    @weakify(self)
//    [self.model vv_addObserverForKeyPath:@"title"
//                                 options:NSKeyValueObservingOptionNew
//                                 context:(__bridge void * _Nullable)self
//                               withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpAlpha];
//        [self setUpTitle];
//    }];
//
//    NSArray<NSString *> *keyPaths = @[
//        @"alpha",
//        @"barBGModel.darkColor"
//    ];
//    [self.model vv_addObserverForKeyPaths:keyPaths options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)self withDetailBlock:^(NSString * _Nonnull keyPath, NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpAlpha];
//    }];
//
//    [self.model vv_addObserverOptionsNewForKeyPath:@"backBarButtonItem" block:^{
//        @strongify(self)
//        [self arrangeBackBarButtonItem];
//        [self setUpTitle];
//    }];
//
//    [self.model vv_addObserverOptionsNewForKeyPath:@"rightBarButtonItem" block:^{
//        @strongify(self)
//        [self arrangeRightBarButtonItem];
//        [self setUpTitle];
//    }];
//
//    [self.model vv_addObserverOptionsNewForKeyPath:@"rightBarButtonItems" block:^{
//        @strongify(self)
//        [self arrangeRightBarButtonItems];
//        [self setUpTitle];
//    }];
}

- (void)setUpAlpha
{
    self.titleLabel.alpha = self.model.alpha;
    self.titleLabel.attributedText = self.model.realityAttrTitle;
    for (VVBarButtonItem *item in self.barButtonItems) {
        item.statusBarStyle = self.model.realityStatusBarStyle;
    }
}

- (void)setUpTitle
{
    if (_trailingStackView.superview) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.trailing.lessThanOrEqualTo(self.trailingStackView.mas_leading).offset(-16);
        }];
    } else if (_leadingStackView.superview) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.leading.greaterThanOrEqualTo(self.leadingStackView.mas_trailing).offset(16);
        }];
    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.leading.mas_greaterThanOrEqualTo(16);
        }];
    }
};

- (void)arrangeBackBarButtonItem
{
    VVBarButtonItem *backBarButtonItem = self.model.backBarButtonItem;
    if (backBarButtonItem) {
        [self setUpLeadingStackView];
        [self stackView:self.leadingStackView
    addArrangedSubviews:@[backBarButtonItem]];
    } else {
        [self.leadingStackView removeFromSuperview];
    }
}

- (void)arrangeRightBarButtonItem
{
    VVBarButtonItem *rightBarButtonItem = self.model.rightBarButtonItem;
    if (rightBarButtonItem) {
        [self setUpTrailingStackView];
        [self stackView:self.trailingStackView
    addArrangedSubviews:@[rightBarButtonItem]];
    } else {
        [self.trailingStackView removeFromSuperview];
    }
}

- (void)arrangeRightBarButtonItems
{
    BOOL flag = (self.model.rightBarButtonItems.count <= 2);
    [self assert:flag desc:@"右侧自定义按钮不能超过两个"];
    
    NSArray<VVBarButtonItem *> *rightBarButtonItems = self.model.rightBarButtonItems;
    if (rightBarButtonItems.count) {
        [self setUpTrailingStackView];
        [self stackView:self.trailingStackView
    addArrangedSubviews:rightBarButtonItems];
    } else {
        [self.trailingStackView removeFromSuperview];
    }
}

- (void)stackView:(UIStackView *)stackView
addArrangedSubviews:(NSArray<VVBarButtonItem *> *)items
{
    NSArray<UIView *> *array = stackView.arrangedSubviews;
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    
    int count = (int)items.count;
    for (int i = (count - 1); i >= 0; i = i - 1) {
        VVBarButtonItem *item = [items objectAtIndex:i];
        VVButtonBarButton *barButton = [self.barButtonItems objectForKey:item];
        item.statusBarStyle = self.model.realityStatusBarStyle;
        if (barButton) {
            item.statusBarStyle = self.model.realityStatusBarStyle;
            [stackView addArrangedSubview:barButton];
            continue;
        }
        
        if ([item respondsToSelector:@selector(itemGetButton)]) {
            barButton = [item itemGetButton];
        } else {
            [self assert:false desc:@"哎呀呀，匹配不上"];
        }
        
        BOOL flag = [barButton isKindOfClass:VVButtonBarButton.class];
        
        [self assert:flag desc:@"自定义的导航栏按钮不是VVButtonBarButton子类哦"];
        
        if (flag) {
            [self.barButtonItems setObject:barButton forKey:item];
            [barButton updateWithModel:item];
            [stackView addArrangedSubview:barButton];
            if (item.target &&
                item.action) {
                [barButton addTarget:item.target
                              action:item.action
                    forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (void)setUpLeadingStackView
{
    if (!self.leadingStackView.superview) {
        [self addSubview:self.leadingStackView];
        [self.leadingStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(12);
        }];
    }
}

- (void)setUpTrailingStackView
{
    if (!self.trailingStackView.superview) {
        [self addSubview:self.trailingStackView];
        [self.trailingStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.trailing.mas_equalTo(-12);
        }];
    }
}

- (UIStackView *)horizonTalStackView
{
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 16;
    return stackView;
}

#pragma mark - assert
- (void)assert:(BOOL)flag desc:(NSString *)desc
{
#if DEBUG
    NSAssert(flag, desc);
#endif
}

#pragma mark - 懒加载
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIStackView *)leadingStackView
{
    if (!_leadingStackView) {
        _leadingStackView = [self horizonTalStackView];
    }
    return _leadingStackView;
}

- (UIStackView *)trailingStackView
{
    if (!_trailingStackView) {
        _trailingStackView = [self horizonTalStackView];
    }
    return _trailingStackView;
}

@end
