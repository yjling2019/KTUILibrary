//
//  KTImageSaver.h
//  KTFoundation
//
//  Created by KOTU on 2022/10/10.
//

#import <Foundation/Foundation.h>
#import "KTImageSaverConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTImageSaver : NSObject

+ (void)saveImageWithConfigurationBlock:(void(^ __nullable)(KTImageSaverConfig *config))configurationBlock
						completionBlock:(void(^ __nullable)(BOOL success, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
