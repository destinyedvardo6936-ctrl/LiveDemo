//
//  LCLiveGameListView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCLiveGameListView.h"
#import "LCLiveGameListCollectionCell.h"
#import "LCLiveGameListViewModel.h"
#import "LCGameCenterHeaderView.h"
@interface LCLiveGameListView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@property (nonatomic, copy) void (^scrollBlock)(UIScrollView *scrollView);
@property (nonatomic , strong) LCLiveGameListViewModel *viewModel;
@end
@implementation LCLiveGameListView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        @weakify(self)
        [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            
    //        self.loadingView.hidden = YES;
            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
          
            [self.mainCollectionView reloadData];
            
            
            
        }];
        [[self.viewModel.thirdGameTypeSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
          
            [self.viewModel.loadDataCommend execute:@(YES)];

          
         
            
        }];
    }
    return self;
}

- (void)setDataModel:(LCGameTypeModel *)dataModel{
    _dataModel = dataModel;
    self.viewModel.typeModel = _dataModel;
    if([self.viewModel.typeModel.modelId isEqualToString:@"0"]){
        if(self.viewModel.typeModel.dataArray.count){
            [self.mainCollectionView reloadData];
        }else{
            [self.viewModel.loadDataCommend execute:@(YES)];
        }
    }else{
        if(self.viewModel.typeModel.typeArray.count){
            
                [self.viewModel.loadDataCommend execute:@(YES)];
            
            
        }else{
            [self.viewModel.thirdGameTypeCommand execute:@(YES)];
        }
    }
    
}
#pragma mark---- JXPagerViewListViewDelegate ----
/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。

 @return UIView
 */
- (UIView *)listView{
    return self;
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
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollBlock = callback;
}

//- (void)listScrollViewWillResetContentOffset {
//    //当前的listScrollView需要重置的时候，就把所有列表的contentOffset都重置了
//    self.mainCollectionView.contentOffset = CGPointZero;
//    
//}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([self.viewModel.typeModel.modelId isEqualToString:@"0"] && section == 0){
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.width, kUI_Width(28) + kUI_Width(10) * 2);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([self.viewModel.typeModel.modelId isEqualToString:@"0"] && indexPath.section == 0){
        return nil;
    }
    LCGameCenterHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCGameCenterHeaderView" forIndexPath:indexPath];
    view.dataArray = self.viewModel.typeModel.typeArray;
    view.selectTypeModel = self.viewModel.typeModel.selectTypeModel;
    WS(weakSelf)
    view.subTypeClickBlock = ^(LCGameSubTypeModel * _Nonnull selectModel) {
        weakSelf.viewModel.typeModel.selectTypeModel = selectModel;
        [weakSelf.viewModel.loadDataCommend execute:@(YES)];
    };
    
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kUI_Width(76), kUI_Width(76));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return (collectionView.width - collectionView.contentInset.left - collectionView.contentInset.right - kUI_Width(76) * 4)/4.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(20);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCLiveGameListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveGameListCollectionCell" forIndexPath:indexPath];
    cell.dataModel = self.viewModel.dataArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
  
        LCGameListModel *model = self.viewModel.dataArray[indexPath.item];
        if(self.isFromVideo){
            [[NSNotificationCenter defaultCenter] postNotificationName:LCVideoLotteryTicketSelectNot object:model];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveLotteryTicketSelectNot object:model];
        }
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollBlock) {
        self.scrollBlock(scrollView);
    }
}
#pragma mark---- 懒加载 ----
- (LCBaseCollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        
        
        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
        _mainCollectionView.contentInset = UIEdgeInsetsMake(kUI_Width(10), 0, 0, 0);
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLiveGameListCollectionCell class] forCellWithReuseIdentifier:@"LCLiveGameListCollectionCell"];
        [_mainCollectionView registerClass:[LCGameCenterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCGameCenterHeaderView"];
        
       
    }
    return _mainCollectionView;
}
- (LCLiveGameListViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCLiveGameListViewModel new];
    }
    return _viewModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
