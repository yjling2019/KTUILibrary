//
//  KTImagePickerResult.h
//  KTUILibrary
//
//  Created by KOTU on 2022/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTImagePickerResult : NSObject

@property (nonatomic, strong) NSArray <UIImage *> *images;
@property (nonatomic, strong) NSString *errorMsg;

@end

NS_ASSUME_NONNULL_END
