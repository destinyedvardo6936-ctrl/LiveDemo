//
//  LCLiveGamesSelectView.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/3.
//

#import "LCLiveGamesSelectView.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorImageView.h>
#import <JXPagerView.h>
#import "LCLiveGameListView.h"


@interface LCLiveGamesSelectView ()<JXPagerViewDelegate,JXCategoryViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic , weak) UIView *contentView;

@property (nonatomic , weak) JXPagerView *pagerView;
@property (nonatomic , strong) JXCategoryTitleView *segmentControl;

@property (nonatomic , weak) UIView *bottomView;
@property (nonatomic , weak) UILabel *balanceLabel;
@property (nonatomic , weak) UIButton *chargeBtn;
@property (nonatomic , weak) UIButton *gameCenterBtn;

@property (nonatomic , strong) LCLiveGameTypeViewModel *viewModel;
@end
@implementation LCLiveGamesSelectView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(KSafeHeight + kUI_Width(400) );
        }];
//        [self.contentView layoutIfNeeded];
//        [self.contentView acs_radiusWithRadius:kUI_Width(16) corner:UIRectCornerTopLeft|UIRectCornerTopRight frame:self.contentView.bounds];
//        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(kUI_Width(25));
//            make.top.equalTo(kUI_Width(18));
//            make.left.right.equalTo(0);
//        }];
        [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-kUI_Width(20));
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(24));
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(28));
        }];
        

        @weakify(self)
        [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            
    //        self.loadingView.hidden = YES;
            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
          
            self.segmentControl.titles = self.viewModel.titleArray;
            [self.segmentControl reloadData];
            [self.pagerView reloadData];
            
            
            
        }];
        [[self.viewModel.balanceSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            
            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:KLanguage(@"余额：") attributes:@{NSForegroundColorAttributeName:Color(@"#FFFFFF")}];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:self.viewModel.balanceStr attributes:@{NSForegroundColorAttributeName:Color(@"#F6E23B")}]];
            
            self.balanceLabel.attributedText = att;
           
            
        }];
        [self.viewModel.loadDataCommend execute:@(YES)];
        [self.viewModel.balanceCommand execute:@(YES)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonWithButton)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)leftButtonWithButton{
    if(self.dismissBlock){
        self.dismissBlock();
    }
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
    
        return NO;
    }
    
    return YES;
}
#pragma mark---- JXPagerViewDelegate ----
/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView{
    return 0;
}

/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    return kUI_Width(18) + kUI_Width(25);
}

/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, kUI_Width(18)+kUI_Width(25))];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kUI_Width(25));
                    make.top.equalTo(kUI_Width(18));
                    make.left.right.equalTo(0);
    }];
    return view;
}

/**
 返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView{
    return self.segmentControl.titles.count;
}

/**
 根据index初始化一个对应列表实例，需要是遵从`JXPagerViewListViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
 注意：一定要是新生成的实例！！！

 @param pagerView pagerView description
 @param index index description
 @return 新生成的列表实例
 */
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index{
    LCLiveGameListView *listView = [[LCLiveGameListView alloc]init];
    listView.isFromVideo = self.isFromVideo;
    listView.dataModel = self.viewModel.dataArray[index];
    return listView;
}
#pragma mark---- 懒加载 ----
- (UIView *)contentView{
    if (!_contentView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:view];
        view.layer.cornerRadius = kUI_Width(16);
        view.backgroundColor = ColorAlpha(@"#000000", 0.7);
        _contentView = view;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}
- (JXPagerView *)pagerView{
    if (_pagerView == nil) {
        JXPagerView *view = [[JXPagerView alloc]initWithDelegate:self listContainerType:JXPagerListContainerType_CollectionView];
        _pagerView = view;
        _pagerView.automaticallyDisplayListVerticalScrollIndicator = NO;
        _pagerView.backgroundColor = [UIColor clearColor];
        _pagerView.mainTableView.backgroundColor = [UIColor clearColor];
        _pagerView.listContainerView.listCellBackgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_pagerView];
    }
    return _pagerView;
}
- (JXCategoryTitleView *)segmentControl{
    if (_segmentControl == nil) {
        JXCategoryTitleView *view = [[JXCategoryTitleView alloc]initWithFrame:CGRectZero];
        _segmentControl = view;
        _segmentControl.tag = 200;
        _segmentControl.delegate = self;

        _segmentControl.contentEdgeInsetLeft = kUI_Width(18);
        _segmentControl.contentEdgeInsetRight = kUI_Width(18);
        
        _segmentControl.titleFont = RegularFont(18);
        _segmentControl.titleSelectedFont = MediumFont(18);
        _segmentControl.titleColor = Color(@"#CCCCCC");
        _segmentControl.titleSelectedColor = Color(@"#FFFFFF");
        _segmentControl.titleColorGradientEnabled = YES;

        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleCenter;
        _segmentControl.titleLabelVerticalOffset = -kUI_Width(4);
       
        _segmentControl.titleColorGradientEnabled = YES;
//        _segmentControl.cellSpacing = kUI_Width(12);
                _segmentControl.averageCellSpacingEnabled = YES;
        JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
        lineView.indicatorImageView.image = image(@"icon_segmentLine");
        lineView.indicatorImageViewSize = CGSizeMake(kUI_Width(20), kUI_Width(4));
        lineView.indicatorWidth = kUI_Width(20) ;
        lineView.indicatorHeight = kUI_Width(4);

        lineView.indicatorCornerRadius =kUI_Width(4)/2.0;
        _segmentControl.indicators = @[lineView];
         
        _segmentControl.backgroundColor = [UIColor clearColor];
//        [self.categoryBackView addSubview:_categoryView];
        _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
        
//        _segmentControl.collectionView.scrollEnabled = NO;
        
    }
    return _segmentControl;
}
- (UIView *)bottomView{
    if(!_bottomView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:view];
        _bottomView = view;
        UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        balanceLabel.font = MediumFont(14);
//        balanceLabel.textColor = Color(@"#FFFFFF");
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:KLanguage(@"余额：") attributes:@{NSForegroundColorAttributeName:Color(@"#FFFFFF")}];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"0" attributes:@{NSForegroundColorAttributeName:Color(@"#F9E43B")}]];
        balanceLabel.attributedText = att;
        [_bottomView addSubview:balanceLabel];
        _balanceLabel = balanceLabel;
        
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshBtn setImage:image(@"icon_gameRefreshBalanceImg") forState:UIControlStateNormal];
        [_bottomView addSubview:refreshBtn];
        WS(weakSelf)
        [[refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.viewModel.balanceCommand execute:@(YES)];
        }];
        UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechargeBtn setBackgroundImage:image(@"icon_liveGameRechargeBtnBg") forState:UIControlStateNormal];
        [rechargeBtn setTitle:KLanguage(@"充值") forState:UIControlStateNormal];
        [rechargeBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        rechargeBtn.titleLabel.font = MediumFont(14);
        [_bottomView addSubview:rechargeBtn];
       
        [[rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.rechageClickBlock){
                weakSelf.rechageClickBlock();
            }
        }];
        
        
        

        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setBackgroundImage:image(@"icon_liveGameCenterBg") forState:UIControlStateNormal];
        [sendBtn setTitle:KLanguage(@"游戏中心") forState:UIControlStateNormal];
        [sendBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        sendBtn.titleLabel.font = MediumFont(14);
        [_bottomView addSubview:sendBtn];
      
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.gameCenterClickBlock){
                weakSelf.gameCenterClickBlock();
            }
            
        }];
        
        [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.right.mas_lessThanOrEqualTo(refreshBtn.mas_left).offset(-kUI_Width(10));
            make.centerY.equalTo(rechargeBtn.mas_centerY);
        }];
        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(16));
            make.right.mas_equalTo(rechargeBtn.mas_left).offset(-kUI_Width(12));
            make.centerY.equalTo(rechargeBtn.mas_centerY);
        }];
        [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(61));
            make.left.equalTo(kUI_Width(167));
            make.top.equalTo(0);
        }];
        
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.width.equalTo(kUI_Width(81));
            make.height.equalTo(kUI_Width(28));
            make.centerY.equalTo(0);
        }];
        
    }
    return _bottomView;
}
- (LCLiveGameTypeViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCLiveGameTypeViewModel new];
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
