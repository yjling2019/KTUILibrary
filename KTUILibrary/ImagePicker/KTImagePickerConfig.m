//
//  KTImagePickerConfig.m
//  KTFoundation
//
//  Created by KOTU on 2022/8/29.
//

#import "KTImagePickerConfig.h"

@implementation KTImagePickerConfig

- (instancetype)init
{
	self = [super init];
	if (self) {
		_selectionLimit = 0;
		_mode = KTImagePickerModeCamera | KTImagePickerModeLibrary;
	}
	return self;
}

@end
