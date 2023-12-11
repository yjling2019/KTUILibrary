//
//  KTWebViewControllerHelpProtocol.h
//  vv_webview_ios
//
//  Created by KOTU on 2020/8/17.
//

#import <Foundation/Foundation.h>

@class KTWebContainerViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol KTWebViewControllerHelpProtocol <NSObject>

/// 进度条颜色
@property (nonatomic, strong) UIColor *progressTintColor;
/// title需要被替换的字符串
@property (nonatomic, copy) NSString *titleReplacingString;

@optional

- (void)alertPanelWithMessage:(NSString *)message
               viewController:(KTWebContainerViewController *)viewController;

- (void)confirmPanelWithMessage:(NSString *)message
                 viewController:(KTWebContainerViewController *)viewController
              completionHandler:(void (^)(BOOL))completionHandler;

- (void)addAllScriptMessageHandler:(KTWebContainerViewController *)viewController;

- (void)removeAllScriptMessageHandler:(KTWebContainerViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
