//
//  KTImagePicker.m
//  KTFoundation
//
//  Created by KOTU on 2022/8/29.
//

#import "KTImagePicker.h"
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <KTFoundation/KTMacros.h>
#import <KTFoundation/UIWindow+KTHelp.h>
#import <KTFoundation/UIAlertController+KTHelp.h>
#import <UniformTypeIdentifiers/UTCoreTypes.h>

static KTImagePicker *ktImagePicker;

@interface KTImagePicker () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate>

@property (nonatomic, strong) KTImagePicker *picker;

@property (nonatomic, strong) KTImagePickerConfig *config;
@property (nonatomic, strong) void(^completionBlock)(KTImagePickerResult *result);

@end

@implementation KTImagePicker

+ (void)showPickerWithConfigurationBlock:(void(^)(KTImagePickerConfig *config))configurationBlock
						 completionBlock:(void(^)(KTImagePickerResult *result))completionBlock
{
	KTImagePicker *picker = KTImagePicker.new;
	picker.picker = picker;
	
	if (configurationBlock) {
		configurationBlock(picker.config);
	}
	picker.completionBlock = completionBlock;
	[picker prepare];
}

- (void)prepare
{
	[self showSelectionActionSheet];
}

- (void)free
{
	self.picker = nil;
}

#pragma mark - action sheet
- (void)showSelectionActionSheet
{
	UIAlertController *vc = [UIAlertController kt_actionSheetWithTitle:nil];
	if (self.config.mode & KTImagePickerModeCamera) {
		@weakify(self);
		[vc kt_addButtonWithTitle:@"拍照" action:^(UIAlertAction * _Nonnull action) {
			@strongify(self);
			[self showCamereView];
		}];
	}
	
	if (self.config.mode & KTImagePickerModeLibrary) {
		@weakify(self);
		[vc kt_addButtonWithTitle:@"从手机相册选择" action:^(UIAlertAction * _Nonnull action) {
			@strongify(self);
			if (@available(iOS 14.0, *)) {
				[self showPhotoPicker];
			} else {
				[self showPhotoLibrary];
			}
		}];
	}
	
	[vc kt_addCancelButtonWithTitle:@"取消" action:nil];
	[UIWindow.kt_currentViewController presentViewController:vc animated:YES completion:nil];
}

- (void)showCamereView
{
	UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
	// 设置资源来源（相册、相机、图库之一）
	imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
	imagePickerVC.mediaTypes = @[(NSString *)kUTTypeImage];
	// 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
	imagePickerVC.delegate = self;
	// 是否允许编辑（YES：图片选择完成进入编辑模式）
	imagePickerVC.allowsEditing = YES;
	[UIWindow.kt_currentViewController presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)showPhotoLibrary
{
	UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
	// 设置资源来源（相册、相机、图库之一）
	imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerVC.mediaTypes = @[(NSString *)kUTTypeImage];
	// 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
	imagePickerVC.delegate = self;
	// 是否允许编辑（YES：图片选择完成进入编辑模式）
	imagePickerVC.allowsEditing = YES;
	[UIWindow.kt_currentViewController presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)showPhotoPicker
{
	if (@available(iOS 14.0, *)) {
		PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
		config.selectionLimit = self.config.selectionLimit;
		config.filter = [PHPickerFilter imagesFilter];
		config.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeCurrent;

		PHPickerViewController *imagePickerVC = [[PHPickerViewController alloc] initWithConfiguration:config];
		imagePickerVC.delegate = self;
		[UIWindow.kt_currentViewController presentViewController:imagePickerVC animated:YES completion:nil];
	}
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{	
	[picker dismissViewControllerAnimated:YES completion:nil];

	UIImage *image = info[UIImagePickerControllerEditedImage];
	if (!image) {
		image = info[UIImagePickerControllerOriginalImage];
	}
	
	if (image && self.completionBlock) {
		KTImagePickerResult *rs = KTImagePickerResult.new;
		rs.images = @[image];
		self.completionBlock(rs);
	}

	[self free];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self free];
}

#pragma mark - PHPickerViewControllerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14))
{
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	__block NSString *errorMsg;
	dispatch_group_t group = dispatch_group_create();
	
	NSMutableArray *images = [NSMutableArray array];
	for (PHPickerResult *result in results) {
		if ([result.itemProvider canLoadObjectOfClass:UIImage.class]) {
			dispatch_group_enter(group);
			[result.itemProvider loadObjectOfClass:[UIImage class]
								 completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
				if (error) {
					errorMsg = error.localizedDescription;
				} else if ([object isKindOfClass:[UIImage class]]) {
					[images addObject:object];
				}
				dispatch_group_leave(group);
			}];
		} else {
			NSArray *supportedRepresentations = @[[UTTypeRAWImage identifier],
												  [UTTypeTIFF identifier],
												  [UTTypeBMP identifier],
												  [UTTypePNG identifier],
												  [UTTypeJPEG identifier],
												  [UTTypeWebP identifier],
												  [UTTypeHEIC identifier],
												  [UTTypeHEIF identifier],
												];
			
			for (NSString *representation in supportedRepresentations) {
				if ([result.itemProvider hasItemConformingToTypeIdentifier:representation]) {
					dispatch_group_enter(group);
					[result.itemProvider loadDataRepresentationForTypeIdentifier:[UTTypeWebP identifier] completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
						if (error) {
							errorMsg = error.localizedDescription;
						} else {
							UIImage *image = [UIImage imageWithData:data];
							if (image) {
								[images addObject:image];
							}
						}
						dispatch_group_leave(group);
					}];
				}
			}
		}
	}
	
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		KTImagePickerResult *rs = KTImagePickerResult.new;
		rs.images = images;
		rs.errorMsg = errorMsg;
		self.completionBlock(rs);
		[self free];
	});
}

#pragma mark - lazy load
- (KTImagePickerConfig *)config
{
	if (!_config) {
		_config = KTImagePickerConfig.new;
	}
	return _config;
}

@end
