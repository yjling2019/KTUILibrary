//
//  VVTabBarBackgroundView.m
//  vv_rootlib_ios
//
//  Created by fwzhou on 2020/5/29.
//

#import "VVTabBarBackgroundView.h"
#import <Masonry/Masonry.h>
#import "VVTabBarConfigModel.h"

@interface VVTabBarBackgroundView ()

@property (nonatomic, strong) UIImageView *shadowImageView;

@end

@implementation VVTabBarBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.shadowImageView];
}

- (void)setUpConstraints
{
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-0.5);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)updateWithModel:(VVTabBarConfigModel *)model
{
    if (![model isKindOfClass:VVTabBarConfigModel.class]) {
        return;
    }
    
#if DEBUG
    NSAssert(model.backgroundColor, @"VVTabBar背景颜色必须设置");
#endif
    self.backgroundColor = model.backgroundColor;
    
#if DEBUG
    NSAssert(model.shadowImageColor, @"VVTabBar细线颜色必须设置");
#endif
    self.shadowImageView.backgroundColor = model.shadowImageColor;
}

#pragma mark - 懒加载
- (UIImageView *)shadowImageView
{
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc] init];
    }
    return _shadowImageView;
}

@end
