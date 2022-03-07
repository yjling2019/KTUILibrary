//
//  KTMiddleTabBarModel.h
//  VOVA
//
//  Created by fwzhou on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTTabBarModel.h"

NS_ASSUME_NONNULL_BEGIN

/// KTTabBar中间按钮配置项
@interface KTMiddleTabBarModel : KTTabBarModel

/// 中间按钮是否影响tabbar的index
/// increaseIndex为NO时，选中的样式不支持
@property (nonatomic, assign) BOOL increaseIndex;

/// 凸起的高度
@property (nonatomic, assign) CGFloat convexHeight;

/// 背景width
@property (nonatomic, assign) CGFloat width;

@end

NS_ASSUME_NONNULL_END
