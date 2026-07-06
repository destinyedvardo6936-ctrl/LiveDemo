//
//  LCLiveGiftListView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import "LCLiveGiftListView.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorImageView.h>
#import "LCLiveGiftListCollectionCell.h"
#import "LWLCollectionViewHorizontalLayout.h"
#import "LCLiveGiftSelectView.h"
@interface LCLiveGiftListView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JXCategoryViewDelegate,JXCategoryTitleViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) JXCategoryTitleView *segmentControl;
@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@property (nonatomic , weak) UIPageControl *pageControl;
@property (nonatomic , weak) UIView *bottomView;

@property (nonatomic , weak) UILabel *balanaceLabel;
@property (nonatomic , weak) UIView *sendBackView;
@property (nonatomic , weak) UILabel *countLabel;
@property (nonatomic , weak) UIButton *countBtn;
//@property (nonatomic , weak) UITextField *textField;

@property (nonatomic , strong) LCLiveRoomGiftListViewModel *viewModel;
@end
@implementation LCLiveGiftListView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(416));
            make.bottom.equalTo(0);
        }];
        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(3)+kUI_Width(18) + kUI_Width(4));
            make.top.equalTo(kUI_Width(16));
        }];
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.mas_equalTo(self.segmentControl.mas_bottom).offset(kUI_Width(16));
            make.bottom.mas_equalTo(self.pageControl.mas_top).offset(-kUI_Width(20));
        }];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.height.equalTo(kUI_Width(4));
            make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-kUI_Width(22));
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(28)+kUI_Width(29));
        }];
        @weakify(self)
        [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            
            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
            self.pageControl.numberOfPages = (self.viewModel.dataArray.count+ 7 )/8;
            
            self.mainCollectionView.hidden = NO;
            
           
            [UIView animateWithDuration:0 animations:^{
                [self.mainCollectionView reloadData];
            }];
            
            
        }];
        [[self.viewModel.sendGiftSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            
            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:KLanguage(@"钻石：") attributes:@{NSForegroundColorAttributeName:Color(@"#FFFFFF")}];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:self.viewModel.balanceStr attributes:@{NSForegroundColorAttributeName:Color(@"#F9E43B")}]];
            
            self.balanaceLabel.attributedText = att;
            if(self.sendClickBlock){
                self.sendClickBlock(x, self.countLabel.text);
            }
            self.countLabel.text = @"1";
            
        }];
        [[self.viewModel.balanceSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            
            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:KLanguage(@"钻石：") attributes:@{NSForegroundColorAttributeName:Color(@"#FFFFFF")}];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:self.viewModel.balanceStr attributes:@{NSForegroundColorAttributeName:Color(@"#F9E43B")}]];
            
            self.balanaceLabel.attributedText = att;
            
            
        }];
        [[RACObserve(self.viewModel, selectGiftModel) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LCLiveGiftModel *  _Nullable x) {
            if(!x){
                self.sendBackView.hidden = NO;
                
                return;
            }
            if([x.type integerValue] == 1){
                self.sendBackView.hidden = YES;
            }else{
                self.sendBackView.hidden = NO;
            }
            
        }];
        [self.viewModel.loadDataCommend execute:@(YES)];
        [self.viewModel.balanceCommand execute:@(YES)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonWithButton)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setRoomId:(NSString *)roomId{
    _roomId = [roomId copy];
    self.viewModel.roomId = _roomId;
}
- (void)setStream:(NSString *)stream{
    _stream = [stream copy];
    self.viewModel.stream = _stream;
}
- (void)leftButtonWithButton{
    if(self.dismissBlock){
        self.dismissBlock();
    }
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.backView]) {
    
        return NO;
    }
    
    return YES;
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    self.isLoading = YES;
    self.viewModel.isBackPack = index == 1;
    [self.viewModel.selectGiftCommand execute:nil];
    [self.viewModel.loadDataCommend execute:@(YES)];
    self.viewModel.selectGiftModel = nil;
    self.pageControl.currentPage = 0;
}

#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (self.viewModel.dataArray.count+ 7 )/8 * 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.width/4.0, kUI_Width(80) + kUI_Width(6) + kUI_Width(14) + kUI_Width(4) + kUI_Width(14));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(8);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCLiveGiftListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCLiveGiftListCollectionCell" forIndexPath:indexPath];
    if (indexPath.item < self.viewModel.dataArray.count) {
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.dataModel = self.viewModel.dataArray[indexPath.item];
        }else{
            cell.dataModel = nil;
        }
    cell.contentView.backgroundColor = collectionView.backgroundColor;
    cell.backgroundColor = collectionView.backgroundColor;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item < self.viewModel.dataArray.count){
        [self.viewModel.selectGiftCommand execute:self.viewModel.dataArray[indexPath.item]];
    }
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.width;
    self.pageControl.currentPage = index;
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.7);
        view.layer.cornerRadius = kUI_Width(16);
        view.clipsToBounds = YES;
        [self addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (JXCategoryTitleView *)segmentControl{
    if (_segmentControl == nil) {
        JXCategoryTitleView *view = [[JXCategoryTitleView alloc]initWithFrame:CGRectZero];
        _segmentControl = view;
        _segmentControl.tag = 200;
        _segmentControl.delegate = self;
        _segmentControl.collectionView.scrollEnabled = NO;
        _segmentControl.titleDataSource = self;
        _segmentControl.titles = @[KLanguage(@"礼物"),KLanguage(@"背包")];
        _segmentControl.contentEdgeInsetLeft = kUI_Width(kViewMargin);
        _segmentControl.contentEdgeInsetRight = kUI_Width(kViewMargin);
        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleCenter;
        _segmentControl.titleLabelVerticalOffset = -kUI_Width(3);
        _segmentControl.titleFont = RegularFont(18);
        _segmentControl.titleSelectedFont = MediumFont(18);
        _segmentControl.titleSelectedColor = Color(@"#FFFFFF");
        _segmentControl.titleColor = Color(@"#CCCCCC");
        _segmentControl.titleColorGradientEnabled = YES;

//        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
//        _segmentControl.titleLabelVerticalOffset = _segmentControl.titleSelectedFont.lineHeight- _segmentControl.titleFont.lineHeight - kUI_Width(6);
       
        _segmentControl.titleColorGradientEnabled = YES;
        _segmentControl.cellSpacing = kUI_Width(24);
                _segmentControl.averageCellSpacingEnabled = NO;
        JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
        lineView.indicatorImageView.image = image(@"icon_segmentLine");
        lineView.indicatorImageViewSize = CGSizeMake(kUI_Width(20), kUI_Width(4));
        lineView.indicatorWidth = kUI_Width(20) ;
        lineView.indicatorHeight = kUI_Width(4);

        lineView.indicatorCornerRadius =kUI_Width(4)/2.0;
        _segmentControl.indicators = @[lineView];
         
        _segmentControl.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:_segmentControl];
//        [self.categoryBackView addSubview:_categoryView];
       
        
        _segmentControl.collectionView.scrollEnabled = NO;
        
    }
    return _segmentControl;
}
- (LCBaseCollectionView *)mainCollectionView{
    if(!_mainCollectionView){
        LWLCollectionViewHorizontalLayout *collectionLayout = [[LWLCollectionViewHorizontalLayout alloc] init];
       
        collectionLayout.itemCountPerRow = 4;
        collectionLayout.rowCount = 2;
//        collectionLayout.minimumLineSpacing = 0;
//        collectionLayout.minimumInteritemSpacing = 0;
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
//        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, kUI_Width(20), 0, kUI_Width(20));
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
//        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, kUI_Width(12), 0, kUI_Width(12));
        [self.backView addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCLiveGiftListCollectionCell class] forCellWithReuseIdentifier:@"LCLiveGiftListCollectionCell"];
    }
    return _mainCollectionView;
}
- (UIPageControl *)pageControl{
    if(!_pageControl){
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
        pageControl.pageIndicatorTintColor = Color(@"#999999");
//        // 设置当前所在页数
//        pageControl.currentPage = 0;
        pageControl.currentPageIndicatorTintColor = Color(@"#FFFFFF");

        [self.backView addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}
- (UIView *)bottomView{
    if(!_bottomView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:view];
        _bottomView = view;
        UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        balanceLabel.font = MediumFont(14);
//        balanceLabel.textColor = Color(@"#FFFFFF");
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:KLanguage(@"钻石：") attributes:@{NSForegroundColorAttributeName:Color(@"#FFFFFF")}];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"0" attributes:@{NSForegroundColorAttributeName:Color(@"#F9E43B")}]];
        balanceLabel.attributedText = att;
        [_bottomView addSubview:balanceLabel];
        _balanaceLabel = balanceLabel;
        
        UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechargeBtn setBackgroundImage:image(@"icon_liveGiftRechargeBtnBg") forState:UIControlStateNormal];
        [rechargeBtn setTitle:KLanguage(@"兑换钻石") forState:UIControlStateNormal];
        [rechargeBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        rechargeBtn.titleLabel.font = MediumFont(14);
        [_bottomView addSubview:rechargeBtn];
        WS(weakSelf)
        [[rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.rechageClickBlock){
                weakSelf.rechageClickBlock();
            }
        }];
        
        
        UIView *sendBackView = [[UIView alloc]initWithFrame:CGRectZero];
        sendBackView.backgroundColor = ColorAlpha(@"#000000", 0.6);
        sendBackView.layer.cornerRadius = kUI_Width(28)/2.0;
        sendBackView.clipsToBounds = YES;
        [_bottomView addSubview:sendBackView];
        _sendBackView = sendBackView;
        
        UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        countLabel.font = MediumFont(14);
        countLabel.textColor = Color(@"#FFFFFF");
        countLabel.text = @"1";
        countLabel.textAlignment = NSTextAlignmentCenter;
        [countLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [countLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_sendBackView addSubview:countLabel];
        _countLabel = countLabel;
        
        UIButton *countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [countBtn setImage:image(@"icon_liveGiftNormalImg") forState:UIControlStateNormal];
        [countBtn setImage:image(@"icon_liveGiftSelectedImg") forState:UIControlStateSelected];
        [countBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [countBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [_sendBackView addSubview:countBtn];
        [countBtn setEnlargeEdge:kUI_Width(10)];
        _countBtn = countBtn;
        [[countBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            x.selected = YES;
            [x layoutIfNeeded];
            CGRect newRect =[weakSelf.sendBackView convertRect:x.frame toView:weakSelf];
//            CGRect newRect = [x convertRect:x.frame toView:weakSelf];
            LCLiveGiftSelectView *selectView = [[LCLiveGiftSelectView alloc] initWithFrame:weakSelf.bounds contentOrigin:CGPointMake(newRect.origin.x + x.width, newRect.origin.y - kUI_Width(9))  titles:@[@"1",@"10",@"66",@"88",@"100",@"520",@"1314"]];
            selectView.selectBlock = ^(NSString * _Nonnull selectTitle) {
                weakSelf.countLabel.text = selectTitle;
            };
            selectView.dismissBlock = ^{
                weakSelf.countBtn.selected = NO;
            };
            [weakSelf addSubview:selectView];
        }];

        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setBackgroundImage:image(@"icon_liveGiftSendBtnBg") forState:UIControlStateNormal];
        [sendBtn setTitle:KLanguage(@"赠送") forState:UIControlStateNormal];
        [sendBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        sendBtn.titleLabel.font = MediumFont(14);
        [_bottomView addSubview:sendBtn];
      
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(!weakSelf.viewModel.selectGiftModel){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请选择礼物")];
                return;
            }
            if([weakSelf.viewModel.selectGiftModel.type integerValue] != 1 && !weakSelf.countLabel.text.length){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请选择数量")];
                return;
            }
            [weakSelf.viewModel.sendGiftCommand execute:[RACTuple tupleWithObjects:weakSelf.viewModel.selectGiftModel,weakSelf.countLabel.text, nil]];
            
        }];
        
        [_balanaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.right.mas_lessThanOrEqualTo(rechargeBtn.mas_left).offset(-kUI_Width(10));
            make.centerY.equalTo(rechargeBtn.mas_centerY);
        }];
        [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(80));
            make.left.equalTo(kUI_Width(123));
            make.top.equalTo(0);
        }];
        [sendBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(130));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
        }];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.bottom.equalTo(0);
            make.width.lessThanOrEqualTo(kUI_Width(25));
        }];
        [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(countLabel.mas_right).offset(kUI_Width(5));
            make.width.equalTo(kUI_Width(11));
            make.height.equalTo(kUI_Width(10));
            make.centerY.equalTo(0);
        }];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(sendBackView.mas_right);
            make.width.equalTo(kUI_Width(60));
            make.height.mas_equalTo(sendBackView.mas_height);
            make.top.mas_equalTo(sendBackView.mas_top);
        }];
        
    }
    return _bottomView;
}
- (LCLiveRoomGiftListViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCLiveRoomGiftListViewModel new];
        
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
