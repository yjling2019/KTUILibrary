//
//  KTTabBarNumRedPointView.m
//  VOVA
//
//  Created by fwzhou on 2020/3/16.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTTabBarNumRedPointView.h"
//#import <vv_rootlib_ios/KTDataHelper.h>
#import <Masonry/Masonry.h>
//#import "UIFont+Helpers.h"
//#import <vv_rootlib_ios/UIColor+TDHelp.h>

@interface KTTabBarNumRedPointView ()

@property (nonatomic, strong) UIView *redPointView;

@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation KTTabBarNumRedPointView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self setUpUI];
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.redPointView];
    [self.redPointView addSubview:self.numLabel];
}

- (void)setUpConstraints
{
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(12);
        make.height.mas_equalTo(12);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.redPointView.mas_leading).offset(2);
        make.center.equalTo(self.redPointView);
    }];
}

/// 更新ui
/// @param model 配置参数集合
/// backgroundColor 红点背景颜色
/// textColor 数量的文字颜色
/// num 数量
- (void)updateWithModel:(NSDictionary *)model
{
    if (![model isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    UIColor *backgroundColor = [model valueForKey:@"backgroundColor"];
    if (backgroundColor && [backgroundColor isKindOfClass:[UIColor class]]) {
        self.redPointView.backgroundColor = backgroundColor;
    }
    
	UIColor *textColor = [model valueForKey:@"textColor"];
	if (textColor && [textColor isKindOfClass:[UIColor class]]) {
        self.numLabel.textColor = textColor;
    }
    
    NSString *numText = [model valueForKey:@"num"];
	NSInteger num = numText.integerValue;
    if (num < 10) {
        [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.redPointView.mas_leading);
        }];
    } else {
        [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.redPointView.mas_leading).offset(2);
        }];
    }
    
    self.numLabel.text = numText;
}

- (void)didSelectRedPointView
{
    
}

- (void)playAnimation
{
    
}

- (void)stopAnimation
{
    
}

- (UIView *)redPointView
{
    if (!_redPointView) {
        _redPointView = [[UIView alloc] init];
        _redPointView.layer.cornerRadius = 6;
#warning TODO 0303
		_redPointView.backgroundColor = [UIColor redColor];
    }
    return _redPointView;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
#warning TODo 0303
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = [UIFont systemFontOfSize:9];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

@end
