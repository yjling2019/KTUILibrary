//
//  KTNavigationControllerProtocol.h
//	KOTU
//
//  Created by KOTU on 2020/6/23.
//

#import <Foundation/Foundation.h>

#define KTSynthesizeNavigationControllerProtocol \
@synthesize useCustomNavigationBar = _useCustomNavigationBar;\

NS_ASSUME_NONNULL_BEGIN

@protocol KTNavigationControllerProtocol <NSObject>

@optional
@property (nonatomic, assign) BOOL useCustomNavigationBar;

@end

NS_ASSUME_NONNULL_END
