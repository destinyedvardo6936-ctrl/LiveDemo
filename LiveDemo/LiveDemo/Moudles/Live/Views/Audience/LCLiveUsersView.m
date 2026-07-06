//
//  LCLiveUsersView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import "LCLiveUsersView.h"
#import "LCAudienceCollectionViewCell.h"
@interface LCLiveUsersView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@end
@implementation LCLiveUsersView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = [dataArray copy];
    [self.mainCollectionView reloadData];
}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.height, collectionView.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(9);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(9);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCAudienceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCAudienceCollectionViewCell" forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.clickBlock){
        self.clickBlock();
    }
}
#pragma mark---- 懒加载 ----
- (LCBaseCollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        collectionLayout.flowLayoutStyle = ZNWaterFlowVerticalEqualWidth;
//        collectionLayout.delegate = self;
        
        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
//        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, kUI_Width(20), 0, kUI_Width(20));
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCAudienceCollectionViewCell class] forCellWithReuseIdentifier:@"LCAudienceCollectionViewCell"];
 
       
        
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
