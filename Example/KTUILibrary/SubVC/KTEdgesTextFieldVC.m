//
//  KTEdgeTextFieldVC.m
//  KTUILibrary_Example
//
//  Created by KOTU on 2021/12/7.
//  Copyright © 2021 KOTU. All rights reserved.
//

#import "KTEdgesTextFieldVC.h"
#import <KTUILibrary/KTEdgesTextField.h>
#import "UIColor+Help.h"

@interface KTEdgesTextFieldVC ()

@end

@implementation KTEdgesTextFieldVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    {
        UITextField *tf = [[UITextField alloc] init];
        tf.text = @"Text";
        tf.frame = CGRectMake(20, 60*1, 100, 40);
        tf.backgroundColor = [UIColor randomColor];
        [tf sizeToFit];
        [self.view addSubview:tf];
    }

    {
        KTEdgesTextField *tf = [[KTEdgesTextField alloc] init];
        tf.text = @"Text";
        tf.frame = CGRectMake(20, 60*2, 100, 40);
        tf.textEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        tf.backgroundColor = [UIColor randomColor];
        [tf sizeToFit];
        [self.view addSubview:tf];
    }
    
    {
        KTEdgesTextField *tf = [[KTEdgesTextField alloc] init];
        tf.text = @"Text";
        tf.frame = CGRectMake(20, 60*3, 100, 40);
        tf.textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        tf.backgroundColor = [UIColor randomColor];
        [tf sizeToFit];
        [self.view addSubview:tf];
    }
    
    {
        KTEdgesTextField *tf = [[KTEdgesTextField alloc] init];
        tf.text = @"Text";
        tf.frame = CGRectMake(20, 60*4, 100, 40);
        tf.textEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        tf.backgroundColor = [UIColor randomColor];
        [tf sizeToFit];
        [self.view addSubview:tf];
    }
    
    {
        KTEdgesTextField *tf = [[KTEdgesTextField alloc] init];
        tf.text = @"Text";
        tf.frame = CGRectMake(20, 60*5, 100, 20);
        tf.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        tf.backgroundColor = [UIColor randomColor];
        [tf sizeToFit];
        [self.view addSubview:tf];
    }
    
    {
        KTEdgesTextField *tf = [[KTEdgesTextField alloc] init];
        tf.text = @"ClearButton";
        tf.frame = CGRectMake(20, 60*6, 100, 40);
        tf.clearButtonMode = UITextFieldViewModeAlways;
        tf.textEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        tf.backgroundColor = [UIColor randomColor];
        [tf sizeToFit];
        [self.view addSubview:tf];
    }
}

@end
