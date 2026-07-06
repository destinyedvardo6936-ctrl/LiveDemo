//
//  LCHomeSubViewController.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import <JXCategoryIndicatorBackgroundView.h>
#import "JXCategoryTitleBackgroundView.h"
#import "LCHomeLiveListViewController.h"
#import "LCHomeSubSegmentsViewModel.h"
#import "LCHomeRecommendPageViewController.h"
#import "LCRecommendLiveListViewController.h"
#import "LCShelterGradientView.h"
#import "LCTitleNoticeView.h"
#import <JXPagerListRefreshView.h>
#import "LCGameConfigManager.h"
#import "LCGameListModel.h"
#import "LCLiveViewController.h"
#import "LCHomeListModel.h"
#import "LCCommonWebViewController.h"
#import "LCBindPhoneViewController.h"
#import "LCLanguageManager.h"

@interface LCHomeRecommendPageViewController ()< JXPagerViewDelegate, JXCategoryViewDelegate,JXCategoryTitleViewDataSource>
@property (nonatomic, copy) void (^ scrollBlock)(UIScrollView *scrollView);
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *gameView;
@property (nonatomic, weak) UIView *noticeBackView;

@property (nonatomic, weak) UIView *replaceTopView;

@property (nonatomic, weak) LCTitleNoticeView *noticeView;

@property (nonatomic, strong) LCHomeSubSegmentsViewModel *viewModel;


@property (nonatomic, strong) UIScrollView *currentListView;
@property (nonatomic, weak) JXPagerListRefreshView *pagerView;

@property (nonatomic, weak) JXCategoryTitleBackgroundView *segmentControl;
@end

@implementation LCHomeRecommendPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)lc_addSubviews {
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
    }];
}

- (void)lc_bindViewModel {
    @weakify(self)
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameStatusNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        if([LCGameConfigManager shareManager].gameStatus){
            [weakSelf.viewModel.gameCommand execute:@(YES)];
        }
        
        
    }];
    [[self.viewModel.noticeSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.noticeView.dataArray = self.viewModel.noticeArray;
        [self.segmentControl reloadData];
       
        [self.pagerView reloadData];
       
        

    }];
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.segmentControl.titles = self.viewModel.channelTitleArray;
        [self.segmentControl reloadData];
       
        [self.pagerView reloadData];
       
        

    }];

    [[self.viewModel.gameSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        if ([x isKindOfClass:[NSError class]]) {
//            NSError *er = x;
//            [SVProgressHUD showErrorWithStatus:er.domain];
//            return;
//        }
        if(self.viewModel.gameArray.count){
            [self createGameView];
            
            [self.pagerView reloadData];
           
        }
       
            

    }];
    
    self.segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    [self.viewModel.loadDataCommend execute:@(YES)];
    [self.viewModel.noticeCommand execute:@(YES)];
    if ([LCGameConfigManager shareManager].gameStatus){
        [self.viewModel.gameCommand execute:@(YES)];
    }
    
}

- (void)createGameView {
    if (self.gameView.subviews) {
        [self.gameView removeAllSubviews];
    }

    CGFloat width = (self.view.width - kUI_Width(kViewMargin) * 2 - kUI_Width(8) * 4) / 5.0;

    for (NSInteger i = 0; i < self.viewModel.gameArray.count; i++) {
        LCHomeGameChannelModel *model = self.viewModel.gameArray[i];
        NSInteger col = i % 5;
        NSInteger row = i / 5;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = kUI_Width(30) / 2.0;
        btn.clipsToBounds = YES;
        [self.gameView addSubview:btn];
        btn.tag = i + 200;
        [btn addTarget:self action:@selector(gameChannelCLicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [imgView setImageStr:model.thumb ];
        imgView.userInteractionEnabled = YES;
        [btn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width);
            make.height.equalTo(kUI_Width(30));
            make.left.equalTo(kUI_Width(kViewMargin) + col * width + col * kUI_Width(8));
            make.top.equalTo(row * kUI_Width(30) + row * kUI_Width(8));
        }];
    }
}

- (void)gameChannelCLicked:(UIButton *)btn{
    LCHomeGameChannelModel *model = self.viewModel.gameArray[btn.tag-200];
    //1进入某个直播间；2跳转游戏webview；3跳转代理页面；4跳转活动页面
    if (model.type.intValue == 1) {
        id params = [model.param mj_JSONObject];
        if ([params isKindOfClass:NSDictionary.class]) {
            NSDictionary *dic = params;
            if (dic[@"list"] &&[dic[@"list"] isKindOfClass:NSArray.class]){
                [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"modelId":@"id"};
                }];
                [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"uid":@"uid"};
                }];
                NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
                
                LCLiveViewController *con = [LCLiveViewController new];
                NSMutableArray *temp = [NSMutableArray array];
               
                [temp addObjectsFromArray:arr];
                con.dataArray = temp;
                con.index = 0;
                [self pushToViewController:con];
            }else if (dic[@"list"] &&[dic[@"list"] isKindOfClass:NSDictionary.class]){
                [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"modelId":@"id"};
                }];
                [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"uid":@"uid"};
                }];
                LCHomeListModel *selectModel = [LCHomeListModel mj_objectWithKeyValues:dic[@"list"]];
                LCLiveViewController *con = [LCLiveViewController new];
                NSMutableArray *temp = [NSMutableArray array];
               
                [temp addObject:selectModel];
                con.dataArray = temp;
                con.index = 0;
                [self pushToViewController:con];
            }
            
        }else if ([params isKindOfClass:NSArray.class]){
            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"uid":@"uid"};
            }];
            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:params];
            
            LCLiveViewController *con = [LCLiveViewController new];
            NSMutableArray *temp = [NSMutableArray array];
           
            [temp addObjectsFromArray:arr];
            con.dataArray = temp;
            con.index = 0;
            [self pushToViewController:con];
        }
        
        
    }else if (model.type.intValue == 2){
        LCCommonWebViewController *con = [LCCommonWebViewController new];
        
        con.url = model.param;
        [self pushToViewController:con];
    }else if (model.type.intValue == 3){
        if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
            [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.destructiveButtonIndex){
                    LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                    [self pushToViewController:con];
                }
            }];
            return;
        }
        if([LCUserInfoManager shareManager].userInfo.isdaili.intValue == 0){
            [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"申请成为代理？") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.destructiveButtonIndex){
                    [SVProgressHUD show];
                    [self.viewModel.applyAgentCommand execute:@(YES)];
                }
            }];
        }else if ([LCUserInfoManager shareManager].userInfo.isdaili.intValue == 2){
            [SVProgressHUD showMaskViewWithInfo:KLanguage(@"申请在审核中")];
        }else if ([LCUserInfoManager shareManager].userInfo.isdaili.intValue == 1){
            LCCommonWebViewController *con = [LCCommonWebViewController new];
            LCMineUrlModel *model = nil;
            for (LCMineUrlModel *m in self.viewModel.urlModelArr) {
                if([m.modelId isEqualToString:@"31"]){
                    model = m;
                }
            }
            
            con.titleStr = model.name;
            con.url = [self addurl:model.href];
            [self pushToViewController:con];
        }
    }else if (model.type.intValue == 4){
        
    }
}
//所有h5需要拼接uid和token
-(NSString *)addurl:(NSString *)url{
    return [url stringByAppendingFormat:@"?uid=%@&token=%@&lang=%@",[LCUserInfoManager shareManager].userInfo.ID,[LCUserInfoManager shareManager].userInfo.token,[[LCLanguageManager shareManager]getLanguageEncode]];
}
#pragma mark----JXCategoryViewDelegate----
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if(index != 0){
        self.topView.hidden = YES;
        self.replaceTopView.hidden = NO;
    }


}
- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title{

    return  [title sizeForFont:titleView.titleSelectedFont size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping].width;

}
#pragma mark---- JXPagerViewListViewDelegate ----
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.pagerView.mainTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollBlock = callback;
}

- (void)listScrollViewWillResetContentOffset {
    //当前的listScrollView需要重置的时候，就把所有列表的contentOffset都重置了
    self.pagerView.mainTableView.contentOffset = CGPointZero;
//    for (LCBaseViewController *list in self.pagerView.validListDict.allValues) {
//        if ([list isKindOfClass:LCRecommendLiveListViewController.class]) {
//            LCRecommendLiveListViewController *con = (LCRecommendLiveListViewController *)list;
//            con.mainCollectionView.contentOffset = CGPointZero;
//        } else {
//            LCHomeLiveListViewController *con = (LCHomeLiveListViewController *)list;
//            con.mainCollectionView.contentOffset = CGPointZero;
//        }
//    }
}

#pragma mark - JXCategoryListContainerViewDelegate
/**
   返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 0;
    
}

/**
   返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, 0)];
//    [view addSubview:self.fakeSegmentControl];
    return view;
    
}

/**
   返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.viewModel.gameArray.count ?  kUI_Width(75) + kUI_Width(28) + kUI_Width(10):kUI_Width(10) * 2 + kUI_Width(28);
}

/**
   返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
//    if (_tableHeaderView) {
//        return self.tableHeaderView;
//    }

    self.tableHeaderView.frame = CGRectMake(0, 0, self.view.width, kUI_Width(75) + kUI_Width(28) + kUI_Width(10));
    self.topView.frame =  CGRectMake(0, 0, self.view.width, kUI_Width(75) + kUI_Width(28) + kUI_Width(10));
    self.gameView.frame = CGRectMake(0, 0, self.topView.width, kUI_Width(75));
    self.gameView.hidden = self.viewModel.gameArray.count ? NO : YES;
    self.noticeBackView.frame = CGRectMake(kUI_Width(kViewMargin), self.gameView.hidden ?kUI_Width(10): self.gameView.bottom, self.topView.width - kUI_Width(kViewMargin) * 2 , kUI_Width(28));
   
    self.noticeView.dataArray = self.viewModel.noticeArray;
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.noticeBackView.bounds;
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0, 0.5);
    gl.colors = @[(__bridge id)Color(@"#FDB5D1").CGColor, (__bridge id)Color(@"#F97EA5").CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.noticeBackView.layer insertSublayer:gl atIndex:0];
    self.replaceTopView.frame = CGRectMake(0, self.viewModel.gameArray.count ? self.tableHeaderView.height - kUI_Width(10) * 2- kUI_Width(28) : 0  , self.tableHeaderView.width, kUI_Width(10) * 2 + kUI_Width(28));
    
    self.replaceTopView.hidden = YES;
    
//    self.replaceTopView.hidden = self.viewModel.gameArray.count ? YES :NO;
    return self.tableHeaderView;
}

/**
   返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
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
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    WS(weakSelf)

    if (index == 0) {
        LCRecommendLiveListViewController *con = [[LCRecommendLiveListViewController alloc] init];
        con.scrollListCallback = ^(UIScrollView * _Nonnull scrollView) {
            if (scrollView.contentOffset.y >= kUI_Width(10) * 2 + kUI_Width(28)) {
           
                               [UIView animateWithDuration:0.15
                                                animations:^{
//                                   weakSelf.topView.hidden = YES;
                                   weakSelf.replaceTopView.hidden = NO;
                               }
                                                completion:^(BOOL finished) {
                               }];
           
           
                       } else {
           
                               [UIView animateWithDuration:0.15
                                                animations:^{
//                                   weakSelf.topView.hidden = NO;
                                   weakSelf.replaceTopView.hidden = YES;
                               }
                                                completion:^(BOOL finished) {
                               }];
           
           
                       }
        };

        [con view];
        self.currentListView = con.mainCollectionView;
        return con;
    } else {
        LCHomeLiveListViewController *con = [[LCHomeLiveListViewController alloc] init];

        con.currentFirstChannel = KLanguage(@"推荐");
        LCHomeSegmentModel *model = self.viewModel.channelDataArray[index ];
        con.channelId = model.channelId;
        [con view];
        self.currentListView = con.mainCollectionView;
        return con;
    }
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
   
    
    if (self.scrollBlock) {
        self.scrollBlock(scrollView);
    }
}

#pragma mark---- 懒加载 ----
- (UIView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.clipsToBounds = YES;
        _tableHeaderView = view;
    }

    return _tableHeaderView;
}

- (UIView *)topView {
    if (_topView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
       
//        view.backgroundColor =[UIColor greenColor];
        view.clipsToBounds = YES;
        _topView = view;
        [self.tableHeaderView addSubview:_topView];
    }

    return _topView;
}

- (UIView *)gameView {
    if (_gameView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [self.topView addSubview:view];
        view.clipsToBounds = YES;
        _gameView = view;
    }

    return _gameView;
}

- (UIView *)noticeBackView {
    if (_noticeBackView == nil) {
        UIView *view = [[UIView alloc] init];
        [self.topView addSubview:view];
        view.clipsToBounds = YES;
        _noticeBackView = view;

        view.layer.cornerRadius = kUI_Width(4);
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_homeNotice")];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(22));
            make.left.equalTo(kUI_Width(kViewMargin));
            make.centerY.equalTo(0);
        }];
        LCTitleNoticeView *noticeView = [[LCTitleNoticeView alloc]initWithFrame:CGRectZero];
        [view addSubview:noticeView];
        _noticeView = noticeView;
        [_noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.top.bottom.equalTo(0);
        }];
    }

    return _noticeBackView;
}

- (UIView *)replaceTopView {
    if (_replaceTopView == nil) {
        UIView *view = [[UIView alloc] init];

        view.clipsToBounds = YES;
        _replaceTopView = view;
        [self.tableHeaderView addSubview:_replaceTopView];
    }

    return _replaceTopView;
}

- (JXPagerListRefreshView *)pagerView {
    if (_pagerView == nil) {
        JXPagerListRefreshView *view = [[JXPagerListRefreshView alloc]initWithDelegate:self listContainerType:JXPagerListContainerType_CollectionView];
        _pagerView = view;
//        _pagerView.pinSectionHeaderVerticalOffset = kUI_Width(75);
        _pagerView.automaticallyDisplayListVerticalScrollIndicator = NO;
        _pagerView.isListHorizontalScrollEnabled = NO;
//        _pagerView.pinSectionHeaderVerticalOffset = kUI_Width(10) * 2 + kUI_Width(30);
        [self.view addSubview:_pagerView];
    }

    return _pagerView;
}
- (JXCategoryTitleBackgroundView *)segmentControl {
    if (_segmentControl == nil) {
        JXCategoryTitleBackgroundView *segmentView = [[JXCategoryTitleBackgroundView alloc]initWithFrame:CGRectZero];
   
        segmentView.cellWidthIncrement = kUI_Width(8) * 2;
        segmentView.contentEdgeInsetLeft = kUI_Width(kViewMargin);
        segmentView.contentEdgeInsetRight = kUI_Width(kViewMargin);
        //    segmentView.titleDataSource = self;
        segmentView.titleFont = RegularFont(12);
        segmentView.titleSelectedFont = RegularFont(14);
        segmentView.titleColor = Color(@"#333333");
        segmentView.titleSelectedColor = Color(@"#FFFFFF");
        segmentView.cellSpacing = kUI_Width(12);
        segmentView.averageCellSpacingEnabled = NO;
        segmentView.delegate = self;
        segmentView.titleDataSource = self;
        segmentView.backgroundHeight = kUI_Width(28) ;
        segmentView.normalBackgroundColor = Color(@"#EEEEEE");
        segmentView.selectedBackgroundColor = [UIColor clearColor];
        segmentView.borderLineWidth = 0.0;
        segmentView.backgroundCornerRadius = kUI_Width(28) / 2.0;
        JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
        backgroundView.indicatorHeight = kUI_Width(28);
        backgroundView.indicatorWidthIncrement = 0;
        backgroundView.indicatorCornerRadius = kUI_Width(28) / 2.0;
        backgroundView.clipsToBounds = YES;
        LCShelterGradientView *gradientView = [LCShelterGradientView new];
        gradientView.gradientLayer.startPoint = CGPointMake(1, 0.5);
        gradientView.gradientLayer.endPoint = CGPointMake(1, 0);
        gradientView.gradientLayer.colors = @[(__bridge id)Color(@"#FF76AF").CGColor, (__bridge id)Color(@"#FF2672 ").CGColor, ];
        gradientView.gradientLayer.locations = @[@(0), @(1.0f)];
        // 设置 gradientView 布局和 JXCategoryIndicatorBackgroundView 一样
        gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [backgroundView addSubview:gradientView];
        
        segmentView.indicators = @[backgroundView];
        _segmentControl = segmentView;
        [self.replaceTopView addSubview:_segmentControl];
        [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(kUI_Width(28));
            make.top.equalTo(kUI_Width(10));
        }];
//
//        _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    }

    return _segmentControl;
}


- (LCHomeSubSegmentsViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCHomeSubSegmentsViewModel new];
        _viewModel.currentFirstChannel = self.currentChannel;
    }
    return _viewModel;
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
