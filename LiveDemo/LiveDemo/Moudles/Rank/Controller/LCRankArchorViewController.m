//
//  LCRankArchorViewController.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCRankArchorViewController.h"
#import "JXCategoryTitleBackgroundView.h"
#import <JXPagerListRefreshView.h>
#import "LCRankViewModel.h"
#import "LCRankListViewController.h"
#import <JXCategoryIndicatorBackgroundView.h>
@interface LCRankArchorViewController ()< JXPagerViewDelegate, JXCategoryViewDelegate,JXCategoryTitleViewDataSource>
@property (nonatomic, copy) void (^ scrollBlock)(UIScrollView *scrollView);



@property (nonatomic, weak) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) JXCategoryTitleBackgroundView *segmentControl;

@end

@implementation LCRankArchorViewController

-(void)viewDidLoad {
   [super viewDidLoad];
   // Do any additional setup after loading the view.
}

- (void)lc_addSubviews {
    self.view.backgroundColor = Color(@"#FC6891");
   [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(0);
       make.right.equalTo(0);
       make.top.mas_equalTo(0);
       make.bottom.equalTo(0);
   }];
}

- (void)lc_bindViewModel {
//    @weakify(self)
//    [[[self.viewModel.loadDataCommend.executing skip:1] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
//        @strongify(self)
//        if (x.boolValue) {
//            self.mainCollectionView.mj_footer.hidden = YES;
//            if (self.mainCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
//                [self.mainCollectionView.mj_footer resetNoMoreData];
//
//            }
//        }else{
//            self.mainCollectionView.mj_footer.hidden = NO;
//        }
//    }];
////      [[self.viewModel.nextPageCommand.executing takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
////          @strongify(self)
////          self.isPreloading = x.boolValue;
////    }];
//
//    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        if (self.mainCollectionView.mj_header.isRefreshing) {
//            [self.mainCollectionView.mj_header endRefreshing];
//        }
//        if (self.mainCollectionView.mj_footer.isRefreshing) {
//            [self.mainCollectionView.mj_footer endRefreshing];
//        }
////        self.loadingView.hidden = YES;
//        if ([x isKindOfClass:[NSError class]]) {
//            NSError *er = x;
//            [SVProgressHUD showErrorWithStatus:er.domain];
//            return;
//        }
//        self.noticeView.dataArray = self.viewModel.noticeArray;
//        self.mainCollectionView.hidden = NO;
//
////        self.loadingView.hidden = YES;
//
//
//
//        self.emptyDataView.hidden = self.viewModel.topDataArray.count;
////
////        kSVPDismiss
//
//        [UIView animateWithDuration:0 animations:^{
//            [self.mainCollectionView reloadData];
//        }];
//
//
//    }];
//
//
//
//    [[self.viewModel.noMoreDataSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber  *_Nullable x) {
//        @strongify(self)
//        if (x.boolValue) {
//            [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
//        }
//
//    }];
//    [self.mainCollectionView.mj_header beginRefreshing];
}



#pragma mark----JXCategoryViewDelegate----
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
}
- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title{

    return  [title sizeForFont:titleView.titleSelectedFont size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping].width+kUI_Width(12) * 2;

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
   for (LCBaseViewController *list in self.pagerView.validListDict.allValues) {
       if ([list isKindOfClass:LCRankListViewController.class]) {
           LCRankListViewController *con = (LCRankListViewController *)list;
           con.mainTableView.contentOffset = CGPointZero;
       } else {
          
       }
   }
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
   return view;
}

/**
  返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
*/
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
   return kUI_Width(84);
}

/**
  返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
*/
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
   UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, kUI_Width(84))];
    view.backgroundColor = Color(@"#FC6891");
   [view addSubview:self.segmentControl];
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.backgroundColor = [UIColor clearColor];
//    [view addSubview:rightBtn];
//    UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_yesterdayRank")];
//    [rightBtn addSubview:imgView];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//    label.font = MediumFont(14);
//    label.textColor = Color(@"#FFFFFF");
//    label.text = KLanguage(@"昨日榜单");
//    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [rightBtn addSubview:label];
//    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//
//    }];
//    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-kUI_Width(kViewMargin));
//        make.height.equalTo(kUI_Width(16));
//        make.centerY.mas_equalTo(self.segmentControl.mas_centerY);
//    }];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.left.equalTo(0);
//        make.width.height.equalTo(kUI_Width(16));
//    }];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(kUI_Width(14));
//        make.centerY.right.equalTo(0);
//        make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(8));
//    }];
   [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(kUI_Width(kViewMargin));
       make.right.equalTo(-kUI_Width(kViewMargin));
       make.height.equalTo(kUI_Width(28));
       make.top.equalTo(kUI_Width(10));
   }];
    
   return view;
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
//   WS(weakSelf)


    LCRankListViewController *con = [[LCRankListViewController alloc] init];
//       con.scrollCallback = ^(UIScrollView *scrollView) {
//           weakSelf.scrollBlock(scrollView);
//       };
    con.isArchorList = self.isArchorList;
    if(index == 0){
        con.type =  @"day";
    }else if (index == 1){
        con.type = @"week";
    }else{
        con.type = @"month";
    }
    
    [con view];
    
       return con;
   
}
- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
   
    
    if (self.scrollBlock) {
        self.scrollBlock(scrollView);
    }
}


#pragma mark---- 懒加载 ----


- (JXPagerListRefreshView *)pagerView {
   if (_pagerView == nil) {
       JXPagerListRefreshView *view = [[JXPagerListRefreshView alloc]initWithDelegate:self listContainerType:JXPagerListContainerType_CollectionView];
       _pagerView = view;
       _pagerView.automaticallyDisplayListVerticalScrollIndicator = NO;
       _pagerView.isListHorizontalScrollEnabled = NO;
//        _pagerView.pinSectionHeaderVerticalOffset = kUI_Width(10) * 2 + kUI_Width(30);
       [self.view addSubview:_pagerView];
   }

   return _pagerView;
}
- (JXCategoryTitleBackgroundView *)segmentControl{
   if(_segmentControl == nil){
       JXCategoryTitleBackgroundView *segmentView = [[JXCategoryTitleBackgroundView alloc]initWithFrame:CGRectZero];
       segmentView.titles = @[KLanguage(@"日榜"),KLanguage(@"周榜"),KLanguage(@"月榜")];
       segmentView.cellSpacing = kUI_Width(10);
       segmentView.contentEdgeInsetLeft = 0;
       segmentView.contentEdgeInsetRight = 0;
   //    segmentView.titleDataSource = self;
       segmentView.titleFont = RegularFont(12);
       segmentView.titleSelectedFont = RegularFont(12);
       segmentView.titleColor = Color(@"#F06896");
       segmentView.titleSelectedColor = Color(@"#F06896");
       segmentView.backgroundHeight = kUI_Width(28);
       segmentView.normalBackgroundColor = ColorAlpha(@"#FFFFFF", 0.5);
       segmentView.selectedBackgroundColor = ColorAlpha(@"#FFFFFF", 1);
       segmentView.borderLineWidth = 0.0;
       segmentView.backgroundCornerRadius = kUI_Width(28) / 2.0;
       segmentView.titleDataSource = self;
       segmentView.delegate = self;
       segmentView.averageCellSpacingEnabled = NO;
       JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
       backgroundView.indicatorHeight = kUI_Width(28);
       backgroundView.indicatorWidthIncrement = 0;
       backgroundView.indicatorCornerRadius = kUI_Width(28) / 2.0;
       backgroundView.indicatorColor = Color(@"#FFFFFF");
       segmentView.indicators = @[backgroundView];
       _segmentControl = segmentView;
       _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
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
