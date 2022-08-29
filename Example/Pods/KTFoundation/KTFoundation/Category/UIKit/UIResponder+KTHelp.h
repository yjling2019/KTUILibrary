//
//  UIResponder+KTHelp.h
//  KOTU
//
//  Created by KOTU on 2017/12/28.
//  Copyright © 2017年 KOTU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kResponderRouterDataKey = @"data";

@interface UIResponder (KTHelp)

/**
 使用next responder充当路由来传递事件

 @param eventName 事件名称
 @param userInfo 自定义事件内容
 */
- (void)routerEventWithName:(nullable NSString *)eventName userInfo:(nullable NSDictionary *)userInfo;

/// 寻找响应链中下一个指定的类
/// @param cls 类
- (__kindof UIResponder * _Nullable)nextResponderOfClass:(Class)cls;
/// 寻找响应链中下一个指定的类
/// @param clsName 类名
- (__kindof UIResponder * _Nullable)nextResponderOfClassName:(NSString *)clsName;
/// 寻找响应链中下一个支持协议的响应者
/// @param prtcol 协议
- (__kindof UIResponder * _Nullable)nextResponderConformsToProtocol:(Protocol *)prtcol;

@end

NS_ASSUME_NONNULL_END
