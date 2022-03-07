//
//  KTTabBarBaseButton.m
//  VOVA
//
//  Created by KOTU on 2020/3/16.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTTabBarBaseButton.h"
#import <Masonry/Masonry.h>

@interface KTTabBarBaseButton ()

/// 背景图
@property (nonatomic, strong) UIImageView *bgImageView;

/// tabbar为KTTabBarImageTypeLot使用
//@property (nonatomic, strong) LOTAnimationView *lotImageView;
/// tabbar为KTTabBarImageTypeImage使用
@property (nonatomic, strong) UIImageView *normalImageView;
/// tabbar为KTTabBarImageTypeGif使用
//@property (nonatomic, strong) FLAnimatedImageView *gifImageView;

/// tabbar文字
@property (nonatomic, strong) UILabel *tabBartitleLabel;

/// 红点
@property (nonatomic, strong) UIView *redPointView;

@property (nonatomic, strong) KTTabBarBaseModel *model;

@end

@implementation KTTabBarBaseButton

+ (id)configTabBarButtonWithModel:(KTTabBarBaseModel *)model
{
    __kindof KTTabBarBaseButton *button = [[model.className alloc] initModel:model];
    return button;
}

- (instancetype)initModel:(KTTabBarBaseModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        
        [self setUpUI];
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.bgImageView];
    
    [self configImageView:self.model];
    
    [self addSubview:self.tabBartitleLabel];
}

- (void)setUpConstraints
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self layoutIfNeeded];
}

- (void)updateWithModel:(KTTabBarBaseModel *)model
{
    if (![model isKindOfClass:[KTTabBarBaseModel class]]) {
#if DEBUG
        NSAssert(NO, @"模型不对");
#endif
        return;
    }
    
    [self setUpBGImageView:model];
    
    [self setUpImageView:model];
    
    [self setUpTitle:model];
    
    [self setUpRedPointView:self.redPointView model:model];
}

/// 设置背景图
- (void)setUpBGImageView:(KTTabBarBaseModel *)model
{
    NSURL *url;
    if (model.selected) {
        url = model.selectedBGImgURL;
    } else {
        url = model.bgImgURL;
    }
    
    if (!url) {
        self.bgImageView.image = nil;
        return;
    }
    if ([url.scheme isEqualToString:kKTTabBarSchemeKey]) {
        self.bgImageView.image = [UIImage imageNamed:url.host];
    } else {
//        UIImage *placeholderImage = [UIImage vv_imageWithColor:[UIColor colorWithWhite:238 / 255.0 alpha:1] size:self.bgImageView.frame.size];
//        [self.bgImageView sd_setImageWithURL:url placeholderImage:placeholderImage];
    }
}

/// 按imageType添加需要的view
- (void)configImageView:(KTTabBarBaseModel *)model
{
//    [_lotImageView removeFromSuperview];
    [_normalImageView removeFromSuperview];
//    [_gifImageView removeFromSuperview];
    
    switch (self.model.imageType) {
//        case KTTabBarImageTypeLot:
//        {
//            [self addSubview:self.lotImageView];
//        }
//            break;

        case KTTabBarImageTypeImage:
        {
            [self addSubview:self.normalImageView];
        }
            break;
            
//        case KTTabBarImageTypeGif:
//        {
//            [self addSubview:self.gifImageView];
//        }
//            break;
            
//        default:
//        {
//            [self addSubview:self.lotImageView];
//        }
//            break;
    }
}

- (void)setUpImageView:(KTTabBarBaseModel *)model
{
    switch (model.imageType) {
        case KTTabBarImageTypeLot:
        {
            [self setUpLotType:model];
        }
            break;

        case KTTabBarImageTypeImage:
        {
            [self setUpImageType:model];
        }
            break;
            
        case KTTabBarImageTypeGif:
        {
            [self setUpGifType:model];
        }
            break;
            
        default:
        {
            [self setUpLotType:model];
        }
            break;
    }
}

/// 设置lottie的tabbar
- (void)setUpLotType:(KTTabBarBaseModel *)model
{
//    if (!self.lotImageView.superview) {
//        [self configImageView:model];
//    }
//    
//    [self remakeConstraints:self.lotImageView model:model];
//    
//    if (!model.lottieURL) {
//        return;
//    }
//    if ([model.lottieURL.scheme isEqualToString:kKTTabBarSchemeKey]) {
//        [self.lotImageView setAnimationNamed:model.lottieURL.host];
//        [self lottiePlayAnimationIfNeeded:model];
//    } else {
//        NSURL *lottieURL = model.lottieURL;
//        if (![model isNeedUpdate:lottieURL]) {
//            [self lottiePlayAnimationIfNeeded:model];
//            return;
//        }
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *animationData = [NSData dataWithContentsOfURL:lottieURL];
//            if (!animationData) {
//                return;
//            }
//            NSError *error;
//            NSDictionary *animationJSON = [NSJSONSerialization JSONObjectWithData:animationData
//                                                                           options:0
//                                                                             error:&error];
//            if (error ||
//                !animationJSON) {
//              return;
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.lotImageView setAnimationFromJSON:animationJSON];
//                [self lottiePlayAnimationIfNeeded:model];
//            });
//        });
//    }
}

- (void)lottiePlayAnimationIfNeeded:(KTTabBarBaseModel *)model
{
#warning TODO 0303
//    if (model.selected) {
//        self.userInteractionEnabled = NO;
//        [self.lotImageView playWithCompletion:^(BOOL animationFinished) {
//            self.userInteractionEnabled = YES;
//        }];
//    }
}

/// 设置image的tabbar
- (void)setUpImageType:(KTTabBarBaseModel *)model
{
    if (!self.normalImageView.superview) {
        [self configImageView:model];
    }
    
    [self remakeConstraints:self.normalImageView model:model];
    
    NSURL *url;
    CGSize size;
    if (model.selected) {
        url = model.selectedImgURL;
        size = model.selectedSize;
    } else {
        url = model.imgURL;
        size = model.size;
    }
    
    if (!url) {
        return;
    }
    
    if (![model isNeedUpdate:url]) {
        return;
    }
    
    if ([url.scheme isEqualToString:kKTTabBarSchemeKey]) {
        self.normalImageView.image = [UIImage imageNamed:url.host];
    } else {
#warning TODO 0303
//        UIImage *placeholderImage = [UIImage vv_imageWithColor:[UIColor colorWithWhite:238 / 255.0 alpha:1] size:size];
//        [self.normalImageView sd_setImageWithURL:url placeholderImage:placeholderImage];
    }
}

/// 设置gif的tabbar
- (void)setUpGifType:(KTTabBarBaseModel *)model
{
#warning TODO 0303
//    if (!self.gifImageView.superview) {
//        [self configImageView:model];
//    }
//
//    [self remakeConstraints:self.gifImageView model:model];
//    NSURL *url;
//    CGSize size;
//    if (model.selected) {
//        url = model.selectedGifURL;
//        size = model.selectedSize;
//    } else {
//        url = model.gifURL;
//        size = model.size;
//    }
//    if (!url) {
//        return;
//    }
//
//    if (![model isNeedUpdate:url]) {
//        return;
//    }
//    if ([url.scheme isEqualToString:kKTTabBarSchemeKey]) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:url.host ofType:@"gif"];
//        if (!vv_isEmptyStr(path)) {
//            FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]]];
//            self.gifImageView.animatedImage = image;
//        }
//    } else {
//        UIImage *placeholderImage = [UIImage vv_imageWithColor:[UIColor colorWithWhite:238 / 255.0 alpha:1] size:size];
//        [self.gifImageView sd_setImageWithURL:url placeholderImage:placeholderImage];
//    }
}

- (void)remakeConstraints:(UIView *)view model:(KTTabBarBaseModel *)model
{
    UIEdgeInsets edgeInsets;
    CGSize size;
    if (model.selected) {
        edgeInsets = model.selectedEdgeInsets;
        size = model.selectedSize;
    } else {
        edgeInsets = model.edgeInsets;
        size = model.size;
    }
    
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(edgeInsets.top);
        if (edgeInsets.left >= 0) {
            // 左边距>=0
            make.centerX.equalTo(self.mas_leading).offset(edgeInsets.left + size.width / 2);
        } else {
            // 左边距<0，做居中处理
            make.centerX.equalTo(self);
        }
        make.size.mas_equalTo(size);
    }];

    [self.tabBartitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.bottom.equalTo(self).offset(-edgeInsets.bottom);
    }];
}

/// 设置tabbar的文字
- (void)setUpTitle:(KTTabBarBaseModel *)model
{
    if ((model.selected &&
        model.selectedTitleShow) ||
        (!model.selected &&
         model.titleShow)) {
        self.tabBartitleLabel.hidden = NO;
        if (model.selected) {
            self.tabBartitleLabel.attributedText = model.selectedAttributedString;
        } else {
            self.tabBartitleLabel.attributedText = model.attributedString;
        }
    } else {
        self.tabBartitleLabel.hidden = YES;
    }
}

- (void)setUpRedPointView:(UIView *)redPointView model:(KTTabBarBaseModel *)model
{
    if (!redPointView) {
        return;
    }
    
    if (self.redPointView == redPointView) {
        [self bringSubviewToFront:redPointView];
        return;
    }
    
    [self.redPointView removeFromSuperview];
    self.redPointView = redPointView;
    
    UIView *bottomView = nil;
    switch (model.imageType) {
//        case KTTabBarImageTypeLot:
//        {
//            bottomView = self.lotImageView;
//        }
//            break;

        case KTTabBarImageTypeImage:
        {
            bottomView = self.normalImageView;
        }
            break;
            
//        case KTTabBarImageTypeGif:
//        {
//            bottomView = self.gifImageView;
//        }
//            break;
//
//        default:
//        {
//            bottomView = self.lotImageView;
//        }
            break;
    }
    
    [self addSubview:self.redPointView];
    [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomView.mas_trailing).offset(-4);
        make.centerY.equalTo(bottomView.mas_top).offset(2);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = NO;
    }
    return _bgImageView;
}

//- (LOTAnimationView *)lotImageView
//{
//    if (!_lotImageView) {
//        _lotImageView = [[LOTAnimationView alloc] init];
//        _lotImageView.userInteractionEnabled = NO;
//    }
//    return _lotImageView;
//}

- (UIImageView *)normalImageView
{
    if (!_normalImageView) {
        _normalImageView = [[UIImageView alloc] init];
        _normalImageView.userInteractionEnabled = NO;
    }
    return _normalImageView;
}

//- (FLAnimatedImageView *)gifImageView
//{
//    if (!_gifImageView) {
//        _gifImageView = [[FLAnimatedImageView alloc] init];
//        _gifImageView.userInteractionEnabled = NO;
//    }
//    return _gifImageView;
//}

- (UILabel *)tabBartitleLabel
{
    if (!_tabBartitleLabel) {
        _tabBartitleLabel = [[UILabel alloc] init];
    }
    return _tabBartitleLabel;
}

@end
