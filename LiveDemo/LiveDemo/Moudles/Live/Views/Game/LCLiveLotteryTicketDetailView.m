//
//  LCLiveLotteryTicketDetailView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import <JXCategoryIndicatorBackgroundView.h>
#import <JXPagerListRefreshView.h>
#import "JXCategoryTitleBackgroundView.h"
#import "LCLiveLotteryTicketCoinView.h"
#import "LCLiveLotteryTicketDetailView.h"
#import "LCLiveLotteryTicketWanfaView.h"

#import "LCLotteryTicketConfimView.h"
@interface LCLiveLotteryTicketDetailView ()< JXCategoryViewDelegate, JXCategoryTitleViewDataSource, JXPagerViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIImageView *gameImgView;
@property (nonatomic, weak) UIView *resultView;
@property (nonatomic, weak) UILabel *qihaoLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) JXCategoryTitleBackgroundView *segmentControl;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) LCLiveLotteryTicketCoinView *coinView;
@property (nonatomic, weak) UILabel *balanceLabel;
@property (nonatomic, weak) UIButton *moneyBtn;
@property (nonatomic, weak) UITextField *moneyTextField;
//@property (nonatomic , weak) UIButton *chargeBtn;


@property (nonatomic, strong) LCLotteryTicketPlayViewModel *viewModel;
@end
@implementation LCLiveLotteryTicketDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(KSafeHeight + kUI_Width(420));
        }];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.height.equalTo(kUI_Width(136));
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-KSafeHeight);
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(5) + kUI_Width(25) + kUI_Width(30) + kUI_Width(28));
        }];
        [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.bottom.mas_equalTo(self.bottomView.mas_top);
        }];
        @weakify(self)
        [[RACObserve(self.viewModel, sqkj) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LCLotteryTicketSQKJModel *  _Nullable x) {
           @strongify(self)
            if (!x.expect.length) {
                self.qihaoLabel.text = nil;
            }
            self.qihaoLabel.text = [NSString stringWithFormat:@"%@%@",KLanguage(@"期号："),x.expect];
            [self.resultView removeAllSubviews];
            NSArray *numA= [x.opencode componentsSeparatedByString:@","];
            [self.resultView layoutIfNeeded];
            CGFloat width = ((self.resultView.width  - kUI_Width(4) * (numA.count - 1 )/numA.count)>kUI_Width(25))? kUI_Width(25) :(self.resultView.width  - kUI_Width(4) * (numA.count - 1 )/numA.count);
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
                label.layer.cornerRadius= kUI_Width(20)/2.0;
                label.textAlignment=NSTextAlignmentCenter;
                label.textColor=[UIColor whiteColor];
                label.text=numA[i];
                CGFloat right =  width *(numA.count - 1 - i)  + kUI_Width(4) * (numA.count - 1 - i);
                [self.resultView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(-right);
                    make.centerY.equalTo(0);
                    make.height.equalTo(kUI_Width(20));
                    make.width.equalTo(width);
                }];
            }
        }];
        [[RACObserve(self.viewModel, customZhuMoneyStr) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *  _Nullable x) {
            @strongify(self)
            if(!x){
                [self.moneyBtn setTitle:KLanguage(@"请输入金额") forState:UIControlStateNormal];
                [self.moneyBtn setTitleColor:Color(@"#959595") forState:UIControlStateNormal];
            }else{
                [self.moneyBtn setTitle:x forState:UIControlStateNormal];
                [self.moneyBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
            }
        }];
        RAC(self.timeLabel, attributedText) = [[RACObserve(self.viewModel, cutDownTimeStr) map:^NSAttributedString *_Nullable (NSString *_Nullable value) {
            if (!value.length) {
                return nil;
            }
            NSString * text = nil;
            if([value integerValue]<=10){
                text = KLanguage(@"封盘中");
            }else{
                NSInteger minute1 = value.integerValue / 60;
                NSInteger seconds1 = value.integerValue % 60;
                text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute1, seconds1];
            }
            
            NSMutableAttributedString *att =  [[NSMutableAttributedString alloc]initWithString:KLanguage(@"本期截止：")
                                                                                    attributes:@{ NSForegroundColorAttributeName: Color(@"#FFFFFF") }];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:text
                                                                       attributes:@{ NSForegroundColorAttributeName: Color(@"#54C23F") }]];
            return att.copy;
        }] takeUntil:self.rac_willDeallocSignal];
        RAC(self.balanceLabel, attributedText) = [[RACObserve(self.viewModel, balanceStr) map:^NSAttributedString *_Nullable (NSString *_Nullable value) {
            if (!value.length) {
                return nil;
            }

           
            NSMutableAttributedString *att =  [[NSMutableAttributedString alloc]initWithString:KLanguage(@"余额：")
                                                                                    attributes:@{ NSForegroundColorAttributeName: Color(@"#FFFFFF") }];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:value
                                                                       attributes:@{ NSForegroundColorAttributeName: Color(@"#F6E23B") }]];
            return att.copy;
        }] takeUntil:self.rac_willDeallocSignal];
        [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id _Nullable x) {
            @strongify(self)

            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }

            [self.gameImgView setImageStr:self.dataModel.icon];
            self.segmentControl.titles = self.viewModel.wanfaSegArr;

            [self.viewModel.changeWanfaSegCommand execute:@(self.segmentControl.defaultSelectedIndex)];

            [self.segmentControl reloadData];
            [self.pagerView reloadData];
            self.coinView.dataArray = self.viewModel.dataModel.coinimg;
        }];

        [self.viewModel.balanceCommand execute:@(YES)];
        [self.viewModel.loadDataCommend execute:@(YES)];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonWithButton)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }

    return self;
}
- (void)setIsFromVideo:(BOOL)isFromVideo{
    _isFromVideo = isFromVideo;
    if(_isFromVideo){
        [self.viewModel.socketInfoCommand execute:@(YES)];
    }
}
- (void)dealloc{
    if(_isFromVideo){
        [self.viewModel.closeSocketCommand execute:@(YES)];
    }
}
- (void)setDataModel:(LCGameListModel *)dataModel {
    _dataModel = dataModel;
    self.viewModel.originModel = _dataModel;
}

- (void)leftButtonWithButton {
    if (self.dismissBlock) {
        self.dismissBlock();
    }

    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }

    return YES;
}

#pragma mark----JXPagerViewDelegate---

/**
   返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 0;
}

/**
   返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, 0)];


    return view;
}

/**
   返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return kUI_Width(40)+kUI_Width(20);
}

/**
   返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, kUI_Width(40)+kUI_Width(20))];

//    view.backgroundColor = Color(@"#FFFFFF");
    [view addSubview:self.segmentControl];
    [self.segmentControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(kUI_Width(40));
        make.left.right.equalTo(0);
    }];

    return view;
}

/**
   返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
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
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    LCLiveLotteryTicketWanfaView *con = [[LCLiveLotteryTicketWanfaView alloc]init];

    con.dataArray = [self.viewModel getWanfaArrWithTitle:self.segmentControl.titles[index]];



    return con;
}

#pragma mark----JXCategoryTitleViewDataSource----
// 如果将JXCategoryTitleView嵌套进UITableView的cell，每次重用的时候，JXCategoryTitleView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该代理方法返回给JXCategoryTitleView。
// 如果实现了该方法就以该方法返回的宽度为准，不触发内部默认的文字宽度计算。
- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    return self.pagerView.width * 1.0 / titleView.titles.count;
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

   

    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark---- 懒加载 ----
- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:view];
        view.layer.cornerRadius = kUI_Width(16);
        view.backgroundColor = ColorAlpha(@"#000000", 0.7);
        _contentView = view;
        _contentView.clipsToBounds = YES;
    }

    return _contentView;
}

- (UIView *)topView {
    if (!_topView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:view];
        _topView = view;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_topView addSubview:imgView];
        _gameImgView = imgView;
        WS(weakSelf)
        UIButton *wanfaTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wanfaTipBtn setTitle:KLanguage(@"玩法说明") forState:UIControlStateNormal];
        [wanfaTipBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        wanfaTipBtn.titleLabel.font = RegularFont(12);
        wanfaTipBtn.layer.cornerRadius = kUI_Width(28) / 2.0;
        wanfaTipBtn.layer.borderWidth = 1;
        wanfaTipBtn.layer.borderColor = Color(@"#FFFFFF").CGColor;
        [_topView addSubview:wanfaTipBtn];
        [[wanfaTipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.btnClickBlock) {
                weakSelf.btnClickBlock(0,weakSelf.dataModel);
            }
           
        }];
        UIButton *xiazhuRecordTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [xiazhuRecordTipBtn setTitle:KLanguage(@"投注记录") forState:UIControlStateNormal];
        [xiazhuRecordTipBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        xiazhuRecordTipBtn.titleLabel.font = RegularFont(12);
        xiazhuRecordTipBtn.layer.cornerRadius = kUI_Width(28) / 2.0;
        xiazhuRecordTipBtn.layer.borderWidth = 1;
        xiazhuRecordTipBtn.layer.borderColor = Color(@"#FFFFFF").CGColor;
        [_topView addSubview:xiazhuRecordTipBtn];
            [[xiazhuRecordTipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (weakSelf.btnClickBlock) {
                    weakSelf.btnClickBlock(1,weakSelf.dataModel);
                }
               
            }];
        UIButton *historyTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [historyTipBtn setTitle:KLanguage(@"开奖记录") forState:UIControlStateNormal];
        [historyTipBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        historyTipBtn.titleLabel.font = RegularFont(12);
        historyTipBtn.layer.cornerRadius = kUI_Width(28) / 2.0;
        historyTipBtn.layer.borderWidth = 1;
        historyTipBtn.layer.borderColor = Color(@"#FFFFFF").CGColor;
        [_topView addSubview:historyTipBtn];
            [[historyTipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (weakSelf.btnClickBlock) {
                    weakSelf.btnClickBlock(2,weakSelf.dataModel);
                }
               
            }];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:image(@"icon_liveLotteryTicketDetailBackImg") forState:UIControlStateNormal];
        [backBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [_topView addSubview:backBtn];
        [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.backBlock) {
                weakSelf.backBlock();
            }
            [weakSelf removeFromSuperview];
        }];

        UILabel *qihaoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        qihaoLabel.font = RegularFont(14);
        qihaoLabel.textColor = Color(@"#FFFFFF");
        qihaoLabel.textAlignment = NSTextAlignmentRight;
        [_topView addSubview:qihaoLabel];
        _qihaoLabel = qihaoLabel;

        UILabel *resultTiplabel = [[UILabel alloc]initWithFrame:CGRectZero];
        resultTiplabel.text = KLanguage(@"开奖结果");
        resultTiplabel.textColor = Color(@"#FFFFFF");
        [resultTiplabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [resultTiplabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        resultTiplabel.font = RegularFont(14);
        [_topView addSubview:resultTiplabel];

        UIView *resultView = [[UIView alloc]initWithFrame:CGRectZero];
        [_topView addSubview:resultView];
        _resultView = resultView;
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        timeLabel.font = RegularFont(14);
        timeLabel.textColor = Color(@"#FFFFFF");
        [_topView addSubview:timeLabel];
        _timeLabel = timeLabel;

        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(60));
            make.left.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(20));
        }];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(24));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(kUI_Width(23));
        }];
        [historyTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(66));
            make.height.equalTo(kUI_Width(28));
            make.right.mas_equalTo(backBtn.mas_left).offset(-kUI_Width(17));
            make.centerY.mas_equalTo(backBtn.mas_centerY);
        }];
        [xiazhuRecordTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(66));
            make.height.equalTo(kUI_Width(28));
            make.right.mas_equalTo(historyTipBtn.mas_left).offset(-kUI_Width(12));
            make.centerY.mas_equalTo(historyTipBtn.mas_centerY);
        }];
        [wanfaTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(66));
            make.height.equalTo(kUI_Width(28));
            make.right.mas_equalTo(xiazhuRecordTipBtn.mas_left).offset(-kUI_Width(12));
            make.centerY.mas_equalTo(xiazhuRecordTipBtn.mas_centerY);
        }];
        [resultTiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backBtn.mas_bottom).offset(kUI_Width(10));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
        }];
        [qihaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(resultTiplabel.mas_left).offset(-kUI_Width(25));
            make.height.equalTo(kUI_Width(14));
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(12));
            make.centerY.mas_equalTo(resultTiplabel.mas_centerY);
        }];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.top.mas_equalTo(imgView.mas_bottom).offset(kUI_Width(23));
        }];
        [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(timeLabel.mas_right).offset(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(35));
            make.top.mas_equalTo(resultTiplabel.mas_bottom).offset(kUI_Width(6));
        }];
    }

    return _topView;
}

- (JXCategoryTitleBackgroundView *)segmentControl {
    if (_segmentControl == nil) {
        JXCategoryTitleBackgroundView *segmentView = [[JXCategoryTitleBackgroundView alloc]initWithFrame:CGRectZero];


        segmentView.contentEdgeInsetLeft = 0;
        segmentView.contentEdgeInsetRight = 0;
        segmentView.titleDataSource = self;
        segmentView.titleFont = RegularFont(14);
        segmentView.titleSelectedFont = RegularFont(14);
        segmentView.titleColor = Color(@"#FFFFFF");
        segmentView.titleSelectedColor = Color(@"#FFFFFF");

        segmentView.backgroundHeight = kUI_Width(40);

        segmentView.normalBackgroundColor = ColorAlpha(@"#000000", 0.5);
        segmentView.selectedBackgroundColor = ColorAlpha(@"#FF63A7", 1);
        segmentView.borderLineWidth = 0.0;
        segmentView.backgroundCornerRadius = 0;
        segmentView.cellSpacing = 0;
        segmentView.cellWidthIncrement = 0;

        segmentView.delegate = self;
        segmentView.averageCellSpacingEnabled = NO;

        _segmentControl = segmentView;
        _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
        _segmentControl.contentScrollView.scrollEnabled = NO;
    }

    return _segmentControl;
}

- (JXPagerListRefreshView *)pagerView {
    if (_pagerView == nil) {
        JXPagerListRefreshView *view = [[JXPagerListRefreshView alloc]initWithDelegate:self listContainerType:JXPagerListContainerType_CollectionView];
        _pagerView = view;
        _pagerView.automaticallyDisplayListVerticalScrollIndicator = NO;
        _pagerView.backgroundColor = [UIColor clearColor];
        _pagerView.mainTableView.backgroundColor = [UIColor clearColor];
        _pagerView.listContainerView.listCellBackgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_pagerView];
    }

    return _pagerView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:view];
        _bottomView = view;
        LCLiveLotteryTicketCoinView *coinView = [[LCLiveLotteryTicketCoinView alloc]initWithFrame:CGRectZero];
        WS(weakSelf)
        coinView.coinSelectBlock = ^(LCLotteryTicketCoinModel *_Nonnull model) {
            [weakSelf.viewModel.selectCoinCommand execute:model];
        };
        [_bottomView addSubview:coinView];
        _coinView = coinView;

        UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        balanceLabel.font = BoldFont(12);
        NSMutableAttributedString *att3 = [[NSMutableAttributedString alloc]initWithString:KLanguage(@"余额：") attributes:@{ NSForegroundColorAttributeName: Color(@"#FFFFFF") }];
        [att3 appendAttributedString:[[NSAttributedString alloc]initWithString:[LCUserInfoManager shareManager].userInfo.coin attributes:@{ NSForegroundColorAttributeName: Color(@"#F6E23B") }]];

        balanceLabel.attributedText = att3;
        [_bottomView addSubview:balanceLabel];
        _balanceLabel = balanceLabel;

        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshBtn setImage:image(@"icon_gameRefreshBalanceImg") forState:UIControlStateNormal];
        [_bottomView addSubview:refreshBtn];

        [[refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
            [weakSelf.viewModel.balanceCommand execute:@(YES)];
        }];
        UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechargeBtn setBackgroundImage:image(@"icon_liveLotteryTicketDetailBg") forState:UIControlStateNormal];
        [rechargeBtn setTitle:KLanguage(@"充值") forState:UIControlStateNormal];
        [rechargeBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        rechargeBtn.titleLabel.font = MediumFont(14);
        [_bottomView addSubview:rechargeBtn];

        [[rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
            if (weakSelf.rechageClickBlock) {
                weakSelf.rechageClickBlock();
            }
        }];
        UIImageView *textBackView = [[UIImageView alloc]initWithFrame:CGRectZero];
        textBackView.image = image(@"icon_liveLotteryTicketMoneyTextBg");
        textBackView.userInteractionEnabled = YES;
        [_bottomView addSubview:textBackView];
        UIButton *textField = [[UIButton alloc]initWithFrame:CGRectZero];
        textField.backgroundColor = [UIColor clearColor];
        [textField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [textField setTitle:KLanguage(@"请输入金额") forState:UIControlStateNormal];
        [textField setTitleColor:Color(@"#959595") forState:UIControlStateNormal];
        
        textField.titleLabel.font = RegularFont(10);
        textField.titleLabel.textAlignment = NSTextAlignmentRight;
       
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

            [weakSelf.findViewController presentViewController:alertController animated:YES completion:nil];
        }];
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setBackgroundImage:image(@"icon_liveLotteryTicketDetailBg") forState:UIControlStateNormal];

        [sendBtn setTitle:KLanguage(@"投注") forState:UIControlStateNormal];
        [sendBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        sendBtn.titleLabel.font = MediumFont(14);
        [textBackView addSubview:sendBtn];
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
            if(!weakSelf.viewModel.wanfaSelectArr.count){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"当前没有投注信息，请先下注")];
                return;
            }
            
            if(!weakSelf.viewModel.customZhuMoneyStr.length && !weakSelf.viewModel.coinModel){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请输入或选择金额")];
                return;
            }
            
            if(weakSelf.submitClickBlock){
                weakSelf.submitClickBlock(weakSelf.viewModel.wanfaSelectArr);
            }
            
            
        }];
        [coinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(5));
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(25));
        }];

        [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.top.equalTo(kUI_Width(5) + kUI_Width(30) * 2);
        }];
        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(16));
            make.right.mas_equalTo(rechargeBtn.mas_left).offset(-kUI_Width(12));
            make.centerY.equalTo(rechargeBtn.mas_centerY);
        }];
        [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(60));
            make.left.equalTo(kUI_Width(167));
            make.centerY.equalTo(balanceLabel.mas_centerY);
        }];
        [textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(rechargeBtn.mas_right).offset(kUI_Width(5));
            make.right.equalTo(-kUI_Width(22));
            make.height.equalTo(kUI_Width(28));
            make.centerY.mas_equalTo(rechargeBtn.mas_centerY);
        }];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(10));
            make.right.equalTo(-kUI_Width(52));
            make.top.bottom.equalTo(0);
        }];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.right.equalTo(kUI_Width(10));
            make.width.equalTo(kUI_Width(60));
        }];
    }

    return _bottomView;
}

- (LCLotteryTicketPlayViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LCLotteryTicketPlayViewModel new];
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
