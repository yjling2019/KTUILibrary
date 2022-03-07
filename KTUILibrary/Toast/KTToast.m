//
//  KTToast.m
//  KOTU
//
//  Created by KOTU on 2017/5/9.
//  Copyright © 2017年 FloryDay. All rights reserved.
//

#import "KTToast.h"
#import <Masonry/Masonry.h>

KTToast *errorLabel;

@implementation KTToast

+ (KTToast *)showErrorMsg:(NSString *)msg
                superView:(UIView *)view
{
    return [self showErrorMsg:msg superView:view duration:2];
}

+ (KTToast *)showErrorMsg:(NSString *)msg
                superView:(UIView *)view
                 duration:(CGFloat)duration
{
    if (msg == nil || msg.length == 0) {
        return nil;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:msg
                                                                 attributes:@{
                                                                              NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                              NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                              NSParagraphStyleAttributeName:style
                                                                              }];
    return [self showAttributedErrorMsg:string superView:view duration:duration];
}

+ (KTToast *)showAttributedErrorMsg:(NSAttributedString *)msg
                          superView:(UIView *)view
                           duration:(CGFloat)duration
{
    if (msg == nil || msg.length == 0) {
        return nil;
    }
    
    if (errorLabel) {
        return nil;
    }
    
    if (!view) {
        return nil;
    }
    
    CGRect rect = [msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
    errorLabel = [[KTToast alloc] init];
    [view addSubview:errorLabel];
    
    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.mas_equalTo(rect.size.width + 25);
        make.height.mas_equalTo(rect.size.height +20);
    }];
    errorLabel.attributedText = msg;
    errorLabel.numberOfLines = 0 ;
    errorLabel.backgroundColor = [UIColor blackColor];
    errorLabel.layer.cornerRadius = 5 ;
    errorLabel.clipsToBounds = YES;
    errorLabel.font = [UIFont systemFontOfSize:15];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
    return errorLabel;
}

+ (KTToast *)showBoldAttributedErrorMsg:(NSAttributedString *)msg
                              superView:(UIView *)view
                               duration:(CGFloat)duration
{
    if (msg == nil || msg.length == 0) {
        return nil;
    }
    
    if (errorLabel) {
        return nil;
    }
    
    if (!view) {
        return nil;
    }
    
    CGRect rect = [msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
    errorLabel = [[KTToast alloc] init];
    [view addSubview:errorLabel];
    
    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.mas_equalTo(rect.size.width + 25);
        make.height.mas_equalTo(rect.size.height +20);
    }];
    errorLabel.attributedText = msg;
    errorLabel.numberOfLines = 0 ;
    errorLabel.backgroundColor = [UIColor blackColor];
    errorLabel.layer.cornerRadius = 5 ;
    errorLabel.clipsToBounds = YES;
    errorLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
    return errorLabel;
}

+ (KTToast *)showErrorMsg:(NSString *)msg
                superView:(UIView *)view
                 toBottom:(CGFloat)space
{
    if (msg == nil || msg.length == 0) {
        return nil ;
    }
    
    if (errorLabel) {
        return nil;
    }
    
    if (!view) {
        return nil;
    }
    
    CGRect rect = [msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    errorLabel = [[KTToast alloc] init];
    [view addSubview:errorLabel];
    
    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.bottom.mas_equalTo(-space);
        make.width.mas_equalTo(rect.size.width + 25);
        make.height.mas_equalTo(rect.size.height +20);
    }];
    errorLabel.text = msg;
    errorLabel.numberOfLines = 0 ;
    errorLabel.backgroundColor = [UIColor blackColor];
    errorLabel.textColor = [UIColor whiteColor];
    errorLabel.layer.cornerRadius = 5 ;
    errorLabel.clipsToBounds = YES;
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.font = [UIFont systemFontOfSize:15];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    return errorLabel;
}
+ (void)dismiss
{
    [UIView animateWithDuration:1 animations:^{
        errorLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [errorLabel removeFromSuperview];
        errorLabel = nil;
    }];
}

+ (KTToast *)showBoldErrorErrorMsg:(NSString *)msg
                         superView:(UIView *)view
                          duration:(CGFloat)duration;
{
    if (msg == nil || msg.length == 0) {
        return nil;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:msg
                                                                 attributes:@{
                                                                              NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                                                              NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                              NSParagraphStyleAttributeName:style
                                                                              }];
    return [self showBoldAttributedErrorMsg:string superView:view duration:duration];
}

@end
