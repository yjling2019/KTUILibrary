//
//  KTDeviceUtils.h
//  KTFoundation
//
//  Created by Yongjian Ling on 1/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const kUsedMemoryDidChanged;
FOUNDATION_EXPORT NSNotificationName const kAvailableMemoryDidChanged;

@class UICKeyChainStore;

@interface KTDeviceUtils : NSObject

#pragma mark - Identifier

//// 自定义的设备ID
////+ (NSString *)userDeviceID;
//
//+ (NSString *)IDFA;
//
///**
// 该IDFV，经过Keychain的优化。
// 第一次获取IDFV时，将其存入Keychain。
// 此后，均从Keychain中获取IDFV，以保证其唯一性。
// */
//+ (NSString *)IDFV;
//
///**
// IDFV，每次卸载会变
// */
//+ (NSString *)organic_idfv;
//
///**
// 获取识别码设备ID: 会从idfa和organic_idfv里按优先级处理
// */
//+ (NSString *)priorityDeviceId;

#pragma mark - device info

// 获取当前系统的版本 10.0.0/11.2.3/...
+ (NSString *)systemVersion;

// 平台 i386/x86_64/iPhone11,4/iPhone9,1...
+ (NSString *)platform;

// 获取移动设备名称 iPad mini 4/iPhone X/...
// #warning: 没维护了
+ (NSString *)deviceName;

// 运行分析/广告产品的实体设备的名称。(x86_64)
+ (NSString *)machineName;

// 设备类型(iPhone)
+ (NSString *)deviceModel;

// mac地址(8c:85:90:cd:ae:d3)
+ (NSString *)macAddress;

// 操作系统名字(iOS)
+ (NSString *)systemName;

// 操作系统及操作系统版本的拼接(iOS 12.1)
+ (NSString *)systemNameAndVersion;

// 设备当前的时间(Asia/Shanghai (GMT+8) offset 28800)
+ (NSString *)systemTimeZone;

// 操作系统的版本号。(18C54)
+ (NSString *)osVersion;

// cpu内核数量
+ (NSUInteger)cpuCoreCount;

// 是否有root权限(NO)
+ (NSString *)deviceIsRoot;

#pragma mark - Memory
+ (double)availableMemory;
+ (double)usedMemory;

#pragma mark - Network
//// DNS服务器地址(DNS Addresses)
//+ (NSArray *)DNSAddresses;

// ip地址(192.168.1.105) 拿不到返回 (Unable To Get)
+ (NSString *)IPAddress;
+ (NSString *)IPAddressWithHostName:(NSString *)hostName;

// 网络类型
+ (NSString *)networkType;

// IMSI
+ (NSString *)IMSI;

// 移动信号国家码
+ (NSString *)mcc;

// 移动网络号码
+ (NSString *)mnc;

#pragma mark - Setting
// 操作系统的语言(en)
+ (NSString *)systemLanguage;

// 设备所在区域/国家(US)code
+ (NSString *)localeCountryCode;

// 系统时区缩写  GMT+8
+ (NSString *)timezoneAbbreviation;

// 设备的可选 IETF 语言区域标记，采用分别由两个字母组成的语言代码和国家/地区代码，两者之间用下划线分隔。(en_US)
+ (NSString *)localeIdentifier;

#pragma mark - Usage
// 是否开启了VPN
+ (BOOL)isVPNOn;

/// cpu利用率
+ (float)cpuUsage;

#pragma mark - iPad
+ (BOOL)isPad;

#pragma mark - iPhoneX
+ (BOOL)isIphone_x;
+ (BOOL)isIphone_xs;
+ (BOOL)isIphone_xsm;
+ (BOOL)isIphone_xr;
+ (BOOL)isIphone_11;
+ (BOOL)isIphone_11P;
+ (BOOL)isIphone_11PM;

// 是否是iPhonex系列
+ (BOOL)isIphone_x_Series;

#pragma mark - Screen
/// 安全区尺寸
+ (UIEdgeInsets)safeAreaInsets;

/// iPhoneX状态栏额外的高度
+ (CGFloat)extraStatusBarHeight;
/// 底部安全区域高度
+ (CGFloat)bottomSafeAreaHeight;
/// 状态栏高度
+ (CGFloat)statusBarHeight;
/// 导航栏 + 状态栏高度
+ (CGFloat)statusBarAndNavigationBarHeight;
/// 底部标签栏高度
+ (CGFloat)tabBarHeight;

@end

NS_ASSUME_NONNULL_END
