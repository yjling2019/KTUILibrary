//
//  KTWebContainerViewController.h
//  KOTU
//
//  Created by KOTU on 2019/4/23.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "KTWebViewControllerHelpProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 网页容器基类
 */
@interface KTWebContainerViewController : UIViewController

/**
 控制页面返回逻辑
 */
@property (nonatomic, copy) BOOL (^navigationBackInterceptBlock) (void);

/**
 控制页面跳转逻辑
 */
@property (nonatomic, copy) BOOL (^webviewNavigationIntercept) (NSString *url);

@property (copy, nonatomic) NSString *urlString;

@property (copy, nonatomic, readonly) NSString *titleString;

@property (copy, nonatomic) NSString *htmlString;

#pragma mark - 初始化
// 跳转第三方网站
- (instancetype)initWithThirdPartURL:(NSString *)URL title:(nullable NSString *)title;

// 使用HTMLString
- (instancetype)initWithHTMLString:(NSString *)HTMLString title:(nullable NSString *)title;

//使用完整的url进行跳转。仅供子类使用，外部不要使用！！！
- (instancetype)initWithCompleteURL:(NSString *)URL title:(nullable NSString *)title;

#pragma mark - webview 配置

@property (strong, nonatomic, readonly) WKWebView *webView;

/**
 VC的webview配置方法
 */
- (void)configWebView;

/**
 给H5添加cookie
 */
- (void)configWebViewCookies:(nonnull NSDictionary *)cookieDic forKey:(NSString *)key;

#pragma mark - webView状态回调
@property (nonatomic, copy) void (^redirectAction)(WKWebView *webView);

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

#pragma mark - 设置help
+ (void)setUpHelp:(id<KTWebViewControllerHelpProtocol>)help;

@end

NS_ASSUME_NONNULL_END
