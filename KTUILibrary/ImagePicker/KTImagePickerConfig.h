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

// default KTImagePickerModeCamera|KTImagePickerModeLibrary
@property (nonatomic, assign) KTImagePickerMode mode;
// default 0
@property (nonatomic, assign) NSInteger selectionLimit;

// default YES
@property (nonatomic, assign) BOOL autoCompress;
// default 300kb
@property (nonatomic, assign) NSUInteger compressMaxSize;

@end

NS_ASSUME_NONNULL_END
