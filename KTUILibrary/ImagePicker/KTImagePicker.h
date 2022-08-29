//
//  KTImagePicker.h
//  KTFoundation
//
//  Created by KOTU on 2022/8/29.
//

#import <Foundation/Foundation.h>
#import "KTImagePickerConfig.h"
#import "KTImagePickerResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTImagePicker : NSObject

+ (void)showPickerWithConfigurationBlock:(void(^)(KTImagePickerConfig *config))configurationBlock
						 completionBlock:(void(^)(KTImagePickerResult *result))completionBlock;

@end

NS_ASSUME_NONNULL_END
