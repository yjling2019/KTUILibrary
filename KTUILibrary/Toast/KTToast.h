//
//  KTToast.h
//  KOTU
//
//  Created by KOTU on 2017/5/9.
//  Copyright © 2017年 KOTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTToast : UILabel

// duration默认为2
+ (KTToast *)showErrorMsg:(NSString *)msg
                superView:(UIView *)view;

+ (KTToast *)showErrorMsg:(NSString *)msg
                superView:(UIView *)view
                 duration:(CGFloat)duration;

+ (KTToast *)showAttributedErrorMsg:(NSAttributedString *)msg
                          superView:(UIView *)view
                           duration:(CGFloat)duration;

+ (KTToast *)showErrorMsg:(NSString *)msg
                superView:(UIView *)view
                 toBottom:(CGFloat)space;

+ (KTToast *)showBoldErrorErrorMsg:(NSString *)msg
                         superView:(UIView *)view
                          duration:(CGFloat)duration;

@end
