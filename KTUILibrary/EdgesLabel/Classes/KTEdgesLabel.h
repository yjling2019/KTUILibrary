//
//  KTEdgesLabel.h
//  KTUILibrary
//
//  Created by KOTU on 2019/7/24.
//  Copyright © 2019 com.lebby.www. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTEdgesLabel : UILabel

// 用来决定上下左右内边距,默认为 UIEdgeInsetsMake(0, 1.5, 0, 1.5)
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end

NS_ASSUME_NONNULL_END
