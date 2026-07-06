//
//  LCRankViewController.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCRankViewController.h"
#import <JXPagerListRefreshView.h>
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorImageView.h>
#import "LCRankArchorViewController.h"

@interface LCRankViewController ()<JXPagerViewDelegate,JXCategoryViewDelegate,JXCategoryTitleViewDataSource>
@property (nonatomic , weak) JXPagerListRefreshView *pagerView;
@property (nonatomic , strong) JXCategoryTitleView *segmentControl;
@end

@implementation LCRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(0);
    }];
}
#pragma mark----JXPagerViewDelegate----
/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView{
    return 0;
}

/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    return kNavBarHeight;
}

/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, kNavBarHeight)];
    view.backgroundColor = Color(@"#FFFFFF");
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:image(@"icon_rankBack") forState:UIControlStateNormal];
    [view addSubview:leftBtn];
    WS(weakSelf)
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf popBack];
    }];
    [view addSubview:self.segmentControl];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(kViewMargin));
        make.width.height.equalTo(kUI_Width(18));
        make.top.equalTo((kNavBarHeight - kStatusBarHeight - kUI_Width(18))/2.0 + kStatusBarHeight);
    }];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(kViewMargin) + kUI_Width(20));
        make.right.equalTo(-(kUI_Width(kViewMargin) + kUI_Width(20)));
        make.height.equalTo(kUI_Width(27));
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - kUI_Width(27))/2.0);
    }];
    return view;
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
    LCRankArchorViewController *con = [LCRankArchorViewController new];
    con.isArchorList = index == 0;
    return con;
}

#pragma mark---- 懒加载 ----
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
        JXCategoryTitleView *view = [[JXCategoryTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        _segmentControl = view;
        _segmentControl.tag = 200;
        _segmentControl.delegate = self;
        _segmentControl.titles = @[KLanguage(@"主播榜"),KLanguage(@"土豪榜")];
        
        _segmentControl.titleDataSource = self;
//        _segmentControl.contentEdgeInsetLeft = kUI_Width(kViewMargin);
//        _segmentControl.contentEdgeInsetRight = kUI_Width(kViewMargin);
        
        _segmentControl.titleFont = RegularFont(16);
        _segmentControl.titleSelectedFont = BoldFont(20);
        _segmentControl.titleColor = Color(@"#333333");
        _segmentControl.titleSelectedColor = Color(@"#333333");
        _segmentControl.titleColorGradientEnabled = YES;

        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleCenter;
        _segmentControl.titleLabelVerticalOffset = -kUI_Width(3);
       
        _segmentControl.titleColorGradientEnabled = YES;
        _segmentControl.cellSpacing = kUI_Width(80);
                _segmentControl.averageCellSpacingEnabled = YES;
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
