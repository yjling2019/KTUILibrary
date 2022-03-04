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
#import <KVOController/KVOController.h>

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
#warning TODO context
    static int count = 1;
    NSString *string = [NSString stringWithFormat:@"%@_%@", VVButtonBarButtonString, @(count)];
    void *context = (__bridge void *)string;
    
	@weakify(self);
	[self.KVOController observe:self
						keyPath:@"buttonItem.statusBarStyle"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self)
		[self setUpImageAndLabel];
	}];
	
	[self.KVOController observe:self
						keyPath:@"buttonItem.enabled"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self)
		self.enabled = self.buttonItem.enabled;
	}];
	
	[self.KVOController observe:self
						keyPath:@"buttonItem.text"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self)
		self.enabled = self.buttonItem.enabled;
		self.buttonItem.lightAttrText = nil;
		self.buttonItem.darkAttrText = nil;
		[self setUpImageAndLabel];
	}];
	
	[self.KVOController observe:self
						keyPath:@"buttonItem.darkImage"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self)
		self.enabled = self.buttonItem.enabled;
		[self setUpImageAndLabel];
	}];
	
	[self.KVOController observe:self
						keyPath:@"buttonItem.lightImage"
						options:NSKeyValueObservingOptionNew
						  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		@strongify(self)
		self.enabled = self.buttonItem.enabled;
		[self setUpImageAndLabel];
	}];
	
    count = count + 1;
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
