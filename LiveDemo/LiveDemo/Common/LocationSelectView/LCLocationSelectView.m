//
//  LCLocationSelectView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCLocationSelectView.h"
#import "LCLocationSelectCell.h"
#import "LCLocationViewModel.h"
@interface LCLocationSelectView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) UIView *contentView;
@property (nonatomic , weak) UILabel *myLocationLabel;
@property (nonatomic , weak) UIImageView *locationBackView;
@property (nonatomic , weak) UILabel *locationLabel;
@property (nonatomic , weak) UIButton *closeBtn;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@property (nonatomic , strong) LCLocationViewModel *viewModel;
@end
@implementation LCLocationSelectView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorAlpha(@"#000000", 0.5);
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(667));
            make.top.equalTo(kUI_Width(135));
        }];
        [self.myLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(12));
            make.right.mas_equalTo(self.closeBtn.mas_left).offset(-kUI_Width(10));
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(8));
            make.right.equalTo(-kUI_Width(8));
            make.width.height.equalTo(kUI_Width(16));
        }];
        [self.locationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.equalTo(kUI_Width(10));
            make.width.equalTo(kUI_Width(78));
            make.height.equalTo(kUI_Width(28));
        }];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(9));
            make.right.equalTo(-kUI_Width(9));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.locationBackView.mas_bottom).offset(kUI_Width(10));
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kUI_Width(10));
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.bottom.equalTo(-kUI_Width(10));
        }];
        @weakify(self)
        [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            
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
        [self.viewModel.loadDataCommend execute:@(YES)];
    }
    return self;
}
- (void)setCurrentArea:(NSString *)currentArea{
    _currentArea = [currentArea copy];
    self.locationLabel.text = _currentArea;
}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //向下取整
    CGFloat width = floor((collectionView.width - kUI_Width(5) * 3)/4.0);
    return CGSizeMake(width, kUI_Width(28));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(5);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCLocationSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLocationSelectCell" forIndexPath:indexPath];
    cell.titleStr = self.viewModel.dataArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.selectBlock){
        self.selectBlock(self.viewModel.dataArray[indexPath.item]);
    }
}
#pragma mark---- 懒加载 ----
- (UIView *)contentView{
    if (_contentView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self addSubview:view];
        _contentView = view;
    }
    return _contentView;
}
- (UILabel *)myLocationLabel{
    if (_myLocationLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"我的地区");
        [self.contentView addSubview:label];
        _myLocationLabel = label;
    }
    return _myLocationLabel;
}
- (UIButton *)closeBtn{
    if(_closeBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image(@"icon_locationClose") forState:UIControlStateNormal];
        _closeBtn = btn;
        [self.contentView addSubview:_closeBtn];
        WS(weakSelf)
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.15 animations:^{
                [weakSelf removeFromSuperview];
            }];
        }];
    }
    return _closeBtn;
}
- (UIImageView *)locationBackView{
    if (_locationBackView == nil){
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectZero];
        view.image = image(@"icon_homeLocationBg");
        [self.contentView addSubview:view];
        _locationBackView = view;
        _locationLabel.layer.masksToBounds = YES;
        _locationBackView.clipsToBounds = YES;
        _locationBackView.layer.cornerRadius = kUI_Width(28)/2.0;
    }
    return _locationBackView;
}
- (UILabel *)locationLabel{
    if (_locationLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
        
        [self.locationBackView addSubview:label];
        _locationLabel = label;
    }
    return _locationLabel;
}
- (UILabel *)tipLabel{
    if (_tipLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"所有地区");
        [self.contentView addSubview:label];
        _tipLabel = label;
    }
    return _tipLabel;
}
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
        [self.contentView addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLocationSelectCell class] forCellWithReuseIdentifier:@"LCLocationSelectCell"];
        
        
       
    }
    return _mainCollectionView;
}
- (LCLocationViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCLocationViewModel new];
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
