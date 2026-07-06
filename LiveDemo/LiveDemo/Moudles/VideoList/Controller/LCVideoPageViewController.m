//
//  LCVideoPageViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/24.
//

#import "LCVideoPageViewController.h"
#import <JXPagerListRefreshView.h>
#import "JXCategoryTitleBackgroundView.h"
#import "LCShelterGradientView.h"
#import <JXCategoryIndicatorBackgroundView.h>
#import "LCShortVideoChannelViewModel.h"
#import "LCVideoListViewController.h"
@interface LCVideoPageViewController ()< JXPagerViewDelegate, JXCategoryViewDelegate,JXCategoryTitleViewDataSource>
@property (nonatomic, copy) void (^ scrollBlock)(UIScrollView *scrollView);
@property (nonatomic, strong) UIScrollView *currentListView;
@property (nonatomic, weak) JXPagerListRefreshView *pagerView;
@property (nonatomic , strong) JXCategoryTitleBackgroundView *segmentControl;
@property (nonatomic, strong) LCShortVideoChannelViewModel *viewModel;
@end

@implementation LCVideoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews {
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.equalTo(0);
    }];
}

- (void)lc_bindViewModel {

   
    self.segmentControl.titles = self.viewModel.channelTitleArray;
    [self.segmentControl reloadData];
    [self.pagerView reloadData];
}



#pragma mark----JXCategoryViewDelegate----
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
//    LCBaseViewController *list = (LCBaseViewController *)self.pagerView.validListDict[@(index)];
//    if ([list isKindOfClass:LCHomeLiveListViewController.class]) {
//        LCHomeLiveListViewController *con = (LCHomeLiveListViewController *)list;
//        self.currentListView = con.mainCollectionView;
//    }
    

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
    for (LCBaseViewController *list in self.pagerView.validListDict.allValues) {
        if ([list isKindOfClass:LCVideoListViewController.class]) {
            LCVideoListViewController *con = (LCVideoListViewController *)list;
            con.mainCollectionView.contentOffset = CGPointZero;
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
    return kUI_Width(10) * 2 + kUI_Width(30);
}

/**
   返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, kUI_Width(10) * 2 + kUI_Width(28))];
    [view addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(-0);
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
   


    LCVideoListViewController *con = [[LCVideoListViewController alloc] init];
        
   
    NSDictionary *dic = self.viewModel.channelDataArray[index ];
    con.channelId = minstr(dic[@"id"]) ;
    [con view];
        self.currentListView = con.mainCollectionView;
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
       
//
        _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    }

    return _segmentControl;
}
- (LCShortVideoChannelViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCShortVideoChannelViewModel new];
        
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
