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

+ (void)showPickerWithConfigurationBlock:(void(^ __nullable)(KTImagePickerConfig *config))configurationBlock
						 completionBlock:(void(^ __nullable)(KTImagePickerResult *result))completionBlock;

@end

NS_ASSUME_NONNULL_END
