//
//  LCLotteryTicketBeishuView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCLotteryTicketBeishuView.h"
#import "LCLotteryTicketBeishuCell.h"
@interface LCLotteryTicketBeishuView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;

@end
@implementation LCLotteryTicketBeishuView
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
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.mainCollectionView reloadData];
}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kUI_Width(56), collectionView.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(18);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCLotteryTicketBeishuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLotteryTicketBeishuCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = collectionView.backgroundColor;
    cell.backgroundColor = collectionView.backgroundColor;
    cell.dataModel = self.dataArray[indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LCLotteryTicketBeishuModel *model = self.dataArray[indexPath.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:LCGameLotteryTicketBeishuSelectNot object:model];
}
#pragma mark---- 懒加载 ----
- (LCBaseCollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, kUI_Width(12), 0, kUI_Width(12));
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLotteryTicketBeishuCell class] forCellWithReuseIdentifier:@"LCLotteryTicketBeishuCell"];
        
        
       
    }
    return _mainCollectionView;
}

@end
