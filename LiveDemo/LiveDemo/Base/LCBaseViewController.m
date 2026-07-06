//
//  LCBaseViewController.m
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import "LCBaseViewController.h"
#import "LCLoginViewController.h"
#import "LCLoginView.h"
#import "LCLoginByUserNameViewController.h"
@interface LCBaseViewController ()<LCBaseNavigationViewDelegate>
@property (nonatomic , assign) BOOL hasJumpLogin;
@property (nonatomic , weak) LCLoginView *loginView;
@end

@implementation LCBaseViewController
@synthesize needHiddenInteractivePopGestureRecognizer = _needHiddenInteractivePopGestureRecognizer;
@synthesize loadingAnimationView = _loadingAnimationView;
@synthesize emptyDataView = _emptyDataView;
@synthesize disconnectView = _disconnectView;
@synthesize navView = _navView;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    LCBaseViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController lc_addSubviews];
        [viewController lc_bindViewModel];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController lc_updatePageNewData];
        [viewController lc_updatePageViews];
    }];
    
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color(@"#F5F8FC");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"quitLogin" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        if(!weakSelf.hasJumpLogin){
            [[LCUserInfoManager shareManager] clearUserInfo];
            if(![NSStringFromClass([weakSelf class]) isEqualToString:@"LCLoginViewController"]){
                if(!weakSelf.loginView){
                    LCLoginView *loginView = [[LCLoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    loginView.loginClickBlock = ^{
                        [UIAlertController showActionSheetInViewController:self withTitle:KLanguage(@"选择登录/注册方式") message:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[KLanguage(@"手机登录/注册"),KLanguage(@"账户登录/注册")] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                            
                        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                            if([action.title isEqualToString:KLanguage(@"手机登录/注册")]){
                                
                                LCLoginViewController *con = [LCLoginViewController new];
                                  [weakSelf pushToViewController:con];
                            }else if ([action.title isEqualToString:KLanguage(@"账户登录/注册")]){
                                LCLoginByUserNameViewController *con = [LCLoginByUserNameViewController new];
                                [weakSelf pushToViewController:con];
                            }
                        }];
                       
                    };
                    [weakSelf.view.window addSubview:loginView];
                    weakSelf.loginView = loginView;
                }
            }
        }
        
        
    }];
}
- (void)popBack{
    if (self.isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)pushToViewController:(UIViewController *)vc {
    [self pushToViewController:vc animation:YES];
}

- (void)pushToViewController:(UIViewController *)vc animation:(BOOL)animition {
    vc.hidesBottomBarWhenPushed = YES;
//    if ([self.navigationController.tabBarController isKindOfClass:NSClassFromString(@"TTCusTomTabbarViewController")]) {
//        TTCusTomTabbarViewController *tabCon = (TTCusTomTabbarViewController *)self.navigationController.tabBarController;
//        tabCon.tabBar.hidden = YES;
//    }

    [self.navigationController pushViewController:vc animated:animition];
}
#pragma mark----LCBaseNavigationViewDelegate----
- (void)leftButtonClicked{
    [self popBack];
}
- (void)rightButtonClicked{
    
}
#pragma mark----子类实现----
/// 绑定viewmodel
- (void)lc_bindViewModel{
    
}

/// 添加子View
- (void)lc_addSubviews{
    self.view.backgroundColor = Color(@"#F7F7F7");
}

/// viewWillAppear时刷新数据
- (void)lc_updatePageNewData{
    
}

/// viewWillAppear时刷新View
- (void)lc_updatePageViews{
    
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}
#pragma mark----懒加载----
- (LCBaseNavigationView *)navView{
    if (_navView == nil) {
        LCBaseNavigationView *view = [[LCBaseNavigationView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0) title:@"" leftType:LCBaseNavigationViewLeftType_None rightType:LCBaseNavigationViewRightType_None];
        _navView = view;
        _navView.delegate = self;
        [self.view addSubview:_navView];
    }
    return _navView;
}
- (LCLoadingView *)loadingAnimationView{
    if (_loadingAnimationView == nil) {
        LCLoadingView *view = [[LCLoadingView alloc]initWithFrame:self.view.bounds];
        _loadingAnimationView = view;
        [self.view addSubview:_loadingAnimationView];
    }
    return _loadingAnimationView;
}
- (LCNoDataView *)emptyDataView{
    if (_emptyDataView == nil) {
        LCNoDataView *view = [[LCNoDataView alloc]initWithFrame:self.view.bounds];
        _emptyDataView = view;
        _emptyDataView.hidden = YES;
        [self.view addSubview:_emptyDataView];
    }
    return _emptyDataView;
}
- (LCNoNetworkView *)disconnectView{
    if (_disconnectView == nil) {
        LCNoNetworkView *view = [[LCNoNetworkView alloc]initWithFrame:self.view.bounds];
        _disconnectView = view;
        _disconnectView.hidden = YES;
        [self.view addSubview:_disconnectView];
    }
    return _disconnectView;
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
