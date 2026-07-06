//
//  LCHomeNearbyListViewController.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCHomeNearbyListViewController.h"
#import "LCLiveListCollectionViewCell.h"
#import "LCHomeNearbyListViewModel.h"
//#import "LCLocationSelectView.h"
//#import "LCSexSelectView.h"

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

@interface LCHomeNearbyListViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property (nonatomic , strong) UIButton *locationBtn;
//@property (nonatomic , strong) UILabel *locationLabel;

@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@property (nonatomic , strong) LCHomeNearbyListViewModel *viewModel;

@property (nonatomic, copy) void (^ scrollBlock)(UIScrollView *scrollView);
@end

@implementation LCHomeNearbyListViewController

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
    self.emptyDataView.title = KLanguage(@"主播在赶来的路上~");
    
    self.emptyDataView.customImageFrame = CGRectMake((self.view.width - kUI_Width(157))/2.0, kUI_Width(136), kUI_Width(157), kUI_Width(157));
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
    
//    [[RACObserve(self.viewModel, area) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *  _Nullable x) {
//        @strongify(self)
//        self.locationLabel.text = x;
//    }];
    
    [self.mainCollectionView.mj_header beginRefreshing];
}
#pragma mark----按钮点击----
- (void)buttonClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    [self resetBtnStatus:btn];
    
}
- (void)resetBtnStatus:(UIButton *)btn{
    UILabel *label = [btn viewWithTag:200];
    UIImageView *imgView = [btn viewWithTag:201];
    if (btn.selected){
        imgView.image = image(@"icon_homePullUp");
    }else{
        imgView.image = image(@"icon_homePullDown");
    }
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        return self.viewModel.dataArray.count;
   
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//  
//    if(section == 0){
//        return CGSizeMake(collectionView.width, kUI_Width(10) * 2 + kUI_Width(28));
//    }
//    return CGSizeZero;
//}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    if( indexPath.section == 0){
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        [view addSubview:self.locationBtn];
//        [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(kViewMargin));
//            make.top.equalTo(kUI_Width(10));
//            make.width.equalTo(kUI_Width(78));
//            make.height.equalTo(kUI_Width(28));
//        }];
//        return view;
//    }
//  
//    return nil;
//}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardInsets();
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat side = LCHomeAnchorCardSide(collectionView.width);
    return CGSizeMake(side, side);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardSpacing();
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeAnchorCardSpacing();
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LCLiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveListCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel =  self.viewModel.dataArray[indexPath.item];
//    cell.contentView.layer.cornerRadius = kUI_Width(4);
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollBlock ?: self.scrollBlock(scrollView);
}
#pragma mark---- 懒加载 ----
//- (UIButton *)locationBtn{
//    if (_locationBtn == nil){
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:image(@"icon_homeLocationBg") forState:UIControlStateNormal];
//        [btn setBackgroundImage:image(@"icon_homeLocationBg") forState:UIControlStateSelected];
////        [self.view addSubview:btn];
//        _locationBtn = btn;
//        WS(weakSelf)
//        [[_locationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            LCLocationSelectView *view = [[LCLocationSelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            view.currentArea = weakSelf.viewModel.area;
//            view.selectBlock = ^(NSString * _Nonnull area) {
//                
//            };
//            [weakSelf.view.window addSubview:view];
//        }];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//        label.font = RegularFont(12);
//        label.textColor = Color(@"#FFFFFF");
//        label.tag = 200;
//        [_locationBtn addSubview:label];
//        _locationLabel = label;
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        imgView.image = image(@"icon_homePullDown");
//        imgView.tag = 201;
//        [_locationBtn addSubview:imgView];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(8));
//            make.centerY.equalTo(0);
//            make.height.equalTo(kUI_Width(12));
//            make.right.mas_equalTo(imgView.mas_left).offset(-kUI_Width(8));
//        }];
//        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(-kUI_Width(8));
//            make.width.height.equalTo(kUI_Width(14));
//            make.centerY.equalTo(0);
//        }];
//        
//    }
//    return _locationBtn;
//}
//- (UIButton *)sexBtn{
//    if (_sexBtn == nil){
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:image(@"icon_homeLocationBg") forState:UIControlStateNormal];
//        [btn setBackgroundImage:image(@"icon_homeLocationBg") forState:UIControlStateSelected];
//        [self.view addSubview:btn];
//        _sexBtn = btn;
//        WS(weakSelf)
//        [[_sexBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            LCLocationSelectView *view = [[LCLocationSelectView alloc]initWithFrame:CGRectZero];
//            view.currentArea = weakSelf.viewModel.area;
//            view.selectBlock = ^(NSString * _Nonnull area) {
//                LCSexSelectView *sexView = [[LCSexSelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//                sexView.currentSex = weakSelf.viewModel.sex;
//                sexView.selectBlock = ^(NSString * _Nonnull sex) {
//
//                };
//                [weakSelf.view.window addSubview:sexView];
//            };
//            [weakSelf.view.window addSubview:view];
//        }];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//        label.font = RegularFont(12);
//        label.textColor = Color(@"#FFFFFF");
//        label.tag = 200;
//        [_sexBtn addSubview:label];
//        _sexLabel = label;
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        imgView.image = image(@"icon_homePullDown");
//        imgView.tag = 201;
//        [_sexBtn addSubview:imgView];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(8));
//            make.centerY.equalTo(0);
//            make.height.equalTo(kUI_Width(12));
//            make.right.mas_equalTo(imgView.mas_left).offset(-kUI_Width(8));
//        }];
//        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(-kUI_Width(8));
//            make.width.height.equalTo(kUI_Width(14));
//            make.centerY.equalTo(0);
//        }];
//
//    }
//    return _sexBtn;
//}
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
        
//        [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
       
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
- (LCHomeNearbyListViewModel *)viewModel{
    if (_viewModel == nil){
        _viewModel = [LCHomeNearbyListViewModel new];
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


