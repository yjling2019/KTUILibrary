//
//  KTTabBarBackgroundView.m
//	KOTU
//
//  Created by KOTU on 2020/5/29.
//

#import "KTTabBarBackgroundView.h"
#import <Masonry/Masonry.h>
#import "KTTabBarConfigModel.h"

@interface KTTabBarBackgroundView ()

@property (nonatomic, strong) UIImageView *shadowImageView;

@end

@implementation KTTabBarBackgroundView

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

- (void)updateWithModel:(KTTabBarConfigModel *)model
{
    if (![model isKindOfClass:KTTabBarConfigModel.class]) {
        return;
    }
    
#if DEBUG
    NSAssert(model.backgroundColor, @"KTTabBar背景颜色必须设置");
#endif
    self.backgroundColor = model.backgroundColor;
    
#if DEBUG
    NSAssert(model.shadowImageColor, @"KTTabBar细线颜色必须设置");
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
