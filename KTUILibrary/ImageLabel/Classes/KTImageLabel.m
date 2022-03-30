//
//  KTImageLabel.m
//  KTUILibrary
//
//  Created by KOTU on 2020/3/12.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTImageLabel.h"
#import <Masonry/Masonry.h>
#import <KTFoundation/KTMacros.h>

static KTImageDownloadBlock imageDownloader = nil;

@interface KTImageLabel ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, assign) KTImageLabelContentImagePosition contentImagePosition_;
@property (nonatomic, assign) KTImageLabelContentImageAlign contentImageAlign_;
@property (nonatomic, assign) CGFloat alignOffset_;
@property (nonatomic, assign) UIEdgeInsets textEdge_;
@property (nonatomic, assign) UIEdgeInsets contentImageEdge_;
@property (nonatomic, assign) CGFloat contentSpace_;
@property (nonatomic, assign) BOOL autoWrap_;
@property (nonatomic, assign) CGSize contentImageSize_;
@end

@implementation KTImageLabel

+ (void)configImageLoader:(KTImageDownloadBlock)block
{
    imageDownloader = block;
}

- (instancetype)init
{
	return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self setUpDefaultValue];
		[self setUpUI];
		[self setUpConstrains];
	}
	return self;
}

- (void)setUpDefaultValue
{
	_autoWrap_ = NO;
	_contentImagePosition_ = KTImageLabelContentImagePositionLeading;
    _contentImageAlign_ = KTImageLabelContentImageAlignCenter;
    _alignOffset_ = 0;
	_textEdge_ = UIEdgeInsetsZero;
	_contentImageEdge_ = UIEdgeInsetsZero;
	_contentSpace_ = 0;
	_contentImageSize_ = CGSizeZero;
}

- (void)setUpUI
{
	[self addSubview:self.backgroundImageView];
	[self addSubview:self.label];
	[self addSubview:self.contentImageView];
}

- (void)setUpConstrains
{
	[self.label mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
	
	[self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

#pragma mark - public
- (KTImageLabelConfigBlock)text
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if (!value) {
			self.label.text = nil;
		} else if ([value isKindOfClass:[NSString class]]) {
			self.label.text = (NSString *)value;
			[self layoutIfNeeded];
		} else {
#if DEBUG
            NSAssert([value isKindOfClass:[NSString class]], @"value is not a string");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigBlock)attributeText
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if (!value) {
			self.label.attributedText = nil;
		} else if ([value isKindOfClass:[NSAttributedString class]]) {
			self.label.attributedText = (NSAttributedString *)value;
		} else {
#if DEBUG
            NSAssert([value isKindOfClass:[NSAttributedString class]], @"value is not a attributed string");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigBlock)font
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if ([value isKindOfClass:[UIFont class]]) {
			self.label.font = (UIFont *)value;
		} else {
#if DEBUG
            NSAssert([value isKindOfClass:[UIFont class]], @"value is not a font");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigBlock)textColor
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if ([value isKindOfClass:[UIColor class]]) {
			self.label.textColor = (UIColor *)value;
		} else {
#if DEBUG
            NSAssert([value isKindOfClass:[UIColor class]], @"value is not a color");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigTextAlignBlock)textAlign
{
	@weakify(self);
	return ^(NSTextAlignment align) {
		@strongify(self);
		self.label.textAlignment = align;
		return self;
	};
}

- (KTImageLabelConfigBlock)lineSpacing
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if ([value respondsToSelector:@selector(floatValue)]) {
			CGFloat fValue = [value floatValue];
			[self.label setValue:[NSNumber numberWithFloat:fValue] forKey:@"lineSpacing"];
		} else {
#if DEBUG
            NSAssert([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]], @"value is not a string or number");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigBlock)numberOfLines
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if ([value respondsToSelector:@selector(integerValue)]) {
			NSInteger num = [value integerValue];
			self.label.numberOfLines = num;
		} else {
#if DEBUG
            NSAssert([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]], @"value is not a string or number");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigBlock)contentImage
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if (!value) {
			self.contentImageView.image = nil;
		} else if ([value isKindOfClass:[UIImage class]]) {
			self.contentImageView.image = (UIImage *)value;
		} else {
#if DEBUG
            NSAssert([value isKindOfClass:[UIImage class]], @"value is not a image");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigBlock)contentImageUrlString
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if (!value) {
			self.contentImageView.image = nil;
		} else if ([value isKindOfClass:[NSString class]]) {
            if (imageDownloader) {
                imageDownloader(self.contentImageView, (NSString *)value);
            }
        } else {
#if DEBUG
            NSAssert([value isKindOfClass:[NSString class]], @"value is not a string");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigBlock)backgroundImage
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if (!value) {
			self.backgroundImageView.image = nil;
		} else if ([value isKindOfClass:[UIImage class]]) {
			self.backgroundImageView.image = (UIImage *)value;
		} else {
#if DEBUG
            NSAssert([value isKindOfClass:[UIImage class]], @"value is not a image");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigPositionBlock)contentImagePosition
{
	@weakify(self);
	return ^(KTImageLabelContentImagePosition position) {
		@strongify(self);
		self.contentImagePosition_ = position;
		return self;
	};
}

- (KTImageLabelConfigAlignBlock)align
{
    @weakify(self);
    return ^(KTImageLabelContentImageAlign align) {
        @strongify(self);
        self.contentImageAlign_ = align;
        return self;
    };
}

- (KTImageLabelConfigBlock)alignOffset
{
    @weakify(self);
    return ^(id value) {
        @strongify(self);
        if ([value respondsToSelector:@selector(floatValue)]) {
            self.alignOffset_ = [value floatValue];
        } else {
#if DEBUG
            NSAssert(NO, @"value cannot convert to float");
#endif
        }
        return self;
    };
}

- (KTImageLabelConfigEdgeBlock)textEdge
{
	@weakify(self);
	return ^(UIEdgeInsets edge) {
		@strongify(self);
		self.textEdge_ = edge;
		return self;
	};
}

- (KTImageLabelConfigEdgeBlock)contentImageEdge
{
	@weakify(self);
	return ^(UIEdgeInsets edge) {
		@strongify(self);
		self.contentImageEdge_ = edge;
		return self;
	};
}

- (KTImageLabelConfigBlock)contentSpace
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if ([value respondsToSelector:@selector(floatValue)]) {
			self.contentSpace_ = [value floatValue];
		} else {
#if DEBUG
            NSAssert(NO, @"value cannot convert to float");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigBlock)autoWrap
{
	@weakify(self);
	return ^(id value) {
		@strongify(self);
		if ([value respondsToSelector:@selector(boolValue)]) {
			self.autoWrap_ = [value boolValue];
		} else {
#if DEBUG
            NSAssert(NO, @"value cannot convert to bool");
#endif
		}
		return self;
	};
}

- (KTImageLabelConfigSizeBlock)contentImageSize
{
	@weakify(self);
	return ^(CGSize size) {
		@strongify(self);
		self.contentImageSize_ = size;
		return self;
	};
}

#pragma mark - privite

- (void)displayContent
{
	if (self.contentImagePosition_ == KTImageLabelContentImagePositionTop) {
        [self displayContentTop];
	} else if (self.contentImagePosition_ == KTImageLabelContentImagePositionLeading) {
        [self displayContentLeading];
	} else if (self.contentImagePosition_ == KTImageLabelContentImagePositionBottom) {
        [self displayContentBottom];
	} else if (self.contentImagePosition_ == KTImageLabelContentImagePositionTrailing) {
        [self displayContentTrailing];
	} else if (self.contentImagePosition_ == KTImageLabelContentImagePositionOverlap) {
        [self displayContentOverlap];
	} else {
#if DEBUG
		NSAssert(NO, @"KTImageLabel: unsupport contentImagePosition");
#endif
	}
}

- (void)displayContentTop
{
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImageEdge_);
        make.size.mas_equalTo(self.contentImageSize_);
        [self masMakeVerticalContentImageAlign:make];
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView.mas_bottom).offset(self.contentSpace_);
        make.leading.trailing.bottom.mas_equalTo(self.textEdge_);
    }];
}

- (void)displayContentLeading
{
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentImageEdge_);
        make.size.mas_equalTo(self.contentImageSize_);
        [self masMakeHorizontalContentImageAlign:make];
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentImageView.mas_trailing).offset(self.contentSpace_);
        make.top.bottom.trailing.mas_equalTo(self.textEdge_);
    }];
}

- (void)displayContentBottom
{
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentImageEdge_);
        make.size.mas_equalTo(self.contentImageSize_);
        [self masMakeVerticalContentImageAlign:make];
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentImageView.mas_top).offset(self.contentSpace_ * -1);
        make.top.leading.trailing.mas_equalTo(self.textEdge_);
    }];
}

- (void)displayContentTrailing
{
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentImageEdge_);
        make.size.mas_equalTo(self.contentImageSize_);
        [self masMakeHorizontalContentImageAlign:make];
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentImageView.mas_leading).offset(self.contentSpace_ * -1);
        make.leading.top.bottom.mas_equalTo(self.textEdge_);
    }];
}

- (void)displayContentOverlap
{
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self.contentImageEdge_);
        make.size.mas_equalTo(self.contentImageSize_);
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.trailing.mas_equalTo(self.textEdge_);
    }];
}

// ◼︎ abc
- (void)masMakeHorizontalContentImageAlign:(MASConstraintMaker *)make
{
    switch (self.contentImageAlign_) {
        case KTImageLabelContentImageAlignCenter: {
            make.centerY.mas_equalTo(self.alignOffset_);
            break;
        }
            
        case KTImageLabelContentImageAlignTextLeading: {
            make.top.equalTo(self.label.mas_top).offset(self.alignOffset_);
            break;
        }
            
        case KTImageLabelContentImageAlignTextCenter: {
            make.centerY.equalTo(self.label.mas_centerY).offset(self.alignOffset_);
            break;
        }
            
        case KTImageLabelContentImageAlignTextTrailing: {
            make.bottom.equalTo(self.label.mas_bottom).offset(self.alignOffset_);
            break;
        }
            
        default: {
#if DEBUG
            NSAssert(NO, @"unknown align");
#endif
            break;
        }
    }
}

//  ◼︎
//  abc
- (void)masMakeVerticalContentImageAlign:(MASConstraintMaker *)make
{
    switch (self.contentImageAlign_) {
        case KTImageLabelContentImageAlignCenter: {
            make.centerX.mas_equalTo(self.alignOffset_);
            break;
        }
            
        case KTImageLabelContentImageAlignTextLeading: {
            make.leading.equalTo(self.label.mas_leading).offset(self.alignOffset_);
            break;
        }
            
        case KTImageLabelContentImageAlignTextCenter: {
            make.centerX.mas_equalTo(self.label.mas_centerX).offset(self.alignOffset_);
            break;
        }
            
        case KTImageLabelContentImageAlignTextTrailing: {
            make.trailing.mas_equalTo(self.label.mas_trailing).offset(self.alignOffset_);
            break;
        }
            
        default: {
#if DEBUG
            NSAssert(NO, @"unknown align");
#endif
            break;
        }
    }
}

#pragma mark - setter
- (void)setContentImagePosition_:(KTImageLabelContentImagePosition)contentImagePosition
{
	if (_contentImagePosition_ == contentImagePosition) {
		return;
	}
	
	_contentImagePosition_ = contentImagePosition;
	[self displayContent];
}

- (void)setTextEdge_:(UIEdgeInsets)textEdge_
{
	if (UIEdgeInsetsEqualToEdgeInsets(_textEdge_, textEdge_)) {
		return;
	}
	
	_textEdge_ = textEdge_;
	[self displayContent];
}

- (void)setContentImageEdge_:(UIEdgeInsets)contentImageEdge_
{
	if (UIEdgeInsetsEqualToEdgeInsets(_contentImageEdge_, contentImageEdge_)) {
		return;
	}
	
	_contentImageEdge_ = contentImageEdge_;
	[self displayContent];
}

- (void)setContentSpace_:(CGFloat)contentSpace
{
	if (_contentSpace_ == contentSpace) {
		return;
	}
	
	_contentSpace_ = contentSpace;
	[self displayContent];
}

- (void)setAutoWrap_:(BOOL)autoWrap
{
	if (_autoWrap_ == autoWrap) {
		return;
	}
	
	_autoWrap_ = autoWrap;
	self.label.numberOfLines = _autoWrap_?0:1;
}

- (void)setContentImageSize_:(CGSize)contentImageSize_
{
	if (CGSizeEqualToSize(_contentImageSize_, contentImageSize_)) {
		return;
	}
	
	_contentImageSize_ = contentImageSize_;
	[self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(_contentImageSize_);
	}];
}

- (void)setContentImageAlign_:(KTImageLabelContentImageAlign)contentImageAlign_
{
    if (_contentImageAlign_ == contentImageAlign_) {
        return;
    }
    _contentImageAlign_ = contentImageAlign_;
    [self displayContent];
}

- (void)setAlignOffset_:(CGFloat)alignOffset_
{
    if (_alignOffset_ == alignOffset_) {
        return;
    }
    
    _alignOffset_ = alignOffset_;
    [self displayContent];
}

#pragma mark - lazy load
- (UILabel *)label
{
	if (!_label) {
		_label = [[UILabel alloc] init];
		_label.textAlignment = NSTextAlignmentCenter;
	}
	return _label;
}

- (UIImageView *)contentImageView
{
	if (!_contentImageView) {
		_contentImageView = [[UIImageView alloc] init];
	}
	return _contentImageView;
}

- (UIImageView *)backgroundImageView
{
	if (!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] init];
	}
	return _backgroundImageView;
}

@end
