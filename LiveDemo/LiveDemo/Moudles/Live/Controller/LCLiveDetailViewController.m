//
//  LCLiveDetailViewController.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/26.
//

#import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>
#import "continueGift.h"
#import "expensiveGiftV.h"
#import "guardShowView.h"
#import "LCBettingRecordViewController.h"
#import "LCCommonWebViewController.h"
#import "LCGameCenterViewController.h"
#import "LCGameTipViewController.h"
#import "LCGameWinningHistoryViewController.h"
#import "LCLiveActivitysView.h"
#import "LCLiveArchorInfoView.h"
#import "LCLiveChatLotteryTicketTableCell.h"
#import "LCLiveChatMessageTableViewCell.h"
#import "LCLiveDetailViewController.h"
#import "LCLiveDetailViewModel+LCSocketViewModel.h"
#import "LCLiveDetailViewModel.h"
#import "LCLiveEnterRoomView.h"
#import "LCLiveGameRecommendView.h"
#import "LCLiveGamesSelectView.h"
#import "LCLiveGiftListView.h"
#import "LCLiveHighUserLevelAnimationView.h"
#import "LCLiveLotteryTicketDetailView.h"
#import "LCLiveRecommendRoomView.h"
#import "LCLiveToolView.h"
#import "LCLiveUsersView.h"
#import "LCLiveViewController.h"
#import "LCLotteryTicketConfimView.h"
#import "LCRechageViewController.h"
#import "LCScrollView.h"
#import "LCUserHomeViewController.h"
#import "PlatGiftView.h"
#import "shouhuView.h"
#import "LCLiveStopInfoView.h"
#import "GrounderSuperView.h"
#import "LCPersonalContributeRankViewController.h"
#import "ChessCardWebVC.h"
#import "LCBindPhoneViewController.h"

@interface LCLiveDetailViewController ()<V2TXLivePlayerObserver, TXVodPlayListener, UITableViewDelegate, UITableViewDataSource, TXVodPlayListener, UITextFieldDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, haohuadelegate, guardShowDelegate, shouhuViewDelegate, platDelgate> {
    dispatch_source_t _timer;
    dispatch_source_t _previewTimer;
}
@property (nonatomic, strong) TXVodPlayer *videoPlayer;
@property (nonatomic, strong) V2TXLivePlayer *livePlayer;
@property (nonatomic, weak) UIView *playerView;
@property (nonatomic, weak) UIImageView *playHolderImgView;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
@property (nonatomic, weak) LCScrollView *mainScrollView;

@property (nonatomic, weak) UIView *playControlView;
@property (nonatomic, weak) LCLiveArchorInfoView *archorInfoView;

@property (nonatomic, weak) LCLiveUsersView *audienceView;
@property (nonatomic, weak) UIView *audienceBackView;
@property (nonatomic, weak) UILabel *audienceNumLabel;
@property (nonatomic, weak) UIView *contributionView;
@property (nonatomic, weak) UIView *guardView;
@property (nonatomic, weak) UILabel *guardNumLabel;
@property (nonatomic, weak) UIView *recommendView;
//@property (nonatomic, weak) UIImageView *archorCardImgView;

@property (nonatomic, weak) UIView *priceBackView;
@property (nonatomic, weak) UIView *previewBackView;
@property (nonatomic, weak) UILabel *priceLabel; //#ED9A38
@property (nonatomic, weak) UILabel *previewLavel;

@property (nonatomic, weak) expensiveGiftV *expensiveGiftView;
@property (nonatomic, weak) UIView *giftBackView;
@property (nonatomic, weak) continueGift *normalGiftAnimationView;
@property (nonatomic, weak) PlatGiftView *allPlatFormGiftView;
//@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) LCBaseTableView *messageTableView;
@property (nonatomic, weak) UIView *roomGameView;
@property (nonatomic, weak) UIImageView *roomGameImgView;
@property (nonatomic, weak) UILabel *roomGameTimerLabel;
@property (nonatomic, weak) LCLiveGameRecommendView *recommendGameView;
@property (nonatomic, weak) LCLiveEnterRoomView *userEnterRoomView;

@property (nonatomic, weak) LCLiveToolView *toolView;

@property (nonatomic, weak) UIView *inputShelterView;
@property (nonatomic, weak) UIView *inputMsgView;
@property (nonatomic, weak) UIButton *danmuBtn;
@property (nonatomic, weak) UITextField *msgTextField;

@property (nonatomic , weak) GrounderSuperView *danmuDisplayView;

@property (nonatomic, weak) LCLiveRecommendRoomView *recommendRoomView;

@property (nonatomic, weak) LCLiveHighUserLevelAnimationView *userHighAnimationView;

@property (nonatomic, weak) LCLiveGamesSelectView *selectGameView;
@property (nonatomic, weak) LCLiveLotteryTicketDetailView *lotteryTicketDetailView;

@property (nonatomic, weak) guardShowView *guardListView;
@property (nonatomic, weak) shouhuView *guardBuyView;

@property (nonatomic , strong) UIAlertController *chargeAlertCon;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGes;

@property (nonatomic, strong) LCLiveDetailViewModel *detailViewModel;



@end

@implementation LCLiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)lc_addSubviews {
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(0);
    }];
    [self.playHolderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(0);
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(0);
        make.width.height.equalTo(kUI_Width(40));
    }];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(0);
    }];

    [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    [self.playControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SCREEN_WIDTH);
        make.top.equalTo(0);
        make.width.mas_equalTo(self.mainScrollView.mas_width);
        make.height.mas_equalTo(self.mainScrollView.mas_height);
    }];
    [self.archorInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(36));
        make.top.equalTo(kStatusBarHeight + kUI_Width(10));
        make.right.lessThanOrEqualTo(-(self.view.width) / 2.0);
    }];
    [self.audienceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(28));
        make.centerY.mas_equalTo(self.archorInfoView.mas_centerY);
//        make.left.mas_equalTo(self.archorInfoView.mas_right).offset(kUI_Width(12));
    }];
    [self.audienceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(12));
        make.right.equalTo(-kUI_Width(12));
        make.top.bottom.equalTo(0);
    }];
    [self.audienceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.archorInfoView.mas_right).offset(kUI_Width(12));
        make.right.mas_equalTo(self.audienceBackView.mas_left).offset(-kUI_Width(2));
        make.height.equalTo(kUI_Width(32));
        make.centerY.mas_equalTo(self.archorInfoView.mas_centerY);
    }];
    [self.contributionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.archorInfoView.mas_left);
        make.height.equalTo(kUI_Width(24));
//        make.width.equalTo(kUI_Width(96));
        make.top.mas_equalTo(self.archorInfoView.mas_bottom).offset(kUI_Width(10));
    }];
    [self.guardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contributionView.mas_right).offset(kUI_Width(8));
        make.height.equalTo(kUI_Width(24));

        make.top.mas_equalTo(self.archorInfoView.mas_bottom).offset(kUI_Width(10));
    }];
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(24));
        make.centerY.mas_equalTo(self.contributionView.mas_centerY);
    }];
//    [self.archorCardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-kUI_Width(kViewMargin));
//        make.height.equalTo(kUI_Width(49));
//        make.height.equalTo(kUI_Width(72));
//        make.top.mas_equalTo(self.recommendView.mas_bottom).offset(kUI_Width(8));
//    }];
    [self.priceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.archorInfoView.mas_left);
        make.height.equalTo(kUI_Width(24));
        make.top.mas_equalTo(self.contributionView.mas_bottom).offset(kUI_Width(10));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(8));
        make.right.equalTo(-kUI_Width(8));
        make.top.bottom.equalTo(0);
    }];
    [self.previewBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.archorInfoView.mas_left);
        make.height.equalTo(kUI_Width(24));
        make.top.mas_equalTo(self.priceBackView.mas_bottom).offset(kUI_Width(10));
    }];
    [self.previewLavel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(8));
        make.right.equalTo(-kUI_Width(8));
        make.top.bottom.equalTo(0);
    }];
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(0);
//        make.left.equalTo(self.view.width);
//        make.height.equalTo(kUI_Width(225) + KSafeHeight);
//        make.bottom.equalTo(0);
//    }];
    [self.giftBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(kUI_Width(300));
        make.height.equalTo(kUI_Width(140));
        make.bottom.mas_equalTo(self.messageTableView.mas_top).offset(-kUI_Width(10));
    }];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(190));
        make.bottom.mas_equalTo(self.toolView.mas_top).offset(-kUI_Width(54) );
        make.width.equalTo(kUI_Width(264));
    }];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-KSafeHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(kUI_Width(10) + kUI_Width(36));
    }];
    [self.inputShelterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    [self.inputMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(kUI_Width(40));
        make.bottom.equalTo(0);
    }];
    self.inputShelterView.hidden = YES;
    [self.userEnterRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageTableView.mas_bottom).offset(kUI_Width(5));
        make.left.equalTo(kUI_Width(kViewMargin));
        make.width.equalTo(kUI_Width(264));
        make.bottom.mas_equalTo(self.toolView.mas_top).offset(-kUI_Width(5));
    }];
    [self.roomGameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageTableView.mas_top).offset(kUI_Width(20));
        make.right.equalTo(-kUI_Width(20));
        make.width.equalTo(kUI_Width(60));
        make.height.equalTo(kUI_Width(60) + kUI_Width(12) + kUI_Width(8));
    }];
    self.roomGameView.hidden = ![LCGameConfigManager shareManager].gameStatus;
    [self.roomGameImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.mas_equalTo(self.roomGameImgView.mas_width);
    }];
    [self.roomGameTimerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.roomGameImgView.mas_bottom).offset(kUI_Width(8));
        make.height.equalTo(kUI_Width(12));
        make.left.right.equalTo(0);
    }];
    [self.recommendGameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.messageTableView.mas_right).offset(kUI_Width(15));
        make.right.equalTo(0);
        make.height.equalTo(kUI_Width(60));
        make.bottom.mas_equalTo(self.messageTableView.mas_bottom).offset(-kUI_Width(10));
    }];
    self.recommendGameView.hidden = ![LCGameConfigManager shareManager].gameStatus;


    [self.userHighAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(kUI_Width(40));
        make.bottom.mas_equalTo(self.messageTableView.mas_top).offset(-kUI_Width(15));
    }];
    self.userHighAnimationView.hidden = YES;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
    [self.msgTextField resignFirstResponder];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [IQKeyboardManager sharedManager].enable = NO;
//    [self pausePlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
//    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = NO;
//    [self resumePlayer];
}

- (void)lc_bindViewModel {
    @weakify(self);

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification
                                                            object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification *_Nullable x) {
        @strongify(self);

        if ([self.msgTextField isFirstResponder]) {
            NSDictionary *userInfo = [x userInfo];
            NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
            
            CGRect keyboardRect = [aValue CGRectValue];
            CGFloat height = keyboardRect.size.height;
            self.inputMsgView.transform = CGAffineTransformMakeTranslation(0, -(height ));
            self.playControlView.transform = CGAffineTransformMakeTranslation(0, -(height - KSafeHeight - kUI_Width(40) ));
        }
    }];

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification
                                                            object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification *_Nullable x) {
        @strongify(self);

        if ([self.msgTextField isFirstResponder]) {
            self.inputMsgView.transform = CGAffineTransformIdentity;
            self.playControlView.transform = CGAffineTransformIdentity;
            self.inputShelterView.hidden = YES;
        }
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification
                                                            object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification *_Nullable x) {
        @strongify(self);

        self.toolView.hidden = NO;
    }];

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketKaijiangResultNot
                                                            object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *_Nullable x) {
        @strongify(self);
        LCLotteryTicketSQKJModel *model = x.object;



        UIView *paoMaView = [[UIView alloc]initWithFrame:CGRectZero];
        paoMaView.layer.masksToBounds = YES;
        paoMaView.layer.cornerRadius = kUI_Width(4);
        [self.playControlView addSubview:paoMaView];
        paoMaView.backgroundColor = ColorAlpha(@"#000000", 0.3);
        [paoMaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playControlView.mas_right).offset(kUI_Width(12));
            make.width.equalTo(kUI_Width(200));
            make.top.equalTo(kStatusBarHeight + kUI_Width(90));
            make.height.equalTo(kUI_Width(49));
        }];
        UILabel *qishu = [[UILabel alloc]initWithFrame:CGRectZero];
        qishu.textAlignment = NSTextAlignmentLeft;
        qishu.font = MediumFont(12);
        qishu.textColor = Color(@"#FFFFFF");
        qishu.text = [NSString stringWithFormat:@"%@%@%@", model.title, model.expect, KLanguage(@"期")];
        [paoMaView addSubview:qishu];
        [qishu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(8));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(6));
            make.right.equalTo(-kUI_Width(8));
        }];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectZero];
        lineV.backgroundColor = ColorAlpha(@"#FFFFFF", 0.3);
        [paoMaView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(kUI_Width(24));
            make.height.equalTo(1);
        }];


        NSArray *arr = [model.opencode componentsSeparatedByString:@","];
        [paoMaView layoutIfNeeded];
        CGFloat width = arr.count > 8 ? (paoMaView.width - kUI_Width(8) *  2 - (arr.count - 1) * kUI_Width(3)) / arr.count : kUI_Width(16);

        for (int i = 0; i < arr.count; i++) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
            lab.text = arr[i];
            lab.textColor = Color(@"#FFFFFF");
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = MediumFont(12);
            lab.layer.cornerRadius = kUI_Width(4);
            lab.clipsToBounds = YES;
            int x = arc4random() % 3;

            if (x == 0) {
                lab.backgroundColor = RGB(91, 186, 40);
            } else if (x == 1) {
                lab.backgroundColor = RGB(80, 177, 240);
            } else {
                lab.backgroundColor = RGB(231, 86, 95);
            }

            [paoMaView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(kUI_Width(8) + width * i + i * kUI_Width(3));
                make.width.equalTo(width);
                make.height.equalTo(kUI_Width(16));
                make.top.mas_equalTo(lineV.mas_bottom).offset(kUI_Width(4));
            }];
        }

        [UIView animateWithDuration:1.0
                         animations:^{
            paoMaView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
        }
                         completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [paoMaView removeFromSuperview];
                           });
        }];
    }];

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketSelectNot
                                                            object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNotification *_Nullable x) {
        @strongify(self);
        LCGameListModel *model = x.object;

        if (self.selectGameView) {
            self.selectGameView.hidden = YES;
        }
        if(model.ismy){
            [self lotteryTicketClicked:model];
        }else{
            if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
                [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if(buttonIndex == controller.destructiveButtonIndex){
                        LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                        [self pushToViewController:con];
                    }else{
                        self.toolView.hidden = NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(YES)];
                        self.swipeGes.enabled = YES;
                        self.mainScrollView.scrollEnabled = YES;
                    }
                }];
                return;
            }
            [SVProgressHUD showWithMaskView];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if(model.biaoshi.length){
                dic[@"biaoshi"] = model.biaoshi;
            }
            if(model.type.length){
                dic[@"type"] = model.type;
            }
            if(model.code.length){
                dic[@"code"] = model.code;
            }
            [[LCNetWorkManager manager]requestUrl:@"Caipiao.Twoclass" method:@"POST" params:dic success:^(id  _Nullable result) {
                [SVProgressHUD dismiss];
                if([x isKindOfClass:NSDictionary.class]){
                    NSDictionary *dic = result[@"info"];
                    ChessCardWebVC *webVC = [[ChessCardWebVC alloc]init];
                    webVC.biaoshi = model.biaoshi;
                    webVC.url=dic[@"purl"];
                    webVC.titleStr=minstr(dic[@"name"]) ;
                    webVC.push=minstr(dic[@"balance"]) ;
                    [self pushToViewController:webVC];
                }

                            } failure:^(NSError * _Nullable error) {
                                [SVProgressHUD showErrorWithStatus:error.domain];
                            }];
        }
        
       
    }];
    [[RACObserve(self.detailViewModel, origalModel) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LCHomeListModel *_Nullable x) {
        @strongify(self)
        [self.playHolderImgView setImageStr: x.thumb];
        [self.roomGameImgView setImageStr:x.caipiao.icon];
    }];
    [[RACObserve(self.detailViewModel, archorModel) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LCLiveArchorModel *_Nullable x) {
        @strongify(self)
        self.archorInfoView.dataModel = x;
    }];

    RAC(self.roomGameTimerLabel, text) = [[RACObserve(self.detailViewModel, lotteryTicketCutDownTimeStr) map:^NSString *_Nullable (NSString *_Nullable value) {
        @strongify(self)

        if (!value.length) {
            return nil;
        }

        NSString *text = nil;

        if ([value integerValue] <= 10) {
            text = KLanguage(@"封盘中");

            if ([value integerValue] == 1) {
                [self.detailViewModel sendCheckResultLotteryTicketWithBiaoshi:self.dataModel.caipiao.biaoshi];
            }
        } else {
            NSInteger minute1 = value.integerValue / 60;
            NSInteger seconds1 = value.integerValue % 60;
            text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute1, seconds1];
        }

        return text;
    }] takeUntil:self.rac_willDeallocSignal];
    RAC(self.guardNumLabel, text) = [RACObserve(self.detailViewModel.dataModel, guard_nums) takeUntil:self.rac_willDeallocSignal];
    RAC(self.audienceNumLabel, text) = [RACObserve(self.detailViewModel.dataModel, nums) takeUntil:self.rac_willDeallocSignal];
    [[RACObserve(self.detailViewModel, isDanmu) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *_Nullable x) {
        @strongify(self);


        self.msgTextField.attributedPlaceholder = [x boolValue] ? [[NSAttributedString alloc]initWithString:KLanguage(@"已开启弹幕评论，10钻石/条")
                                                                                                 attributes:@{ NSFontAttributeName: RegularFont(14), NSForegroundColorAttributeName: Color(@"#666666") }] : [[NSAttributedString alloc]initWithString:KLanguage(@"输入想跟主播说的话")
                                                                                                                                                                                                                                           attributes:@{ NSFontAttributeName: RegularFont(14), NSForegroundColorAttributeName: Color(@"#666666") }];
    }];
    [[self.detailViewModel.sendDanmuSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if([x isKindOfClass:[NSError class]]){
            NSError *err = x;
            [SVProgressHUD showNoMaskViewWithFailure:err.domain];
            return;
        }
        [self.detailViewModel sendDanMuWithText:x];
        self.msgTextField.text = nil;
    }];
    [[RACObserve(self.detailViewModel, roomTypeModel) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LCLiveRoomTypeModel *_Nullable x) {
        @strongify(self);

        switch (x.type.intValue) {
            case 0:{
                self.priceBackView.hidden = YES;
                self.previewBackView.hidden = YES;
            }

            break;

            case 1:{
                self.priceBackView.hidden = YES;
                self.previewBackView.hidden = YES;
            }
            break;

            case 2:{
                self.priceBackView.hidden = NO;
                self.previewBackView.hidden = YES;
//                self.chargeTypeLabel.text = KLanguage(@"按时收费") ;
            }
            break;

            case 3:{
                self.priceBackView.hidden = NO;
                self.previewBackView.hidden = NO;
                self.previewLavel.text = [NSString stringWithFormat:@"%@%@%@",KLanguage(@"预览倒计时"),@"30",KLanguage(@"秒")];
                [self startPreviewTimer];
               self.chargeAlertCon = [UIAlertController showAlertInViewController:self
                                                   withTitle:KLanguage(@"提示")
                                                     message:x.type_msg
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@[KLanguage(@"下一个"), KLanguage(@"确定") ]
                                                    tapBlock:^(UIAlertController *_Nonnull controller, UIAlertAction *_Nonnull action, NSInteger buttonIndex) {
                    if (controller.firstOtherButtonIndex == buttonIndex) {
                        [self cancelPreviewTimer];
                        //跳过
                        [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveSkipNot
                                                                            object:self.dataModel];
                    } else {
                        //确定,执行扣费，计时
                        [self cancelPreviewTimer];
                        [self.detailViewModel.chargeCommand execute:@(YES)];
                    }
                }];
            }

            break;

            default:
                break;
        }
        self.priceLabel.text = [NSString stringWithFormat:@"%@%@/%@", x.type_val, [LCConfigManager shareManager].configModel.name_coin, KLanguage(@"分钟")];
    }];

    [[self.detailViewModel.chargeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id _Nullable x) {
        @strongify(self)

        if ([x isKindOfClass:NSError.class]) {
            [UIAlertController showAlertInViewController:self
                                               withTitle:KLanguage(@"您当前余额不足无法观看")
                                                 message:nil
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:@[ KLanguage(@"确定") ]
                                                tapBlock:^(UIAlertController *_Nonnull controller, UIAlertAction *_Nonnull action, NSInteger buttonIndex) {
                if (controller.firstOtherButtonIndex == buttonIndex) {
                    //跳过
                    [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveSkipNot
                                                                        object:self.dataModel];
                }
            }];
            return;
        }

        [self startTimer];
    }];
    

    [[self.detailViewModel.liveEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id _Nullable x) {
        @strongify(self)
        
        [self releasePlayer];
        [self.detailViewModel.stopInfoCommand execute:@(YES)];
       
        
        
    }];
    [[self.detailViewModel.roomCloseByAdminSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        [self releasePlayer];
        [self.detailViewModel.stopInfoCommand execute:@(YES)];
    }];
    [[self.detailViewModel.stopInfoSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id _Nullable x) {
        @strongify(self)
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic addEntriesFromDictionary:[x isKindOfClass:NSError.class]?@{@"votes":@"0",@"nums":@"0",@"length":@"0"}:x];
        dic[@"avatar"] = self.detailViewModel.archorModel.avatar_thumb;
        dic[@"user_nicename"] = self.detailViewModel.archorModel.user_nicename;
        LCLiveStopInfoView *view = [[LCLiveStopInfoView alloc]initWithFrame:self.view.bounds dataDic:dic];
        view.backBlock = ^{
            [self popBack];
        };
        [self.view addSubview:view];
        
        
    }];
    [[self.detailViewModel.danmuSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *  _Nullable x) {
        @strongify(self)
        [self.danmuDisplayView setModel:x];
    }];
    [[self.detailViewModel.messageAddSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id _Nullable x) {
        @strongify(self)
        [UIView animateWithDuration: 0 animations:^{
            [self.messageTableView reloadData];
        } completion:^(BOOL finished) {
            [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                             inSection:self.detailViewModel.msgArray.count - 1]
                                         atScrollPosition:UITableViewScrollPositionBottom
                                                 animated:YES];
        }];
    }];

    [[self.detailViewModel.sendGiftSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LCChatGiftMessageModel *_Nullable x) {
        @strongify(self)

        if (x) {
            NSDictionary *GiftInfo = @{ @"uid": x.uid,
                                        @"nicename": x.uname,
                                        @"giftname": x.ct.giftname,
                                        @"gifticon": x.ct.gifticon ? x.ct.gifticon : @"",
                                        @"giftcount": x.ct.giftcount,
                                        @"giftid": x.ct.giftid,
                                        @"level": x.level,
                                        @"avatar": x.uhead,
                                        @"type": x.ct.type,
                                        @"swf": x.ct.swf ? x.ct.swf : @"",
                                        @"swftime": x.ct.swftime,
                                        @"swftype": x.ct.swftype,
                                        @"isluck": x.ct.isluck,
                                        @"lucktimes": x.ct.lucktimes,
                                        @"mark": x.ct.mark };

            if ([x.ct.type isEqualToString:@"1"]) {
                if (GiftInfo == nil) {
                } else {
                    [self.expensiveGiftView addArrayCount:GiftInfo];
                }

                if (self.expensiveGiftView.haohuaCount == 0) {
                    [self.expensiveGiftView enGiftEspensive];
                }
            } else {
                [self.normalGiftAnimationView GiftPopView:GiftInfo
                                              andLianSong:x.evensend];
            }
        }
    }];
    [[self.detailViewModel.giftAllPlatformSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *_Nullable x) {
        @strongify(self)

        if (!self.allPlatFormGiftView) {
            PlatGiftView *platliwuV = [[PlatGiftView alloc]initWithIsPlat:YES];

            platliwuV.delegate = self;
            [self.view addSubview:platliwuV];
            self.allPlatFormGiftView = platliwuV;
            //        [backScrollView insertSubview:platliwuV atIndex:8];
            CGAffineTransform t = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
            platliwuV.transform = t;
        }

        if (x == nil) {
        } else {
            [self.allPlatFormGiftView addArrayCount:x];
        }

        if (self.allPlatFormGiftView.haohuaCount == 0) {
            [self.allPlatFormGiftView enGiftEspensive:YES];
        }
    }];

    [[self.detailViewModel.userAccessSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LCLiveUserModel *_Nullable x) {
        @strongify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           if (x.vip_type.integerValue == 1 || x.guard_type.integerValue == 1 || x.guard_type.integerValue == 2) {
                               self.userHighAnimationView.hidden = NO;
                               [self.userHighAnimationView addUserMove:x];
                           }

                           [self.userEnterRoomView addUsers:self.detailViewModel.userAccessArray];
                       });
    }];
    [[self.detailViewModel.checkTypeSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id _Nullable x) {
        @strongify(self)

        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }

//        if ([self.detailViewModel.roomTypeModel.type integerValue] == 3) {
//        }

        [self.detailViewModel.loadDataCommend execute:@(YES)];
    }];

    [[self.detailViewModel.audienceChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id _Nullable x) {
        @strongify(self)
        self.audienceView.dataArray = self.detailViewModel.dataModel.userlists;
    }];
    [[self.detailViewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        self.playControlView.hidden = NO;
        if ([self.detailViewModel.dataModel.pull rangeOfString:@".mp4"].length > 0) {
            int code = [self.videoPlayer startVodPlay:self.detailViewModel.dataModel.pull];
           

            if (code == 0) {
                //播放成功
                [self.loadingView stopAnimating];
                self.playHolderImgView.hidden = YES;
            } else {
                //播放失败
                [self handlePlayerStartFailureWithCode:code message:nil url:self.detailViewModel.dataModel.pull];
            }
        } else {
            V2TXLiveCode code = [self.livePlayer startLivePlay:self.detailViewModel.dataModel.pull];
//            V2TXLiveCode code = [self.livePlayer startPlay:self.detailViewModel.dataModel.pull];

            if (code == 0) {
                //播放成功
                [self.loadingView stopAnimating];
                self.playHolderImgView.hidden = YES;
            } else {
                //播放失败
                [self handlePlayerStartFailureWithCode:code message:nil url:self.detailViewModel.dataModel.pull];
            }
        }

        self.audienceView.dataArray = self.detailViewModel.dataModel.userlists;
//        self.audienceNumLabel.text = [NSString stringWithFormat:@"%ld", self.detailViewModel.dataModel.userlists.count];

        [self.detailViewModel connectToSocket];
    }];
    
    [self.detailViewModel disconnetSocket];
    
    [self.loadingView startAnimating];
}

- (void)startRequest {
    [self.detailViewModel.checkTypeCommand execute:@(YES)];
    [self.detailViewModel.recommendLiveCommand execute:@(YES)];
}

- (void)handlePlayerStartFailureWithCode:(NSInteger)code message:(NSString *)message url:(NSString *)url {
    LCLog(@"live play failed, code: %ld, message: %@, url: %@", (long)code, message ?: @"", url ?: @"");
    [self.loadingView stopAnimating];
    [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"播放失败")];
    self.playHolderImgView.hidden = NO;
}

- (void)pausePlayAndSocket {
    [self pausePlayer];
}

- (void)resumePlayAndSocket {
    [self resumePlayer];
}

- (void)removePlayer {
    if (_livePlayer) {
        [_livePlayer setObserver:nil];
        [_livePlayer stopPlay];
        _livePlayer = nil;
    }

    if (_videoPlayer) {
        _videoPlayer.vodDelegate = nil;
        [_videoPlayer stopPlay];
        _videoPlayer = nil;
    }
}

- (void)releasePlayer {
    [self.detailViewModel disconnetSocket];
    [self.normalGiftAnimationView stopTimerAndArray];
    [self.normalGiftAnimationView initGift];
    [self.normalGiftAnimationView removeFromSuperview];
    _normalGiftAnimationView = nil;
    self.expensiveGiftView.expensiveGiftCount = nil;
    self.expensiveGiftView.expensiveGiftCount = [NSMutableArray array];
    [self.expensiveGiftView stopHaoHUaLiwu];
    [self.allPlatFormGiftView removeFromSuperview];
    [self removePlayer];
}

- (void)pausePlayer {
    if (_livePlayer) {
        [_livePlayer pauseVideo];
        [_livePlayer pauseAudio];
    }

    if (_videoPlayer) {
        [_videoPlayer pause];
//        [_videoPlayer pauseAudio];
    }
}

- (void)resumePlayer {
    if (_livePlayer) {
        [_livePlayer resumeAudio];
        [_livePlayer resumeVideo];
    }

    if (_videoPlayer) {
        [_videoPlayer resume];
//        [_videoPlayer pauseAudio];
    }
}

- (void)dealloc {
//    [self.detailViewModel disconnetSocket];
    [self cancelTimer];
    [self cancelPreviewTimer];
}
- (void)startTimer {
    [self cancelTimer];

    __block NSInteger count = 61;
    WS(weakSelf)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            count--;

            if (count == 0) {
                [weakSelf cancelTimer];

                [weakSelf.detailViewModel.chargeCommand execute:@(YES)];
                return;
            }
        });
    });
    dispatch_resume(_timer);
}

- (void)cancelTimer {
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

- (void)startPreviewTimer {
    [self cancelPreviewTimer];

    __block NSInteger count = 30;
    WS(weakSelf)
    _previewTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_previewTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_previewTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            count--;

            if (count == 0) {
                [weakSelf cancelPreviewTimer];
                if(weakSelf.chargeAlertCon){
                    [weakSelf.chargeAlertCon dismissViewControllerAnimated:NO completion:^{
                        [weakSelf releasePlayer];
                        [weakSelf popBack];
                    }];
                    
                }
              
                return;
            }
            weakSelf.previewBackView.hidden = NO;
            weakSelf.previewLavel.text = [NSString stringWithFormat:@"%@%ld%@",KLanguage(@"预览倒计时"),count,KLanguage(@"秒")];
        });
    });
    dispatch_resume(_previewTimer);
}

- (void)cancelPreviewTimer {
    if (_previewTimer) {
        dispatch_cancel(_previewTimer);
        _previewTimer = nil;
    }
    self.previewBackView.hidden = YES;
    self.previewLavel.text = nil;
}

- (void)swipeDidScroll:(UISwipeGestureRecognizer *)swipe {
//    LCLog(@"%ld",(long)swipe.state);
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showOrHiddenRecommendRoomView];
    }

//    if(swipe.state == UIGestureRecognizerStateBegan ){
//    LCLog(@"2221212");
//        CGPoint point = [swipe locationInView:swipe.view];
//        LCLog(@"清扫位置%@",NSStringFromCGPoint(point));
//    }
}

- (void)showOrHiddenRecommendRoomView {
    self.swipeGes.enabled = NO;
    self.mainScrollView.scrollEnabled = NO;
    self.recommendRoomView.hidden = NO;
    self.recommendRoomView.dataArray = self.detailViewModel.recommendRoomArray;
    [self.recommendRoomView show];
}

- (void)lotteryTicketClicked:(LCGameListModel *)model {
    self.swipeGes.enabled = NO;
    self.mainScrollView.scrollEnabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(NO)];

    if (![model.biaoshi isEqualToString:self.dataModel.caipiao.biaoshi]) {
        [self.detailViewModel sendEndPlayLotteryTicketWithBiaoshi:model.biaoshi];
        [self.detailViewModel sendStartPlayLotteryTicketWithBiaoshi:model.biaoshi];
    }

    LCLiveLotteryTicketDetailView *view = [[LCLiveLotteryTicketDetailView alloc]initWithFrame:CGRectZero];

    view.dataModel = model;
    WS(weakSelf)
    view.dismissBlock = ^{
        weakSelf.toolView.hidden = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(YES)];
        weakSelf.swipeGes.enabled = YES;
        weakSelf.mainScrollView.scrollEnabled = YES;
    };

    view.btnClickBlock = ^(NSInteger index, LCGameListModel *_Nonnull model) {
        if (index == 0) {
            LCGameTipViewController *con = [LCGameTipViewController new];
            con.contentStr = model.content;
            [weakSelf pushToViewController:con];
        } else if (index == 1) {
            LCBettingRecordViewController *con = [LCBettingRecordViewController new];
            con.biaoshi = model.biaoshi;
            [weakSelf pushToViewController:con];
        } else if (index == 2) {
            LCGameWinningHistoryViewController *con = [LCGameWinningHistoryViewController new];
            con.biaoshi = model.biaoshi;
            [weakSelf pushToViewController:con];
        } else {
        }
    };

    view.rechageClickBlock = ^{
        LCRechageViewController *con = [LCRechageViewController new];
        con.needBack = YES;
        [weakSelf pushToViewController:con];
//
    };
    view.backBlock = ^{
        if (weakSelf.selectGameView) {
            weakSelf.selectGameView.hidden = NO;
        }
    };
    view.submitClickBlock = ^(NSMutableArray *_Nonnull array) {
        weakSelf.lotteryTicketDetailView.hidden = YES;
        weakSelf.swipeGes.enabled = NO;
        weakSelf.mainScrollView.scrollEnabled = NO;
        LCLotteryTicketConfimView *confirmView = [[LCLotteryTicketConfimView alloc]initWithFrame:CGRectZero];
        confirmView.zhuboId = weakSelf.dataModel.uid;
        confirmView.dismissBlock = ^{
            weakSelf.lotteryTicketDetailView.hidden = NO;
            weakSelf.swipeGes.enabled = YES;
            weakSelf.mainScrollView.scrollEnabled = YES;
        };
        confirmView.sendBlock = ^(NSDictionary *_Nonnull dic) {
            [weakSelf.detailViewModel sendLotteryTicketMessage:dic];
        };
        confirmView.wanfaSelectArr = array;
        [weakSelf.playControlView addSubview:confirmView];
        [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    };
    [self.playControlView addSubview:view];
    self.lotteryTicketDetailView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark---- guardShowDelegate ----
- (void)buyOrRenewGuard {
    [self removeShouhuView];
    [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(NO)];
    self.swipeGes.enabled = NO;
    self.mainScrollView.scrollEnabled = NO;

    if (!self.guardBuyView) {
        shouhuView *guardView = [[shouhuView alloc]init];
        guardView.liveUid = self.dataModel.uid;
        guardView.stream = self.dataModel.stream;
        guardView.delegate = self;
        guardView.guardType = self.detailViewModel.dataModel.guard.type;
        [self.playControlView addSubview:guardView];
        self.guardBuyView = guardView;
    }

    [self.guardBuyView show];
}

- (void)removeShouhuView {
    if (self.guardBuyView) {
        [self.guardBuyView removeFromSuperview];
        self.guardBuyView = nil;
    }

    if (self.guardListView) {
        [self.guardListView removeFromSuperview];
        self.guardListView = nil;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(YES)];
    self.swipeGes.enabled = YES;
    self.mainScrollView.scrollEnabled = YES;
}

#pragma mark---- haohuadelegate ----
- (void)expensiveGiftdelegate:(NSDictionary *)giftData {
    if (giftData == nil) {
    } else {
        [self.expensiveGiftView addArrayCount:giftData];
    }

    if (self.expensiveGiftView.haohuaCount == 0) {
        [self.expensiveGiftView enGiftEspensive];
    }
}

#pragma mark----platDelgate ----
- (void)platGiftdelegate:(NSDictionary *)giftData {
    if (!self.allPlatFormGiftView) {
        PlatGiftView *platliwuV = [[PlatGiftView alloc]initWithIsPlat:YES];
        platliwuV.delegate = self;
        [self.view addSubview:platliwuV];
        self.allPlatFormGiftView = platliwuV;
        CGAffineTransform t = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
        platliwuV.transform = t;
    }

    if (giftData == nil) {
    } else {
        [self.allPlatFormGiftView addArrayCount:giftData];
    }

    if (self.allPlatFormGiftView.haohuaCount == 0) {
        [self.allPlatFormGiftView enGiftEspensive:YES];
    }
}

#pragma mark---- shouhuViewDelegate ----

- (void)pushCoinV {
    LCRechageViewController *con = [LCRechageViewController new];

    con.needBack = YES;
    [self pushToViewController:con];
}

- (void)buyShouhuSuccess:(NSDictionary *)dic {
    [self.detailViewModel.dataModel mj_setKeyValues:dic];
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    model.level = [NSString stringWithFormat:@"%ld", [dic[@"level"] integerValue]];
    [[LCUserInfoManager shareManager] updateUserInfo:model];
//    self.detailViewModel.dataModel.guard_nums = [NSString stringWithFormat:@"%ld",[dic[@"guard_nums"] integerValue]];
    [self.detailViewModel.dataModel mj_setKeyValues:dic];
    [self.detailViewModel sendBuyGuardMessage:dic];
}

#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailViewModel.msgArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kUI_Width(4);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(4))];

    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCChatMessageModel *model = self.detailViewModel.msgArray[indexPath.section];

    if (model.type == 4) {
        return [tableView fd_heightForCellWithIdentifier:@"LCLiveChatLotteryTicketTableCell"
                                           configuration:^(LCLiveChatLotteryTicketTableCell *cell) {
            cell.dataModel = self.detailViewModel.msgArray[indexPath.section];
        }];
    }

    return [tableView fd_heightForCellWithIdentifier:@"LCLiveChatMessageTableViewCell"
                                       configuration:^(LCLiveChatMessageTableViewCell *cell) {
        cell.dataModel = self.detailViewModel.msgArray[indexPath.section];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCChatMessageModel *model = self.detailViewModel.msgArray[indexPath.section];

    if (model.type == 4) {
        LCLiveChatLotteryTicketTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCLiveChatLotteryTicketTableCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.dataModel = self.detailViewModel.msgArray[indexPath.section];
        WS(weakSelf)
        cell.btnClickedBlock = ^(LCChatMessageModel *_Nonnull selectModel) {
            weakSelf.swipeGes.enabled = NO;
            weakSelf.mainScrollView.scrollEnabled = NO;
            LCLotteryTicketConfimView *confirmView = [[LCLotteryTicketConfimView alloc]initWithFrame:CGRectZero];
            confirmView.zhuboId = weakSelf.dataModel.uid;
            confirmView.dismissBlock = ^{
                weakSelf.swipeGes.enabled = YES;
                weakSelf.mainScrollView.scrollEnabled = YES;
            };
            confirmView.sendBlock = ^(NSDictionary *_Nonnull dic) {
                if (![dic[@"biaoshi"] isEqualToString:weakSelf.dataModel.caipiao.biaoshi]) {
                    [weakSelf.detailViewModel sendEndPlayLotteryTicketWithBiaoshi:dic[@"biaoshi"]];
                }

                [weakSelf.detailViewModel sendLotteryTicketMessage:dic];
            };

            NSMutableArray *a = [LCLotteryTicketWanFaModel mj_objectArrayWithKeyValuesArray:selectModel.lotteryTicketDic[@"wanfa"]];
            LCLotteryTicketWanFaModel *mo = [a firstObject];

            [weakSelf.detailViewModel sendStartPlayLotteryTicketWithBiaoshi:mo.biaoshi];
            confirmView.wanfaSelectArr = a;

            confirmView.selectedBeishu = selectModel.lotteryTicketDic[@"beishu"];
            [weakSelf.playControlView addSubview:confirmView];
            [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(0);
            }];
        };
        return cell;
    }

    LCLiveChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCLiveChatMessageTableViewCell"];

    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;

    cell.dataModel = self.detailViewModel.msgArray[indexPath.section];
    return cell;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.mainScrollView]) {
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.mainScrollView]) {
    }
}

#pragma mark----TXVodPlayListener----
/**
 * 点播事件通知
 *
 * 点播事件通知
 */
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    if (EvtID < 0) {
        [self handlePlayerStartFailureWithCode:EvtID message:param.description url:self.detailViewModel.dataModel.pull];
    }
}

/**
 * 网络状态通知
 *
 * 网络状态通知
 */
- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
}

#pragma mark---- V2TXLivePlayerObserver ----
/////////////////////////////////////////////////////////////////////////////////
//
//                   直播播放器事件回调
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 直播播放器错误通知，播放器出现错误时，会回调该通知
 *
 * @param player    回调该通知的播放器对象
 * @param code      错误码 {@link V2TXLiveCode}
 * @param msg       错误信息
 * @param extraInfo 扩展信息
 */
- (void)onError:(id<V2TXLivePlayer>)player code:(V2TXLiveCode)code message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo {
    [self handlePlayerStartFailureWithCode:code message:msg.length ? msg : extraInfo.description url:self.detailViewModel.dataModel.pull];
}

/**
 * 直播播放器警告通知
 *
 * @param player    回调该通知的播放器对象
 * @param code      警告码 {@link V2TXLiveCode}
 * @param msg       警告信息
 * @param extraInfo 扩展信息
 */
- (void)onWarning:(id<V2TXLivePlayer>)player code:(V2TXLiveCode)code message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo {
}

/**
 * 直播播放器分辨率变化通知
 *
 * @param player    回调该通知的播放器对象
 * @param width     视频宽
 * @param height    视频高
 */
- (void)onVideoResolutionChanged:(id<V2TXLivePlayer>)player width:(NSInteger)width height:(NSInteger)height {
}

/**
 * 已经成功连接到服务器
 *
 * @param player    回调该通知的播放器对象
 * @param extraInfo 扩展信息
 */
- (void)onConnected:(id<V2TXLivePlayer>)player extraInfo:(NSDictionary *)extraInfo {
}

/**
 * 视频播放事件
 *
 * @param player    回调该通知的播放器对象
 * @param firstPlay 第一次播放标志
 * @param extraInfo 扩展信息
 */
- (void)onVideoPlaying:(id<V2TXLivePlayer>)player firstPlay:(BOOL)firstPlay extraInfo:(NSDictionary *)extraInfo {
}

#pragma mark---- UIGestureRecognizerDelegate ----
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if([gestureRecognizer isKindOfClass:UISwipeGestureRecognizer.class] && [gestureRecognizer.view isEqual:self.recommendRoomBackView]){
//        return NO;
//    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.inputMsgView] && [gestureRecognizer isKindOfClass:UITapGestureRecognizer.class] && [gestureRecognizer.view isEqual:self.inputMsgView]) {
        return NO;
    }

//    if([gestureRecognizer isKindOfClass:UISwipeGestureRecognizer.class] && [gestureRecognizer.view isEqual:self.recommendRoomBackView]){
//        return YES;
//    }
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return NO;
//}
#pragma mark---- UITextFieldDelegate-----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
//        [self.view endEditing:YES];
        return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark---- haohuadelegate ----
#pragma mark---- 懒加载 ----


- (TXVodPlayer *)videoPlayer {
    if (!_videoPlayer) {
        TXVodPlayer *player = [[TXVodPlayer alloc]init];
        _videoPlayer = player;
        _videoPlayer.vodDelegate = self;
        TXVodPlayConfig *config = [[TXVodPlayConfig alloc]init];

        _videoPlayer.config = config;

        _videoPlayer.enableHWAcceleration = YES;
        [_videoPlayer setBitrateIndex:-1];
        // 设置循环播放
        [_videoPlayer setLoop:true];
        // 获取当前循环播放状态
        [_videoPlayer loop];
        [_videoPlayer setAudioPlayoutVolume:100];

        [_videoPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        [_videoPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        [_videoPlayer setupVideoWidget:self.playerView insertIndex:0];
    }

    return _videoPlayer;
}

- (V2TXLivePlayer *)livePlayer {
    if (_livePlayer == nil) {
        V2TXLivePlayer *player = [[V2TXLivePlayer alloc]init];
        _livePlayer = player;
        [_livePlayer setObserver:self];
        //自动模式
        [_livePlayer setCacheParams:1 maxTime:5];
        [_livePlayer setRenderFillMode:V2TXLiveFillModeFill];
        [_livePlayer setRenderRotation:V2TXLiveRotation0];
        [_livePlayer setPlayoutVolume:100];
        [_livePlayer setRenderView:self.playerView];
    }

    return _livePlayer;
}

- (UIView *)playerView {
    if (!_playerView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#000000");
        [self.view addSubview:view];
        _playerView = view;
    }

    return _playerView;
}

- (UIImageView *)playHolderImgView {
    if (!_playHolderImgView) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imgView];
        _playHolderImgView = imgView;
        _playHolderImgView.userInteractionEnabled = YES;
    }

    return _playHolderImgView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        [self.playHolderImgView addSubview:view];
        _loadingView = view;
    }

    return _loadingView;
}

- (expensiveGiftV *)expensiveGiftView {
    if (!_expensiveGiftView) {
        expensiveGiftV *view = [[expensiveGiftV alloc]initWithIsPlat:NO];
        view.delegate = self;
        [self.view addSubview:view];
        _expensiveGiftView = view;
    }

    return _expensiveGiftView;
}

- (LCScrollView *)mainScrollView {
    if (_mainScrollView == nil) {
        LCScrollView *sc = [[LCScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        sc.bounces = NO;
        sc.delegate = self;
        sc.backgroundColor = [UIColor clearColor];
        [sc setContentSize:CGSizeMake(2 * SCREEN_WIDTH, SCREEN_HEIGHT)];
        sc.showsHorizontalScrollIndicator = NO;
        sc.directionalLockEnabled = YES;
        sc.alwaysBounceVertical = NO;
        sc.pagingEnabled = YES;
        sc.contentInset = UIEdgeInsetsZero;
        sc.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self.view addSubview:sc];
        _mainScrollView = sc;
    }

    return _mainScrollView;
}

- (UIView *)playControlView {
    if (_playControlView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.mainScrollView addSubview:view];
        _playControlView = view;
        _playControlView.hidden = YES;

        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDidScroll:)];
        swipe.numberOfTouchesRequired = 1;
        swipe.delegate = self;
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [_playControlView addGestureRecognizer:swipe];
        _swipeGes = swipe;
    }

    return _playControlView;
}

- (LCLiveArchorInfoView *)archorInfoView {
    if (_archorInfoView == nil) {
        LCLiveArchorInfoView *view = [[LCLiveArchorInfoView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.3);
        view.clipsToBounds = YES;
        view.layer.cornerRadius = kUI_Width(36) / 2.0;
        [self.playControlView addSubview:view];
        _archorInfoView = view;
        WS(weakSelf)
        _archorInfoView.avaterClickBlock = ^(LCLiveArchorModel *_Nonnull selectModel) {
            LCUserHomeViewController *con = [LCUserHomeViewController new];
            con.userId = selectModel.uid;
            [weakSelf pushToViewController:con];
        };

        _archorInfoView.followBlock = ^{
            [weakSelf.detailViewModel.followCommand execute:@(YES)];
        };
    }

    return _archorInfoView;
}

- (LCLiveUsersView *)audienceView {
    if (!_audienceView) {
        LCLiveUsersView *view = [[LCLiveUsersView alloc]initWithFrame:CGRectZero];
        [self.playControlView addSubview:view];
        _audienceView = view;
        _audienceView.clickBlock = ^{
        };
    }

    return _audienceView;
}

- (UIView *)audienceBackView {
    if (!_audienceBackView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.3);
        view.clipsToBounds = YES;
        view.layer.cornerRadius = kUI_Width(28) / 2.0;
        [self.playControlView addSubview:view];
        _audienceBackView = view;
    }

    return _audienceBackView;
}

- (UILabel *)audienceNumLabel {
    if (!_audienceNumLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
//        label.textAlignment = NSTextAlignmentCenter;
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.audienceBackView addSubview:label];
        _audienceNumLabel = label;
    }

    return _audienceNumLabel;
}

- (UIView *)contributionView {
    if (!_contributionView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.3);
        view.clipsToBounds = YES;
        view.layer.cornerRadius = kUI_Width(24) / 2.0;
        [self.playControlView addSubview:view];
        _contributionView = view;
        view.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            LCPersonalContributeRankViewController *con = [LCPersonalContributeRankViewController new];
            con.userId = weakSelf.dataModel.uid;
            [weakSelf pushToViewController:con];
        }];
        [_contributionView addGestureRecognizer:tap];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveContributionImg")];
        [_contributionView addSubview:imgView];
        UILabel *label = [[UILabel alloc] init];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"贡献榜");
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_contributionView addSubview:label];
        UIImageView *acImgview = [[UIImageView alloc]initWithImage:image(@"icon_liveAccessImg")];
        [_contributionView addSubview:acImgview];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.width.equalTo(kUI_Width(19));
            make.left.equalTo(kUI_Width(8));
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(12));
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(8));
        }];
        [acImgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.mas_equalTo(label.mas_right).offset(kUI_Width(8));
            make.height.width.equalTo(kUI_Width(9));
            make.right.equalTo(-kUI_Width(8));
        }];
    }

    return _contributionView;
}

- (UIView *)guardView {
    if (!_guardView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.3);
        view.clipsToBounds = YES;
        view.layer.cornerRadius = kUI_Width(24) / 2.0;
        view.userInteractionEnabled = YES;
        [self.playControlView addSubview:view];
        _guardView = view;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id _Nonnull sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled
                                                                object:@(NO)];
            weakSelf.swipeGes.enabled = NO;
            weakSelf.mainScrollView.scrollEnabled = NO;
            guardShowView *gShowView = [[guardShowView alloc]initWithFrame:weakSelf.playControlView.bounds
                                                           andUserGuardMsg:[weakSelf.detailViewModel.dataModel.guard mj_JSONObject]
                                                                andLiveUid:weakSelf.dataModel.uid];
            gShowView.delegate = weakSelf;
            [weakSelf.playControlView addSubview:gShowView];
            weakSelf.guardListView = gShowView;
            [gShowView show];
        }];
        [_guardView addGestureRecognizer:tap];
        UILabel *imgView = [[UILabel alloc]initWithFrame:CGRectZero];
        imgView.font = RegularFont(12);
        imgView.textColor = Color(@"#FFFFFF");
        imgView.text = KLanguage(@"守护");
        [_guardView addSubview:imgView];
        [imgView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [imgView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        UILabel *label = [[UILabel alloc] init];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
        [_guardView addSubview:label];
        _guardNumLabel = label;
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        UIImageView *acImgview = [[UIImageView alloc]initWithImage:image(@"icon_liveAccessImg")];
        [_guardView addSubview:acImgview];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(12));
            make.left.equalTo(kUI_Width(8));
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(12));
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(8));
        }];

        [acImgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.mas_equalTo(label.mas_right).offset(kUI_Width(8));
            make.height.width.equalTo(kUI_Width(9));
            make.right.equalTo(-kUI_Width(8));
        }];
    }

    return _guardView;
}

- (UIView *)recommendView {
    if (!_recommendView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.3);
        view.clipsToBounds = YES;
        view.layer.cornerRadius = kUI_Width(24) / 2.0;
        [self.playControlView addSubview:view];
        _recommendView = view;


        UILabel *label = [[UILabel alloc] init];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"为您推荐");
        label.userInteractionEnabled = YES;
        [_recommendView addSubview:label];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        UIImageView *acImgview = [[UIImageView alloc]initWithImage:image(@"icon_liveRoomRecommendAccessImg")];
        [_recommendView addSubview:acImgview];
        acImgview.userInteractionEnabled = YES;
        [acImgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(kUI_Width(8));
            make.height.width.equalTo(kUI_Width(9));
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(12));
            make.left.mas_equalTo(acImgview.mas_right).offset(kUI_Width(8));
            make.right.equalTo(-kUI_Width(8));
        }];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id _Nonnull sender) {
            [weakSelf showOrHiddenRecommendRoomView];
        }];
        [_recommendView addGestureRecognizer:tap];
    }

    return _recommendView;
}

//- (UIImageView *)archorCardImgView {
//    if (_archorCardImgView == nil) {
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        _archorCardImgView = imgView;
//        _archorCardImgView.image = image(@"icon_liveArchorCardImg");
//        _archorCardImgView.userInteractionEnabled = YES;
//
//        [self.playControlView addSubview:_archorCardImgView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id _Nonnull sender) {
//        }];
//        [_archorCardImgView addGestureRecognizer:tap];
//    }
//
//    return _archorCardImgView;
//}

- (UIView *)priceBackView {
    if (!_priceBackView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#F1B24E", 1);
        view.clipsToBounds = YES;
        view.layer.cornerRadius = kUI_Width(24) / 2.0;
        [self.playControlView addSubview:view];
        _priceBackView = view;
    }

    return _priceBackView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        label.textAlignment = NSTextAlignmentCenter;
        [self.priceBackView addSubview:label];
        _priceLabel = label;
    }

    return _priceLabel;
}

- (UIView *)previewBackView {
    if (!_previewBackView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#F1B24E", 1);
        view.clipsToBounds = YES;
        view.layer.cornerRadius = kUI_Width(24) / 2.0;
        [self.playControlView addSubview:view];
        _previewBackView = view;
    }

    return _previewBackView;
}

- (UILabel *)previewLavel {
    if (!_previewLavel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        label.textAlignment = NSTextAlignmentCenter;
        [self.previewBackView addSubview:label];
        _previewLavel = label;
    }

    return _previewLavel;
}

- (UIView *)giftBackView {
    if (!_giftBackView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.playControlView addSubview:view];
        _giftBackView = view;
        continueGift *giftView = [[continueGift alloc]init];
        [_giftBackView addSubview:giftView];
        _normalGiftAnimationView = giftView;
        [giftView initGift];
    }

    return _giftBackView;
}

- (LCBaseTableView *)messageTableView {
    if (_messageTableView == nil) {
        LCBaseTableView *tableView = [LCBaseTableView addTablePlain];
        _messageTableView = tableView;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.showsVerticalScrollIndicator = NO;
        _messageTableView.dataSource = self;
        _messageTableView.delegate = self;
        _messageTableView.backgroundColor = [UIColor clearColor];
        [self.playControlView addSubview:_messageTableView];
        [_messageTableView registerClass:[LCLiveChatMessageTableViewCell class] forCellReuseIdentifier:@"LCLiveChatMessageTableViewCell"];
        [_messageTableView registerClass:[LCLiveChatLotteryTicketTableCell class] forCellReuseIdentifier:@"LCLiveChatLotteryTicketTableCell"];
    }

    return _messageTableView;
}

- (UIView *)roomGameView {
    if (!_roomGameView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        view.clipsToBounds = YES;

        [self.playControlView addSubview:view];
        _roomGameView = view;
        _roomGameView.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id _Nonnull sender) {
            [weakSelf lotteryTicketClicked:weakSelf.dataModel.caipiao];
        }];
        [_roomGameView addGestureRecognizer:tap];
    }

    return _roomGameView;
}

- (UIImageView *)roomGameImgView {
    if (!_roomGameImgView) {
        UIImageView *acImgview = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.roomGameView addSubview:acImgview];
        _roomGameImgView = acImgview;
    }

    return _roomGameImgView;
}

- (UILabel *)roomGameTimerLabel {
    if (!_roomGameTimerLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = MediumFont(12);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.roomGameView addSubview:label];
        _roomGameTimerLabel = label;
        _roomGameTimerLabel.layer.shadowColor = ColorAlpha(@"#000000", 0.5).CGColor;
        _roomGameTimerLabel.layer.shadowOffset = CGSizeMake(0, 1);
        _roomGameTimerLabel.layer.shadowOpacity = 1;
    }

    return _roomGameTimerLabel;
}

- (LCLiveGameRecommendView *)recommendGameView {
    if (!_recommendGameView) {
        LCLiveGameRecommendView *view = [[LCLiveGameRecommendView alloc]initWithFrame:CGRectZero];
        [self.playControlView addSubview:view];
        _recommendGameView = view;
        _recommendGameView.gameClickBlock = ^(id _Nonnull model) {
        };
    }

    return _recommendGameView;
}

- (LCLiveHighUserLevelAnimationView *)userHighAnimationView {
    if (!_userHighAnimationView) {
        LCLiveHighUserLevelAnimationView *view = [[LCLiveHighUserLevelAnimationView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.playControlView addSubview:view];
        _userHighAnimationView = view;
    }

    return _userHighAnimationView;
}

- (LCLiveEnterRoomView *)userEnterRoomView {
    if (!_userEnterRoomView) {
        LCLiveEnterRoomView *view = [[LCLiveEnterRoomView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.playControlView addSubview:view];
        _userEnterRoomView = view;
    }

    return _userEnterRoomView;
}

- (LCLiveToolView *)toolView {
    if (!_toolView) {
        LCLiveToolView *view = [[LCLiveToolView alloc]initWithFrame:CGRectZero];
        [self.playControlView addSubview:view];
        _toolView = view;
        WS(weakSelf)
        _toolView.btnClickBlock = ^(NSInteger index) {
            if (index == 0) {
                weakSelf.toolView.hidden = YES;
                weakSelf.inputShelterView.hidden = NO;
                [weakSelf.msgTextField becomeFirstResponder];
            } else if (index == 1) {
                //客服
                
                LCCommonWebViewController *con = [LCCommonWebViewController new];
                
                con.titleStr = KLanguage(@"客服");
                con.url = [LCConfigManager shareManager].kefuUrl;
                [weakSelf pushToViewController:con];
            } else if (index == 2) {
                weakSelf.toolView.hidden = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(NO)];
                weakSelf.swipeGes.enabled = NO;
                weakSelf.mainScrollView.scrollEnabled = NO;
                LCLiveActivitysView *activityView = [[LCLiveActivitysView alloc]initWithFrame:CGRectZero];
                activityView.activityClickBlock = ^(LCActivityModel *_Nonnull selectModel) {
                    LCCommonWebViewController *con = [LCCommonWebViewController new];
                    con.titleStr = selectModel.title;
                    con.url = selectModel.aurl;
                    [weakSelf pushToViewController:con];
                };
                activityView.dismissBlock = ^{
                    weakSelf.toolView.hidden = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(YES)];

                    weakSelf.swipeGes.enabled = YES;
                    weakSelf.mainScrollView.scrollEnabled = YES;
                };
                [weakSelf.view addSubview:activityView];
                [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(0);
                }];
            } else if (index == 3) {
                weakSelf.toolView.hidden = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(NO)];
                weakSelf.swipeGes.enabled = NO;
                weakSelf.mainScrollView.scrollEnabled = NO;
                //礼物
                LCLiveGiftListView *giftView = [[LCLiveGiftListView alloc]initWithFrame:CGRectZero];
                giftView.roomId = weakSelf.detailViewModel.dataModel.uid;
                giftView.stream = weakSelf.detailViewModel.dataModel.stream;
                giftView.rechageClickBlock = ^{
                    LCRechageViewController *con = [LCRechageViewController new];
                    con.needBack = YES;
                    [weakSelf pushToViewController:con];
                };
                giftView.sendClickBlock = ^(NSString *_Nonnull giftToken, NSString *_Nonnull nums) {
                    [weakSelf.detailViewModel sendGiftWithModel:giftToken num:nums.integerValue];
                };
                giftView.dismissBlock = ^{
                    weakSelf.toolView.hidden = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(YES)];
                    weakSelf.swipeGes.enabled = YES;
                    weakSelf.mainScrollView.scrollEnabled = YES;
                };
                [self.view addSubview:giftView];
                [giftView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(0);
                }];
            } else if (index == 4) {
                //游戏
                weakSelf.toolView.hidden = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(NO)];
                weakSelf.swipeGes.enabled = NO;
                weakSelf.mainScrollView.scrollEnabled = NO;
                LCLiveGamesSelectView *giftView = [[LCLiveGamesSelectView alloc]initWithFrame:CGRectZero];
//                giftView.roomId = weakSelf.detailViewModel.dataModel.uid;
//                giftView.stream = weakSelf.detailViewModel.dataModel.stream;
                giftView.rechageClickBlock = ^{
                    LCRechageViewController *con = [LCRechageViewController new];
                    con.needBack = YES;
                    [weakSelf pushToViewController:con];
                };
                giftView.gameCenterClickBlock = ^{
                    LCGameCenterViewController *con = [LCGameCenterViewController new];
                    con.needBack = YES;
                    [weakSelf pushToViewController:con];
                };
                giftView.dismissBlock = ^{
                    weakSelf.toolView.hidden = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(YES)];
                    weakSelf.swipeGes.enabled = YES;
                    weakSelf.mainScrollView.scrollEnabled = YES;
                };
                [weakSelf.view addSubview:giftView];
                weakSelf.selectGameView = giftView;

                [giftView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(0);
                }];
            } else if (index == 5) {
                [weakSelf.detailViewModel disconnetSocket];
                [weakSelf releasePlayer];

                [weakSelf popBack];
            }
        };
    }

    return _toolView;
}

- (UIView *)inputShelterView {
    if (_inputShelterView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        _inputShelterView = view;
        [self.view addSubview:_inputShelterView];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id _Nonnull sender) {
            [weakSelf.msgTextField resignFirstResponder];
        }];
        tap.delegate = self;

        [_inputShelterView addGestureRecognizer:tap];
    }

    return _inputShelterView;
}

- (UIView *)inputMsgView {
    if (!_inputMsgView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        [self.inputShelterView addSubview:view];
        _inputMsgView = view;
        UIButton *danmuBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [danmuBtn setImage:image(@"icon_danmuNormalImg") forState:UIControlStateNormal];
        [danmuBtn setImage:image(@"icon_danmuSelectedImg") forState:UIControlStateSelected];

        [_inputMsgView addSubview:danmuBtn];
        _danmuBtn = danmuBtn;
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
        textField.backgroundColor = Color(@"#E6E8EB");
        textField.textColor = Color(@"#333333");
        textField.font = MediumFont(14);
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUI_Width(12), kUI_Width(27))];
        textField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUI_Width(12), kUI_Width(27))];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeNever;
        textField.delegate = self;
        textField.layer.cornerRadius = kUI_Width(27) / 2.0;
        textField.clipsToBounds = YES;
//        textField.borderStyle
        [_inputMsgView addSubview:textField];
        _msgTextField = textField;
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setTitle:KLanguage(@"发送") forState:UIControlStateNormal];
        [sendBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        sendBtn.backgroundColor = Color(@"#EF3E8C");
        sendBtn.layer.cornerRadius = kUI_Width(4);
        sendBtn.clipsToBounds = YES;
        [_inputMsgView addSubview:sendBtn];
        sendBtn.selected = self.detailViewModel.isDanmu;
        WS(weakSelf)
        [[danmuBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
            x.selected = !x.selected;
            weakSelf.detailViewModel.isDanmu = x.selected;
        }];
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
            if (weakSelf.detailViewModel.isDanmu) {
                if (!weakSelf.msgTextField.text.length) {
                    [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请输入弹幕")];
                    return;
                }
                [weakSelf.detailViewModel.sendDanmuCommand execute:weakSelf.msgTextField.text];
               
            } else {
                if (!weakSelf.msgTextField.text.length) {
                    [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请输入消息")];
                    return;
                }

                [weakSelf.detailViewModel sendMessageWithText:weakSelf.msgTextField.text];
                weakSelf.msgTextField.text = nil;
            }
        }];
        [danmuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(27));
            make.width.equalTo(kUI_Width(64));
            make.centerY.equalTo(0);
        }];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(danmuBtn.mas_right).offset(kUI_Width(12));
            make.right.mas_equalTo(sendBtn.mas_left).offset(-kUI_Width(10));
            make.height.equalTo(kUI_Width(27));
            make.centerY.equalTo(0);
        }];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(27));
            make.width.equalTo(kUI_Width(50));
            make.centerY.equalTo(0);
        }];
    }

    return _inputMsgView;
}

- (LCLiveRecommendRoomView *)recommendRoomView {
    if (!_recommendRoomView) {
        LCLiveRecommendRoomView *view = [[LCLiveRecommendRoomView alloc]initWithFrame:CGRectZero];
        _recommendRoomView = view;
        WS(weakSelf)
        _recommendRoomView.dismissBlock = ^{
            weakSelf.swipeGes.enabled = YES;
            weakSelf.mainScrollView.scrollEnabled = YES;
        };
        _recommendRoomView.selectOtherRoomBlock = ^(NSArray *_Nonnull arr, LCHomeListModel *_Nonnull model) {
//            [weakSelf.detailViewModel disconnetSocket];
//            [weakSelf pausePlayer];
            LCLiveViewController *con = [LCLiveViewController new];


            con.dataArray = arr;
            con.index = [arr indexOfObject:model];

            [weakSelf pushToViewController:con];
        };
        _recommendRoomView.hidden = YES;
        [self.playControlView addSubview:_recommendRoomView];
        [_recommendRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.width.mas_equalTo(self.playerView.mas_width);
        }];
    }

    return _recommendRoomView;
}
- (GrounderSuperView *)danmuDisplayView{
    if(!_danmuDisplayView){
        GrounderSuperView *danmuView = [[GrounderSuperView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 140)];
        [self.playControlView addSubview:danmuView];
        _danmuDisplayView = danmuView;
    }
    return _danmuDisplayView;
}
//- (LCLiveChatViewModel *)chatViewModel {
//    if (_chatViewModel == nil) {
//        _chatViewModel = [LCLiveChatViewModel new];
//    }
//
//    return _chatViewModel;
//}

- (LCLiveDetailViewModel *)detailViewModel {
    if (_detailViewModel == nil) {
        _detailViewModel = [LCLiveDetailViewModel new];
        _detailViewModel.origalModel = self.dataModel;
    }

    return _detailViewModel;
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
