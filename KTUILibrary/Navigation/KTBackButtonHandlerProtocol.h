//
//  KTBackButtonHandlerProtocol.h
// 	KOTU
//
//  Created by KOTU on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KTBackButtonHandlerProtocol <NSObject>

@optional
- (BOOL)navigationShouldPopOnBackButton;

@end

NS_ASSUME_NONNULL_END
