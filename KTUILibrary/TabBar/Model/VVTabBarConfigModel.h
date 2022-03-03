//
//  VVTabBarConfigModel.h
//  vv_bodylib_ios
//
//  Created by fwzhou on 2020/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// VVTabBar配置项
@interface VVTabBarConfigModel : NSObject

/// tabbar的背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;

/// tabbar上细线颜色
@property (nonatomic, strong) UIColor *shadowImageColor;

@end

NS_ASSUME_NONNULL_END
