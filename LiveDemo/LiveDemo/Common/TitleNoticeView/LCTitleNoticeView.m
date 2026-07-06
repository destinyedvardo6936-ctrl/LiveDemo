//
//  LCTitleNoticeView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/21.
//

#import "LCTitleNoticeView.h"
#import "LCTitleNoticeCell.h"
@interface LCTitleNoticeView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    dispatch_source_t _timer;
}
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@end
@implementation LCTitleNoticeView
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
    if(_dataArray.count){
        if(_timer){
            dispatch_cancel(_timer);
            _timer = nil;
        }
        WS(weakSelf)
        [self.mainCollectionView layoutIfNeeded];
        __block CGFloat space = 0;
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0,0));
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                space += weakSelf.mainCollectionView.width/10.0;
                if(space >= weakSelf.mainCollectionView.contentSize.width){
                    space = 0;
                }
                [weakSelf.mainCollectionView setContentOffset:CGPointMake(space, 0)];
//                [weakSelf.mainCollectionView scrollRectToVisible:CGRectMake(space, 0, weakSelf.mainCollectionView.width, weakSelf.mainCollectionView.height) animated:YES];
            });
        });
        dispatch_resume(_timer);
    }
}
- (void)dealloc{
    if(_timer){
        dispatch_cancel(_timer);
        _timer = nil;
    }
}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.dataArray[indexPath.item];
    return CGSizeMake([str sizeForFont:RegularFont(14) size:CGSizeMake(CGFLOAT_MAX, collectionView.height) mode:NSLineBreakByCharWrapping].width,collectionView.height);
   
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCTitleNoticeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCTitleNoticeCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = collectionView.backgroundColor;
    cell.contentView.clipsToBounds = YES;
    cell.titleStr = self.dataArray[indexPath.item];
    cell.textColor = self.cusTextColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    

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
        [_mainCollectionView registerClass:[LCTitleNoticeCell class] forCellWithReuseIdentifier:@"LCTitleNoticeCell"];
 
       
        
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
