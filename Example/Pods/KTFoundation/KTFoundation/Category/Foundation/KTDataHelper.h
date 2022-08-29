//
//  KTDataHelper.h
//  KTFoundation
//
//  Created by KOTU on 2019/8/14.
//  Copyright © 2019 KTFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 判断是否是NSArray类型如果是返回本身，不是返回nil
 
 @param array 数组
 @return 返回结果
 */
static inline NSArray * _Nullable kt_safeArray(id _Nullable array)
{
    if ([array isKindOfClass:[NSArray class]]) {
        return array;
    }
    return nil;
}

/**
 判断是否是NSMutableArray类型如果是返回本身，不是返回nil
 
 @param mutableArray 可变数组
 @return 返回结果
 */
static inline NSMutableArray * _Nullable kt_safeMutableArray(id _Nullable mutableArray)
{
    if ([mutableArray isKindOfClass:[NSMutableArray class]]) {
        return mutableArray;
    }
    return nil;
}

/**
 判断是否是NSDictionary类型，如果是返回本身，不是返回nil
 
 @param dict 字典
 @return 返回结果
 */
static inline NSDictionary * _Nullable kt_safeDict(id _Nullable dict)
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return dict;
    }
    return nil;
}

/**
 判断是否是NSMutableDictionary类型，如果是返回本身，不是返回nil
 
 @param mutableDict 字典
 @return 返回结果
 */
static inline NSMutableDictionary * _Nullable kt_safeMutableDict(id _Nullable mutableDict)
{
    if ([mutableDict isKindOfClass:[NSMutableDictionary class]]) {
        return mutableDict;
    }
    return nil;
}

/**
 判断是否是NSString类型，如果是返回本身，不是返回nil
 
 @param str 字符串
 @return 返回结果
 */
static inline NSString * _Nullable kt_safeStr(id _Nullable str)
{
    if ([str isKindOfClass:[NSString class]]) {
        return str;
    }
    return nil;
}

/**
 判断是否是NSString类型，如果是返回本身，不是返回defaultStr
 
 @param str 字符串
 @return 返回结果
 */
static inline NSString * _Nullable kt_safeStrWithDefalut(id _Nullable str,NSString * _Nullable defaultStr)
{
    NSString *temp = kt_safeStr(str);
    return temp ?: defaultStr;
}

/**
 判断是否是NSObject类型，如果是返回本身，不是返回nil
 
 @param obj NSObject对象
 @return 返回结果
 */
static inline NSObject * _Nullable kt_safeObj(id _Nullable obj)
{
    if ([obj isKindOfClass:[NSObject class]]) {
        return obj;
    }
    return nil;
}

/**
 判断是否是空字符串，如果是返回YES，不是的话返回NO，验证前需要保证str为NSString类型
 
 @param str 待验证的字符串
 @return 返回结果
 */
static inline BOOL kt_isEmptyStr(NSString * _Nullable str)
{
    if (!str) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
#if DEBUG
        NSLog(@"func kt_isEmptyStr, str must be kind of NSString class");
        assert(NO);
#endif
        return YES; //类型不匹配是当做空字符串处理，要不然很危险
    }    
    if (str.length == 0) {
        return YES;
    }
    
    return NO;
}

/// 判断是否是NSNumber类型，如果是返回本身，不是返回nil
static inline NSNumber * _Nullable kt_safeNumber(id _Nullable obj)
{
    if ([obj isKindOfClass:NSNumber.class]) {
        return obj;
    }
    return nil;
}

/// 判断是否是NSMutableArray类型，如果是返回本身，如果是NSArrary类型，根据数据创建一个NSMutableArray类型的对象
/// 其余情况返回为nil
/// @param mutableArray 数组
static inline NSMutableArray * _Nullable kt_mutableArray(id _Nullable mutableArray)
{
    if ([mutableArray isKindOfClass:[NSMutableArray class]]) {
        return mutableArray;
    } else if ([mutableArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:mutableArray];
        return array;
    }
    return nil;
}
