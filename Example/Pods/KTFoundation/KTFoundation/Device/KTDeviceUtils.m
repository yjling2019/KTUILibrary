//
//  KTDeviceUtils.m
//  KTFoundation
//
//  Created by KOTU on 1/8/18.
//

#import "KTDeviceUtils.h"
//#import <UICKeyChainStore/UICKeyChainStore.h>
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <resolv.h>
#include <netdb.h>
#include <ifaddrs.h>
//#import "VVEncryptHelper.h"
//#import "VVStoreTool.h"

#define GET_IP_URL_TXT                                              @"http://ipof.in/txt"

NSNotificationName const kUsedMemoryDidChanged = @"kUsedMemoryDidChanged";
NSNotificationName const kAvailableMemoryDidChanged = @"kAvailableMemoryDidChanged";

@implementation KTDeviceUtils

/**
 isVPNOn2和isVPNOn实现效果一致，但都存在小概率crash的问题，可以无差别调用。
 
 原则上调用isVPNOn，保持项目整体一致
 */
+ (BOOL)isVPNOn2
{
    BOOL flag = NO;
    NSString *version = [UIDevice currentDevice].systemVersion;
    // need two ways to judge this.
    if (version.doubleValue >= 9.0) {
        NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
        NSArray *keys = [dict[@"__SCOPED__"] allKeys];
        for (NSString *key in keys) {
            if ([key rangeOfString:@"tap"].location != NSNotFound ||
                [key rangeOfString:@"tun"].location != NSNotFound ||
                [key rangeOfString:@"ipsec"].location != NSNotFound ||
                [key rangeOfString:@"ppp"].location != NSNotFound){
                flag = YES;
                break;
            }
        }
    } else {
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0)
        {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while (temp_addr != NULL)
            {
                NSString *string = [NSString stringWithFormat:@"%s" , temp_addr->ifa_name];
                if ([string rangeOfString:@"tap"].location != NSNotFound ||
                    [string rangeOfString:@"tun"].location != NSNotFound ||
                    [string rangeOfString:@"ipsec"].location != NSNotFound ||
                    [string rangeOfString:@"ppp"].location != NSNotFound)
                {
                    flag = YES;
                    break;
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        
        // Free memory
        freeifaddrs(interfaces);
    }
    
    return flag;
}

+ (double)getAvailableMemory {
    return [self availableMemory];
}

+ (double)getUsedMemory {
    return [self usedMemory];
}


#pragma mark - device indentifier

/**
 自定义的设备ID
 */
//+ (NSString *)userDeviceID
//{
//    NSString *UUID = [NSUUID UUID].UUIDString;
//    NSString *IDFV = [[UIDevice currentDevice] identifierForVendor].UUIDString;
//    NSString *deviceID = [NSString stringWithFormat:@"%@%@", UUID, IDFV];
//    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    deviceID = [VVEncryptHelper MD5String:deviceID];
//    return deviceID;
//}
//
///// idfa保存在NSUserDefaults 里面，每次获取idfa时先从userDefaults获取，如果有会直接返回，没有的话，获取IDFV
//+ (NSString *)IDFA
//{
//    static NSString *current_IDFA = nil;
//    if (!current_IDFA) {
//        NSString *idfa = [[NSUserDefaults standardUserDefaults] stringForKey:kKTIDFAUserDefaultsKey];
//        if (!idfa ||(idfa && idfa.length == 0) || [idfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
//            current_IDFA = [self IDFV];
//            [[NSUserDefaults standardUserDefaults] setObject:current_IDFA forKey:kKTIDFAUserDefaultsKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            return current_IDFA ? current_IDFA : @"";
//        } else {
//            current_IDFA = idfa;
//        }
//    }
//    return current_IDFA;
//}
//
///**
// 该IDFV，经过Keychain的优化。
// 第一次获取IDFV时，将其存入Keychain。
// 此后，均从Keychain中获取IDFV，以保证其唯一性。
// 该方法内不能调用IDFA，否则会死循环
// */
//+ (NSString *)IDFV
//{
//    static NSString *IDFV = nil;
//    if (!IDFV) {
//        NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
//        UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:bundleIdentifier];
//        NSString *IDFVFromKeyChain = keyChain[@"IDFV"];
//        if (IDFVFromKeyChain == nil) {
//            IDFVFromKeyChain = [self organic_idfv];
//            keyChain[@"IDFV"] = IDFVFromKeyChain;
//        } else {
//            IDFV = IDFVFromKeyChain;
//        }
//    }
//    return IDFV ?: @"";
//}
//
///**
// IDFV，每次卸载会变
// */
//+ (NSString *)organic_idfv
//{
//    static NSString *organic_idfv = nil;
//    if (!organic_idfv) {
//        organic_idfv = [[UIDevice currentDevice] identifierForVendor].UUIDString;
//    }
//    return organic_idfv ?: @"";
//}
//
///**
// 获取识别码设备ID: 会从idfa和organic_idfv里按优先级处理
// */
//+ (NSString *)priorityDeviceId
//{
//    static NSString *current_priorityDeviceId = nil;
//    if (!current_priorityDeviceId) {
//        NSString *idfa = [KTDeviceUtils IDFA];
//        NSString *idfv = [KTDeviceUtils IDFV];
//        if (!idfa || [idfa isEqualToString:@""] || [idfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
//            current_priorityDeviceId = idfv;
//        } else {
//            current_priorityDeviceId = idfa;
//        }
//    }
//    return current_priorityDeviceId;
//}

#pragma makr - device info

/**
 获取当前系统的版本 10.0.0/11.2.3/...
 */
+ (NSString *)systemVersion
{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return systemVersion ? systemVersion : @"";
}

/**
 平台 i386/x86_64/iPhone11,4/iPhone9,1...
 */
+ (NSString *)platform
{
    static NSString *current_platform = nil;
    if (!current_platform) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
        current_platform = platform;
    }
    return current_platform;
}

/**
 获取移动设备名称 iPad mini 4/iPhone X/...
 */
+ (NSString *)deviceName
{
    static NSString *current_deviceName = nil;
    if (!current_deviceName) {
        NSString *deviceName = [self deviceForName];
        current_deviceName = deviceName;
        return deviceName ? deviceName : @"";
    }
    return current_deviceName;
}

/**
 * 运行分析/广告产品的实体设备的名称。(x86_64)
 */
+ (NSString *)machineName
{
    static NSString *current_machineName = nil;
    if (!current_machineName) {
        size_t bufferSize = 64;
        NSMutableData *buffer = [[NSMutableData alloc] initWithLength:bufferSize];
        int status = sysctlbyname("hw.machine", buffer.mutableBytes, &bufferSize, NULL, 0);
        if (status != 0) {
            return nil;
        }
        current_machineName = [[NSString alloc] initWithCString:buffer.mutableBytes encoding:NSUTF8StringEncoding];
    }
    return current_machineName;
}

/**
 *  设备类型(iPhone)
 */
+ (NSString *)deviceModel
{
    static NSString *current_deviceModel = nil;
    if (!current_deviceModel) {
        NSString *deviceType = [[UIDevice currentDevice] model];
        struct utsname systemInfo;
        uname(&systemInfo);
        current_deviceModel = deviceType;
    }
    return current_deviceModel;
}

/**
 *  操作系统名字(iOS)
 */
+ (NSString *)systemName
{
    NSString *operationSystem = [[UIDevice currentDevice] systemName];
    return operationSystem;
}

/**
 * 操作系统及操作系统版本的拼接(iOS 12.1)
 */
+ (NSString *)systemNameAndVersion
{
    NSString *osAndVersion = [NSString stringWithFormat:@"%@ %@", [self systemName], [self systemVersion]];
    return osAndVersion;
}

/**
 *  mac地址(8c:85:90:cd:ae:d3)
 */
+ (NSString *)macAddress
{
    static NSString *current_macAddress = nil;
    if (!current_macAddress) {
        int mgmtInfoBase[6];
        char *msgBuffer = NULL;
        size_t length;
        unsigned char macAddress[6];
        struct if_msghdr *interfaceMsgStruct;
        struct sockaddr_dl *socketStruct;
        NSString *errorFlag = NULL;
        mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
        mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
        mgmtInfoBase[2] = 0;
        mgmtInfoBase[3] = AF_LINK;        // Request link layer information
        mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
        if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) {
            errorFlag = @"if_nametoindex failure";
        } else {
            if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) {
                errorFlag = @"sysctl mgmtInfoBase failure";
            } else {
                if ((msgBuffer = malloc(length)) == NULL) {
                    errorFlag = @"buffer allocation failure";
                } else {
                    if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) {
                        errorFlag = @"sysctl msgBuffer failure";
                    }
                }
            }
        }
        if (errorFlag != NULL) {
    #if DEBUG
            NSLog(@"Error: %@", errorFlag);
    #endif
        }
        interfaceMsgStruct = (struct if_msghdr *)msgBuffer;
        socketStruct = (struct sockaddr_dl *)(interfaceMsgStruct + 1);
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                      macAddress[0], macAddress[1], macAddress[2],
                                      macAddress[3], macAddress[4], macAddress[5]];
        current_macAddress = macAddressString;
    }
    return current_macAddress;
}

/**
 *  ip地址(192.168.1.105) 拿不到返回 (Unable To Get)
 */
+ (NSString *)IPAddress
{
    NSError *error;
    NSURL *getIpURL = [NSURL URLWithString:GET_IP_URL_TXT];
    NSString *ip = [NSString stringWithContentsOfURL:getIpURL encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        ip = @"Unable To Get";
    }
    return ip;
}

+ (NSString *)IPAddressWithHostName:(NSString *)hostName
{
    const char *hostN = [hostName UTF8String];
    struct hostent *phot;
    @try {
        phot = gethostbyname(hostN);
    } @catch (NSException *exception) {
        return nil;
    }
    struct in_addr ip_addr;
    if (phot == NULL) {
#if DEBUG
        NSLog(@"获取失败");
#endif
        return nil;
    }
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0}; inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    NSString *strIPAddress = [NSString stringWithUTF8String:ip];
#if DEBUG
    NSLog(@"host:%@ ip:%@", hostName, strIPAddress);
#endif
    return strIPAddress;
}

/**
 IMSI
 */
+ (NSString *)IMSI
{
    static NSString *current_IMSI = nil;
    if (!current_IMSI) {
        NSInteger root = [[self deviceIsRoot] integerValue];
        if (root) {
            current_IMSI = @"";
        } else {
            @try {
                CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
                
                CTCarrier *carrier;
                if (@available(iOS 12.0, *)) {
                    NSDictionary<NSString *, CTCarrier *> *carrierDic = [info serviceSubscriberCellularProviders];
                    carrier = carrierDic.allValues.firstObject;
                } else {
                    carrier = [info subscriberCellularProvider];
                }

                NSString *mcc = [carrier mobileCountryCode];
                NSString *mnc = [carrier mobileNetworkCode];
                
                NSString *imsi = @"";
                if (mcc && mnc) {
                    imsi = [NSString stringWithFormat:@"%@%@", mcc, mnc];
                }
                current_IMSI = imsi;
            } @catch (...) {
                current_IMSI = nil;
                return @"";
            }
        }
    }
    return current_IMSI;
}

// 移动信号国家码
+ (NSString *)mcc
{
    NSInteger root = [[self deviceIsRoot] integerValue];
    if (root) {
        return @"";
    }
    
    @try {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        
        CTCarrier *carrier;
        if (@available(iOS 12.0, *)) {
            NSDictionary<NSString *, CTCarrier *> *carrierDic = [info serviceSubscriberCellularProviders];
            carrier = carrierDic.allValues.firstObject;
        } else {
            carrier = [info subscriberCellularProvider];
        }

        NSString *mcc = [carrier mobileCountryCode];
        return mcc;
    } @catch (...) {
        return @"";
    }
}

// 移动网络号码
+ (NSString *)mnc
{
    NSInteger root = [[self deviceIsRoot] integerValue];
    if (root) {
        return @"";
    }
    
    @try {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        
        CTCarrier *carrier;
        if (@available(iOS 12.0, *)) {
            NSDictionary<NSString *, CTCarrier *> *carrierDic = [info serviceSubscriberCellularProviders];
            carrier = carrierDic.allValues.firstObject;
        } else {
            carrier = [info subscriberCellularProvider];
        }

        NSString *mnc = [carrier mobileNetworkCode];
        return mnc;
    } @catch (...) {
        return @"";
    }
}

/**
 * 操作系统的语言(en)
 */
+ (NSString *)systemLanguage
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *sysLan = [currentLocale objectForKey:NSLocaleLanguageCode];
    return sysLan;
    
    /**
     如下获取方式存在越狱被修改的风险
     NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
     NSArray *languages = [defs objectForKey:@"AppleLanguages"];
     NSString *preferredLang = [languages objectAtIndex:0];
     return preferredLang;
     */
}

/**
 * 设备所在区域/国家(US)code
 */
+ (NSString *)localeCountryCode
{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    return countryCode;
}

/**
 * 设备当前的时间(Asia/Shanghai (GMT+8) offset 28800)
 */
+ (NSString *)systemTimeZone
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    return timeZone.description;
}

/**
 * 网络类型
 */
+ (NSString *)networkType
{
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CTTelephonyNetworkInfo *teleInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString]) {
            return @"4G";
        } else if ([typeStrings3G containsObject:accessString]) {
            return @"3G";
        } else if ([typeStrings2G containsObject:accessString]) {
            return @"2G";
        } else {
            return @"Null";
        }
    } else {
        return @"Unknow";
    }
}

/**
 * 是否有root权限(NO)
 */
+ (NSString *)deviceIsRoot
{
    return [[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"] ? @"1" : @"0";
}

///**
// * DNS服务器地址(DNS Addresses)
// */
//+ (NSArray *)DNSAddresses
//{
//    res_state res = malloc(sizeof(struct __res_state));
//    NSMutableArray *dnsArray = [NSMutableArray new];
//    if (res_ninit(res) == 0) {
//        for (int i = 0; i < res->nscount; i++ ) {
//            NSString *s = [NSString stringWithUTF8String:inet_ntoa(res->nsaddr_list[i].sin_addr)];
//            [dnsArray addObject:s];
//        }
//    }
//    res_ndestroy(res);
//    free(res);
//    return dnsArray;
//}

/**
 * 设备的可选 IETF 语言区域标记，采用分别由两个字母组成的语言代码和国家/地区代码，两者之间用下划线分隔。(en_US)
 */
+ (NSString *)localeIdentifier
{
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    return locale;
}

/**
 * 操作系统的版本号。(18C54)
 */
+ (NSString *)osVersion
{
    static NSString *current_osVersion = nil;
    if (!current_osVersion) {
        size_t bufferSize = 64;
        NSMutableData *buffer = [[NSMutableData alloc] initWithLength:bufferSize];
        int status = sysctlbyname("kern.osversion", buffer.mutableBytes, &bufferSize, NULL, 0);
        if (status != 0) {
            return nil;
        }
        current_osVersion = [[NSString alloc] initWithCString:buffer.mutableBytes encoding:NSUTF8StringEncoding];
    }
    return current_osVersion;
}

/**
 系统时区缩写  GMT+8
 */
+ (NSString *)timezoneAbbreviation
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSString *abbreviation = [zone localizedName:NSTimeZoneNameStyleShortStandard locale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    return abbreviation ?: @"";
}

/**
 是否开启了VPN
 */
+ (BOOL)isVPNOn
{
    NSInteger root = [[self deviceIsRoot] integerValue];
    /**
     越狱环境下不进行vpn判断（firebase显示越狱环境下，此方法执行很大程度增加crash概率）
     
     也可以执行vpn判断，加上try catch防止crash
     */
    if (root) {
        return NO;
    }
    
    @try {
        NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
        NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.google.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
        NSDictionary *settings = proxies.firstObject;
        
        /**
         NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
         NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
         NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
         */
        
        if (!settings ||
            ![settings isKindOfClass:[NSDictionary class]] ||
            [[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
            //没有设置代理
            return NO;
        }else{
            //设置代理了
            return YES;
        }
    }
    @catch(NSException *exception) {
        //        [NSException printWithMessage:[NSString stringWithFormat:@"Get_isVPNOn_exception_%@",exception.reason]];
    }
    @finally {
        return NO;
    }
}

#pragma mark - iPhone X以上机型判断
+ (BOOL)isIphone_x
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIphone_xs
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone11,2"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIphone_xsm
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone11,4"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIphone_xr
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone11,8"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIphone_11
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone12,1"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIphone_11P
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone12,3"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIphone_11PM
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone12,5"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIphone_x_Series
{
    return (self.safeAreaInsets.bottom > 0.0);
}

+ (UIEdgeInsets)safeAreaInsets
{
    static UIEdgeInsets safeAreaInsets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        safeAreaInsets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    });
    return safeAreaInsets;
}

+ (CGFloat)extraStatusBarHeight
{
    if (@available(iOS 12.0, *)) {
        return [KTDeviceUtils safeAreaInsets].top - 20;
    } else {
        if ([KTDeviceUtils isIphone_x_Series]) {
            return [KTDeviceUtils safeAreaInsets].top - 20;
        } else {
            return [KTDeviceUtils safeAreaInsets].top;
        }
    }
}

+ (CGFloat)bottomSafeAreaHeight
{
    return [KTDeviceUtils safeAreaInsets].bottom;
}

+ (CGFloat)statusBarHeight
{
    if (@available(iOS 12.0, *)) {
        return [KTDeviceUtils safeAreaInsets].top;
    } else {
        if ([KTDeviceUtils isIphone_x_Series]) {
            return [KTDeviceUtils safeAreaInsets].top;
        } else {
            return [KTDeviceUtils safeAreaInsets].top + 20;
        }
    }
}

+ (CGFloat)statusBarAndNavigationBarHeight
{
    if (@available(iOS 12.0, *)) {
        return 44 + [KTDeviceUtils safeAreaInsets].top;
    } else {
        if ([KTDeviceUtils isIphone_x_Series]) {
            return 44 + [KTDeviceUtils safeAreaInsets].top;
        } else {
            return 44 + [KTDeviceUtils safeAreaInsets].top + 20;
        }
    }
}

+ (CGFloat)tabBarHeight
{
    return 49 + [KTDeviceUtils safeAreaInsets].bottom;
}

#pragma mark - iPad
+ (BOOL)isPad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}

/**
 内存相关
 */
+ (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) /1024.0) / 1024.0;
}

+ (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount =TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn =task_info(mach_task_self(),
                                        TASK_BASIC_INFO,
                                        (task_info_t)&taskInfo,
                                        &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
        
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (float)cpuUsage
{
    kern_return_t kr;
       task_info_data_t tinfo;
       mach_msg_type_number_t task_info_count;

       task_info_count = TASK_INFO_MAX;
       kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
       if (kr != KERN_SUCCESS) {
           return -1;
       }

       task_basic_info_t      basic_info;
       thread_array_t         thread_list;
       mach_msg_type_number_t thread_count;

       thread_info_data_t     thinfo;
       mach_msg_type_number_t thread_info_count;

       thread_basic_info_t basic_info_th;
       uint32_t stat_thread = 0; // Mach threads

       basic_info = (task_basic_info_t)tinfo;

       // get threads in the task
      kr = task_threads(mach_task_self(), &thread_list, &thread_count);
       if (kr != KERN_SUCCESS) {
           return -1;
       }
       if (thread_count > 0)
           stat_thread += thread_count;

       long tot_sec = 0;
       long tot_usec = 0;
       float tot_cpu = 0;
       int j;

       for (j = 0; j < thread_count; j++)
       {
           thread_info_count = THREAD_INFO_MAX;
           kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                            (thread_info_t)thinfo, &thread_info_count);
           if (kr != KERN_SUCCESS) {
               return -1;
           }

           basic_info_th = (thread_basic_info_t)thinfo;

           if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
               tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
               tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
               tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
           }

       } // for each thread

       kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
       assert(kr == KERN_SUCCESS);

       return tot_cpu / 100;
}

+ (NSUInteger)cpuCoreCount
{
    static NSUInteger current_cpuCoreCount = 0;
    if (!current_cpuCoreCount) {
        unsigned int ncpu;
        size_t len = sizeof(ncpu);
        sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
        current_cpuCoreCount = ncpu;
    }
    return current_cpuCoreCount;
}

+ (NSString *)deviceForName
{
    // 获取方法
    // https://www.theiphonewiki.com/wiki/Models
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"]) {
        return @"iPhone 1G";
    }
    if ([deviceString isEqualToString:@"iPhone1,2"]) {
        return @"iPhone 3G";
    }
    if ([deviceString isEqualToString:@"iPhone2,1"]) {
        return @"iPhone 3GS";
    }
    if ([deviceString isEqualToString:@"iPhone3,1"]) {
        return @"iPhone 4";
    }
    if ([deviceString isEqualToString:@"iPhone3,2"]) {
        return @"Verizon iPhone 4";
    }
    if ([deviceString isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S";
    }
    if ([deviceString isEqualToString:@"iPhone5,1"]) {
        return @"iPhone 5";
    }
    if ([deviceString isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5";
    }
    if ([deviceString isEqualToString:@"iPhone5,3"]) {
        return @"iPhone 5C";
    }
    if ([deviceString isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5C";
    }
    if ([deviceString isEqualToString:@"iPhone6,1"]) {
        return @"iPhone 5S";
    }
    if ([deviceString isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5S";
    }
    if ([deviceString isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6";
    }
    if ([deviceString isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s";
    }
    if ([deviceString isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6s Plus";
    }
    if ([deviceString isEqualToString:@"iPhone8,4"]) {
        return @"iPhone SE";
    }
    if ([deviceString isEqualToString:@"iPhone9,1"]) {
        return @"iPhone 7";
    }
    if ([deviceString isEqualToString:@"iPhone9,3"]) {
        return @"iPhone 7";
    }
    if ([deviceString isEqualToString:@"iPhone9,2"]) {
        return @"iPhone 7 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone9,4"]) {
        return @"iPhone 7 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone10,1"]) {
        return @"iPhone 8";
    }
    if ([deviceString isEqualToString:@"iPhone10,4"]) {
        return @"iPhone 8";
    }
    if ([deviceString isEqualToString:@"iPhone10,2"]) {
        return @"iPhone 8 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone10,5"]) {
        return @"iPhone 8 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone10,3"]) {
        return @"iPhone X";
    }
    if ([deviceString isEqualToString:@"iPhone10,6"]) {
        return @"iPhone X";
    }
    if ([deviceString isEqualToString:@"iPhone11,2"]) {
        return @"iPhone XS";
    }
    if ([deviceString isEqualToString:@"iPhone11,4"]) {
        return @"iPhone XS Max";
    }
    if ([deviceString isEqualToString:@"iPhone11,6"]) {
        return @"iPhone XS Max";
    }
    if ([deviceString isEqualToString:@"iPhone11,8"]) {
        return @"iPhone XR";
    }
    if([deviceString isEqualToString:@"iPhone12,1"]) {
        return @"iPhone 11";
    }
    if([deviceString isEqualToString:@"iPhone12,3"]) {
        return @"iPhone 11 Pro";
    }
    if([deviceString isEqualToString:@"iPhone12,5"]) {
        return @"iPhone 11 Pro Max";
    }
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"]) {
        return @"iPod Touch 1G";
    }
    if ([deviceString isEqualToString:@"iPod2,1"]) {
        return @"iPod Touch 2G";
    }
    if ([deviceString isEqualToString:@"iPod3,1"]) {
        return @"iPod Touch 3G";
    }
    if ([deviceString isEqualToString:@"iPod4,1"]) {
        return @"iPod Touch 4G";
    }
    if ([deviceString isEqualToString:@"iPod5,1"]) {
        return @"iPod Touch 5G";
    }
    if ([deviceString isEqualToString:@"iPod7,1"]) {
        return @"iPod Touch 6G";
    }
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"]) {
        return @"iPad";
    }
    if ([deviceString isEqualToString:@"iPad2,1"]) {
        return @"iPad 2 (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad2,2"]) {
        return @"iPad 2 (GSM)";
    }
    if ([deviceString isEqualToString:@"iPad2,3"]) {
        return @"iPad 2 (CDMA)";
    }
    if ([deviceString isEqualToString:@"iPad2,4"]) {
        return @"iPad 2 (32nm)";
    }
    if ([deviceString isEqualToString:@"iPad2,5"]) {
        return @"iPad mini (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad2,6"]) {
        return @"iPad mini (GSM)";
    }
    if ([deviceString isEqualToString:@"iPad2,7"]) {
        return @"iPad mini (CDMA)";
    }
    if ([deviceString isEqualToString:@"iPad3,1"]) {
        return @"iPad 3(WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad3,2"]) {
        return @"iPad 3(CDMA)";
    }
    if ([deviceString isEqualToString:@"iPad3,3"]) {
        return @"iPad 3(4G)";
    }
    if ([deviceString isEqualToString:@"iPad3,4"]) {
        return @"iPad 4 (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad3,5"]) {
        return @"iPad 4 (4G)";
    }
    if ([deviceString isEqualToString:@"iPad3,6"]) {
        return @"iPad 4 (CDMA)";
    }
    if ([deviceString isEqualToString:@"iPad4,1"]) {
        return @"iPad Air";
    }
    if ([deviceString isEqualToString:@"iPad4,2"]) {
        return @"iPad Air";
    }
    if ([deviceString isEqualToString:@"iPad4,3"]) {
        return @"iPad Air";
    }
    if ([deviceString isEqualToString:@"iPad4,4"]) {
        return @"iPad mini 2";
    }
    if ([deviceString isEqualToString:@"iPad4,5"]) {
        return @"iPad mini 2";
    }
    if ([deviceString isEqualToString:@"iPad4,6"]) {
        return @"iPad mini 2";
    }
    if ([deviceString isEqualToString:@"iPad4,7"]) {
        return @"iPad mini 3";
    }
    if ([deviceString isEqualToString:@"iPad4,8"]) {
        return @"iPad mini 3";
    }
    if ([deviceString isEqualToString:@"iPad4,9"]) {
        return @"iPad mini 3";
    }
    if ([deviceString isEqualToString:@"iPad5,1"]) {
        return @"iPad mini 4";
    }
    if ([deviceString isEqualToString:@"iPad5,2"]) {
        return @"iPad mini 4";
    }
    if ([deviceString isEqualToString:@"iPad5,3"]) {
        return @"iPad Air 2";
    }
    if ([deviceString isEqualToString:@"iPad5,4"]) {
        return @"iPad Air 2";
    }
    if ([deviceString isEqualToString:@"iPad6,3"]) {
        return @"iPad Pro 9.7-inch";
    }
    if ([deviceString isEqualToString:@"iPad6,4"]) {
        return @"iPad Pro 9.7-inch";
    }
    if ([deviceString isEqualToString:@"iPad6,7"]) {
        return @"iPad Pro 12.9-inch";
    }
    if ([deviceString isEqualToString:@"iPad6,8"]) {
        return @"iPad Pro 12.9-inch";
    }
    if ([deviceString isEqualToString:@"iPad6,11"]) {
        return @"iPad 5Th";
    }
    if ([deviceString isEqualToString:@"iPad6,12"]) {
        return @"iPad 5Th";
    }
    if ([deviceString isEqualToString:@"iPad7,1"]) {
        return @"iPad Pro 12.9-inch 2nd";
    }
    if ([deviceString isEqualToString:@"iPad7,2"]) {
        return @"iPad Pro 12.9-inch 2nd";
    }
    if ([deviceString isEqualToString:@"iPad7,3"]) {
        return @"iPad Pro 10.5-inch";
    }
    if ([deviceString isEqualToString:@"iPad7,4"]) {
        return @"iPad Pro 10.5-inch";
    }
    //AirPods
    if ([deviceString isEqualToString:@"AirPods1,1"]) {
        return @"AirPods";
    }
    //Apple TV
    if ([deviceString isEqualToString:@"AppleTV2,1"]) {
        return @"AppleTV 2";
    }
    if ([deviceString isEqualToString:@"AppleTV3,1"]) {
        return @"AppleTV 3";
    }
    if ([deviceString isEqualToString:@"AppleTV3,2"]) {
        return @"AppleTV 3";
    }
    if ([deviceString isEqualToString:@"AppleTV5,3"]) {
        return @"AppleTV 4";
    }
    if ([deviceString isEqualToString:@"AppleTV6,2"]) {
        return @"AppleTV 4K";
    }
    //Apple Watch
    if ([deviceString isEqualToString:@"Watch1,1"]) {
        return @"Apple Watch1";
    }
    if ([deviceString isEqualToString:@"Watch1,2"]) {
        return @"Apple Watch1";
    }
    if ([deviceString isEqualToString:@"Watch2,6"]) {
        return @"Apple Watch Series 1";
    }
    if ([deviceString isEqualToString:@"Watch2,7"]) {
        return @"Apple Watch Series 1";
    }
    if ([deviceString isEqualToString:@"Watch2,3"]) {
        return @"Apple Watch Series 2";
    }
    if ([deviceString isEqualToString:@"Watch2,4"]) {
        return @"Apple Watch Series 2";
    }
    if ([deviceString isEqualToString:@"Watch3,1"]) {
        return @"Apple Watch Series 3";
    }
    if ([deviceString isEqualToString:@"Watch3,2"]) {
        return @"Apple Watch Series 3";
    }
    if ([deviceString isEqualToString:@"Watch3,3"]) {
        return @"Apple Watch Series 3";
    }
    if ([deviceString isEqualToString:@"Watch3,4"]) {
        return @"Apple Watch Series 3";
    }
    //HomePod
    if ([deviceString isEqualToString:@"AudioAccessory1,1"]) {
        return @"HomePod";
    }
    //模拟器
    if ([deviceString isEqualToString:@"i386"]) {
        return @"Simulator";
    }
    if ([deviceString isEqualToString:@"x86_64"]) {
        return @"Simulator";
    }
    return deviceString;
}

@end
