//
//  KTTabBarBaseModel.m
//  VOVA
//
//  Created by KOTU on 2020/3/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KTTabBarBaseModel.h"
#import "KTTabBarBaseButton.h"

NSString * const kKTTabBarSchemeKey = @"vvfile";

@interface KTTabBarBaseModel ()

@property (nonatomic, strong) NSURL *lastURL;

@end

@implementation KTTabBarBaseModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@synthesize className = _className;

+ (instancetype)imageTypeLot:(NSURL *)lottie
{
    __kindof KTTabBarBaseModel *model = [[self alloc] init];
    model.imageType = KTTabBarImageTypeLot;
    model.lottieURL = lottie;
    return model;
}

+ (instancetype)imageTypeImage:(NSURL *)img
                 selectedImage:(NSURL *)selectedImg
{
    __kindof KTTabBarBaseModel *model = [[self alloc] init];
    model.imageType = KTTabBarImageTypeImage;
    model.imgURL = img;
    model.selectedImgURL = selectedImg;
    return model;
}

+ (instancetype)imageTypeGif:(NSURL *)gif
             selectedGifName:(nullable NSURL *)selectedGif
{
    __kindof KTTabBarBaseModel *model = [[self alloc] init];
    model.imageType = KTTabBarImageTypeGif;
    model.gifURL = gif;
    model.selectedGifURL = selectedGif;
    return model;
}

- (Class)className
{
    return [KTTabBarBaseButton class];
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
