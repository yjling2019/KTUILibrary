//
//  KTImageSaverConfig.h
//  KTFoundation
//
//  Created by KOTU on 2022/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTImageSaverConfig : NSObject

@property (nonatomic, strong) NSArray <UIImage *> *images;
@property (nonatomic, strong) UIImage *image;

// 是否保存到自定义相册
@property (nonatomic, assign) BOOL saveToCustomAlbum;
// 自定义相册名称，默认app名
@property (nonatomic, strong) NSString *albumName;

// 检查相册权限
@property (nonatomic, assign) BOOL authorizationStatusCheck;

@end

NS_ASSUME_NONNULL_END
