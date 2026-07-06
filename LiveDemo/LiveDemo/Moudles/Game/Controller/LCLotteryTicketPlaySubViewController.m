//
//  LCGamePlaySubViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCLotteryTicketPlaySubViewController.h"
#import "LCLotteryTicketCollectionViewCell.h"
@interface LCLotteryTicketPlaySubViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;

@property (nonatomic, copy) void (^scrollBlock)(UIScrollView *scrollView);

@end

@implementation LCLotteryTicketPlaySubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)lc_addSubviews{
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
}
- (void)lc_bindViewModel{

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
    
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width =(collectionView.width - collectionView.contentInset.left - collectionView.contentInset.right - kUI_Width(12) *4)/5.0;
    
    
    return  CGSizeMake(width, kUI_Width(32)+kUI_Width(6)+kUI_Width(16));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return kUI_Width(12);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return kUI_Width(15);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCLotteryTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLotteryTicketCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = collectionView.backgroundColor;
    cell.contentView.backgroundColor = collectionView.backgroundColor;
   
    cell.dataModel = self.dataArray[indexPath.item];
//    cell.contentView.clipsToBounds = YES;
//    cell.contentView.layer.cornerRadius = 5;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LCLotteryTicketWanFaModel *model = self.dataArray[indexPath.item];
    model.isSelected = !model.isSelected;
    [[NSNotificationCenter defaultCenter]postNotificationName:LCGameLotteryTicketSelectNot object:model];
    
    [collectionView reloadData];
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
        _mainCollectionView.contentInset = UIEdgeInsetsMake(kUI_Width(12), kUI_Width(12), kUI_Width(12), kUI_Width(12));
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLotteryTicketCollectionViewCell class] forCellWithReuseIdentifier:@"LCLotteryTicketCollectionViewCell"];
        
    }
    return _mainCollectionView;
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
