//
//  KTDeviceMacros.m
//  KTFoundation
//
//  Created by KOTU on 2022/5/31.
//

#import <Foundation/Foundation.h>
#import "KTDeviceUtils.h"

//iphone  X系列判断
#define IS_iPhoneXSeries [KTDeviceUtils isIphone_x_Series]
//iPhoneX状态栏额外的高度
#define iPhoneX_extra_statusHeight [KTDeviceUtils extraStatusBarHeight]
//安全区域高度
#define BottomSafeAreaHeight [KTDeviceUtils bottomSafeAreaHeight]

//状态栏高度
#define StatusBarHeight [KTDeviceUtils statusBarHeight]
//导航栏 + 状态栏高度
#define StatusBarAndNavigationBarHeight [KTDeviceUtils statusBarAndNavigationBarHeight]
//底部标签栏高度
#define TabBarHeight [KTDeviceUtils tabBarHeight]
