//
//  LCHomeFollowLiveListController.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCHomeFollowLiveListController.h"
#import "LCLiveListCollectionViewCell.h"
#import "LCHomeFollowListViewModel.h"
#import "LCHomeFollowListHeaderView.h"
#import "LCHomeFollowEmptyCell.h"
#import "LCLiveViewController.h"

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

@interface LCHomeFollowLiveListController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@property (nonatomic , strong) LCHomeFollowListViewModel *viewModel;
@property (nonatomic, copy) void (^ scrollBlock)(UIScrollView *scrollView);
@end

@implementation LCHomeFollowLiveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [[self.viewModel.replaceRecommendSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
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
    [self.viewModel.replaceRecommendCommand execute:@(YES)];
}
#pragma mark---- JXPagerViewListViewDelegate ----
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.mainCollectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollBlock = callback;
}

- (void)listScrollViewWillResetContentOffset {
    //当前的listScrollView需要重置的时候，就把所有列表的contentOffset都重置了
    self.mainCollectionView.contentOffset = CGPointZero;
    
}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.viewModel.dataArray.count == 0 && section == 0){
        return 1;
    }
    if (section == 0){
        return self.viewModel.dataArray.count;
    }
    return self.viewModel.recommendArray.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.viewModel.dataArray.count == 0 && section == 0){
        return UIEdgeInsetsZero;
    }
    return LCHomeAnchorCardInsets();
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.viewModel.dataArray.count == 0 && section == 0){
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.width, kUI_Width(25) + kUI_Width(10) * 2);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (self.viewModel.dataArray.count == 0 && indexPath.section == 0){
        return nil;
    }
    LCHomeFollowListHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCHomeFollowListHeaderView" forIndexPath:indexPath];
    view.titleStr = indexPath.section == 0 ? KLanguage(@"已关注主播"):KLanguage(@"为您推荐");
    view.image = indexPath.section == 0 ?image(@"icon_homeRecommendArchorTip"): image(@"icon_homeFollowHeaderImg");
    view.needReplace = indexPath.section == 1;
    WS(weakSelf)
    view.replaceClickBlock = ^{
        [weakSelf.viewModel.replaceRecommendCommand execute:@(YES)];
    };
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.dataArray.count == 0 && indexPath.section == 0){
        return CGSizeMake(collectionView.width, kUI_Width(253));
    }
 
    CGFloat side = LCHomeAnchorCardSide(collectionView.width);
    return CGSizeMake(side, side);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardSpacing();
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardSpacing();
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewModel.dataArray.count == 0 && indexPath.section == 0){
        LCHomeFollowEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCHomeFollowEmptyCell" forIndexPath:indexPath];
        return cell;
    }
    LCLiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveListCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel = indexPath.section == 0 ? self.viewModel.dataArray[indexPath.item] : self.viewModel.recommendArray[indexPath.item];
//    cell.contentView.layer.cornerRadius = kUI_Width(4);
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.viewModel.dataArray.count == 0 && indexPath.section == 0){
        
    }else{
        if(indexPath.section == 0){
            LCLiveViewController *con = [LCLiveViewController new];
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObjectsFromArray:self.viewModel.dataArray];
           
            con.dataArray = temp;
            con.index = indexPath.item;
            [self pushToViewController:con];
        }else{
            LCLiveViewController *con = [LCLiveViewController new];
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObjectsFromArray:self.viewModel.recommendArray];
           
            con.dataArray = temp;
            con.index = indexPath.item;
            [self pushToViewController:con];
        }
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollBlock ?: self.scrollBlock(scrollView);
}
#pragma mark---- 懒加载 ----

- (LCBaseCollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
      
        
        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
//        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, kUI_Width(20), 0, kUI_Width(20));
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLiveListCollectionViewCell class] forCellWithReuseIdentifier:@"LCLiveListCollectionViewCell"];
        [_mainCollectionView registerClass:[LCHomeFollowEmptyCell class] forCellWithReuseIdentifier:@"LCHomeFollowEmptyCell"];
        [_mainCollectionView registerClass:[LCHomeFollowListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCHomeFollowListHeaderView"];
        
       
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
- (LCHomeFollowListViewModel *)viewModel{
    if (_viewModel == nil){
        _viewModel = [LCHomeFollowListViewModel new];
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


