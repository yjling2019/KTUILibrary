//
//  KTViewControllerProtocol.h
//  KOTU
//
//  Created by KOTU on 2019/8/9.
//  Copyright © 2019 iOS. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef KTViewControllerProtocol_h
#define KTViewControllerProtocol_h

#define KTSynthesizeViewControllerProtocol \
@synthesize inputJson = _inputJson;\
@synthesize inputModel = _inputModel;\
@synthesize callBack = _callBack;\

static NSString * const kViewControllerCallBackDataKey = @"kViewControllerCallBackDataKey";

typedef void (^KTViewControllerCallBackBlock)(NSDictionary *data);

@protocol KTViewControllerProtocol <NSObject>

@optional

/// 使用类方法进行初始化
+ (instancetype)kt_controller;

/// 使用类方法根据json对象初始化
/// @param json json对象
+ (instancetype)kt_controllerWithJSON:(NSDictionary *)json;

/// 使用类方法根据json对象初始化
/// @param json json对象
/// @param callBack 回调block
+ (instancetype)kt_controllerWithJSON:(NSDictionary *)json
							 callBack:(KTViewControllerCallBackBlock)callBack;

///  使用类方法根据model初始化
/// @param model 数据模型
+ (instancetype)kt_controllerWithModel:(id)model;

///  使用类方法根据model初始化
/// @param model 数据模型
/// @param callBack 回调block
+ (instancetype)kt_controllerWithModel:(id)model
							  callBack:(KTViewControllerCallBackBlock)callBack;

@property (nonatomic, strong) NSDictionary *inputJson;
@property (nonatomic, strong) id inputModel;
@property (nonatomic, strong) KTViewControllerCallBackBlock callBack;

@end

#endif /* KTViewControllerProtocol_h */
