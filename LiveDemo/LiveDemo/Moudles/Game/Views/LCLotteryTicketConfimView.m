//
//  LCLotteryTicketConfimView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCLotteryTicketBeishuView.h"
#import "LCLotteryTicketConfimView.h"
#import "LCLotteryTicketConfirmTableCell.h"
#import "LCLotteryTicketConfirmViewModel.h"
@interface LCLotteryTicketConfimView ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *navView;
@property (nonatomic, weak) UILabel *timelabal;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) LCBaseTableView *mainTableView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) LCLotteryTicketBeishuView *beishuView;
@property (nonatomic, weak) UILabel *bettingLabel;
@property (nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, weak) UILabel *balanceLabel;
@property (nonatomic, strong) LCLotteryTicketConfirmViewModel *viewModel;
@property (nonatomic, weak) UITextField *alertTextField;
@end
@implementation LCLotteryTicketConfimView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(KSafeHeight + kUI_Width(428));
        }];
        [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.height.equalTo(kUI_Width(44));
        }];
        [self.timelabal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.mas_equalTo(self.navView.mas_bottom).offset(kUI_Width(10));
            make.height.equalTo(kUI_Width(14));
        }];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.mas_equalTo(self.timelabal.mas_bottom).offset(kUI_Width(10));
            make.height.equalTo(kUI_Width(24));
        }];
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.bottom.mas_equalTo(self.bottomView.mas_top);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(KSafeHeight + kUI_Width(13) * 2 + kUI_Width(28) + kUI_Width(5) + kUI_Width(30));
        }];
        WS(weakSelf)
        [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id _Nullable x) {
            [weakSelf.mainTableView reloadData];
        }];
        [[self.viewModel.xiazhuSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id _Nullable x) {
           

            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
            [SVProgressHUD showNoMaskViewWithSuccess:KLanguage(@"下注成功")];
            NSDictionary *dic = x;
            if(weakSelf.sendBlock){
                weakSelf.sendBlock(dic);
            }
            [weakSelf leftButtonWithButton];
            
        }];
        RAC(self.moneyLabel, attributedText) = [[RACObserve(self.viewModel, totalMoney) map:^NSAttributedString *_Nullable (NSString *_Nullable value) {
            if (!value.length) {
                return nil;
            }
            NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc]initWithString:value
                                                                                    attributes:@{ NSForegroundColorAttributeName: Color(@"#FF2A2A") }];
            NSTextAttachment *ach = [[NSTextAttachment alloc]init];
            ach.image = image(@"icon_lotteryTicketZSCoinImg");
            ach.bounds = CGRectMake(0, -(kUI_Width(14) - kUI_Width(11)) / 2.0, kUI_Width(14), kUI_Width(11));

            [att1 appendAttributedString:[NSAttributedString attributedStringWithAttachment:ach]];
            
            return att1.copy;
        }] takeUntil:self.rac_willDeallocSignal];
        RAC(self.bettingLabel, attributedText) = [[RACObserve(self.viewModel, xiazhuCount) map:^NSAttributedString *_Nullable (NSNumber *_Nullable value) {
            if (!value) {
                return nil;
            }
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", value.integerValue]
                                                                                   attributes:@{ NSForegroundColorAttributeName: Color(@"#FF2A2A") }];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:KLanguage(@"注")
                                                                       attributes:@{ NSForegroundColorAttributeName: Color(@"#666666") }]];
            
            return att.copy;
        }] takeUntil:self.rac_willDeallocSignal];
        RAC(self.balanceLabel, attributedText) = [[RACObserve(self.viewModel, balanceStr) map:^NSAttributedString *_Nullable (NSString *_Nullable value) {
            if (!value.length) {
                return nil;
            }

           
            NSMutableAttributedString *att =  [[NSMutableAttributedString alloc]initWithString:KLanguage(@"余额：")
                                                                                    attributes:@{ NSForegroundColorAttributeName: Color(@"#666666") }];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:value
                                                                       attributes:@{ NSForegroundColorAttributeName: Color(@"#F44336") }]];
            return att.copy;
        }] takeUntil:self.rac_willDeallocSignal];
        [[[RACSignal combineLatest:@[RACObserve(self.viewModel, countDownTime),RACObserve(self.viewModel, qihao)]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
            NSString *cutDownTime = x[0];
            NSString *qihao = x[1];
            if(!cutDownTime.length || !qihao.length){
                return;
            }
            NSString * text = nil;
            if([cutDownTime integerValue]<=10){
                text = KLanguage(@"封盘中");
            }else{
                NSInteger minute1 = cutDownTime.integerValue / 60;
                NSInteger seconds1 = cutDownTime.integerValue % 60;
                text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute1, seconds1];
            }
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@ %@ %@", KLanguage(@"第"),qihao,KLanguage(@"期"),KLanguage(@"本期截止：")]
                                                                                   attributes:@{ NSForegroundColorAttributeName: Color(@"#333333") }];
            [att appendAttributedString:[[NSAttributedString alloc]initWithString:text
                                                                       attributes:@{ NSForegroundColorAttributeName: Color(@"#75C176") }]];
            self.timelabal.attributedText = att;
        }];
    
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
- (void)setWanfaSelectArr:(NSMutableArray *)wanfaSelectArr {
    _wanfaSelectArr = wanfaSelectArr;
    self.viewModel.wanfaSelectArr = _wanfaSelectArr;
    self.viewModel.xiazhuCount = _wanfaSelectArr.count;
    [self.mainTableView reloadData];
}
- (void)setZhuboId:(NSString *)zhuboId{
    _zhuboId = [zhuboId copy];
    self.viewModel.zhuboId = _zhuboId;
}
- (void)setSelectedBeishu:(NSString *)selectedBeishu{
    _selectedBeishu = [selectedBeishu copy];
    [self.viewModel.selectBeishuCommand execute:_selectedBeishu];
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.wanfaSelectArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000000000000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000000000000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kUI_Width(32);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLotteryTicketConfirmTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCLotteryTicketConfirmTableCell"];

    cell.dataModel = self.viewModel.wanfaSelectArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    cell.moneyClickBlock = ^(LCLotteryTicketWanFaModel *_Nonnull selectModel) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:KLanguage(@"请填写单注金额") preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KLanguage(@"取消")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *_Nonnull action) {
        }];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:KLanguage(@"确定")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {
            [weakSelf.viewModel.customMoneyCommand execute:[RACTuple tupleWithObjects:weakSelf.alertTextField.text,selectModel, nil]];
           
            
        }];

        [alertController addAction:okAction];
        [alertController addAction:cancelAction];

        // 添加文本框(只能添加到UIAlertControllerStyleAlert的样式，如果是preferredStyle:UIAlertControllerStyleActionSheet则会崩溃)
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            weakSelf.alertTextField = textField;
            textField.placeholder = KLanguage(@"请填写单注金额");
            textField.keyboardType = UIKeyboardTypeNumberPad;
        // 监听文字改变的方法，也可以通过通知
            [[textField.rac_textSignal takeUntil:weakSelf.rac_willDeallocSignal] subscribeNext:^(NSString *_Nullable x) {
                okAction.enabled = x.length > 0 ? YES : NO;
            }];
        }];

        [weakSelf.findViewController presentViewController:alertController animated:YES completion:nil];
    };
    cell.deleteBlock = ^(LCLotteryTicketWanFaModel *_Nonnull selectModel) {
        if(weakSelf.viewModel.wanfaSelectArr.count > 1){
            [[NSNotificationCenter defaultCenter] postNotificationName:LCGameLotteryTicketWanfaDeleteNot object:selectModel];
        }else{
            [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"不能全部删除")];
        }
        
    };
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
#pragma mark---- 懒加载 ----
- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(16);
        view.clipsToBounds = YES;
        [self addSubview:view];
        _contentView = view;
    }

    return _contentView;
}

- (UIImageView *)navView {
    if (!_navView) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_lotteryTicketConfirmTopBg")];
        imgView.userInteractionEnabled = YES;
        [self.contentView addSubview:imgView];
        _navView = imgView;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(18);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"确认投注");
        label.textAlignment = NSTextAlignmentCenter;
        [_navView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(18));
            make.centerY.equalTo(0);
            make.left.right.equalTo(0);
        }];
    }

    return _navView;
}

- (UILabel *)timelabal {
    if (!_timelabal) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(14);
        label.textColor = Color(@"#333333");
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _timelabal = label;
    }

    return _timelabal;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:view];
        _headerView = view;
        UILabel *wanfaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        wanfaLabel.font = RegularFont(14);
        wanfaLabel.textColor = Color(@"#333333");
        wanfaLabel.text = KLanguage(@"玩法");
        wanfaLabel.textAlignment = NSTextAlignmentCenter;
        wanfaLabel.layer.borderWidth = 0.5;
        wanfaLabel.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [_headerView addSubview:wanfaLabel];
        UILabel *peilvLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        peilvLabel.font = RegularFont(14);
        peilvLabel.textColor = Color(@"#333333");
        peilvLabel.text = KLanguage(@"赔率");
        peilvLabel.textAlignment = NSTextAlignmentCenter;
        peilvLabel.layer.borderWidth = 0.5;
        peilvLabel.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [_headerView addSubview:peilvLabel];
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        moneyLabel.font = RegularFont(14);
        moneyLabel.textColor = Color(@"#333333");
        moneyLabel.text = KLanguage(@"金额");
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.layer.borderWidth = 0.5;
        moneyLabel.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [_headerView addSubview:moneyLabel];
        UILabel *deleteLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        deleteLabel.font = RegularFont(14);
        deleteLabel.textColor = Color(@"#333333");
        deleteLabel.text = KLanguage(@"删除");
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        deleteLabel.layer.borderWidth = 0.5;
        deleteLabel.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [_headerView addSubview:deleteLabel];
        [wanfaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_WidthWithFloat(150));
            make.height.equalTo(kUI_Width(24));
            make.top.left.equalTo(0);
        }];
        [peilvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_WidthWithFloat(70));
            make.height.equalTo(kUI_Width(24));
            make.top.equalTo(0);
            make.left.mas_equalTo(wanfaLabel.mas_right);
        }];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_WidthWithFloat(98));
            make.height.equalTo(kUI_Width(24));
            make.top.equalTo(0);
            make.left.mas_equalTo(peilvLabel.mas_right);
        }];
        [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.height.equalTo(kUI_Width(24));
            make.top.equalTo(0);
            make.left.mas_equalTo(moneyLabel.mas_right);
        }];
    }

    return _headerView;
}

- (LCBaseTableView *)mainTableView {
    if (_mainTableView == nil) {
        LCBaseTableView *tableView = [LCBaseTableView addTableGrouped];
        _mainTableView = tableView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;

        _mainTableView.backgroundColor = Color(@"#FFFFFF");
        [self.contentView addSubview:_mainTableView];
        [_mainTableView registerClass:[LCLotteryTicketConfirmTableCell class] forCellReuseIdentifier:@"LCLotteryTicketConfirmTableCell"];
    }

    return _mainTableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        [self.contentView addSubview:view];
        _bottomView = view;
        LCLotteryTicketBeishuView *coinView = [[LCLotteryTicketBeishuView alloc]initWithFrame:CGRectZero];
        coinView.dataArray = self.viewModel.beishuArr;
        
        [_bottomView addSubview:coinView];
        _beishuView = coinView;
        UILabel *bettingTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        bettingTipLabel.font = MediumFont(14);
        bettingTipLabel.textColor = Color(@"#666666");
        bettingTipLabel.text = KLanguage(@"合计 ");
        [_bottomView addSubview:bettingTipLabel];
        UILabel *bettingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        bettingLabel.font = MediumFont(14);
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:@"0" attributes:@{ NSForegroundColorAttributeName: Color(@"#FF2A2A") }];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:KLanguage(@"注") attributes:@{ NSForegroundColorAttributeName: Color(@"#666666") }]];

        bettingLabel.attributedText = att;
        [_bottomView addSubview:bettingLabel];
        _bettingLabel = bettingLabel;
        UILabel *moneyTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        moneyTipLabel.font = MediumFont(14);
        moneyTipLabel.textColor = Color(@"#666666");
        moneyTipLabel.text = KLanguage(@"金额 ");
        [_bottomView addSubview:moneyTipLabel];
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        moneyLabel.font = MediumFont(14);
        NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc]initWithString:@"0" attributes:@{ NSForegroundColorAttributeName: Color(@"#FF2A2A") }];
        NSTextAttachment *ach = [[NSTextAttachment alloc]init];
        ach.image = image(@"icon_lotteryTicketZSCoinImg");
        ach.bounds = CGRectMake(0, -(kUI_Width(14) - kUI_Width(11)) / 2.0, kUI_Width(14), kUI_Width(11));

        [att1 appendAttributedString:[NSAttributedString attributedStringWithAttachment:ach]];

        moneyLabel.attributedText = att1;
        [_bottomView addSubview:moneyLabel];
        _moneyLabel = moneyLabel;

        UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        balanceLabel.font = MediumFont(14);
        NSMutableAttributedString *att3 = [[NSMutableAttributedString alloc]initWithString:KLanguage(@"余额：") attributes:@{ NSForegroundColorAttributeName: Color(@"#666666") }];
        [att3 appendAttributedString:[[NSAttributedString alloc]initWithString:[LCUserInfoManager shareManager].userInfo.coin attributes:@{ NSForegroundColorAttributeName: Color(@"#FF2A2A") }]];

        balanceLabel.attributedText = att3;
        [_bottomView addSubview:balanceLabel];
        _balanceLabel = balanceLabel;

        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setBackgroundImage:image(@"icon_lotteryTicketComfirmBtnBg") forState:UIControlStateNormal];
//        sendBtn.layer.cornerRadius = kUI_Width(4);
        [sendBtn setTitle:KLanguage(@"确认投注") forState:UIControlStateNormal];
        [sendBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        sendBtn.titleLabel.font = MediumFont(14);
        [_bottomView addSubview:sendBtn];
        WS(weakSelf)
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
            if(weakSelf.viewModel.isFP){
                [SVProgressHUD showNoMaskViewWithFailure:@"封盘中，不能下注"];
                return;
            }
            [weakSelf.viewModel.xiazhuCommand execute:@(YES)];
        }];
        [coinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(5));
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(30));
        }];
        [bettingTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.top.equalTo(kUI_Width(5) + kUI_Width(30) + kUI_Width(14));
        }];
        [bettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bettingTipLabel.mas_right).offset(kUI_Width(3));
            make.height.equalTo(kUI_Width(14));
            make.top.equalTo(kUI_Width(5) + kUI_Width(30) + kUI_Width(14));
        }];
        [moneyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bettingLabel.mas_right).offset(kUI_Width(8));
            make.height.equalTo(kUI_Width(14));
            make.top.equalTo(kUI_Width(5) + kUI_Width(30) + kUI_Width(14));
        }];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(14));
            make.top.equalTo(kUI_Width(5) + kUI_Width(30) + kUI_Width(14));
            make.left.mas_equalTo(moneyTipLabel.mas_right);
        }];
        [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.top.mas_equalTo(bettingLabel.mas_bottom).offset(kUI_Width(4));
        }];


        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(80));
            make.height.equalTo(kUI_Width(28));
            make.right.equalTo(-kUI_Width(12));
            make.top.mas_equalTo(coinView.mas_bottom).offset(kUI_Width(13));
        }];
    }

    return _bottomView;
}

- (LCLotteryTicketConfirmViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LCLotteryTicketConfirmViewModel new];
        
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
