//
//  VVButtonBarButton.m
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVButtonBarButton.h"
#import "VVBarButtonItem.h"
#import <Masonry/Masonry.h>
#import <KTFoundation/KTMacros.h>
//#import <vv_rootlib_ios/NSObject+VVKVOHelper.h>
//#import <vv_rootlib_ios/NSDictionary+DataProtect.h>

static NSString * const VVButtonBarButtonString = @"VVButtonBarButtonString";

@interface VVButtonBarButton ()

/// 图片
@property (nonatomic, strong) UIImageView *imageView;

/// 文字
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) VVBarButtonItem *buttonItem;

@end

@implementation VVButtonBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        [self setUpConstraints];
        [self bindUIActions];
        
#warning TODO 0303
        @weakify(self)
//        [self vv_addObserverOptionsNewForKeyPath:@"buttonItem" block:^{
//            @strongify(self)
//            [self addObservers];
//        }];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.textLabel];
    [self addSubview:self.imageView];
}

- (void)setUpConstraints
{
    
}

- (void)bindUIActions
{
    
}

- (void)updateWithModel:(VVBarButtonItem *)model
{
    if (![model isKindOfClass:VVBarButtonItem.class]) {
        return;
    }
    
    if (self.buttonItem != model) {
        self.buttonItem = model;
    }
    
    [self setUpImageAndLabel];
    self.enabled = model.enabled;
}

- (void)setUpImageAndLabel
{
    NSAttributedString *attributedText = [self.buttonItem realityAttrText];
    UIImage *image = [self.buttonItem realityImage];
    if (image &&
        attributedText) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.imageView.mas_trailing).offset(5);
            make.top.bottom.trailing.mas_equalTo(0);
        }];
        
        self.textLabel.hidden = false;
        self.imageView.hidden = false;
    } else if (image) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        self.textLabel.hidden = true;
        self.imageView.hidden = false;
    } else {
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.trailing.mas_equalTo(0);
        }];
        self.textLabel.hidden = false;
        self.imageView.hidden = true;
    }
    self.imageView.image = image;
    self.textLabel.attributedText = attributedText;
}

- (void)addObservers
{
    static int count = 1;
    NSString *string = [NSString stringWithFormat:@"%@_%@", VVButtonBarButtonString, @(count)];
    void *context = (__bridge void *)string;
    
#warning TODO 0303
	
//    @weakify(self)
//    [self.buttonItem vv_addObserverForKeyPath:@"statusBarStyle"
//                                      options:NSKeyValueObservingOptionNew
//                                      context:context
//                                    withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        [self setUpImageAndLabel];
//    }];
//
//    [self.buttonItem  vv_addObserverForKeyPath:@"enabled"
//                                         options:NSKeyValueObservingOptionNew
//                                         context:context
//                                       withBlock:^(NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self)
//        self.enabled = self.buttonItem.enabled;
//    }];
//
//    [self.buttonItem vv_addObserverForKeyPaths:@[@"text",
//                                                 @"darkImage",
//                                                 @"lightImage"] options:NSKeyValueObservingOptionNew context:context withDetailBlock:^(NSString * _Nonnull keyPath, NSDictionary * _Nonnull change, void * _Nonnull context) {
//        @strongify(self);
//        if ([keyPath isEqualToString:@"text"]) {
//            self.buttonItem.lightAttrText = nil;
//            self.buttonItem.darkAttrText = nil;
//        }
//        [self setUpImageAndLabel];
//    }];
//
//    count = count + 1;
}

#pragma mark - 懒加载
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
