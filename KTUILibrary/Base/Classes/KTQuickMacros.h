//
//  KTRootMacro.h
//  Pods
//
//  Created by KOTU on 2020/8/25.
//

#ifndef KTMacros_h
#define KTMacros_h

#import <pthread.h>

#pragma mark - Assert
#if DEBUG

#define KTAssert(condition, desc, ...) NSAssert((condition), (desc), ## __VA_ARGS__)
#define KTAssert1(condition, desc, arg1) KTAssert((condition), (desc), (arg1))
#define KTAssert2(condition, desc, arg1, arg2) KTAssert((condition), (desc), (arg1), (arg2))
#define KTAssert3(condition, desc, arg1, arg2, arg3) KTAssert((condition), (desc), (arg1), (arg2), (arg3))
#define KTAssert4(condition, desc, arg1, arg2, arg3, arg4) KTAssert((condition), (desc), (arg1), (arg2), (arg3), (arg4))
#define KTAssert5(condition, desc, arg1, arg2, arg3, arg4, arg5) KTAssert((condition), (desc), (arg1), (arg2), (arg3), (arg4), (arg5))
#define KTParameterAssert(condition) KTAssert((condition), @"Invalid parameter not satisfying: %@", @#condition)

#else

#define KTAssert(condition, desc, ...)
#define KTAssert1(condition, desc, arg1)
#define KTAssert2(condition, desc, arg1, arg2)
#define KTAssert3(condition, desc, arg1, arg2, arg3)
#define KTAssert4(condition, desc, arg1, arg2, arg3, arg4)
#define KTAssert5(condition, desc, arg1, arg2, arg3, arg4, arg5)
#define KTParameterAssert(condition)

#endif


#if DEBUG
#define KTAssertReturn(condition, desc, result)		NSAssert(condition, desc); \
													if (!condition) { return result; }
#define KTAssertReturnVoid(condition, desc)			NSAssert(condition, desc); \
													if (!condition) { return; }
#define KTAssertReturnNil(condition, desc)			NSAssert(condition, desc); \
													if (!condition) { return nil; }
#else
#define KTAssertReturn(condition, desc, result)		if (!condition) { return result; }
#define KTAssertReturnVoid(condition, desc)			if (!condition) { return; }
#define KTAssertReturnNil(condition, desc)			if (!condition) { return nil; }
#endif


#define KTClassAssert(instance, class_name)                         KTAssert([instance isKindOfClass:[class_name class]], @"class error.")
#define KTClassAssertReturn(instance, class_name, result)           KTAssertReturn([instance isKindOfClass:[class_name class]], @"class error.", result)
#define KTClassAssertReturnVoid(instance, class_name)               KTAssertReturnVoid([instance isKindOfClass:[class_name class]], @"class error.")
#define KTClassAssertReturnNil(instance, class_name)                KTAssertReturnNil([instance isKindOfClass:[class_name class]], @"class error.")

#define KTParameterAssertReturn(condition, result)                  KTAssertReturn((condition), @"params error.", result)
#define KTParameterAssertReturnVoid(condition)                      KTAssertReturnVoid(condition), @"params error.")
#define KTParameterAssertReturnNil(condition)                       KTParameterAssertReturnNil(condition), @"params error.")

#pragma mark - Debug Helper

#if DEBUG
#define KTDebugCodeStart		do {
#define KTDebugCodeEnd 			} while (0);
#else
#define KTDebugCodeStart		while (0) {
#define KTDebugCodeEnd			};
#endif


#if DEBUG
#define KTDebugCode(code)   	do code while (0);
#else
#define KTDebugCode(code)   	while (0) code;
#endif

#pragma mark - Likely
#define likely(x) __builtin_expect(!!(x), 1) //x很可能为真
#define unlikely(x) __builtin_expect(!!(x), 0) //x很可能为假

#pragma mark - Block
typedef void(^KTBlock)(void);
typedef void(^KTCommonBlock)(id);

#pragma mark - main thread
/// 在主线程执行的的宏定义
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
	if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
		block();\
	} else {\
		dispatch_async(dispatch_get_main_queue(), block);\
	}
#endif

static inline void dispatch_async_on_main_queue(void (^block)(void)) {
	if (pthread_main_np()) {
		block();
	} else {
		dispatch_async(dispatch_get_main_queue(), block);
	}
}

#pragma mark - Lazy load
#define KTLazyload(class, name, config) 	- (class *)name\
											{\
												if (!_##name) {\
													_##name = [[class alloc] init];\
													config;\
												}\
												return _##name;\
											}


#pragma mark - Log
#ifdef DEBUG
#define KTLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ## __VA_ARGS__] UTF8String])
#else
#define KTLog(format, ...)
#endif

#pragma mark - Associated Object
#ifndef KT_SYNTH_DYNAMIC_PROPERTY_OBJECT
#define KT_SYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
	[self willChangeValueForKey:@#_getter_]; \
	objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
	[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
	return objc_getAssociatedObject(self, @selector(_setter_:)); \
}

#endif

#ifndef KT_SYNTH_DYNAMIC_PROPERTY_CTYPE
#define KT_SYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
	[self willChangeValueForKey:@#_getter_]; \
	NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
	objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
	[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
	_type_ cValue = { 0 }; \
	NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
	[value getValue:&cValue]; \
	return cValue; \
}
#endif

#pragma mark - KTDeallocCheck
#ifdef DEBUG
#define KTDeallocCheck          - (void)dealloc \
								{ \
									NSLog(@"%@ did dealloc", NSStringFromClass([self class])); \
								}
#else
#define KTDeallocCheck
#endif

#pragma mark - Duration Record
#ifdef DEBUG
#define KTDurationRecordStart       NSDate *kt_duration_start_date = [NSDate date];
#define KTDurationRecordEnd         NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:kt_duration_start_date]; \
									NSLog(@"Duration: %.3f", duration * 1000); \
									NSLog(@"--------------------------------");
#else
#define KTDurationRecordStart
#define KTDurationRecordEnd
#endif

#pragma mark - Quick Help
#ifdef __cplusplus
#define KT_EXTERN_C_BEGIN  extern "C" {
#define KT_EXTERN_C_END  }
#else
#define KT_EXTERN_C_BEGIN
#define KT_EXTERN_C_END
#endif


KT_EXTERN_C_BEGIN

#ifndef KT_CLAMP // return the clamped value
#define KT_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#ifndef KT_SWAP // swap two value
#define KT_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif


//main window
#define kMainWindow                [UIApplication sharedApplication].keyWindow

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define kMinLineHeight (1 / UIScreen.mainScreen.scale)

//iphone  X系列判断
//#define IS_iPhoneXSeries [KTDeviceUtils isIphone_x_Series]
//iPhoneX状态栏额外的高度
//#define iPhoneX_extra_statusHeight [KTDeviceUtils extraStatusBarHeight]
//安全区域高度
//#define BottomSafeAreaHeight [KTDeviceUtils bottomSafeAreaHeight]

////状态栏高度
//#define StatusBarHeight [KTDeviceUtils statusBarHeight]
////导航栏 + 状态栏高度
//#define StatusBarAndNavigationBarHeight [KTDeviceUtils statusBarAndNavigationBarHeight]
////底部标签栏高度
//#define TabBarHeight [KTDeviceUtils tabBarHeight]

// RGB颜色
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

// 根据屏幕的宽度自适应，此处UISize如同fontSize，不是结构体CGSize
#define autoScaleSize(UISize) (UISize * SCREEN_W / 375)// 375为设计图宽度

//商品列表 商品cell 之间的itemspace
#define kProductItemSpace 10
//商品列表 商品cell 的宽度
#define kProductCellWidth  ([UIScreen mainScreen].bounds.size.width - 3 * kProductItemSpace) / 2
//商品列表 商品cell 的高度
#define kProductCellHeight  ([UIScreen mainScreen].bounds.size.width - 3 * kProductItemSpace) / 2

// 判断反向布局
#define IS_RightToLeft \
({BOOL isRightToLeft = NO;\
if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {\
	isRightToLeft = YES;\
}\
(isRightToLeft);})\

//判断暗黑模式
#define IS_DarkMode \
({BOOL isDarkMode = NO;\
if (@available(iOS 13.0, *)) {\
	   if ([UIScreen mainScreen].traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {\
		   isDarkMode = YES;\
	   }\
   }\
(isDarkMode);})\

#endif /* KTMacro_h */
