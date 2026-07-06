//
//  LCHomeLiveListViewController.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/22.
//

#import "LCHomeLiveListViewController.h"
#import "LCLiveListCollectionViewCell.h"
#import "LCHomeOtherLiveListViewModel.h"
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

@interface LCHomeLiveListViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic , strong) LCHomeOtherLiveListViewModel *viewModel;

@end

@implementation LCHomeLiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
    }];
//    self.emptyDataView.title = KLanguage(@"主播在赶来的路上~");
//
//    self.emptyDataView.customImageFrame = CGRectMake((self.view.width - kUI_Width(157))/2.0, kUI_Width(136), kUI_Width(157), kUI_Width(157));
//    [self.emptyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.right.equalTo(0);
//        make.top.equalTo(0);
//        make.bottom.equalTo(0);
//    }];
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
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainCollectionView.hidden = NO;
        
//        self.emptyDataView.hidden = self.viewModel.dataArray.count;

        
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

/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。

 @return UIView
 */
- (UIView *)listView{
    return self.view;
}

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView{
    return self.mainCollectionView;
}

/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback

 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback{
    self.scrollCallback   = callback;
}
#pragma mark ================ collectionview头视图 ===============


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.viewModel.dataArray.count ? self.viewModel.dataArray.count : 1;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.viewModel.dataArray.count == 0 ){
        return UIEdgeInsetsZero;
    }
    return LCHomeAnchorCardInsets();
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardSpacing();
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardSpacing();
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.dataArray.count == 0 ){
        return CGSizeMake(collectionView.width, collectionView.height);
    }
    CGFloat side = LCHomeAnchorCardSide(collectionView.width);
    return CGSizeMake(side, side);

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewModel.dataArray.count == 0 ){
        LCHomeFollowEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCHomeFollowEmptyCell" forIndexPath:indexPath];
        return cell;
    }
    LCLiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveListCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel = self.viewModel.dataArray[indexPath.item];
//    cell.contentView.layer.cornerRadius = kUI_Width(4);
    return cell;
   
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.viewModel.dataArray.count == 0 ){
        
    }else{
        
            LCLiveViewController *con = [LCLiveViewController new];
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObjectsFromArray:self.viewModel.dataArray];
           
            con.dataArray = temp;
            con.index = indexPath.item;
            [self pushToViewController:con];
        
        
    }
    
    
//    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
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
- (LCHomeOtherLiveListViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCHomeOtherLiveListViewModel new];
        _viewModel.currentFirstChannel = self.currentFirstChannel;
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


