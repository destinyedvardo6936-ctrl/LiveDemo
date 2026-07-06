//
//  LCGamePlayViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCLotteryTicketPlayViewController.h"
#import <JXPagerListRefreshView.h>
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorImageView.h>
#import "LCLotteryTicketPlaySubViewController.h"
#import "LCLotteryTicketPlayViewModel.h"
#import "LCGameOptionView.h"
#import "LCGameTipViewController.h"
#import "LCBettingRecordViewController.h"
#import "LCGameWinningHistoryViewController.h"
#import "LCRechageViewController.h"
#import "LCLotteryTicketCoinView.h"
#import "LCLotteryTicketConfimView.h"
@interface LCLotteryTicketPlayViewController ()<JXPagerViewDelegate,JXCategoryViewDelegate,JXCategoryTitleViewDataSource,UITextFieldDelegate>
@property (nonatomic , weak) JXPagerListRefreshView *pagerView;
@property (nonatomic , strong) JXCategoryTitleView *segmentControl;

@property (nonatomic , strong) UIView *kaijiangView;
@property (nonatomic , weak) UIView *lineView;
@property (nonatomic , weak) UILabel *kjqhLabel;//开奖期号
@property (nonatomic , weak) UILabel *kjqhTipLabel;//开奖期号
@property (nonatomic , weak) UIView *resultView;
@property (nonatomic , weak) UILabel *fpqhLabel;//封盘期号
@property (nonatomic , weak) UILabel *fpqhTipLabel;
@property (nonatomic , weak) UILabel *timeLabel;

@property (nonatomic , weak) UIView *bottomView;
@property (nonatomic , weak) LCLotteryTicketCoinView *coinView;
@property (nonatomic , weak) UILabel *bettingLabel;
@property (nonatomic , weak) UILabel *moneyLabel;
@property (nonatomic , weak) UILabel *balanceLabel;
@property (nonatomic, weak) UIButton *moneyBtn;
@property (nonatomic , weak) UITextField *moneyTextField;
@property (nonatomic , strong) LCLotteryTicketPlayViewModel *viewModel;

@end

@implementation LCLotteryTicketPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    self.needHiddenInteractivePopGestureRecognizer = YES;
    [self.navView setLeftButtonType: LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:self.dataModel.name];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:image(@"icon_lotteryTickOptionBtnImg") forState:UIControlStateNormal];
    [rightBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.navView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(12));
        make.width.height.equalTo(kUI_Width(20));
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - kUI_Width(20))/2.0);
    }];
    WS(weakSelf)
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        LCGameOptionView *view = [[LCGameOptionView alloc]initWithFrame:weakSelf.view.bounds];
        view.btnClickBlock = ^(NSInteger index) {
            if(index == 0){
                LCGameTipViewController *con = [LCGameTipViewController new];
                con.contentStr = weakSelf.dataModel.content;
                [weakSelf pushToViewController:con];
            }else if (index == 1){
                LCBettingRecordViewController *con = [LCBettingRecordViewController new];
                con.biaoshi = weakSelf.dataModel.biaoshi;
                [weakSelf pushToViewController:con];
            }else if (index == 2){
                LCGameWinningHistoryViewController *con = [LCGameWinningHistoryViewController new];
                con.biaoshi = weakSelf.dataModel.biaoshi;
                [weakSelf pushToViewController:con];
            }else{
                LCRechageViewController *con = [LCRechageViewController new];
                con.needBack = YES;
                [weakSelf pushToViewController:con];
            }
            
            
        };
        [weakSelf.view addSubview:view];
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(KSafeHeight + kUI_Width(40) + kUI_Width(12) + kUI_Width(12) +kUI_Width(5) + kUI_Width(30) * 2);
    }];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
}
- (void)popBack{
    [self.viewModel.closeSocketCommand execute:@(YES)];
    [super popBack ];
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        [self.viewModel.socketInfoCommand execute:@(YES)];
        self.segmentControl.titles = self.viewModel.wanfaSegArr;
        [self.viewModel.changeWanfaSegCommand execute:@(self.segmentControl.defaultSelectedIndex)];
       
        [self.segmentControl reloadData];
        [self.pagerView reloadData];
        self.coinView.dataArray = self.viewModel.dataModel.coinimg;
        
        
    }];
    [[RACObserve(self.viewModel, sqkj) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LCLotteryTicketSQKJModel *  _Nullable x) {
       @strongify(self)
        if (!x.expect.length) {
            self.kjqhLabel.text = nil;
        }
        self.kjqhLabel.text = [NSString stringWithFormat:@"%@%@",x.expect,KLanguage(@"期")];
        [self.resultView removeAllSubviews];
        NSArray *numA= [x.opencode componentsSeparatedByString:@","];
        [self.resultView layoutIfNeeded];
        CGFloat space = numA.count > 6 ? kUI_Width(2):kUI_Width(4);
        CGFloat width = ((self.resultView.width  - space * (numA.count - 1 ))/numA.count);
        if(width > kUI_Width(25)){
            width = kUI_Width(25);
        }
//        CGFloat width = ((self.resultView.width  - kUI_Width(4) * (numA.count - 1 )/numA.count)>kUI_Width(25))? kUI_Width(25) :(self.resultView.width  - kUI_Width(4) * (numA.count - 1 )/numA.count);
        for (NSInteger i = (numA.count - 1) ; i>=0; i--) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            if (![numA[i] isEqualToString:@"+"]){
                int x = arc4random() % 3;
                if (x==0) {
                    label.backgroundColor= RGB(91, 186, 40);
                }else if (x==1){
                    label.backgroundColor=RGB(80, 177, 240);
                }else{
                    label.backgroundColor=RGB(231, 86, 95);
                }
                
            }else{
                
            }

            label.layer.masksToBounds=YES;
            label.layer.cornerRadius= width/2.0;
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor whiteColor];
            label.text=numA[i];
            CGFloat right =  width *(numA.count - 1 - i)  + space * (numA.count - 1 - i);
            [self.resultView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-right);
                make.centerY.equalTo(0);
                make.height.equalTo(width);
                make.width.equalTo(width);
            }];
        }
    }];
    [[RACObserve(self.viewModel, customZhuMoneyStr) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if(!x){
            [self.moneyBtn setTitle:KLanguage(@"请输入金额") forState:UIControlStateNormal];
            [self.moneyBtn setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
            self.moneyBtn.titleLabel.font = RegularFont(14);
        }else{
            [self.moneyBtn setTitle:x forState:UIControlStateNormal];
            [self.moneyBtn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
            self.moneyBtn.titleLabel.font = MediumFont(14);
        }
    }];
     [[[RACObserve(self.viewModel, nowQihaoStr) map:^NSString *_Nullable (NSString *_Nullable value) {
        if (!value.length) {
            return nil;
        }
        return [NSString stringWithFormat:@"%@%@",value,KLanguage(@"期")];
    }] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        self.fpqhLabel.text = x;
    }] ;
//    RAC(self.kjqhLabel, text) = [[RACObserve(self.viewModel.sqkj, expect) map:^NSString *_Nullable (NSString *_Nullable value) {
//        if (!value.length) {
//            return nil;
//        }
//        return [NSString stringWithFormat:@"%@%@",value,KLanguage(@"期")];
//    }] takeUntil:self.rac_willDeallocSignal];
    [[[RACObserve(self.viewModel, cutDownTimeStr) map:^NSString *_Nullable (NSString *_Nullable value) {
            if (!value.length) {
                return nil;
            }
        if([value integerValue]<=10){
            return  KLanguage(@"封盘中");
        }
            NSInteger minute1 = value.integerValue / 60;
            NSInteger seconds1 = value.integerValue % 60;
            NSString * text =  [NSString stringWithFormat:@"%02ld:%02ld", (long)minute1, seconds1];
            return text;
    }] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        self.timeLabel.text = x;
    }] ;
    
    
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, xiazhuCount),RACObserve(self.viewModel, customZhuMoneyStr),RACObserve(self.viewModel, coinModel)]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
        NSInteger count = [x[0] integerValue];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",count] attributes:@{NSForegroundColorAttributeName:Color(@"#FF2A2A")}];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:KLanguage(@"注") attributes:@{NSForegroundColorAttributeName:Color(@"#666666")}]];
        self.bettingLabel.attributedText = att;
        NSString *price = x[1];
        if(price.length){
            NSString *totalPrice = [NSString stringWithFormat:@"%ld",[price integerValue] * count] ;
            NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc]initWithString:totalPrice attributes:@{NSForegroundColorAttributeName:Color(@"#FF2A2A")}];
            NSTextAttachment *ach = [[NSTextAttachment alloc]init];
            ach.image = image(@"icon_lotteryTicketZSCoinImg");
            ach.bounds = CGRectMake(0, -(kUI_Width(12) - kUI_Width(11))/2.0, kUI_Width(14), kUI_Width(11));
            
            [att1 appendAttributedString:[NSAttributedString attributedStringWithAttachment:ach]];
            self.moneyLabel.attributedText = att1;
        }else{
            NSString *totalPrice = [NSString stringWithFormat:@"%ld",[self.viewModel.coinModel.coin integerValue] * count] ;
            NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc]initWithString:totalPrice attributes:@{NSForegroundColorAttributeName:Color(@"#FF2A2A")}];
            NSTextAttachment *ach = [[NSTextAttachment alloc]init];
            ach.image = image(@"icon_lotteryTicketZSCoinImg");
            ach.bounds = CGRectMake(0, -(kUI_Width(12) - kUI_Width(11))/2.0, kUI_Width(14), kUI_Width(11));
            
            [att1 appendAttributedString:[NSAttributedString attributedStringWithAttachment:ach]];
            self.moneyLabel.attributedText = att1;
//            NSInteger totalPrice = 0;
//            for (lc in <#collection#>) {
//                <#statements#>
//            }
        }
        
    }];
    
    [self.viewModel.loadDataCommend execute:@(YES)];
}
#pragma mark----JXPagerViewDelegate---

/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView{
   
    return  0 ;
}

/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView{
   
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
   
    return view;
}

/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    return kUI_Width(42)+kUI_Width(6)+kUI_Width(74);

}

/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, kUI_Width(42)+kUI_Width(6)+kUI_Width(74))];
    view.backgroundColor = Color(@"#FFFFFF");
    [view addSubview:self.segmentControl];
    [self.segmentControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kUI_Width(10));
        make.height.equalTo(kUI_Width(14)+kUI_Width(4)+kUI_Width(4));
        make.left.right.equalTo(0);
    }];
    UIView *sepView = [[UIView alloc]initWithFrame:CGRectZero];
    sepView.backgroundColor = self.view.backgroundColor;
    [view addSubview:sepView];
    [sepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(kUI_Width(42));
        make.height.equalTo(kUI_Width(6));
    }];
    [view addSubview:self.kaijiangView];
    [self.kaijiangView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(kUI_Width(42)+kUI_Width(6));
        make.height.equalTo(kUI_Width(74));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(1);
        make.height.equalTo(kUI_Width(61));
        make.centerY.equalTo(0);
        make.centerX.equalTo(0);
    }];
    [self.kjqhLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.kjqhTipLabel.mas_left).offset(-kUI_Width(9));
        make.height.equalTo(kUI_Width(14));
        make.left.equalTo(kUI_Width(12));
        make.top.equalTo(kUI_Width(16));
        
    }];
    [self.kjqhTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(kUI_Width(60));
        make.height.equalTo(kUI_Width(14));
        make.right.mas_equalTo(self.lineView.mas_left).offset(-kUI_Width(8));
        make.top.equalTo(kUI_Width(16));
        
    }];
    [self.resultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView.mas_left).offset(-kUI_Width(5));
        make.left.equalTo(kUI_Width(12));
        make.top.mas_equalTo(self.kjqhLabel.mas_bottom).offset(kUI_Width(12));
        make.height.equalTo(kUI_Width(16));
    }];
    [self.fpqhLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right).offset(kUI_Width(12));
        make.height.equalTo(kUI_Width(14));
        make.top.equalTo(kUI_Width(16));
        make.right.mas_equalTo(self.fpqhTipLabel.mas_left).offset(-kUI_Width(12));
    }];
    [self.fpqhTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kUI_Width(16));
        make.height.equalTo(kUI_Width(14));
        make.right.equalTo(-kUI_Width(12));
        make.width.lessThanOrEqualTo(kUI_Width(50));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(12));
        make.height.equalTo(kUI_Width(14));
        make.top.mas_equalTo(self.fpqhLabel.mas_bottom).offset(kUI_Width(12));
    }];
    return  view;
    
  
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
    
    
    LCLotteryTicketPlaySubViewController *con = [LCLotteryTicketPlaySubViewController new];
//    con.type = index;
    con.dataArray = [self.viewModel getWanfaArrWithTitle: self.segmentControl.titles[index]];
   
    
    
    return con;
}
#pragma mark----JXCategoryTitleViewDataSource----
// 如果将JXCategoryTitleView嵌套进UITableView的cell，每次重用的时候，JXCategoryTitleView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该代理方法返回给JXCategoryTitleView。
// 如果实现了该方法就以该方法返回的宽度为准，不触发内部默认的文字宽度计算。
- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title{

    return  [title sizeForFont:titleView.titleSelectedFont size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping].width;

}
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.viewModel.changeWanfaSegCommand execute:@(self.segmentControl.defaultSelectedIndex)];

}


- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.segmentControl.collectionView.panGestureRecognizer) {
        return NO;
    }

    if ([otherGestureRecognizer.view.findViewController isKindOfClass:[UIPageViewController class]]) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark---- 懒加载 ----
- (JXPagerListRefreshView *)pagerView{
    if (_pagerView == nil) {
        JXPagerListRefreshView *view = [[JXPagerListRefreshView alloc]initWithDelegate:self listContainerType:JXPagerListContainerType_CollectionView];
        _pagerView = view;
        _pagerView.automaticallyDisplayListVerticalScrollIndicator = NO;

        [self.view addSubview:_pagerView];
    }
    return _pagerView;
}
- (JXCategoryTitleView *)segmentControl{
    if (_segmentControl == nil) {
        JXCategoryTitleView *view = [[JXCategoryTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, kUI_Width(32))];
        _segmentControl = view;
        _segmentControl.tag = 200;
        _segmentControl.delegate = self;
        _segmentControl.collectionView.scrollEnabled = NO;
        _segmentControl.titleDataSource = self;
        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleCenter;
        _segmentControl.titleLabelVerticalOffset = -kUI_Width(3);
        _segmentControl.titleFont = RegularFont(14);
        _segmentControl.titleSelectedFont = BoldFont(14);
        _segmentControl.titleColor = Color(@"#333333");
        _segmentControl.titleSelectedColor = Color(@"#333333");
        _segmentControl.titleColorGradientEnabled = YES;


        _segmentControl.averageCellSpacingEnabled = YES;
        JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
        lineView.indicatorImageView.image = image(@"icon_segmentLine");
        lineView.indicatorImageViewSize = CGSizeMake(kUI_Width(20), kUI_Width(4));
        lineView.indicatorWidth = kUI_Width(20) ;
        lineView.indicatorHeight = kUI_Width(4);

        lineView.indicatorCornerRadius =kUI_Width(4)/2.0;
        _segmentControl.indicators = @[lineView];
         
        _segmentControl.backgroundColor = Color(@"#FFFFFF");

        _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
        
        _segmentControl.collectionView.scrollEnabled = NO;
        
    }
    return _segmentControl;
}
- (UIView *)kaijiangView{
    if(!_kaijiangView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        _kaijiangView = view;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = Color(@"#F2F2F6");
        [_kaijiangView addSubview:lineView];
        _lineView = lineView;
        
        UILabel *kjqhLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        kjqhLabel.font = RegularFont(14);
        kjqhLabel.textColor = Color(@"#333333");
        [_kaijiangView addSubview:kjqhLabel];
        _kjqhLabel = kjqhLabel;
        UILabel *kjqhTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        kjqhTipLabel.font = RegularFont(14);
        kjqhTipLabel.textColor = Color(@"#333333");
        kjqhTipLabel.text = KLanguage(@"已开奖");
        [kjqhTipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [kjqhTipLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_kaijiangView addSubview:kjqhTipLabel];
        _kjqhTipLabel = kjqhTipLabel;
        UIView *resultView = [[UIView alloc]initWithFrame:CGRectZero];
        resultView.backgroundColor = [UIColor clearColor];
        [_kaijiangView addSubview:resultView];
        _resultView = resultView;
        UILabel *fpqhLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        fpqhLabel.font = RegularFont(14);
        fpqhLabel.textColor = Color(@"#333333");
        [_kaijiangView addSubview:fpqhLabel];
        _fpqhLabel = fpqhLabel;
        UILabel *fpqhTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        fpqhTipLabel.font = RegularFont(14);
        fpqhTipLabel.textColor = Color(@"#333333");
        fpqhTipLabel.text = KLanguage(@"封盘");
        [_kaijiangView addSubview:fpqhTipLabel];
        _fpqhTipLabel = fpqhTipLabel;
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        timeLabel.font = MediumFont(14);
        timeLabel.textColor = Color(@"#333333");
        [_kaijiangView addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    return _kaijiangView;
}
- (UIView *)bottomView{
    if(!_bottomView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        _bottomView = view;
        LCLotteryTicketCoinView *coinView = [[LCLotteryTicketCoinView alloc]initWithFrame:CGRectZero];
        WS(weakSelf)
        coinView.coinSelectBlock = ^(LCLotteryTicketCoinModel * _Nonnull model) {
            [weakSelf.viewModel.selectCoinCommand execute:model];
        };
        [_bottomView addSubview:coinView];
        _coinView = coinView;
        
        UILabel *bettingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        bettingLabel.font = BoldFont(12);
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:@"0" attributes:@{NSForegroundColorAttributeName:Color(@"#FF2A2A")}];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:KLanguage(@"注") attributes:@{NSForegroundColorAttributeName:Color(@"#666666")}]];
        
        bettingLabel.attributedText = att;
        [_bottomView addSubview:bettingLabel];
        _bettingLabel = bettingLabel;
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        moneyLabel.font = BoldFont(12);
        NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc]initWithString:@"0" attributes:@{NSForegroundColorAttributeName:Color(@"#FF2A2A")}];
        NSTextAttachment *ach = [[NSTextAttachment alloc]init];
        ach.image = image(@"icon_lotteryTicketZSCoinImg");
        ach.bounds = CGRectMake(0, -(kUI_Width(12) - kUI_Width(11)), kUI_Width(14), kUI_Width(11));
        
        [att1 appendAttributedString:[NSAttributedString attributedStringWithAttachment:ach]];
        
        moneyLabel.attributedText = att1;
        [_bottomView addSubview:moneyLabel];
        _moneyLabel = moneyLabel;
        
        UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        balanceLabel.font = BoldFont(12);
        NSMutableAttributedString *att3 = [[NSMutableAttributedString alloc]initWithString:KLanguage(@"账户剩余：") attributes:@{NSForegroundColorAttributeName:Color(@"#666666")}];
        [att3 appendAttributedString:[[NSAttributedString alloc]initWithString:[LCUserInfoManager shareManager].userInfo.coin attributes:@{NSForegroundColorAttributeName:Color(@"#FF2A2A")}]];
        
        balanceLabel.attributedText = att3;
        [_bottomView addSubview:balanceLabel];
        _balanceLabel = balanceLabel;
        UIView *bView = [[UIView alloc]initWithFrame:CGRectZero];
        bView.backgroundColor = Color(@"#FFFFFF");
        [_bottomView addSubview:bView];
        UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [firstBtn setImage:image(@"icon_gameJixuanImg") forState:UIControlStateNormal];
        [firstBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [firstBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [bView addSubview:firstBtn];
       
        [[firstBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.viewModel.jixuanCommand execute:@(YES)];
        }];
        UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [secondBtn setImage:image(@"icon_gameJixuanResetImg") forState:UIControlStateNormal];
        [secondBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [secondBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [bView addSubview:secondBtn];
        [[secondBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
          
            [weakSelf.viewModel.clearSelectCommand execute:@(YES)];
        }];
        
        UIView *textBackView = [[UIView alloc]initWithFrame:CGRectZero];
        textBackView.backgroundColor = Color(@"#E6E8EB");
        textBackView.layer.cornerRadius = kUI_Width(26)/2.0;
        [bView addSubview:textBackView];
        UIButton *textField = [[UIButton alloc]initWithFrame:CGRectZero];
        textField.backgroundColor = [UIColor clearColor];
        [textField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [textField setTitle:KLanguage(@"请输入金额") forState:UIControlStateNormal];
        [textField setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
        
        textField.titleLabel.font = RegularFont(14);
//        textField.titleLabel.textAlignment = NSTextAlignmentRight;
       
//        textField.layer.cornerRadius = kUI_Width(26)/2.0;
        [textBackView addSubview:textField];
        _moneyBtn = textField;
        [[textField rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:KLanguage(@"请填写单注金额") preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KLanguage(@"取消")
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *_Nonnull action) {
            }];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:KLanguage(@"确定")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action) {
                [weakSelf.viewModel.customZhuMoneyCommand execute:weakSelf.moneyTextField.text];
               
                
            }];

            [alertController addAction:okAction];
            [alertController addAction:cancelAction];

            // 添加文本框(只能添加到UIAlertControllerStyleAlert的样式，如果是preferredStyle:UIAlertControllerStyleActionSheet则会崩溃)
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                weakSelf.moneyTextField = textField;
                textField.placeholder = KLanguage(@"请填写单注金额");
                textField.keyboardType = UIKeyboardTypeNumberPad;
            // 监听文字改变的方法，也可以通过通知
                [[textField.rac_textSignal takeUntil:weakSelf.rac_willDeallocSignal] subscribeNext:^(NSString *_Nullable x) {
                    okAction.enabled = x.length > 0 ? YES : NO;
                }];
            }];

            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }];
        
        
//        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
//        textField.backgroundColor = [UIColor clearColor];
//        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入金额") attributes:@{NSFontAttributeName:RegularFont(14),NSForegroundColorAttributeName:Color(@"#666666")}];
//        textField.font = MediumFont(14);
//        textField.textColor = Color(@"#333333");
//        textField.delegate = self;
////        textField.layer.cornerRadius = kUI_Width(26)/2.0;
//        [textBackView addSubview:textField];
//        _moneyTextField = textField;
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setBackgroundColor:Color(@"#EF3E8C")];
        sendBtn.layer.cornerRadius = kUI_Width(4);
        [sendBtn setTitle:KLanguage(@"提交") forState:UIControlStateNormal];
        [sendBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        sendBtn.titleLabel.font = RegularFont(14);
        [bView addSubview:sendBtn];
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(!weakSelf.viewModel.wanfaSelectArr.count){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"当前没有投注信息，请先下注")];
                return;
            }
            if(!weakSelf.viewModel.customZhuMoneyStr.length && !weakSelf.viewModel.coinModel){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请输入或选择金额")];
                return;
            }
//            for (LCLotteryTicketWanFaModel *m in weakSelf.viewModel.wanfaSelectArr) {
//                m.gameName = weakSelf.viewModel.originModel.name;
//                m.coin = weakSelf.moneyTextField.text.length? weakSelf.moneyTextField.text:weakSelf.viewModel.coinModel.coin;
//            }
            LCLotteryTicketConfimView *confirmView = [[LCLotteryTicketConfimView alloc]initWithFrame:weakSelf.view.bounds];
            confirmView.wanfaSelectArr = weakSelf.viewModel.wanfaSelectArr;
            [weakSelf.view addSubview:confirmView];
        }];
        [coinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(5));
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(30));
        }];
        [bettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(5) +kUI_Width(30) * 2);
            
        }];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(5)+kUI_Width(30) * 2);
            make.left.mas_equalTo(bettingLabel.mas_right).offset(kUI_Width(12));
        }];
        [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(5)+kUI_Width(30) * 2);
        }];
        [bView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bettingLabel.mas_bottom).offset(kUI_Width(12));
            make.left.right.bottom.equalTo(0);
        }];
        [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(10));
            make.width.height.equalTo(kUI_Width(20));
        }];
        [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(10));
            make.width.height.equalTo(kUI_Width(20));
            make.left.mas_equalTo(firstBtn.mas_right).offset(kUI_Width(12));
        }];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(50));
            make.height.equalTo(kUI_Width(27));
            make.right.equalTo(-kUI_Width(12));
            make.centerY.mas_equalTo(firstBtn.mas_centerY);
        }];
        [textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(secondBtn.mas_right).offset(kUI_Width(12));
            make.right.mas_equalTo(sendBtn.mas_left).offset(-kUI_Width(12));
            make.height.equalTo(kUI_Width(26));
            make.centerY.mas_equalTo(firstBtn.mas_centerY);
        }];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(13));
            make.right.equalTo(-kUI_Width(13));
            make.top.bottom.equalTo(0);
        }];
    }
    return _bottomView;
}
- (LCLotteryTicketPlayViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCLotteryTicketPlayViewModel new];
        _viewModel.originModel = self.dataModel;
    }
    return _viewModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
