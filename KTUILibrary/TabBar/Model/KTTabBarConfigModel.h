//
//  KTTabBarConfigModel.h
//	KOTU
//
//  Created by KOTU on 2020/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// KTTabBar配置项
@interface KTTabBarConfigModel : NSObject

/// tabbar的背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;

/// tabbar上细线颜色
@property (nonatomic, strong) UIColor *shadowImageColor;

@end

NS_ASSUME_NONNULL_END
