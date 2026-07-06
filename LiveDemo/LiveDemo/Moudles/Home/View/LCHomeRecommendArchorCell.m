//
//  LCHomeRecommendArchorCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/21.
//

#import "LCHomeRecommendArchorCell.h"
#import "LCHomeRecommendArchorSubCell.h"

static CGFloat LCHomeCompactCardSize(void) {
    return kUI_Width(84);
}

static CGFloat LCHomeCompactCardSpacing(void) {
    return kUI_Width(2);
}

static CGFloat LCHomeCompactTitleHeight(void) {
    return kUI_Width(34);
}

static CGFloat LCHomeCompactCollectionHeight(void) {
    return LCHomeCompactCardSize() + LCHomeCompactCardSpacing() * 2;
}

@interface LCHomeRecommendArchorCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@end

@implementation LCHomeRecommendArchorCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(2));
            make.right.equalTo(-kUI_Width(2));
            make.top.equalTo(0);
            make.height.equalTo(LCHomeCompactTitleHeight());
        }];
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.mas_equalTo(self.tipLabel.mas_bottom);
            make.height.equalTo(LCHomeCompactCollectionHeight());
        }];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = [dataArray copy];
    [self.mainCollectionView reloadData];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = [titleStr copy];
    self.tipLabel.text = _titleStr;
}

#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cardSize = LCHomeCompactCardSize();
    return CGSizeMake(cardSize, cardSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeCompactCardSpacing();
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return LCHomeCompactCardSpacing();
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat spacing = LCHomeCompactCardSpacing();
    return UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCHomeRecommendArchorSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCHomeRecommendArchorSubCell" forIndexPath:indexPath];
    cell.dataModel = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.clickBlock){
        self.clickBlock(self.dataArray[indexPath.item]);
    }
}

#pragma mark---- 懒加载 ----
- (UILabel *)tipLabel{
    if (_tipLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipLabel = label;
        _tipLabel.font = BoldFont(14);
        _tipLabel.textColor = Color(@"#333333");
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (LCBaseCollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCHomeRecommendArchorSubCell class] forCellWithReuseIdentifier:@"LCHomeRecommendArchorSubCell"];
    }
    return _mainCollectionView;
}

@end
