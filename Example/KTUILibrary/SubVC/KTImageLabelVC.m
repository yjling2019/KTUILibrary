//
//  KTImageLabelVC.m
//  KTUILibrary_Example
//
//  Created by KOTU on 2021/12/7.
//  Copyright © 2021 KOTU. All rights reserved.
//

#import "KTImageLabelVC.h"
#import <KTUILibrary/KTImageLabel.h>
#import "UIColor+Help.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <KTFoundation/KTSandBoxManager.h>

@interface KTImageLabelVC ()

@end

@implementation KTImageLabelVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [KTImageLabel configImageLoader:^(UIImageView * _Nonnull imageView, NSString * _Nonnull urlString) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    }];

    {
        KTImageLabel *label = [[KTImageLabel alloc] init];
        label.text(@"KTImageLabelContentImagePositionLeading")
        .contentImage([KTSandBoxManager imageNamed:@"Navigation_Back_Black_No_Dark" inPod:@"KTUILibrary_Navigation"])
        .contentImagePosition(KTImageLabelContentImagePositionLeading)
        .contentSpace(@10)
        .contentImageSize(CGSizeMake(44, 44))
        .numberOfLines(@0)
        .contentImageEdge(UIEdgeInsetsMake(10, 10, 10, 10));
        
        label.label.backgroundColor = [UIColor randomColor];
        label.backgroundColor = [UIColor randomColor];
        label.contentImageView.backgroundColor = [UIColor randomColor];
        
        [self.view addSubview:label];
        
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(100 * 1);
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(80);
        }];
    }
    
    {
        KTImageLabel *label = [[KTImageLabel alloc] init];
        label.text(@"KTImageLabelContentImagePositionLeading_without_height")
        .contentImage([KTSandBoxManager imageNamed:@"Navigation_Back_Black_No_Dark" inPod:@"KTUILibrary_Navigation"])
        .contentImagePosition(KTImageLabelContentImagePositionLeading)
        .contentSpace(@10)
        .contentImageSize(CGSizeMake(80, 80))
        .numberOfLines(@0);
        
        label.label.backgroundColor = [UIColor randomColor];
        label.backgroundColor = [UIColor randomColor];
        label.contentImageView.backgroundColor = [UIColor randomColor];
        
        [self.view addSubview:label];
        
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(100 * 2);
            make.width.mas_equalTo(300);
        }];
    }
    
    {
        KTImageLabel *label = [[KTImageLabel alloc] init];
        label.text(@"Top")
        .contentImage([UIImage imageNamed:@"cart"])
        .contentImagePosition(KTImageLabelContentImagePositionTop)
        .contentSpace(@5)
        .contentImageSize(CGSizeMake(22, 22));
        
        label.label.backgroundColor = [UIColor randomColor];
        label.backgroundColor = [UIColor randomColor];
        label.contentImageView.backgroundColor = [UIColor randomColor];
        
        [self.view addSubview:label];
        
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(100 * 3);
            make.width.mas_equalTo(80);
        }];
    }
    
    {
        KTImageLabel *label = [[KTImageLabel alloc] init];
        label.text(@"Top")
        .contentImage([UIImage imageNamed:@"cart"])
        .contentImagePosition(KTImageLabelContentImagePositionTop)
        .contentSpace(@5)
        .contentImageSize(CGSizeMake(22, 22))
        .align(KTImageLabelContentImageAlignTextTrailing)
        .alignOffset(@-5);
        
        label.label.backgroundColor = [UIColor randomColor];
        label.backgroundColor = [UIColor randomColor];
        label.contentImageView.backgroundColor = [UIColor randomColor];
        
        [self.view addSubview:label];
        
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(100 * 4);
            make.width.mas_equalTo(80);
        }];
    }
    
    {
        KTImageLabel *label = [[KTImageLabel alloc] init];
        label.text(@"KTImageLabelContentImagePositionOverlap")
        .contentImageUrlString(@"https://raw.githubusercontent.com/SDWebImage/SDWebImage/master/SDWebImage_logo.png")
        .contentImagePosition(KTImageLabelContentImagePositionOverlap)
        .contentSpace(@5)
        .contentImageSize(CGSizeMake(222, 40));
        
        label.label.backgroundColor = [UIColor randomColor];
        label.backgroundColor = [UIColor randomColor];
        label.contentImageView.backgroundColor = [UIColor randomColor];
        
        [self.view addSubview:label];
        
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(100 * 5);
        }];
    }
}

@end
