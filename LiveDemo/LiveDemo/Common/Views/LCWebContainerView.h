//
//  LCWebContainerView.h
//  LCHeadlines
//
//  Created by mrgao on 2019/12/10.
//  Copyright © 2019 WY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol LCWebContainerViewDelegate <NSObject>

@optional
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;
- (WKWebView*)webView:(WKWebView*)webView createWebViewWithConfiguration:(WKWebViewConfiguration*)configuration forNavigationAction:(WKNavigationAction*)navigationAction windowFeatures:(WKWindowFeatures*)windowFeatures;
@end
@interface LCWebContainerView : UIView
@property(nonatomic, strong,readonly) WKWebView *webView;
@property(nonatomic, weak)id<LCWebContainerViewDelegate> webContainerDelegate;

//进度条progress block
@property(nonatomic, copy) void (^webViewUpdateProgress)(LCWebContainerView *webView, double progress);

//配合JavaScriptWebViewBridge
@property(weak, nonatomic)id<WKNavigationDelegate> wkWebViewBridgeDelegate;

- (void)loadRequestUrlString:(NSString *)urlString;

- (void)loadRequestUrl:(NSURL *)url;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHtmlString:(NSString *)htmlStr;

- (void)captureImageCompletionHandler:(void (^)(UIImage *capturedImage))completionHandler;
@end

NS_ASSUME_NONNULL_END
