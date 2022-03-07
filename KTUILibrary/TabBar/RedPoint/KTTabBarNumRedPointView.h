//
//  KTTabBarNumRedPointView.h
//  KOTU
//
//  Created by KOTU on 2020/3/16.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTTabBarRedPointViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTTabBarNumRedPointView : UIView <KTTabBarRedPointViewProtocol>

/// 更新ui
/// @param model 配置参数集合
/// backgroundColor 红点背景颜色
/// textColor 数量的文字颜色
/// num 数量
- (void)updateWithModel:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
