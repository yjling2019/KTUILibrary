//
//  KTStoreTool.h
//  KOTU
//
//  Created by KOTU on 2019/1/28.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMKV/MMKV.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTStoreTool : NSObject

#pragma mark - 偏好设置/MMKV

+ (BOOL)containsKey:(nonnull NSString *)key;

/// int64 保存/获取的便利方法
/// @param key 设置Key
+ (int64_t)int64ForKey:(nonnull NSString *)key;
+ (BOOL)setInt64:(int64_t)value forKey:(nonnull NSString *)key;

/// bool 保存/获取的便利方法
/// @param key 设置Key
+ (BOOL)boolForKey:(nonnull NSString *)key;
+ (BOOL)setBool:(BOOL)value forKey:(nonnull NSString *)key;

/// NSString 保存/获取的便利方法
/// @param key 设置Key
+ (nullable NSString *)stringForKey:(nonnull NSString *)key;
+ (BOOL)setString:(NSString *)value forKey:(nonnull NSString *)key;

/// double 保存/获取的便利方法
/// @param key 设置Key
+ (double)doubleForKey:(nonnull NSString *)key;
+ (BOOL)setDouble:(double)value forKey:(nonnull NSString *)key;

/// NSMutableArray 获取的便利方法
/// @param key 设置Key
+ (nullable NSMutableArray *)mutableArrayForKey:(nonnull NSString *)key;
+ (nullable NSArray *)arrayForKey:(nonnull NSString *)key;

/// NSMutableDictionary 获取的便利方法
/// @param key 设置Key
+ (nullable NSMutableDictionary *)mutableDictionaryForKey:(nonnull NSString *)key;
+ (nullable NSDictionary *)dictionaryForKey:(nonnull NSString *)key;

/// object 保存/获取的便利方法
/// @param key 设置Key
/// @param class 获取的实例对应类型
+ (nullable id)objectOfClass:(Class)class forKey:(nonnull NSString *)key;
+ (BOOL)setObject:(nullable NSObject<NSCoding> *)object forKey:(nonnull NSString *)key;

+ (void)removeValueForKey:(nonnull NSString *)key;

@end

NS_ASSUME_NONNULL_END

