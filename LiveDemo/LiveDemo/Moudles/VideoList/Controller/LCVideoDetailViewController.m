//
//  LCVideoDetailViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCVideoDetailViewController.h"
#import "LCVideoListCollectionViewCell.h"
#import "LCNoDataCollectionViewCell.h"
#import "LCVideoDetailCollectionHeaderView.h"
#import "LCWaterFlowCollectionLayout.h"
#import "LCVideoDetailViewModel.h"
#import "LCGameCenterViewController.h"
#import <ZFPlayer.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "LCLiveGamesSelectView.h"
#import "LCLiveLotteryTicketDetailView.h"
#import "LCGameTipViewController.h"
#import "LCBettingRecordViewController.h"
#import "LCGameWinningHistoryViewController.h"
#import "LCRechageViewController.h"
#import "LCLotteryTicketConfimView.h"
#import "LCCommonWebViewController.h"
#import "LCLanguageManager.h"
#import "LCVipWebViewController.h"
#import "ChessCardWebVC.h"

#import "LCBindPhoneViewController.h"
@interface LCVideoDetailViewController ()<UICollectionViewDataSource,LCWaterFlowCollectionLayoutDelegate,UICollectionViewDelegate>
{
    dispatch_source_t _timer;
}
@property (nonatomic , assign)NSInteger cutDownTime;
@property (nonatomic , weak)UIImageView *playerView;
@property (nonatomic , weak)UIView *preView;
@property (nonatomic , weak)UILabel *cutdownLabel;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, weak) UIButton *backBtn;

@property (nonatomic , weak)LCBaseCollectionView *mainCollectionView;
@property (nonatomic , strong)LCVideoDetailViewModel *viewModel;
@property(nonatomic,weak)LCLiveGamesSelectView *selectGameView;
@property (nonatomic , weak)LCLiveLotteryTicketDetailView *lotteryTicketDetailView;
@end

@implementation LCVideoDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.cutDownTime = 180;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([LCUserInfoManager shareManager].userInfo.vip_type.intValue == 0 && self.player.currentPlayerManager.isPreparedToPlay){
        if([self.viewModel.currentVideoModel.isvip boolValue]){
            if(_timer && (self.cutDownTime != 180 && self.cutDownTime != 0) ){
                [self.player.currentPlayerManager play];
                [self startTimer];
            }else {
                [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"温馨提示") message:KLanguage(@"试看结束，请开通会员后继续观看！") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"升级VIP") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if(buttonIndex == controller.destructiveButtonIndex){
                        NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,@"/Appapi/Mall/index"];
                        LCVipWebViewController *con = [LCVipWebViewController new];
                        con.url = [self addurl:url];
                        [self pushToViewController:con];
                    }else if (buttonIndex == controller.cancelButtonIndex){
                        [self.player stop];
                        [self popBack];
                    }
                }];
            }
            
            
            
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
    [self cancelTimer];
    [self.player.currentPlayerManager pause];
//    if(self.selectGameView){
//        [self.selectGameView removeFromSuperview];
//        
//    }
//    if(self.lotteryTicketDetailView){
//        [self.lotteryTicketDetailView removeFromSuperview];
//    }
}
- (void)dealloc{
    [self cancelTimer];
}
- (void)lc_addSubviews{
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(kStatusBarHeight);
        make.height.mas_equalTo(self.playerView.mas_width).multipliedBy(9/16.0);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(12));
        make.width.height.equalTo(kUI_Width(18));
        make.top.equalTo(kUI_Width(14));
    }];
    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kUI_Width(24));
        make.right.equalTo(-kUI_Width(12));
        make.top.equalTo(kUI_Width(12));
    }];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.mas_equalTo(self.playerView.mas_bottom);
    }];
}
- (void)lc_bindViewModel{
    @weakify(self)
    
    [[RACObserve(self.viewModel, currentVideoModel) takeUntil:self.rac_willDeallocSignal]subscribeNext:^(LCVideoListModel * _Nullable x) {
       @strongify(self)
        self.player.assetURL = [NSURL URLWithString:x.href] ;
        [self.player playTheIndex:0];
        [self.controlView showTitle:@"" coverURLString:x.thumb fullScreenMode:ZFFullScreenModeLandscape];
    }];
    
    [[[self.viewModel.loadDataCommend.executing skip:1] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            self.mainCollectionView.mj_footer.hidden = YES;
            if (self.mainCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.mainCollectionView.mj_footer resetNoMoreData];
                
            }
        }else{
            self.mainCollectionView.mj_footer.hidden = NO;
        }
    }];
//      [[self.viewModel.nextPageCommand.executing takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
//          @strongify(self)
//          self.isPreloading = x.boolValue;
//    }];
    
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.mainCollectionView.mj_header.isRefreshing) {
            [self.mainCollectionView.mj_header endRefreshing];
        }
        if (self.mainCollectionView.mj_footer.isRefreshing) {
            [self.mainCollectionView.mj_footer endRefreshing];
        }
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainCollectionView.hidden = NO;
        
        self.mainCollectionView.mj_footer.hidden = !self.viewModel.dataArray.count;
        
        [UIView animateWithDuration:0 animations:^{
            [self.mainCollectionView reloadData];
        }];
        
        
    }];

 
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCVideoLotteryTicketSelectNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
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
    
    [[self.viewModel.noMoreDataSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber  *_Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    
   
    [self.viewModel.loadDataCommend execute:@(YES)];
}
- (void)lotteryTicketClicked:(LCGameListModel *)model {
//    self.swipeGes.enabled = NO;
//    self.mainScrollView.scrollEnabled = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveNeedMakeScrollEnabled object:@(NO)];

    
    LCLiveLotteryTicketDetailView *view = [[LCLiveLotteryTicketDetailView alloc]initWithFrame:CGRectZero];
    
    view.dataModel = model;
    view.isFromVideo = YES;
    WS(weakSelf)
    view.dismissBlock = ^{
        
    };
    
    view.btnClickBlock = ^(NSInteger index, LCGameListModel *_Nonnull model) {
        if (index == 0) {
            LCGameTipViewController *con = [LCGameTipViewController new];
            con.contentStr = model.content;
            [(LCBaseViewController *)weakSelf pushToViewController:con];
        } else if (index == 1) {
            LCBettingRecordViewController *con = [LCBettingRecordViewController new];
            con.biaoshi = model.biaoshi;
            [(LCBaseViewController *)weakSelf pushToViewController:con];
        } else if (index == 2) {
            LCGameWinningHistoryViewController *con = [LCGameWinningHistoryViewController new];
            con.biaoshi = model.biaoshi;
            [(LCBaseViewController *)weakSelf pushToViewController:con];
        } else {
        }
    };

    view.rechageClickBlock = ^{
        LCRechageViewController *con = [LCRechageViewController new];
        con.needBack = YES;
        [(LCBaseViewController *)weakSelf pushToViewController:con];
//
    };
    view.backBlock = ^{
        if (weakSelf.selectGameView) {
            weakSelf.selectGameView.hidden = NO;
        }
    };
    view.submitClickBlock = ^(NSMutableArray *_Nonnull array) {
        weakSelf.lotteryTicketDetailView.hidden = YES;
      
        LCLotteryTicketConfimView *confirmView = [[LCLotteryTicketConfimView alloc]initWithFrame:CGRectZero];
        
        confirmView.dismissBlock = ^{
            weakSelf.lotteryTicketDetailView.hidden = NO;
           
        };
        confirmView.sendBlock = ^(NSDictionary *_Nonnull dic) {
            
        };
        confirmView.wanfaSelectArr = array;
        [weakSelf.view addSubview:confirmView];
        [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    };
    [self.view addSubview:view];
    self.lotteryTicketDetailView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (void)startTimer{
    [self cancelTimer];
    
    
    WS(weakSelf)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.cutDownTime --;
            if (weakSelf.cutDownTime == 0) {
                weakSelf.cutdownLabel.text = KLanguage(@"试看结束");
                [weakSelf cancelTimer];
                weakSelf.cutDownTime = 180;
                [weakSelf.player.currentPlayerManager pause];
                [UIAlertController showAlertInViewController:weakSelf withTitle:KLanguage(@"温馨提示") message:KLanguage(@"试看结束，请开通会员后继续观看！") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"升级VIP") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if(buttonIndex == controller.destructiveButtonIndex){
                        NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,@"/Appapi/Mall/index"];
                        LCVipWebViewController *con = [LCVipWebViewController new];
                        con.url = [weakSelf addurl:url];
                        [weakSelf pushToViewController:con];
                    }else if (buttonIndex == controller.cancelButtonIndex){
                        [weakSelf.player stop];
                        [weakSelf popBack];
                    }
                }];
                
                return;
            }
//            [weakSelf.checkCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSString *str = [NSString stringWithFormat:@"%lds%@", weakSelf.cutDownTime,KLanguage(@"秒后试看结束") ];
            weakSelf.cutdownLabel.text = str;

        });
    });
    dispatch_resume(_timer);
}
- (void)cancelTimer {
    
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
   
    
//    [self.checkCodeBtn setTitleColor:[UIColor colorWithHexString:kColor_9C9C9C] forState:UIControlStateNormal];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
#pragma mark----LCWaterFlowCollectionLayout----
/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为WSLWaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 WSLWaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 WSLWaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 WSLWaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.viewModel.dataArray.count == 0){
        CGFloat width = self.mainCollectionView.width  - kUI_Width(12) * 2;
        return CGSizeMake(width, self.mainCollectionView.height  );
    }
    CGFloat width = (self.mainCollectionView.width  - kUI_Width(12) * 2 - kUI_Width(15))/2.0;
    LCVideoListModel *model = self.viewModel.dataArray[indexPath.item];
    CGFloat height = [model.title sizeForFont:RegularFont(12) size:CGSizeMake(width, RegularFont(12).lineHeight* 2) mode:NSLineBreakByCharWrapping].height;
    return CGSizeMake(width, height + kUI_Width(96) + kUI_Width(8));
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    if(section == 0 ){
   
            if([LCUserInfoManager shareManager].userInfo.vip_type.intValue != 0){
                CGFloat height = [self.viewModel.currentVideoModel.title sizeForFont:BoldFont(14) size:CGSizeMake(self.mainCollectionView.width - kUI_Width(12) * 2, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping].height;
                
                CGFloat width = self.mainCollectionView.width  - kUI_Width(12) * 2;
                
                return CGSizeMake(width, kUI_Width(7)+height + kUI_Width(15)+kUI_Width(12)+kUI_Width(10) + kUI_Width(25) + kUI_Width(10));
            }else{
                CGFloat height = [self.viewModel.currentVideoModel.title sizeForFont:BoldFont(14) size:CGSizeMake(self.mainCollectionView.width - kUI_Width(12) * 2, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping].height;
                
                CGFloat width = self.mainCollectionView.width  - kUI_Width(12) * 2;
                
                return CGSizeMake(width, kUI_Width(7)+height + kUI_Width(15)+kUI_Width(12)+kUI_Width(10) + kUI_Width(25) + kUI_Width(10) + kUI_Width(10) + kUI_Width(46)) ;
            }
        
    }
    
    return CGSizeZero;
}
///** 脚视图Size */
//-(CGSize )waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
//    return CGSizeZero;
//}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionHeader]){
        LCVideoDetailCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCVideoDetailCollectionHeaderView" forIndexPath:indexPath];
        view.dataModel = self.viewModel.currentVideoModel;
        WS(weakSelf)
        view.vipClickedBlock = ^{
            [weakSelf.player.currentPlayerManager pause];
            [weakSelf cancelTimer];
            
            [UIAlertController showAlertInViewController:weakSelf withTitle:KLanguage(@"温馨提示") message:KLanguage(@"确定升级VIP？") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"升级VIP") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.destructiveButtonIndex){
                    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,@"/Appapi/Mall/index"];
                    LCVipWebViewController *con = [LCVipWebViewController new];

                    
                //    con.titleStr = KLanguage(@"充值记录");
                    con.url = [weakSelf addurl:url];
                    [weakSelf pushToViewController:con];
                }else if (buttonIndex == controller.cancelButtonIndex){
                    [weakSelf.player stop];
                    [weakSelf popBack];
                }
            }];
        };
        view.gameCenterClickBlock = ^{
            LCLiveGamesSelectView *giftView = [[LCLiveGamesSelectView alloc]initWithFrame:CGRectZero];
            giftView.isFromVideo = YES;

            giftView.rechageClickBlock = ^{
                LCRechageViewController *con = [LCRechageViewController new];
                con.needBack = YES;
                [(LCBaseViewController *)weakSelf pushToViewController:con];
            };
            giftView.gameCenterClickBlock = ^{
                LCGameCenterViewController *con = [LCGameCenterViewController new];
                con.needBack = YES;
                [(LCBaseViewController *)weakSelf pushToViewController:con];
            };
            giftView.dismissBlock = ^{
               
                
               
            };
            [weakSelf.view addSubview:giftView];
            weakSelf.selectGameView = giftView;

            [giftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(0);
            }];
        };
        return view;
    }
    return nil;
    
}
    -(NSString *)addurl:(NSString *)url{
        return [url stringByAppendingFormat:@"?uid=%@&token=%@&lang=%@",[LCUserInfoManager shareManager].userInfo.ID,[LCUserInfoManager shareManager].userInfo.token,[[LCLanguageManager shareManager]getLanguageEncode]];
    }
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout{
    if(self.viewModel.dataArray.count == 0){
        return 1;
    }
    return 2;
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout{
    return kUI_Width(15);
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout{
    return kUI_Width(10);
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(0, kUI_Width(12), 0, kUI_Width(12));
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count ? self.viewModel.dataArray.count : 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.dataArray.count == 0){
        LCNoDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCNoDataCollectionViewCell" forIndexPath:indexPath];
        cell.titleStr = KLanguage(@"暂无相关视频");
        cell.customBgColor = collectionView.backgroundColor;
        return cell;
    }
    LCVideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCVideoListCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel = self.viewModel.dataArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.dataArray.count != 0){
        LCVideoListModel *model = self.viewModel.dataArray[indexPath.item];
        self.viewModel.currentVideoModel = model;
    }
}
- (void)playClick:(UIButton *)btn{
    
}
#pragma mark ---- 懒加载----
- (UIImageView *)playerView{
    if(_playerView == nil){
        UIImageView *imgView= [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.backgroundColor = Color(@"#000000");
        [self.view addSubview:imgView];
        _playerView = imgView;
    }
    return _playerView;
}
- (UIView *)preView{
    if(!_preView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.5);
        view.layer.cornerRadius = kUI_Width(24)/2.0;
        view.clipsToBounds = YES;
        [self.playerView addSubview:view];
        _preView = view;
        _preView.hidden = YES;
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        timeLabel.font = RegularFont(12);
        timeLabel.textColor = Color(@"#FFFFFF");
        [_preView addSubview:timeLabel];
        _cutdownLabel = timeLabel;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:KLanguage(@"开通会员") forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFB462") forState:UIControlStateNormal];
        btn.titleLabel.font = RegularFont(12);
        [_preView addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.player.currentPlayerManager pause];
            [weakSelf cancelTimer];
            
            [UIAlertController showAlertInViewController:weakSelf withTitle:KLanguage(@"温馨提示") message:KLanguage(@"确定升级VIP？") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"升级VIP") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.destructiveButtonIndex){
                    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,@"/Appapi/Mall/index"];
                    LCVipWebViewController *con = [LCVipWebViewController new];

                    
                //    con.titleStr = KLanguage(@"充值记录");
                    con.url = [weakSelf addurl:url];
                    [weakSelf pushToViewController:con];
                }else if (buttonIndex == controller.cancelButtonIndex){
                    [weakSelf.player stop];
                    [weakSelf popBack];
                }
            }];
        }];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(12));
            make.left.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
            make.right.mas_equalTo(btn.mas_left).offset(-kUI_Width(12));
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
            make.width.equalTo(kUI_Width(50));
        }];
        
    }
    return _preView;
}
- (ZFPlayerController *)player{
    if(_player == nil){
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//       ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
//
//        playerManager.shouldAutoPlay = YES;
        
        /// 播放器相关
        self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.playerView];
        self.player.controlView = self.controlView;
        
        WS(weakSelf)
        self.player.playerPrepareToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
            [weakSelf.playerView bringSubviewToFront:weakSelf.backBtn];
            if([LCUserInfoManager shareManager].userInfo.vip_type.intValue == 0){
                if([weakSelf.viewModel.currentVideoModel.isvip boolValue]){
                    weakSelf.cutDownTime = 180;
                    [weakSelf startTimer];
                    weakSelf.preView.hidden = NO;
                    [weakSelf.playerView bringSubviewToFront:weakSelf.preView];
                    
                    
                }
            }
        };
      
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
//            if(isFullScreen){
////                weakSelf.controlView.fullScreenMode = ZFFullScreenModeLandscape;
//                [weakSelf.player rotateToOrientation:UIInterfaceOrientationLandscapeRight animated:YES completion:nil];
//            }else{
////                weakSelf.controlView.fullScreenMode = ZFFullScreenModeLandscape;
//                [weakSelf.player rotateToOrientation:UIInterfaceOrientationPortrait animated:YES completion:nil];
//            }
//            
            
        };
        self.player.orientationDidChanged = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            if(isFullScreen){
                if([LCUserInfoManager shareManager].userInfo.vip_type.intValue == 0){
                    if([weakSelf.viewModel.currentVideoModel.isvip boolValue]){
                        
                        [weakSelf.playerView bringSubviewToFront:weakSelf.preView];
                        
                        
                    }
                }
            }else{
                if([LCUserInfoManager shareManager].userInfo.vip_type.intValue == 0){
                    if([weakSelf.viewModel.currentVideoModel.isvip boolValue]){
                        
                        [weakSelf.playerView bringSubviewToFront:weakSelf.preView];
                        
                        
                    }
                }
                [weakSelf.playerView bringSubviewToFront:weakSelf.backBtn];
            }
        };
    }
    return _player;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
        _controlView.showCustomStatusBar = NO;
    }
    return _controlView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playerView addSubview:btn];
        _backBtn = btn;
        [_backBtn setImage:image(@"icon_videoDetailBack") forState:UIControlStateNormal];
        WS(weakSelf)
        [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf popBack];
        }];
    }
    return _backBtn;
}
- (LCBaseCollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        LCWaterFlowCollectionLayout *collectionLayout = [[LCWaterFlowCollectionLayout alloc] init];
        collectionLayout.delegate = self;
        collectionLayout.flowLayoutStyle = LCWaterFlowVerticalEqualWidth;
        
        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mainCollectionView = collectionView;
//        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, kUI_Width(20), 0, kUI_Width(20));
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainCollectionView];
        [_mainCollectionView registerClass:[LCVideoListCollectionViewCell class] forCellWithReuseIdentifier:@"LCVideoListCollectionViewCell"];
        [_mainCollectionView registerClass:[LCNoDataCollectionViewCell class] forCellWithReuseIdentifier:@"LCNoDataCollectionViewCell"];
        [_mainCollectionView registerClass:[LCVideoDetailCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCVideoDetailCollectionHeaderView"];
        
       
        WS(weakSelf)
       
        _mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
          
                [weakSelf.viewModel.nextPageCommand execute:@(YES)];
            
        }];
        _mainCollectionView.mj_footer.hidden = YES;
    }
    return _mainCollectionView;
}
- (LCVideoDetailViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCVideoDetailViewModel new];
        _viewModel.currentVideoModel = self.dataModel;
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
