//
//  KTSaveImageVC.m
//  KTUILibrary_Example
//
//  Created by KOTU on 2022/10/10.
//  Copyright © 2022 KOTU. All rights reserved.
//

#import "KTSaveImageVC.h"
#import "KTImageSaver.h"

@interface KTSaveImageVC ()

@end

@implementation KTSaveImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 60, 40)];
	[button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = UIColor.redColor;
	[self.view addSubview:button];
}

- (void)click
{
	[KTImageSaver saveImageWithConfigurationBlock:^(KTImageSaverConfig * _Nonnull config) {
		config.image = [UIImage imageNamed:@"cart"];
		config.authorizationStatusCheck = YES;
	} completionBlock:^(BOOL success, NSError * _Nullable error) {
		
	}];
}

@end
