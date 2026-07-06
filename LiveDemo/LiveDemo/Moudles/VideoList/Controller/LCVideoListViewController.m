//
//  LCVideoListViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/5.
//

#import "LCVideoListViewController.h"
#import "LCWaterFlowCollectionLayout.h"
#import "LCVideoListViewModel.h"
#import "LCVideoListCollectionViewCell.h"
#import "LCCommonWebViewController.h"
#import "LCVideoListCollectionHeaderView.h"
#import "LCNoDataCollectionViewCell.h"
#import "LCVideoDetailViewController.h"
@interface LCVideoListViewController ()<UICollectionViewDataSource,LCWaterFlowCollectionLayoutDelegate,UICollectionViewDelegate>

@property (nonatomic , strong) LCVideoListViewModel *viewModel;


@end

@implementation LCVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(0);
    }];
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[[self.viewModel.loadDataCommend.executing skip:1] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            self.mainCollectionView.mj_footer.hidden = YES;
            if (self.mainCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.mainCollectionView.mj_footer resetNoMoreData];
                
            }
        }else{
            self.mainCollectionView.mj_footer.hidden = NO;
        }
    }];
//      [[self.viewModel.nextPageCommand.executing takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
//          @strongify(self)
//          self.isPreloading = x.boolValue;
//    }];
    
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.mainCollectionView.mj_header.isRefreshing) {
            [self.mainCollectionView.mj_header endRefreshing];
        }
        if (self.mainCollectionView.mj_footer.isRefreshing) {
            [self.mainCollectionView.mj_footer endRefreshing];
        }
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainCollectionView.hidden = NO;
        
        self.mainCollectionView.mj_footer.hidden = !self.viewModel.dataArray.count;
        
        [UIView animateWithDuration:0 animations:^{
            [self.mainCollectionView reloadData];
        }];
        
        
    }];

    
    
    [[self.viewModel.noMoreDataSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber  *_Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    [[self.viewModel.bannerSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
       
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainCollectionView.hidden = NO;
        
      
        
        [UIView animateWithDuration:0 animations:^{
            [self.mainCollectionView reloadData];
        }];
        
        
    }];
    [self.mainCollectionView.mj_header beginRefreshing];
    [self.viewModel.bannerCommand execute:@(YES)];
}
#pragma mark---- JXPagerViewListViewDelegate ----
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.mainCollectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollListCallback   = callback;
}

- (void)listScrollViewWillResetContentOffset {
    //当前的listScrollView需要重置的时候，就把所有列表的contentOffset都重置了
    self.mainCollectionView.contentOffset = CGPointZero;
    
}
#pragma mark----LCWaterFlowCollectionLayout----
/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为WSLWaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 WSLWaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 WSLWaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 WSLWaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.dataArray.count == 0){
        CGFloat width = self.mainCollectionView.width  - kUI_Width(12) * 2;
        return CGSizeMake(width, self.mainCollectionView.height - (self.viewModel.bannerArray.count? (kUI_Width(120)+kUI_Width(10)+ kUI_Width(25) +kUI_Width(10)):(kUI_Width(10)+ kUI_Width(25) +kUI_Width(10))) );
    }
    CGFloat width = (self.mainCollectionView.width  - kUI_Width(12) * 2 - kUI_Width(15))/2.0;
    LCVideoListModel *model = self.viewModel.dataArray[indexPath.item];
    CGFloat height = [model.title sizeForFont:RegularFont(12) size:CGSizeMake(width, RegularFont(12).lineHeight* 2) mode:NSLineBreakByCharWrapping].height;
    return CGSizeMake(width, height + kUI_Width(96) + kUI_Width(8));
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    if(section == 0 && self.viewModel.bannerArray.count){
        return CGSizeMake(self.mainCollectionView.width - kUI_Width(12) * 2, kUI_Width(10) + kUI_Width(120)+kUI_Width(10)+ kUI_Width(25) +kUI_Width(10));
    }else if (section == 0 && !self.viewModel.bannerArray.count){
        return CGSizeMake(self.mainCollectionView.width - kUI_Width(12) * 2, kUI_Width(10)+ kUI_Width(25) +kUI_Width(10));
    }
    
    return CGSizeZero;
}
///** 脚视图Size */
//-(CGSize )waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
//    return CGSizeZero;
//}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionHeader]){
        LCVideoListCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCVideoListCollectionHeaderView" forIndexPath:indexPath];
        view.dataArray = self.viewModel.bannerArray;
        WS(weakSelf)
        view.clickBlock = ^(LCBannerModel * _Nonnull selectModel) {
            LCCommonWebViewController *con = [LCCommonWebViewController new];
            
            con.url = selectModel.slide_url;
            [weakSelf pushToViewController:con];
        };
        return view;
    }
    return nil;
    
}
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout{
    if(self.viewModel.dataArray.count == 0){
        return 1;
    }
    return 2;
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout{
    return kUI_Width(15);
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout{
    return kUI_Width(10);
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(0, kUI_Width(12), 0, kUI_Width(12));
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count ? self.viewModel.dataArray.count : 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.dataArray.count == 0){
        LCNoDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCNoDataCollectionViewCell" forIndexPath:indexPath];
        cell.titleStr = KLanguage(@"暂无推荐视频");
        cell.customBgColor = collectionView.backgroundColor;
        return cell;
    }
    LCVideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCVideoListCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel = self.viewModel.dataArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.dataArray.count != 0){
        LCVideoListModel *model = self.viewModel.dataArray[indexPath.item];
        LCVideoDetailViewController *con = [LCVideoDetailViewController new];
        con.dataModel = model;
        [self pushToViewController:con];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollListCallback ?: self.scrollListCallback(scrollView);
}
#pragma mark ---- 懒加载----
- (LCBaseCollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        LCWaterFlowCollectionLayout *collectionLayout = [[LCWaterFlowCollectionLayout alloc] init];
        collectionLayout.delegate = self;
        collectionLayout.flowLayoutStyle = LCWaterFlowVerticalEqualWidth;
        
        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
//        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, kUI_Width(20), 0, kUI_Width(20));
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCVideoListCollectionViewCell class] forCellWithReuseIdentifier:@"LCVideoListCollectionViewCell"];
        [_mainCollectionView registerClass:[LCNoDataCollectionViewCell class] forCellWithReuseIdentifier:@"LCNoDataCollectionViewCell"];
        [_mainCollectionView registerClass:[LCVideoListCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCVideoListCollectionHeaderView"];
        
       
        WS(weakSelf)
        _mainCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.loadDataCommend execute:@(YES)];
        }];
        _mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
          
                [weakSelf.viewModel.nextPageCommand execute:@(YES)];
            
        }];
        _mainCollectionView.mj_footer.hidden = YES;
    }
    return _mainCollectionView;
}
- (LCVideoListViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCVideoListViewModel new];
        _viewModel.channelId = self.channelId;
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
