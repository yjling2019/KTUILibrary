//
//  KTStoreTool.m
//  KOTU
//
//  Created by KOTU on 2019/1/28.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "KTStoreTool.h"

@interface KTStoreTool()

@end

@implementation KTStoreTool

+ (void)initialize
{
    if (self == [KTStoreTool class]) {
        [self setUpMMKV];
    }
}

#pragma mark - 偏好设置/MMKV
+ (BOOL)containsKey:(NSString *)key
{
    return [MMKV.defaultMMKV containsKey:key];
}

+ (int64_t)int64ForKey:(NSString *)key
{
    return [MMKV.defaultMMKV getInt64ForKey:key];
}

+ (BOOL)setInt64:(int64_t)value forKey:(NSString *)key
{
    return [MMKV.defaultMMKV setInt64:value forKey:key];
}

+ (BOOL)boolForKey:(NSString *)key
{
    return [MMKV.defaultMMKV getBoolForKey:key];
}

+ (BOOL)setBool:(BOOL)value forKey:(NSString *)key
{
    return [MMKV.defaultMMKV setBool:value forKey:key];
}

+ (NSString *)stringForKey:(NSString *)key
{
    return [MMKV.defaultMMKV getStringForKey:key];
}

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    return [MMKV.defaultMMKV setString:value forKey:key];
}

+ (double)doubleForKey:(NSString *)key
{
    return [MMKV.defaultMMKV getDoubleForKey:key];
}

+ (BOOL)setDouble:(double)value forKey:(NSString *)key
{
    return [MMKV.defaultMMKV setDouble:value forKey:key];
}

+ (NSMutableArray *)mutableArrayForKey:(NSString *)key
{
    return (NSMutableArray *)[self objectOfClass:NSMutableArray.class forKey:key];
}

+ (NSArray *)arrayForKey:(NSString *)key
{
    return (NSArray *)[self objectOfClass:NSArray.class forKey:key];
}

+ (NSMutableDictionary *)mutableDictionaryForKey:(NSString *)key
{
    id res = [self objectOfClass:NSMutableDictionary.class forKey:key];
    
    if ([res isKindOfClass:[NSMutableDictionary class]]) {
        return (NSMutableDictionary *)res;
    } else if ([res isKindOfClass:[NSDictionary class]]) {
        return [NSMutableDictionary dictionaryWithDictionary:res];
    } else {
        return nil;
    }
}

+ (NSDictionary *)dictionaryForKey:(NSString *)key
{
    return (NSDictionary *)[self objectOfClass:NSDictionary.class forKey:key];
}

+ (id)objectOfClass:(Class)class forKey:key
{
    return [MMKV.defaultMMKV getObjectOfClass:class forKey:key];
}

+ (BOOL)setObject:(nullable NSObject<NSCoding> *)object forKey:(NSString *)key
{
    return [MMKV.defaultMMKV setObject:object forKey:key];
}

+ (void)removeValueForKey:(NSString *)key
{
    [MMKV.defaultMMKV removeValueForKey:key];
}

+ (void)setUpMMKV
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleMemoryWarning)
												 name:UIApplicationDidReceiveMemoryWarningNotification
											   object:nil];
	
	[MMKV initializeMMKV:[MMKV mmkvBasePath] logLevel:MMKVLogError];
	
    
//    NSString *isMmkvHasMigrated = @"isMmkvHasMigrated";
//    // 迁移userdefaults的数据到MMKV
//    BOOL hasMigrated = [NSUserDefaults.standardUserDefaults boolForKey:isMmkvHasMigrated];
//    if (!hasMigrated) {
//#if DEBUG
//        NSLog(@"开始迁移Userdefault数据");
//#endif
//        uint32_t count = [MMKV.defaultMMKV migrateFromUserDefaults:NSUserDefaults.standardUserDefaults];
//        [NSUserDefaults.standardUserDefaults setBool:YES forKey:isMmkvHasMigrated];
//#if DEBUG
//        NSLog(@"迁移Userdefault数据完成:%d",count);
//#endif
//    }
}

+ (void)handleMemoryWarning
{
	// 在内存警告时，清除mmkv内存部分缓存
	[MMKV.defaultMMKV clearMemoryCache];
}

@end
