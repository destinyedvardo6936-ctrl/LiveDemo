//
//  LCCommonWebViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCCommonWebViewController.h"
#import <WebKit/WebKit.h>
@interface LCCommonWebViewController ()<WKNavigationDelegate>
@property (nonatomic , weak) WKWebView *webView;

@end

@implementation LCCommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:self.titleStr.length?self.titleStr:@""];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}
#pragma mark --> WKWebView的代理方法

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
   
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
   
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
  
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
   
}

#pragma mark---- 懒加载 ----
- (WKWebView *)webView{
    if(_webView == nil){
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        //音频自动播放
        configuration.allowsInlineMediaPlayback = YES;
        configuration.mediaPlaybackRequiresUserAction = false;
        configuration.processPool = [[WKProcessPool alloc] init];
   
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
        configuration.userContentController = userContentController;
        if ([configuration respondsToSelector:@selector(setDataDetectorTypes:)]) {
            configuration.dataDetectorTypes = UIDataDetectorTypeNone;
        }


        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
//        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        
        if (@available
        (iOS
        11.0, *)) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

//        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

        _webView = webView;
        [self.view addSubview:_webView];
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
    }
    return _webView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
