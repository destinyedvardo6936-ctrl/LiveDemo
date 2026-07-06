//
//  LCLiveLotteryTicketWanfaView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/23.
//

#import "LCLiveLotteryTicketWanfaView.h"
#import "LCLiveLotteryTicketWanfaCollectionCell.h"
@interface LCLiveLotteryTicketWanfaView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@property (nonatomic, copy) void (^scrollBlock)(UIScrollView *scrollView);
@end
@implementation LCLiveLotteryTicketWanfaView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}

#pragma mark---- JXPagerViewListViewDelegate ----
- (UIView *)listView {
    return self;
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
    if(self.dataArray.count > 4){
        CGFloat width =(collectionView.width - collectionView.contentInset.left - collectionView.contentInset.right - kUI_Width(12) *5)/6.0;
        return  CGSizeMake(width, kUI_Width(40)+kUI_Width(15)+kUI_Width(16));
    }
    
    CGFloat width =(collectionView.width - collectionView.contentInset.left - collectionView.contentInset.right - kUI_Width(24) *3)/4.0;
    return  CGSizeMake(width, kUI_Width(70)+kUI_Width(15)+kUI_Width(16));
   
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return kUI_Width(12);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if(self.dataArray.count > 4){
        return kUI_Width(12);
    }
    return kUI_Width(24);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCLiveLotteryTicketWanfaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveLotteryTicketWanfaCollectionCell" forIndexPath:indexPath];
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
        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, kUI_Width(12), kUI_Width(20), kUI_Width(12));
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLiveLotteryTicketWanfaCollectionCell class] forCellWithReuseIdentifier:@"LCLiveLotteryTicketWanfaCollectionCell"];
        
    }
    return _mainCollectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
