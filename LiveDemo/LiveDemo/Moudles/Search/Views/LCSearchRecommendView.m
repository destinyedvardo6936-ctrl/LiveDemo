//
//  LCSearchRecommendView.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCSearchRecommendView.h"
#import "LCLiveListCollectionViewCell.h"
#import "LCHomeFollowListHeaderView.h"
#import "LCHomeFollowListViewModel.h"
#import "LCLiveViewController.h"
@interface LCSearchRecommendView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@property (nonatomic , strong) LCHomeFollowListViewModel *viewModel;
@end
@implementation LCSearchRecommendView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(@"#FFFFFF");
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
        }];
        @weakify(self)
        [[self.viewModel.replaceRecommendSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
           
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
       
        [self.viewModel.replaceRecommendCommand execute:@(YES)];
    }
    return self;
}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
    return self.viewModel.recommendArray.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
  
    return UIEdgeInsetsMake(0, kUI_Width(kViewMargin), 0, kUI_Width(kViewMargin));
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
  
    return CGSizeMake(collectionView.width, kUI_Width(25) + kUI_Width(10) * 2);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    LCHomeFollowListHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCHomeFollowListHeaderView" forIndexPath:indexPath];
    view.titleStr = KLanguage(@"为您推荐");
    view.image =  image(@"icon_homeFollowHeaderImg");
    view.needReplace = YES;
    WS(weakSelf)
    view.replaceClickBlock = ^{
        [weakSelf.viewModel.replaceRecommendCommand execute:@(YES)];
    };
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
    return CGSizeMake((collectionView.width - kUI_Width(kViewMargin) - kUI_Width(kViewMargin) - kUI_Width(11))/2.0, kUI_Width(170));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return kUI_Width(11);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    LCLiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveListCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel = self.viewModel.recommendArray[indexPath.item];
//    cell.contentView.layer.cornerRadius = kUI_Width(4);
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
   
        
            LCLiveViewController *con = [LCLiveViewController new];
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObjectsFromArray:self.viewModel.recommendArray];
           
            con.dataArray = temp;
            con.index = indexPath.item;
        
            [(LCBaseViewController *)self.findViewController pushToViewController:con];
        
        
    
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
        [self addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLiveListCollectionViewCell class] forCellWithReuseIdentifier:@"LCLiveListCollectionViewCell"];
       
        [_mainCollectionView registerClass:[LCHomeFollowListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCHomeFollowListHeaderView"];
        
       
       
    }
    return _mainCollectionView;
}
- (LCHomeFollowListViewModel *)viewModel{
    if (_viewModel == nil){
        _viewModel = [LCHomeFollowListViewModel new];
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
