//
//  LCHomeViewController.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCHomeViewController.h"
#import <JXPagerListRefreshView.h>
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorImageView.h>
#import "LCHomeRecommendPageViewController.h"
#import "LCHomeSegmentsViewModel.h"
#import "LCRankViewController.h"
#import "LCHomeOtherLiveListViewController.h"
#import "LCHomeFollowLiveListController.h"
#import "LCHomeNearbyListViewController.h"
#import "LCLoginView.h"
#import "LCLoginViewController.h"
#import "LCSearchViewController.h"
#import "LCVideoPageViewController.h"
#import "LCLoginByUserNameViewController.h"
#import "LCShortVideoListPageViewController.h"
#import "LCVersionView.h"
#import "LCHomeADAlertApi.h"
#import "LCHomeAdAlertview.h"
#import "LCHomeWebAlertView.h"
#import "LCCommonWebViewController.h"
@interface LCHomeViewController ()<UITextFieldDelegate,JXPagerViewDelegate,JXCategoryViewDelegate,JXCategoryTitleViewDataSource>

@property (nonatomic , strong) LCHomeSegmentsViewModel *viewModel;
@property (nonatomic , weak) JXPagerListRefreshView *pagerView;
@property (nonatomic , weak) JXCategoryTitleView *segmentControl;
@property (nonatomic , weak) LCLoginView *loginView;
@property (nonatomic , strong) LCVersionView *versionView;
@property (nonatomic , strong) LCHomeAdAlertview *adAlertView;
@property (nonatomic , strong) LCHomeWebAlertView *adWebAlertView;
@end

@implementation LCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    UIButton *rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
 
    rankBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rankBtn setImage:[UIImage imageNamed:@"icon_homeRank"] forState:UIControlStateNormal];
    [rankBtn addTarget:self action:@selector(rankBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:rankBtn];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
 
    searchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [searchBtn setImage:[UIImage imageNamed:@"icon_homeSearch"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:searchBtn];
    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - kUI_Width(26))/2.0);
        make.width.height.equalTo(kUI_Width(26));
    }];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rankBtn.mas_left).offset(-kUI_Width(20));
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - kUI_Width(26))/2.0);
        make.width.height.equalTo(kUI_Width(26));
    }];
  
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.height.equalTo(kUI_Width(20)+kUI_Width(4) *2);
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - (kUI_Width(20)+kUI_Width(4) *2))/2.0);
        make.right.mas_equalTo(searchBtn.mas_left);
    }];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
    self.segmentControl.titles = self.viewModel.channelDataArray;
    self.pagerView.defaultSelectedIndex = self.viewModel.currentIndex;
    self.segmentControl.defaultSelectedIndex = self.viewModel.currentIndex;
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameStatusNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        
        weakSelf.segmentControl.titles = weakSelf.viewModel.channelDataArray;
        weakSelf.pagerView.defaultSelectedIndex = self.viewModel.currentIndex;
        weakSelf.segmentControl.defaultSelectedIndex = self.viewModel.currentIndex;
        [weakSelf.segmentControl reloadData];
        [weakSelf.pagerView reloadData];
    }];
  
    
//    [self.segmentControl selectItemAtIndex:self.viewModel.currentIndex];
//    [self.pagerView reloadData];
}
- (void)getHomeAdAlert{
    WS(weakSelf)
    LCHomeADAlertApi *agentApi = [LCHomeADAlertApi new];
   
    [[LCNetWorkManager manager] requestApi:agentApi success:^(id  _Nullable result) {
        if([result isKindOfClass:NSDictionary.class]){
            NSDictionary *info = result[@"info"];
            NSMutableArray *tanchuangArr = [LCHomeAlertModel mj_objectArrayWithKeyValuesArray:info[@"tanchuang"]];
            
                if(!weakSelf.adAlertView && !weakSelf.loginView){
                    weakSelf.adAlertView = [[LCHomeAdAlertview alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    weakSelf.adAlertView.dataArray = tanchuangArr;
                    weakSelf.adAlertView.clickBlock = ^(LCHomeAlertModel * _Nonnull selectModel) {
                        LCCommonWebViewController *con = [LCCommonWebViewController new];
                        
                        con.url = selectModel.url;
                        [weakSelf pushToViewController:con];
                    };
                    weakSelf.adAlertView.closeBlock = ^{
                        if(!weakSelf.adWebAlertView){
                            weakSelf.adWebAlertView = [[LCHomeWebAlertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                            weakSelf.adWebAlertView.webText = info[@"tanchuang_text"];
                            [weakSelf.view.window addSubview:weakSelf.adWebAlertView];
                        }
                    };
                    [weakSelf.view.window addSubview:weakSelf.adAlertView];
                }
              
            
            
        }else{
            [SVProgressHUD showMaskViewWithFailure:KLanguage(@"请稍后再试")];
            
        }
       
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD showMaskViewWithFailure:error.domain];
    }];
}
- (void)checkAgent{
    WS(weakSelf)
    if([LCConfigManager shareManager].agentSwitch && ![LCConfigManager shareManager].hasAgent && [LCUserInfoManager shareManager].userInfo.ID.length){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:KLanguage(@"请填写邀请码") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:KLanguage(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alert.textFields[0];
            if(!textField.text.length){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(KLanguage(@"请填写邀请码"))];
                return;
            }
            [[LCConfigManager shareManager]addAgentWithCode:textField.text successBlock:^{
                            
                        } failedBlock:^(NSError * _Nonnull error) {
                            [SVProgressHUD showNoMaskViewWithFailure:error.domain];
                            [weakSelf checkAgent];
                        }];
        }];
        [alert addAction:confimAction];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = KLanguage(@"请填写邀请码");
        }];
        [weakSelf presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
}
- (void)lc_updatePageViews{
    
    [self.viewModel.versionCommand execute:@(YES)];
    if(![LCUserInfoManager shareManager].userInfo.token.length){
        WS(weakSelf)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
           
        });
    }else{
        [self checkAgent];
    }
    
}
- (void)lc_bindViewModel{
   
    @weakify(self)
    [[RACObserve(self.viewModel, currentIndex) takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        [self.segmentControl selectItemAtIndex:x.integerValue];
//        [self.pagerView reloadData];
    }];
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        self.segmentControl.titles = self.viewModel.channelDataArray;
        self.pagerView.defaultSelectedIndex = self.viewModel.currentIndex;
        self.segmentControl.defaultSelectedIndex = self.viewModel.currentIndex;
        [self.segmentControl reloadData];
        [self.pagerView reloadData];
        
    }];
    [[self.viewModel.versionSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if([x isKindOfClass:NSError.class]){
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];

        // 获取App的版本号
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        if(![self.viewModel.versionModel.version isEqualToString:appVersion]){
            if(!self.versionView){
                self.versionView = [[LCVersionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                self.versionView.updateClickBlock = ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.viewModel.versionModel.url] options:0 completionHandler:^(BOOL success) {
                        
                    }];
                };
                [self.view.window addSubview:self.versionView];
            }
            self.versionView.dataModel = self.viewModel.versionModel;
        }
        
        
    }];
    [self.viewModel.loadDataCommend execute:@(YES)];
    [self getHomeAdAlert];
    
}
#pragma mark ----按钮点击----
- (void)rankBtnClick{
    LCRankViewController *con = [LCRankViewController new];
    [self pushToViewController:con];
}
- (void)searchBtnClick{
    LCSearchViewController *con = [LCSearchViewController new];
    [self pushToViewController:con];
}
#pragma mark----JXPagerViewDelegate---

/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView{
   
    return  0 ;
}

/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView{
   
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
   
    return view;
}

/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    return 0;
//    return kUI_Width(22) ;
}

/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, 0)];
    view.backgroundColor = Color(@"#FFFFFF");

    return  view;
    
  
}

/**
 返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView{
    
    return self.segmentControl.titles.count;
}

/**
 根据index初始化一个对应列表实例，需要是遵从`JXPagerViewListViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
 注意：一定要是新生成的实例！！！

 @param pagerView pagerView description
 @param index index description
 @return 新生成的列表实例
 */
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index{
    NSString *channelName = self.viewModel.channelDataArray[index];
    if (index == 0){
        LCHomeFollowLiveListController *con = [[LCHomeFollowLiveListController alloc]init];
        return con;
    }else if(index == 1){
        LCHomeRecommendPageViewController *con = [[LCHomeRecommendPageViewController alloc]init];
        con.currentChannel = self.viewModel.channelDataArray[index];
        return con;
    }else if([channelName isEqualToString:KLanguage(@"短视频")]){
        LCShortVideoListPageViewController *con = [[LCShortVideoListPageViewController alloc]init];
        return con;
    }else if([channelName isEqualToString:KLanguage(@"视频")]){
        LCVideoPageViewController *con = [[LCVideoPageViewController alloc]init];
        return con;
    }else if ([channelName isEqualToString:KLanguage(@"附近")]){
        LCHomeNearbyListViewController *con = [[LCHomeNearbyListViewController alloc]init];
        return con;
    }
    else{
        LCHomeOtherLiveListViewController *con = [[LCHomeOtherLiveListViewController alloc]init];
        con.currentChannel = self.viewModel.channelDataArray[index];
        return con;
    }
    

    
    

    return nil;
}
#pragma mark----JXCategoryTitleViewDataSource----
// 如果将JXCategoryTitleView嵌套进UITableView的cell，每次重用的时候，JXCategoryTitleView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该代理方法返回给JXCategoryTitleView。
// 如果实现了该方法就以该方法返回的宽度为准，不触发内部默认的文字宽度计算。
- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title{

    return  [title sizeForFont:titleView.titleSelectedFont size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping].width;

}
#pragma mark - JXCategoryViewDelegate
//- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index{
//    if (self.isLoading ) {
//        return NO;
//    }
//    if (index == (self.viewModel.type - 1)) {
//        return NO;
//    }
//    return YES;
//}
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    self.isLoading = YES;
//   [self.viewModel.changeTypeCommand execute:@(index + 1)];
}


- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.segmentControl.collectionView.panGestureRecognizer) {
        return NO;
    }

    if ([otherGestureRecognizer.view.findViewController isKindOfClass:[UIPageViewController class]]) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}



#pragma mark---- 懒加载 ----
- (LCHomeSegmentsViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [LCHomeSegmentsViewModel new];
    }
    return _viewModel;
}



- (JXPagerListRefreshView *)pagerView{
    if (_pagerView == nil) {
        JXPagerListRefreshView *view = [[JXPagerListRefreshView alloc]initWithDelegate:self listContainerType:JXPagerListContainerType_CollectionView];
        _pagerView = view;
        _pagerView.automaticallyDisplayListVerticalScrollIndicator = NO;

        [self.view addSubview:_pagerView];
    }
    return _pagerView;
}
- (JXCategoryTitleView *)segmentControl{
    if (_segmentControl == nil) {
        JXCategoryTitleView *view = [[JXCategoryTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, kUI_Width(32))];
        _segmentControl = view;
        _segmentControl.tag = 200;
        _segmentControl.delegate = self;
//        _segmentControl.collectionView.scrollEnabled = NO;
        _segmentControl.titleDataSource = self;
        _segmentControl.contentEdgeInsetLeft = kUI_Width(kViewMargin);
        _segmentControl.contentEdgeInsetRight = kUI_Width(kViewMargin);
        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleCenter;
        _segmentControl.titleLabelVerticalOffset = -kUI_Width(3);
        _segmentControl.titleFont = RegularFont(16);
        _segmentControl.titleSelectedFont = BoldFont(20);
        _segmentControl.titleColor = Color(@"#999999");
        _segmentControl.titleSelectedColor = Color(@"#333333");
        _segmentControl.titleColorGradientEnabled = YES;

//        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
//        _segmentControl.titleLabelVerticalOffset = _segmentControl.titleSelectedFont.lineHeight- _segmentControl.titleFont.lineHeight - kUI_Width(6);
       
        _segmentControl.titleColorGradientEnabled = YES;
        _segmentControl.cellSpacing = kUI_Width(12);
                _segmentControl.averageCellSpacingEnabled = NO;
        JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
        lineView.indicatorImageView.image = image(@"icon_segmentLine");
        lineView.indicatorImageViewSize = CGSizeMake(kUI_Width(20), kUI_Width(4));
        lineView.indicatorWidth = kUI_Width(20) ;
        lineView.indicatorHeight = kUI_Width(4);

        lineView.indicatorCornerRadius =kUI_Width(4)/2.0;
        _segmentControl.indicators = @[lineView];
         
        _segmentControl.backgroundColor = [UIColor whiteColor];
//        [self.categoryBackView addSubview:_categoryView];
        _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
        [self.navView addSubview:_segmentControl];
//        _segmentControl.collectionView.scrollEnabled = NO;
        
    }
    return _segmentControl;
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
