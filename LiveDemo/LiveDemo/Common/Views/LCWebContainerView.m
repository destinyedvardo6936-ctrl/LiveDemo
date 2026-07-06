//
//  LCWebContainerView.m
//  LCHeadlines
//
//  Created by mrgao on 2019/12/10.
//  Copyright © 2019 WY. All rights reserved.
//

#import "LCWebContainerView.h"

#import "NSString+LCHash.h"
@interface LCWebContainerView ()<WKUIDelegate, WKNavigationDelegate>
//加载进度
@property(nonatomic, assign) double estimatedProgress;
//当前request
@property(nonatomic, strong) NSURLRequest *currentRequest;

@end

@implementation LCWebContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMyself];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initMyself];
    }
    return self;
}

- (void)initMyself {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.preferences = [[WKPreferences alloc] init];
    //音频自动播放
    configuration.allowsInlineMediaPlayback = YES;
    if (@available(iOS 10.0, *)) {
        configuration.mediaTypesRequiringUserActionForPlayback = false;
    } else {
        configuration.mediaPlaybackRequiresUserAction = false;
    }
    configuration.processPool = [[WKProcessPool alloc] init];

    configuration.preferences.javaScriptEnabled = YES;
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
//    configuration.suppressesIncrementalRendering = YES; // 是否支持记忆读取
       [configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        if (@available(iOS 10.0, *)) {
             [configuration setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
        }
//    [configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];

    configuration.userContentController = userContentController;
//    if ([configuration respondsToSelector:@selector(setDataDetectorTypes:)]) {
//        if (@available(iOS 10.0, *)) {
//            configuration.dataDetectorTypes = UIDataDetectorTypeNone;
//        } else {
//            // Fallback on earlier versions
//        }
//    }


    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    if (@available
    (iOS
    11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    _webView = webView;
//    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:_webView];
    self.backgroundColor = [UIColor whiteColor];

//    //监听UIWindow显示
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
//    //监听UIWindow隐藏
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
}

//- (void)beginFullScreen {
//
//}
//
//- (void)endFullScreen {
//    NSLog(@"退出全屏");
//    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
//}

- (void)loadRequestUrlString:(NSString *)urlString {
    if (urlString.length) {
//        urlString = [urlString stringByURLEncode];
        [self loadRequestUrl:[NSURL URLWithString:urlString]];
    }
}
- (void)loadHtmlString:(NSString *)htmlStr{
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}
- (void)loadRequestUrl:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    LCLog(@"网页加载链接:%@",url.absoluteString);
    
    [self.webView loadRequest:request];
//    NSHTTPURLResponse *cachedResopnse = [[TTWebViewCookiesManager shareManager] getCookieResponseForRequest:request];
//
//    NSDictionary *cachedHeaders = cachedResopnse.allHeaderFields;
//    //设置request headers (带上上次的请求头下面两参数一种就可以，也可以两个都带上)
//    if (cachedHeaders) {
////        NSString *etag = [cachedHeaders objectForKey:@"Etag"];
////        if (etag) {
////            [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
////        }
//        NSString *lastModified = cachedHeaders[@"Last-Modified"];
//        if (lastModified) {
//            [request setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
//        }
//    }
//
//
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        NSLog(@"httpResponse == %@", httpResponse);
//        // 根据statusCode设置缓存策略
//        if (httpResponse.statusCode == 304) {
//
//            [[TTWebViewCookiesManager shareManager] saveCookieResponse:httpResponse responseData:data withRequest:request];
//
//
//            [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
//        } else {
//            // 保存当前的NSHTTPURLResponse
//            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//
//
//        }
//        // 重新刷新
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.webView loadRequest:request];
//        });
//    }] resume];
}

- (void)loadRequest:(NSURLRequest *)request{
   
    LCLog(@"网页加载链接:%@",request.URL.absoluteString);
    
    [self.webView loadRequest:request];
}
- (void)layoutSubviews {
    [super layoutSubviews];

    self.webView.frame = self.bounds;
}

#pragma mark ---- 截长图----

- (void)captureImageCompletionHandler:(void (^)(UIImage *capturedImage))completionHandler {
 

    // 获取当前UIView可滚动的内容长度
    CGPoint scrollOffset = _webView.scrollView.contentOffset;

    // 向下取整数 － 可滚动长度与UIView本身屏幕边界坐标相差倍数
    float maxIndex = floorf(_webView.scrollView.contentSize.height / self.bounds.size.height);

    // 保持清晰度
    UIGraphicsBeginImageContextWithOptions(_webView.scrollView.contentSize, false, [UIScreen mainScreen].scale);

    // 滚动截图
    [self contentScrollPageDraw:0 maxIndex:(int) maxIndex drawCallback:^{
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // 恢复原UIView
        [_webView.scrollView setContentOffset:scrollOffset animated:NO];
//        [snapShotView removeFromSuperview];

        completionHandler(capturedImage);
    }];
}

// 滚动截图
- (void)contentScrollPageDraw:(int)index maxIndex:(int)maxIndex drawCallback:(void (^)(void))drawCallback {
    [_webView.scrollView setContentOffset:CGPointMake(0, (float) index * self.frame.size.height)];
    CGRect splitFrame = CGRectMake(0, (float) index * self.frame.size.height, self.bounds.size.width, self.bounds.size.height);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        if (index < maxIndex) {
            [self contentScrollPageDraw:index + 1 maxIndex:maxIndex drawCallback:drawCallback];
        } else {
            drawCallback();
        }
    });
}

#pragma mark --> WKWebView的代理方法

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    BOOL isLoadingDisableScheme = [self isLoadingWKWebViewDisableScheme:navigationAction.request.URL];

    if (!isLoadingDisableScheme) {
        self.currentRequest = navigationAction.request;
        if (self.wkWebViewBridgeDelegate && [self.wkWebViewBridgeDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
            [self.wkWebViewBridgeDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        } else if (self.webContainerDelegate && [self.webContainerDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
            [self.webContainerDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        } else {
            if (navigationAction.targetFrame == nil) {
                [webView loadRequest:navigationAction.request];
            }
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param webView The web view invoking the delegate method.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.wkWebViewBridgeDelegate && [self.wkWebViewBridgeDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.wkWebViewBridgeDelegate webView:webView didStartProvisionalNavigation:navigation];
    } else if (self.webContainerDelegate && [self.webContainerDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.webContainerDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    LCLog(@"网页链接加载完成:%@",webView.URL.absoluteString);
    if (self.wkWebViewBridgeDelegate && [self.wkWebViewBridgeDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.wkWebViewBridgeDelegate webView:webView didFinishNavigation:navigation];
    } else if (self.webContainerDelegate && [self.webContainerDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.webContainerDelegate webView:webView didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    LCLog(@"网页链接加载出错:%@ errror：%@",webView.URL.absoluteString,error);
    if (self.wkWebViewBridgeDelegate && [self.wkWebViewBridgeDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [self.wkWebViewBridgeDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    } else if (self.webContainerDelegate && [self.webContainerDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [self.webContainerDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.wkWebViewBridgeDelegate && [self.wkWebViewBridgeDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [self.wkWebViewBridgeDelegate webView:webView didFailNavigation:navigation withError:error];
    } else if (self.webContainerDelegate && [self.webContainerDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [self.webContainerDelegate webView:webView didFailNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [[self findViewController] presentViewController:alertController animated:YES completion:^{
    }];
}

- (WKWebView*)webView:(WKWebView*)webView createWebViewWithConfiguration:(WKWebViewConfiguration*)configuration forNavigationAction:(WKNavigationAction*)navigationAction windowFeatures:(WKWindowFeatures*)windowFeatures {

    if ([self.webContainerDelegate respondsToSelector:@selector(webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:)]) {
      return   [self.webContainerDelegate webView:webView createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
    }

    
    return nil;

}

#pragma mark- CALLBACK WebView Delegate

- (void)callback_webViewUpdateProgress:(float)progress {
    if (self.webViewUpdateProgress) {
        self.webViewUpdateProgress(self, progress);
    }
}

///判断当前加载的url是否是WKWebView不能打开的协议类型
- (BOOL)isLoadingWKWebViewDisableScheme:(NSURL *)url {
    BOOL retValue = NO;

    //判断是否正在加载WKWebview不能识别的协议类型：phone numbers, email address, maps, etc.
    if ([url.scheme isEqualToString:@"tel"]) {
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
            retValue = YES;
        }
    }

    return retValue;
}

#pragma mark WkWebView的progress 回调

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self callback_webViewUpdateProgress:self.estimatedProgress];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark- 清理

- (void)dealloc {
    self.webView.UIDelegate = nil;
    self.webView.navigationDelegate = nil;

    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

    [self.webView scrollView].delegate = nil;
    [self.webView stopLoading];
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    [self.webView removeFromSuperview];
    _webView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
