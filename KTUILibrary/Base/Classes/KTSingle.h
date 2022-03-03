//
//  KTSingle.h
//  KTFoundation
//
//  Created by KOTU on 2019/1/24.
//  Copyright © 2019 iOS. All rights reserved.
//

#ifndef KTSingle
#define KTSingle

// 单例通用定义

#define KT_AS_SINGLE \
+ (instancetype)sharedInstance;\
- (void)unLoad;\

#define KT_DEF_SINGLE(__class) \
static __class *_instance = nil;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
+ (instancetype)sharedInstance \
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone \
{\
return _instance;\
}\

#endif /* KTSingle_h */
