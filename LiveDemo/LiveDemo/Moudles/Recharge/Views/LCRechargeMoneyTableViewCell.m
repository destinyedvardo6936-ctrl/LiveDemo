//
//  LCRechargeMoneyTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCRechargeMoneyTableViewCell.h"
#import "LCRechargeMoneyCollectionViewCell.h"
@interface LCRechargeMoneyTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;

@end
@implementation LCRechargeMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.bottom.equalTo(0);
            
        }];
       
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.mainCollectionView reloadData];
    
}


#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kUI_Width(212)/2.0, kUI_Width(113)/2.0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    LCRechargeMoneyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCRechargeMoneyCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel = self.dataArr[indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LCRechargeMoneyModel *selectModel = self.dataArr[indexPath.item];
    if (!selectModel.isSelected) {
        for (LCRechargeMoneyModel *model in self.dataArr) {
            model.isSelected = NO;
        }
        selectModel.isSelected = YES;
        if (self.labelSelectedBlock) {
            self.labelSelectedBlock(selectModel);
        }
        [collectionView reloadData];
    }else{
        
    }

}
#pragma mark---- 懒加载 ----
- (UICollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
      

        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        collectionLayout.minimumLineSpacing = kUI_Width(10);
        collectionLayout.minimumInteritemSpacing =(SCREEN_WIDTH - kUI_Width(212)/2.0 * 3 - kUI_Width(12) * 2)/2.0;

        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
        
        _mainCollectionView.contentInset = UIEdgeInsetsMake(kUI_Width(10), kUI_Width(12), kUI_Width(10), kUI_Width(12));
        
//        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, (SCREEN_WIDTH-60-btnWidth*3)/2, 15,  (SCREEN_WIDTH-60-btnWidth*3)/2);
        _mainCollectionView.scrollEnabled = NO;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCRechargeMoneyCollectionViewCell class] forCellWithReuseIdentifier:@"LCRechargeMoneyCollectionViewCell"];
//        [_mainCollectionView registerClass:[TTRecommendTTKMoreCell class] forCellWithReuseIdentifier:@"TTRecommendTTKMoreCell"];
        
    }
    return _mainCollectionView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
