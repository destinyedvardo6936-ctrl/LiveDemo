//
//  LCRecommendLiveLIstViewController.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/22.
//

#import "LCRecommendLiveListViewController.h"
#import "LCLiveListCollectionViewCell.h"
#import "LCLiveViewController.h"
#import "LCHomeRecommendArchorCell.h"
#import "LCHomeBannerCollectionCell.h"
#import "LCHomeRecommedViewModel.h"
#import "LCCommonWebViewController.h"

static CGFloat LCHomeAnchorCardSpacing(void) {
    return kUI_Width(2);
}

static UIEdgeInsets LCHomeAnchorCardInsets(void) {
    CGFloat spacing = LCHomeAnchorCardSpacing();
    return UIEdgeInsetsMake(0, spacing, 0, spacing);
}

static CGFloat LCHomeAnchorCardSide(CGFloat containerWidth) {
    CGFloat spacing = LCHomeAnchorCardSpacing();
    return floor((containerWidth - spacing * 3) / 2.0);
}

static CGFloat LCHomeRecommendModuleHeight(void) {
    return kUI_Width(122);
}

static CGFloat LCHomeRecommendBannerHeight(void) {
    return kUI_Width(140);
}

@interface LCRecommendLiveListViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic , strong) LCHomeRecommedViewModel *viewModel;
@end

@implementation LCRecommendLiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)lc_addSubviews{
    self.view.backgroundColor = Color(@"#FFFFFF");
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
    }];
    self.emptyDataView.title = KLanguage(@"主播在赶来的路上~");
    self.emptyDataView.backgroundColor = self.view.backgroundColor;
    self.emptyDataView.customImageFrame = CGRectMake((self.view.width - kUI_Width(200))/2.0, kUI_Width(136), kUI_Width(200), kUI_Width(148));
    [self.emptyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
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

    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.mainCollectionView.mj_header.isRefreshing) {
            [self.mainCollectionView.mj_header endRefreshing];
        }
        if (self.mainCollectionView.mj_footer.isRefreshing) {
            [self.mainCollectionView.mj_footer endRefreshing];
        }
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }

        self.mainCollectionView.hidden = NO;
        self.emptyDataView.hidden = self.viewModel.topDataArray.count;

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
    [self.mainCollectionView.mj_header beginRefreshing];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView{
    return self.view;
}

- (UIScrollView *)listScrollView{
    return self.mainCollectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback{
    self.scrollCallback   = callback;
}

#pragma mark ================ collectionview头视图 ===============

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger num = 0;
    if (self.viewModel.topDataArray.count){
        num += 1;
    }
    if(self.viewModel.recommendArchorArray.count){
        num += 1;
    }
    if(self.viewModel.bannerArray.count){
        num += 1;
    }
    if(self.viewModel.gameRecommendArchorArray.count){
        num += 1;
    }
    if(self.viewModel.bottomDataArray.count){
        num += 1;
    }
    return num;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.viewModel.topDataArray.count && section == 0){
        return self.viewModel.topDataArray.count;
    }else if((self.viewModel.recommendArchorArray.count && section == 1) || (self.viewModel.recommendArchorArray.count&& section == 0)){
        return 1;
    }else if((self.viewModel.bannerArray.count && section == 2) || ( section == 0 && self.viewModel.bannerArray.count)||( section == 1 && self.viewModel.bannerArray.count)){
        return 1;
    }else if((self.viewModel.gameRecommendArchorArray.count && section == 3) || ( section == 0 && self.viewModel.gameRecommendArchorArray.count)||( section == 1 && self.viewModel.gameRecommendArchorArray.count)||( section == 2 && self.viewModel.gameRecommendArchorArray.count)){
        return 1;
    }
    return self.viewModel.bottomDataArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardSpacing();
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardSpacing();
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardInsets();
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets sectionInsets = LCHomeAnchorCardInsets();
    if (self.viewModel.topDataArray.count && indexPath.section == 0){
        CGFloat side = LCHomeAnchorCardSide(collectionView.width);
        return CGSizeMake(side, side);
    }else if((self.viewModel.recommendArchorArray.count && indexPath.section == 1) || (self.viewModel.recommendArchorArray.count&& indexPath.section == 0)){
        return CGSizeMake(collectionView.width - sectionInsets.left - sectionInsets.right , LCHomeRecommendModuleHeight());
    }else if((self.viewModel.bannerArray.count && indexPath.section == 2) || ( indexPath.section == 0 && self.viewModel.bannerArray.count)||( indexPath.section == 1 && self.viewModel.bannerArray.count)){
        return CGSizeMake(collectionView.width - sectionInsets.left - sectionInsets.right , LCHomeRecommendBannerHeight());
    }else if((self.viewModel.gameRecommendArchorArray.count && indexPath.section == 3) || ( indexPath.section == 0 && self.viewModel.gameRecommendArchorArray.count)||( indexPath.section == 1 && self.viewModel.gameRecommendArchorArray.count)||( indexPath.section == 2 && self.viewModel.gameRecommendArchorArray.count)){
        return CGSizeMake(collectionView.width - sectionInsets.left - sectionInsets.right , LCHomeRecommendModuleHeight());
    }
    CGFloat side = LCHomeAnchorCardSide(collectionView.width);
    return CGSizeMake(side, side);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf)
    if (self.viewModel.topDataArray.count && indexPath.section == 0){
        LCLiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveListCollectionViewCell" forIndexPath:indexPath];
        cell.dataModel = self.viewModel.topDataArray[indexPath.item];
        return cell;
    }else if((self.viewModel.recommendArchorArray.count && indexPath.section == 1) || (self.viewModel.recommendArchorArray.count&& indexPath.section == 0)){
        LCHomeRecommendArchorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCHomeRecommendArchorCell" forIndexPath:indexPath];
        cell.titleStr = KLanguage(@"光年推荐");
        cell.dataArray = self.viewModel.recommendArchorArray;
        cell.clickBlock = ^(LCHomeListModel * _Nonnull selectModel) {
            LCLiveViewController *con = [LCLiveViewController new];
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObjectsFromArray:weakSelf.viewModel.recommendArchorArray];
            con.dataArray = temp;
            con.index = [weakSelf.viewModel.recommendArchorArray indexOfObject:selectModel];
            [weakSelf pushToViewController:con];
        };
        return cell ;
    }else if((self.viewModel.bannerArray.count && indexPath.section == 2) || ( indexPath.section == 0 && self.viewModel.bannerArray.count)||( indexPath.section == 1 && self.viewModel.bannerArray.count)){
        LCHomeBannerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCHomeBannerCollectionCell" forIndexPath:indexPath];
        cell.dataArray = self.viewModel.bannerArray;
        cell.clickBlock = ^(NSInteger index) {
            LCCommonWebViewController *con = [LCCommonWebViewController new];
            LCBannerModel *banner = [weakSelf.viewModel.bannerArray objectAtIndex:index];
            con.url = banner.slide_url;
            [weakSelf pushToViewController:con];
        };
        return cell ;
    }else if((self.viewModel.gameRecommendArchorArray.count && indexPath.section == 3) || ( indexPath.section == 0 && self.viewModel.gameRecommendArchorArray.count)||( indexPath.section == 1 && self.viewModel.gameRecommendArchorArray.count)||( indexPath.section == 2 && self.viewModel.gameRecommendArchorArray.count)){
        LCHomeRecommendArchorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCHomeRecommendArchorCell" forIndexPath:indexPath];
        cell.dataArray = self.viewModel.gameRecommendArchorArray;
        cell.titleStr = KLanguage(@"游戏推荐");
        cell.clickBlock = ^(LCHomeListModel * _Nonnull selectModel) {
            LCLiveViewController *con = [LCLiveViewController new];
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObjectsFromArray:weakSelf.viewModel.gameRecommendArchorArray];
            con.dataArray = temp;
            con.index = [weakSelf.viewModel.gameRecommendArchorArray indexOfObject:selectModel];
            [weakSelf pushToViewController:con];
        };
        return cell ;
    }
    LCLiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveListCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel = self.viewModel.bottomDataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.viewModel.topDataArray.count && indexPath.section == 0){
        LCLiveViewController *con = [LCLiveViewController new];
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:self.viewModel.topDataArray];
        [temp addObjectsFromArray:self.viewModel.bottomDataArray];
        con.dataArray = temp;
        con.index = indexPath.item;
        [self pushToViewController:con];
    }else if((self.viewModel.recommendArchorArray.count && indexPath.section == 1) || (self.viewModel.recommendArchorArray.count&& indexPath.section == 0)){

    }else if((self.viewModel.gameRecommendArchorArray.count && indexPath.section == 3) || ( indexPath.section == 0 && self.viewModel.gameRecommendArchorArray.count)||( indexPath.section == 1 && self.viewModel.gameRecommendArchorArray.count)||( indexPath.section == 2 && self.viewModel.gameRecommendArchorArray.count)){

    }else{
        LCLiveViewController *con = [LCLiveViewController new];
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:self.viewModel.topDataArray];
        [temp addObjectsFromArray:self.viewModel.bottomDataArray];
        con.dataArray = temp;
        con.index = indexPath.item + self.viewModel.topDataArray.count;
        [self pushToViewController:con];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    if(self.scrollListCallback){
        self.scrollListCallback(scrollView);
    }
}

#pragma mark---- 懒加载 ----

- (LCBaseCollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionLayout.sectionInset = UIEdgeInsetsZero;

        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLiveListCollectionViewCell class] forCellWithReuseIdentifier:@"LCLiveListCollectionViewCell"];
        [_mainCollectionView registerClass:[LCHomeBannerCollectionCell class] forCellWithReuseIdentifier:@"LCHomeBannerCollectionCell"];
        [_mainCollectionView registerClass:[LCHomeRecommendArchorCell class] forCellWithReuseIdentifier:@"LCHomeRecommendArchorCell"];
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

- (LCHomeRecommedViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCHomeRecommedViewModel new];
    }
    return _viewModel;
}

@end
