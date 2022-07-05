//
//  KTWebContainerViewController.m
//  KOTU
//
//  Created by KOTU on 2019/4/23.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "KTWebContainerViewController.h"
#import <Masonry/Masonry.h>

static id<KTWebViewControllerHelpProtocol> globalHelp = nil;

@interface KTWebContainerViewController () <WKNavigationDelegate, WKUIDelegate>

@property (copy, nonatomic) NSString *titleString;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation KTWebContainerViewController

#pragma mark - 设置help
+ (void)setUpHelp:(id<KTWebViewControllerHelpProtocol>)help
{
	globalHelp = help;
}

#pragma mark - 初始化
//跳转第三方网站
- (instancetype)initWithThirdPartURL:(NSString *)URL title:(NSString *)title
{
    return [self initWithCompleteURL:URL title:title];
}

// 自定义使用链接前缀
- (instancetype)initWithCompleteURL:(NSString *)URL title:(NSString *)title
{
    if (self = [super init]) {
        self.urlString = URL;
        self.titleString = title;
    }
    return self;
}

//使用HTMLString
- (instancetype)initWithHTMLString:(NSString *)HTMLString title:(NSString *)title
{
    if (self = [super init]) {
        self.htmlString = HTMLString;
        self.titleString = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWebView];
    [self configWebView];
    [self configureProgressView];
}

#pragma mark - 初始化webview
- (void)initWebView
{
	//js脚本
	NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
	//注入
	WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
	WKUserContentController *wkUController = [[WKUserContentController alloc] init];
	[wkUController addUserScript:wkUScript];
	
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
	conf.userContentController = wkUController;
    //设置是否将数据加载如内存后渲染界面
    conf.suppressesIncrementalRendering = NO;
    if ([conf respondsToSelector:@selector(setWebsiteDataStore:)]) {
        conf.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    }
//    conf.applicationNameForUserAgent = VVUserAgentTool.fullCustomAgentString;
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:conf];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

// 配置webview
- (void)configWebView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if (self.urlString) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
        [self.webView loadRequest:request];
    } else if (self.htmlString) {
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    }
}

// 加载进度条
- (void)configureProgressView
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1.5)];
    if ([globalHelp respondsToSelector:@selector(progressTintColor)]) {
        UIColor *progressTintColor = globalHelp.progressTintColor;
#if DEBUG
        NSAssert(progressTintColor, @"需要设置进度条颜色");
#endif
		self.progressView.progressTintColor = progressTintColor;
    }
    [self.webView addSubview:self.progressView];
}

#pragma mark - 给H5添加cookie
- (void)configWebViewCookies:(nonnull NSDictionary *)cookieDic forKey:(NSString *)key
{
#if DEBUG
    NSAssert(cookieDic && key, @"webview设置cookie，key和cookie不能为空");
    NSAssert(self.webView, @"webview未初始化");
#endif
    if (![cookieDic isKindOfClass:NSDictionary.class]) {
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cookieDic options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!myString) {
        return;
    }
    NSString *cookieValue = [NSString stringWithFormat:@"document.cookie = '%@=%@';", key, myString];
    WKUserScript *cookieScript = [[WKUserScript alloc]
                                  initWithSource:cookieValue
                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:cookieScript];
}

#pragma mark - WKNavigationDelegatesetUpHelp
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    // 网页由于某些原因加载失败
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    if (error.code == NSURLErrorNotConnectedToInternet) {
//        [self webViewNetWorkError];
        return;
    }
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    // 网页开始接收网页内容
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler
{
    if (!completionHandler) {
        return;
    }
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

//网页跳转方法
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (!decisionHandler) {
        return;
    }
    if (self.webviewNavigationIntercept) {
        BOOL canNav = self.webviewNavigationIntercept(navigationAction.request.URL.absoluteString);
        if (!canNav) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    if (self.redirectAction) {
        self.redirectAction(webView);
    }
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    if ([globalHelp respondsToSelector:@selector(alertPanelWithMessage:viewController:)]) {
        [globalHelp alertPanelWithMessage:message viewController:self];
    }
    if (completionHandler) {
        completionHandler();
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    if ([globalHelp respondsToSelector:@selector(confirmPanelWithMessage:viewController:completionHandler:)]) {
        [globalHelp confirmPanelWithMessage:message viewController:self completionHandler:completionHandler];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            self.progressView.hidden = YES;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 标题处理
- (NSString *)parsingTitle:(NSString *)title
{
    if (!title) {
        return nil;
    }
	
    NSString *string = @"";
    if ([globalHelp respondsToSelector:@selector(titleReplacingString)]) {
        string = globalHelp.titleReplacingString;
        if (!string) {
            string = @"";
        }
        
    }
    NSString *r = [title stringByReplacingOccurrencesOfString:string
                                                   withString:@""
                                                      options:NSCaseInsensitiveSearch | NSRegularExpressionSearch
                                                        range:NSMakeRange(0, title.length)];
    NSString *t = [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (t.length > 18) {
        // maximum 18 characters.
        return [[t substringToIndex:15] stringByAppendingString:@"..."];
    } else {
        return t;
    }
}

#pragma mark - dealloc
- (void)dealloc
{
	[_webView removeObserver:self forKeyPath:@"estimatedProgress"];
	_webView.scrollView.delegate = nil;
	if (_webView.loading) {
		[_webView stopLoading];
	}
	_webView.navigationDelegate = nil;
	_webView.UIDelegate = nil;
}

@end
