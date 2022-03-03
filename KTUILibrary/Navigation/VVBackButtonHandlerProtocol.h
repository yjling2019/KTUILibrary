//
//  VVBackButtonHandlerProtocol.h
//  vv_bodylib_ios
//
//  Created by fwzhou on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VVBackButtonHandlerProtocol <NSObject>

@optional
- (BOOL)navigationShouldPopOnBackButton;

@end

NS_ASSUME_NONNULL_END
