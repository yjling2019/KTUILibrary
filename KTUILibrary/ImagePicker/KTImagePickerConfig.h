//
//  KTImagePickerConfig.h
//  KTFoundation
//
//  Created by KOTU on 2022/8/29.
//

#import <Foundation/Foundation.h>
#import <PhotosUI/PhotosUI.h>

typedef NS_OPTIONS(NSUInteger, KTImagePickerMode) {
	KTImagePickerModeCamera = 1 << 1,
	KTImagePickerModeLibrary = 1 << 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface KTImagePickerConfig : NSObject

@property (nonatomic, assign) KTImagePickerMode mode;
@property (nonatomic, assign) NSInteger selectionLimit;

@end

NS_ASSUME_NONNULL_END
