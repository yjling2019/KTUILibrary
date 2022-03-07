//
//  KTTabBarNormalRedPointView.m
//  VOVA
//
//  Created by KOTU on 2020/3/16.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTTabBarNormalRedPointView.h"
#import <Masonry/Masonry.h>

@interface KTTabBarNormalRedPointView ()

@property (nonatomic, strong) UIView *redPointView;

@end

@implementation KTTabBarNormalRedPointView

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
}

- (void)setUpConstraints
{
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
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

- (void)updateWithModel:(UIColor *)model
{
    if (![model isKindOfClass:[UIColor class]]) {
        return;
    }
    
    self.redPointView.backgroundColor = model;
}

- (UIView *)redPointView
{
    if (!_redPointView) {
        _redPointView = [[UIView alloc] init];
        _redPointView.layer.cornerRadius = 4;
#warning TODO 0303
//        _redPointView.backgroundColor = [UIColor colorWithHex:0xf06446];
		_redPointView.backgroundColor = [UIColor redColor];
    }
    return _redPointView;
}

@end
