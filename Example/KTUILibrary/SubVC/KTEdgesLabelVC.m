//
//  KTEdgeLabelVC.m
//  KTUILibrary_Example
//
//  Created by KOTU on 2021/12/7.
//  Copyright © 2021 KOTU. All rights reserved.
//

#import "KTEdgesLabelVC.h"
#import "UIColor+Help.h"
#import <Masonry/Masonry.h>
#import <KTUILibrary/KTEdgesLabel.h>

@interface KTEdgesLabelVC ()

@end

@implementation KTEdgesLabelVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    {
        KTEdgesLabel *label = [[KTEdgesLabel alloc] init];
        [self.view addSubview:label];
        label.text = @"label";
        label.backgroundColor = [UIColor randomColor];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(60 * 1);
        }];
    }

    {
        KTEdgesLabel *label = [[KTEdgesLabel alloc] init];
        [self.view addSubview:label];
        label.text = @"label";
        label.backgroundColor = [UIColor randomColor];
        label.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(60 * 2);
        }];
    }
}

@end
