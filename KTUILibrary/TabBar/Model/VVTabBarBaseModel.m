//
//  VVTabBarBaseModel.m
//  VOVA
//
//  Created by fwzhou on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "VVTabBarBaseModel.h"
#import "VVTabBarBaseButton.h"

NSString * const kVVTabBarSchemeKey = @"vvfile";

@interface VVTabBarBaseModel ()

@property (nonatomic, strong) NSURL *lastURL;

@end

@implementation VVTabBarBaseModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@synthesize className = _className;

+ (instancetype)imageTypeLot:(NSURL *)lottie
{
    __kindof VVTabBarBaseModel *model = [[self alloc] init];
    model.imageType = VVTabBarImageTypeLot;
    model.lottieURL = lottie;
    return model;
}

+ (instancetype)imageTypeImage:(NSURL *)img
                 selectedImage:(NSURL *)selectedImg
{
    __kindof VVTabBarBaseModel *model = [[self alloc] init];
    model.imageType = VVTabBarImageTypeImage;
    model.imgURL = img;
    model.selectedImgURL = selectedImg;
    return model;
}

+ (instancetype)imageTypeGif:(NSURL *)gif
             selectedGifName:(nullable NSURL *)selectedGif
{
    __kindof VVTabBarBaseModel *model = [[self alloc] init];
    model.imageType = VVTabBarImageTypeGif;
    model.gifURL = gif;
    model.selectedGifURL = selectedGif;
    return model;
}

- (Class)className
{
    return [VVTabBarBaseButton class];
}

- (void)setClassName:(Class)className
{
    _className = className;
}

- (BOOL)isNeedUpdate:(NSURL *)URL
{
    BOOL need = ![self.lastURL.absoluteString isEqualToString:URL.absoluteString];
    self.lastURL = URL;
    return need;
}

@end
