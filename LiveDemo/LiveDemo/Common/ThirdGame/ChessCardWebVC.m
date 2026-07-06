//
//  ChessCardWebVC.m
//  yunbaolive
//
//  Created by 陶成堂 on 2020/5/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "ChessCardWebVC.h"
#import "QuotaConversionVC.h"
#import "AppDelegate.h"
#import "ChessCardView.h"
#import "MCAssistiveTouchGame.h"
#import <WebKit/WebKit.h>
#import "LCQuotaTransApi.h"

@interface ChessCardWebVC ()<WKNavigationDelegate>
{
    WKWebView *_webView;
    UIView *btmView;
}
@property (nonatomic,strong)ChessCardView *chessCardView;

@end

@implementation ChessCardWebVC


-(void)viewWillAppear:(BOOL)animated{
    [[MCAssistiveTouchGame sharedInstance] show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
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
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(0);
    }];
    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
//    webView = [[UIWebView alloc]init];
//    webView.frame = CGRectMake(0,0,SCREEN_WIDTH , SCREEN_HEIGHT);
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
//    [self.view addSubview:webView];

    [self creatUI];
}

-(void)creatUI{
    _chessCardView = [[ChessCardView alloc] init];
    [_chessCardView.cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [_chessCardView.sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    _chessCardView.banLab.text =_push;
    _chessCardView.secondTipLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"当前可转入额度"),self.coin];
    btmView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, kNavBarHeight, 200, 40)];
    [self.view addSubview:btmView];
    
    NSArray *nameArr =@[/*@"zhuanhuan",*/@"shouye",@"shuaxin",@"xiayiye"];
    for (int i =0; i<3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*50, 0, 40, 40)];
        [btn setImage:[UIImage imageNamed:nameArr[i]] forState:UIControlStateNormal];
        btn.tag=6000+i;
        [btn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
        [btmView addSubview:btn];
    }
    
    
    [[MCAssistiveTouchGame sharedInstance] setWindowTapBlock:^{

        [_chessCardView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            [_chessCardView removeFromSuperview];
            [[MCAssistiveTouchGame sharedInstance] dismiss];
            btmView.frame =  CGRectMake(SCREEN_WIDTH-150, kNavBarHeight, 200, 40);

        } completion:^(BOOL finished) {
        }];
    }];

    [self creatShareView];

}



-(void)clickCancel{
    [_chessCardView removeFromSuperview];
}


-(void)sureClick{
    [_chessCardView removeFromSuperview];

    LCQuotaTransApi *api = [LCQuotaTransApi new];
    api.biaoshi = self.biaoshi;
    api.action = @"0";
    api.amount = self.coin;
    [[LCNetWorkManager manager]requestApi:api success:^(id  _Nullable result) {
        [SVProgressHUD showNoMaskViewWithSuccess:result[@"msg"]];
        } failure:^(NSError * _Nullable error) {
            [SVProgressHUD showNoMaskViewWithFailure:error.domain];
        }];
//    QuotaConversionVC *quotaVC = [[QuotaConversionVC alloc]init];
//    [self pushToViewController:quotaVC];
}


-(void)creatShareView{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:_chessCardView];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.7;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.25f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_chessCardView.layer addAnimation:popAnimation forKey:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[MCAssistiveTouchGame sharedInstance] dismiss];
}


-(void)backClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)chooseClick:(UIButton *)sender{
    /*if (sender.tag == 6000) {
        btmView.frame = CGRectMake(SCREEN_WIDTH, kNavBarHeight, 200, 40);
        QuotaConversionVC *quotaVC = [[QuotaConversionVC alloc]init];
        [self pushToViewController:quotaVC];
    }else*/ if (sender.tag==6000){
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag==6001){
        [_webView reload];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            btmView.frame = CGRectMake(SCREEN_WIDTH,kNavBarHeight, 200, 40);
        } completion:^(BOOL finished) {
            [[MCAssistiveTouchGame sharedInstance] show];
        }];
    }
}
#pragma mark --> WKWebView的代理方法

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
   
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败：%@",error);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败：%@",error);
}


@end
