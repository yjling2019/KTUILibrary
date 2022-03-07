//
//  KTBarButtonItem.h
//  KOTU
//
//  Created by KOTU on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KTButtonBarButton;
@class KTBarButtonItem;

@protocol KTButtonBarButtonMatchProtocol <NSObject>

- (__kindof KTButtonBarButton *)itemGetButton;

@end

@interface KTBarButtonItem : NSObject <KTButtonBarButtonMatchProtocol>

/// 按钮标题
@property (nonatomic, strong, nullable) NSString *text;

/// 暗色个性化标题
@property (nonatomic, strong, nullable) NSAttributedString *darkAttrText;
/// 亮色个性化标题
@property (nonatomic, strong, nullable) NSAttributedString *lightAttrText;

/// 暗色图片
@property (nonatomic, strong, nullable) UIImage *darkImage;

/// 亮色图片
@property (nonatomic, strong, nullable) UIImage *lightImage;

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, weak) id target;

@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

- (instancetype)initWithText:(nullable NSString *)text
                   darkImage:(nullable UIImage *)darkImage
                  lightImage:(nullable UIImage *)lightImage
                      target:(nullable id)target
                      action:(nullable SEL)action;

/// 根据statusBarStyle得到的attributedString
- (NSAttributedString *)realityAttrText;

/// 根据statusBarStyle得到的image
- (UIImage *)realityImage;

@end

NS_ASSUME_NONNULL_END
