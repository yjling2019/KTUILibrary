//
//  KTImageSaver.m
//  KTFoundation
//
//  Created by KOTU on 2022/10/10.
//

#import "KTImageSaver.h"
#import <Photos/Photos.h>
#import <KTFoundation/KTFoundationCategory.h>

@implementation KTImageSaver

+ (void)saveImageWithConfigurationBlock:(void(^ __nullable)(KTImageSaverConfig *config))configurationBlock
						completionBlock:(void(^ __nullable)(BOOL success, NSError * _Nullable error))completionBlock
{
	if (!configurationBlock) {
		if (completionBlock) {
			completionBlock(YES, nil);
		}
		return;
	}
	
	KTImageSaverConfig *config = KTImageSaverConfig.new;
	configurationBlock(config);
	
	NSMutableArray *images = [NSMutableArray arrayWithArray:config.images];
	if (!images.count && config.image) {
		[images addObject:config.image];
	}
	
	if (!images.count) {
		if (completionBlock) {
			completionBlock(YES, nil);
		}
		return;
	}
	
	if (config.authorizationStatusCheck) {
		if (@available(iOS 14, *)) {
			PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
			if (status == PHAuthorizationStatusNotDetermined) {
				[PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly
														   handler:^(PHAuthorizationStatus status) {
					dispatch_async(dispatch_get_main_queue(), ^{
						if (status == PHAuthorizationStatusAuthorized) {
							[self saveImages:images withConfig:config completion:completionBlock];
						} else if (status == PHAuthorizationStatusDenied) {
							[self showAccessAlert];
						}
					});
				}];
			} else if (status == PHAuthorizationStatusAuthorized) {
				[self saveImages:images withConfig:config completion:completionBlock];
			} else if (status == PHAuthorizationStatusDenied) {
				[self showAccessAlert];
			} else {
			}
		} else {
			PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
			if (status == PHAuthorizationStatusNotDetermined) {
				[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
					dispatch_async(dispatch_get_main_queue(), ^{
						if (status == PHAuthorizationStatusAuthorized) {
							[self saveImages:images withConfig:config completion:completionBlock];
						} else if (status == PHAuthorizationStatusDenied) {
							[self showAccessAlert];
						}
					});
				}];
			} else if (status == PHAuthorizationStatusAuthorized) {
				[self saveImages:images withConfig:config completion:completionBlock];
			} else if (status == PHAuthorizationStatusDenied) {
				[self showAccessAlert];
			} else {
			}
		}
	} else {
		[self saveImages:images withConfig:config completion:completionBlock];
	}
}

+ (void)saveImages:(NSArray *)images
		withConfig:(KTImageSaverConfig *)config
		completion:(void(^ __nullable)(BOOL success, NSError * _Nullable error))completionBlock
{
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		
		PHAssetCollectionChangeRequest *assetCollectionChangeRequest;

		if (config.saveToCustomAlbum) {
			NSString *albumName = config.albumName;
			if (!albumName) {
				NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
				albumName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
			}
			
			PHAssetCollection *assetCollection = [self fetchAssetColletion:albumName];

			if (assetCollection) {
			   assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
			} else {
			   assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
			}
		}
	
		NSMutableArray *assetChangeRequests = NSMutableArray.new;
		for (UIImage *image in images) {
			PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
			[assetChangeRequests addObject:assetChangeRequest];
		}
		
		if (assetCollectionChangeRequest) {
			NSMutableArray *assets = NSMutableArray.array;
			for (PHAssetChangeRequest * assetChangeRequest in assetChangeRequests) {
				[assets addObject:[assetChangeRequest placeholderForCreatedAsset]];
			}
			[assetCollectionChangeRequest addAssets:assets];
		}
		
	} completionHandler:^(BOOL success, NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (completionBlock) {
				completionBlock(success, error);
			}
		});
	}];
}

+ (PHAssetCollection *)fetchAssetColletion:(NSString *)albumTitle
{
	// 获取所有的相册
	PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
	//遍历相册数组,是否已创建该相册
	for (PHAssetCollection *assetCollection in result) {
		if ([assetCollection.localizedTitle isEqualToString:albumTitle]) {
			return assetCollection;
		}
	}
	
	return nil;
}

+ (void)showAccessAlert
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
	
	NSString *title = @"无法保存";
	NSString *msg = [NSString stringWithFormat:@"请在iPhone的\"设置-%@-照片\"选项中，允许%@访问你的照片。", appName, appName];
	
	UIAlertController *vc = [UIAlertController kt_alertWithTitle:title message:msg];
	[vc kt_addButtonWithTitle:@"去设置" action:^(UIAlertAction * _Nonnull action) {
		NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
		[[UIApplication sharedApplication] openURL:url];
	}];
	[vc kt_addCancelButtonWithTitle:@"取消" action:nil];
	[UIWindow.kt_currentViewController presentViewController:vc animated:YES completion:nil];
}

@end
