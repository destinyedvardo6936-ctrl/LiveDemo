//
//  LCActivitysViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCActivitysViewController.h"
#import <JXPagerListRefreshView.h>
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorImageView.h>
#import "LCActivitySegmentViewModel.h"
#import "LCActivityListViewController.h"
@interface LCActivitysViewController ()<JXPagerViewDelegate,JXCategoryViewDelegate,JXCategoryTitleViewDataSource>
@property (nonatomic , strong) LCActivitySegmentViewModel *viewModel;
@property (nonatomic , weak) JXPagerListRefreshView *pagerView;
@property (nonatomic , weak) JXCategoryTitleView *segmentControl;
@end

@implementation LCActivitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    
    [self.navView setLeftButtonType:self.needBack ? LCBaseNavigationViewLeftType_BlackBack: LCBaseNavigationViewLeftType_None];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(70));
        make.height.equalTo(kUI_Width(20)+kUI_Width(4) *2);
        make.top.equalTo((kNavBarHeight - kStatusBarHeight -kUI_Width(20)-kUI_Width(4) *2)/2.0+kStatusBarHeight );
        make.right.equalTo(-kUI_Width(70));
//        make.right.mas_equalTo(searchBtn.mas_left);
    }];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(kUI_Width(10));
    }];
    self.segmentControl.titles = self.viewModel.channelDataArray;
//    self.pagerView.defaultSelectedIndex = 1;
}
- (void)lc_bindViewModel{
//    WS(weakSelf)
//    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameStatusNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
//
//        weakSelf.segmentControl.titles = weakSelf.viewModel.channelDataArray;
//
//        [weakSelf.segmentControl reloadData];
//        [weakSelf.pagerView reloadData];
//    }];
    @weakify(self)
    [[[self.viewModel rac_valuesAndChangesForKeyPath:@"currentIndex" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew observer:self ] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        
     
       
        [self.segmentControl selectItemAtIndex:self.viewModel.currentIndex];
        

    }];
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.segmentControl.titles = self.viewModel.channelTitleArray;
        
        [self.segmentControl reloadData];
        [self.pagerView reloadData];
        
        
    }];
    [self.viewModel.loadDataCommend execute:@(YES)];
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
    
    
    LCActivityListViewController *con = [LCActivityListViewController new];
    con.dataModel = self.viewModel.channelDataArray[index];
    
    

    return con;
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
- (LCActivitySegmentViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [LCActivitySegmentViewModel new];
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
        _segmentControl.collectionView.scrollEnabled = NO;
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
//        _segmentControl.cellSpacing = kUI_Width(60);
                _segmentControl.averageCellSpacingEnabled = YES;
        JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
        lineView.indicatorImageView.image = image(@"icon_segmentLine");
        lineView.indicatorImageViewSize = CGSizeMake(kUI_Width(20), kUI_Width(4));
        lineView.indicatorWidth = kUI_Width(20) ;
        lineView.indicatorHeight = kUI_Width(4);

        lineView.indicatorCornerRadius =kUI_Width(4)/2.0;
        _segmentControl.indicators = @[lineView];
         
        _segmentControl.backgroundColor = [UIColor whiteColor];
        [self.navView addSubview:_segmentControl];
//        [self.categoryBackView addSubview:_categoryView];
        _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
        
        _segmentControl.collectionView.scrollEnabled = NO;
        
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
