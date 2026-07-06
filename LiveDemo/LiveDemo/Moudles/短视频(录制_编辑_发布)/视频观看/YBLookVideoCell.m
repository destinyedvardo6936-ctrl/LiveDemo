//
//  YBLookVideoCell.m
//  yunbaolive
//
//  Created by ybRRR on 2020/9/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "YBLookVideoCell.h"
#import "LCLiveGamesSelectView.h"
#import "LCLiveLotteryTicketDetailView.h"
#import "LCGameTipViewController.h"
#import "LCBettingRecordViewController.h"
#import "LCGameWinningHistoryViewController.h"
#import "LCRechageViewController.h"
#import "LCGameCenterViewController.h"
#import "LCLotteryTicketConfimView.h"
#import "ChessCardWebVC.h"

#import "LCBindPhoneViewController.h"
//#import "otherUserMsgVC.h"
//#import "OutsideGoodsDetailVC.h"
//#import "CommodityDetailVC.h"
//#import "PayVideoDetailVC.h"
@interface YBLookVideoCell()

/** 头像 点赞 评论 分享集合 */
@property(nonatomic,strong)UIView *rightView;
@property (nonatomic , weak) UIButton *gameBtn;
@property(nonatomic,strong) UIButton *iconBtn;
@property(nonatomic,strong) UIButton *followBtn;                    //关注
@property(nonatomic,strong) UIButton *likebtn;                      //点赞
@property(nonatomic,strong) UIButton *enjoyBtn;
/** 名字 标题 (音乐)集合 */
@property(nonatomic,strong)UIView *botView;
@property(nonatomic,strong)UILabel *titleL;                         //视频标题
@property(nonatomic,strong)UILabel *nameL;

@property(nonatomic,strong) UIButton *shopButton;                 //商品按钮
@property(nonatomic,weak)LCLiveGamesSelectView *selectGameView;
@property (nonatomic , weak)LCLiveLotteryTicketDetailView *lotteryTicketDetailView;
@end

@implementation YBLookVideoCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.centerX.centerY.equalTo(self.contentView);
        }];
        [self setUp];
        
        WS(weakSelf)
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCVideoLotteryTicketSelectNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
            LCGameListModel *model = x.object;

            if (weakSelf.selectGameView) {
                weakSelf.selectGameView.hidden = YES;
            }
            if(model.ismy){
                [weakSelf lotteryTicketClicked:model];
            }else{
                if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
                    [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if(buttonIndex == controller.destructiveButtonIndex){
                            LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                            [(LCBaseViewController *)weakSelf.findViewController pushToViewController:con];
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
                        [(LCBaseViewController *)weakSelf.findViewController pushToViewController:webVC];
                    }

                                } failure:^(NSError * _Nullable error) {
                                    [SVProgressHUD showErrorWithStatus:error.domain];
                                }];
            }
            
        }];
    }
    return self;
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
        if (weakSelf.videoCellEvent) {
            weakSelf.videoCellEvent(@"游戏消失", nil);
        }
    };
    
    view.btnClickBlock = ^(NSInteger index, LCGameListModel *_Nonnull model) {
        if (index == 0) {
            LCGameTipViewController *con = [LCGameTipViewController new];
            con.contentStr = model.content;
            [(LCBaseViewController *)weakSelf.findViewController pushToViewController:con];
        } else if (index == 1) {
            LCBettingRecordViewController *con = [LCBettingRecordViewController new];
            con.biaoshi = model.biaoshi;
            [(LCBaseViewController *)weakSelf.findViewController pushToViewController:con];
        } else if (index == 2) {
            LCGameWinningHistoryViewController *con = [LCGameWinningHistoryViewController new];
            con.biaoshi = model.biaoshi;
            [(LCBaseViewController *)weakSelf.findViewController pushToViewController:con];
        } else {
        }
    };

    view.rechageClickBlock = ^{
        LCRechageViewController *con = [LCRechageViewController new];
        con.needBack = YES;
        [(LCBaseViewController *)weakSelf.findViewController pushToViewController:con];
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
            if (weakSelf.videoCellEvent) {
                weakSelf.videoCellEvent(@"游戏消失", nil);
            }
        };
        confirmView.sendBlock = ^(NSDictionary *_Nonnull dic) {
            
        };
        confirmView.wanfaSelectArr = array;
        [weakSelf addSubview:confirmView];
        [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    };
    [self.contentView addSubview:view];
    self.lotteryTicketDetailView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}
- (void)dealloc{
    [self.selectGameView removeFromSuperview];
}
-(void)setUp {
    [self.contentView addSubview:self.rightView];
    [self.contentView addSubview:self.botView];
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.backgroundColor = [UIColor blackColor];
        _bgImgView.tag =191107;
    }
    return _bgImgView;
}


#pragma mark - set/get
- (UIView *)rightView{
    if (!_rightView) {
        CGFloat rv_w = 85;
        CGFloat rv_h = 300 + kUI_Width(36) + 15;//头像+点赞+评论+分享
        CGFloat rv_all_h = 300 + kUI_Width(36) + 15;//头像+点赞+评论+分享 +唱片
        _rightView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-rv_w, SCREEN_HEIGHT-rv_all_h-49-KSafeHeight, rv_w, rv_all_h)];
        _rightView.backgroundColor = [UIColor clearColor];
        
        CGFloat btnW = 70;
        CGFloat btnH = 70;
        CGFloat spaceW = 15;
        CGFloat specialH = 10;//给头像和点赞之间特意多留
        CGFloat spaceH = (rv_h-specialH-btnH*4 - kUI_Width(36) - 15)/3;
        
        //主播头像
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.frame = CGRectMake(10+spaceW, kUI_Width(36) + specialH, 50, 50);
        _iconBtn.layer.masksToBounds = YES;
        _iconBtn.layer.borderWidth = 1;
        _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconBtn.layer.cornerRadius = 25;
        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconBtn.imageView.clipsToBounds = YES;
        [_iconBtn addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];
        [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        
        //关注按钮
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.frame = CGRectMake(_iconBtn.left+12, _iconBtn.bottom-13, 26, 26);
        [_followBtn setImage:[UIImage imageNamed:@"home_follow"] forState:0];
        [_followBtn addTarget:self action:@selector(guanzhuzhubo) forControlEvents:UIControlEventTouchUpInside];
        
        //点赞
        _likebtn = [UIButton buttonWithType:0];
        _likebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _likebtn.frame = CGRectMake(spaceW, _iconBtn.bottom+spaceH+specialH, btnW, btnH);
        [_likebtn addTarget:self action:@selector(dolike) forControlEvents:UIControlEventTouchUpInside];
        [_likebtn setImage:[UIImage imageNamed:@"home_zan"] forState:0];
        [_likebtn setTitle:@" 0 " forState:0];//空格占位符不要去除
        _likebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _likebtn = [self setUpImgDownText:_likebtn];
        
        //评论列表
        _commentBtn = [UIButton buttonWithType:0];
        [_commentBtn setImage:[UIImage imageNamed:@"home_comment"] forState:0];
        [_commentBtn setTitle:@" 0 " forState:0];//空格占位符不要去除
        _commentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _commentBtn.frame = CGRectMake(spaceW, _likebtn.bottom+spaceH, btnW,btnH);
        [_commentBtn addTarget:self action:@selector(messgaebtn) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _commentBtn = [self setUpImgDownText:_commentBtn];
        
        //分享
        _enjoyBtn = [UIButton buttonWithType:0];
        [_enjoyBtn setImage:[UIImage imageNamed:@"home_share"] forState:0];
        [_enjoyBtn setTitle:@" 0 " forState:0];//空格占位符不要去除
        _enjoyBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _enjoyBtn.frame = CGRectMake(spaceW, _commentBtn.bottom+spaceH, btnW,btnH);
        [_enjoyBtn addTarget:self action:@selector(doenjoy) forControlEvents:UIControlEventTouchUpInside];
        _enjoyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _enjoyBtn = [self setUpImgDownText:_enjoyBtn];
                
        [_rightView addSubview:_iconBtn];
        [_rightView addSubview:_followBtn];
        [_rightView addSubview:_likebtn];
        [_rightView addSubview:_commentBtn];
        [_rightView addSubview:_enjoyBtn];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:ColorAlpha(@"#000000", 0.3)];
        btn.layer.cornerRadius = kUI_Width(36)/2.0;
        
        [_rightView addSubview:btn];
        WS(weakSelf)
        [[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.videoCellEvent) {
                weakSelf.videoCellEvent(@"游戏出现", nil);
            }
            LCLiveGamesSelectView *giftView = [[LCLiveGamesSelectView alloc]initWithFrame:CGRectZero];
            giftView.isFromVideo = YES;

            giftView.rechageClickBlock = ^{
                LCRechageViewController *con = [LCRechageViewController new];
                con.needBack = YES;
                [(LCBaseViewController *)weakSelf.findViewController pushToViewController:con];
            };
            giftView.gameCenterClickBlock = ^{
                LCGameCenterViewController *con = [LCGameCenterViewController new];
                con.needBack = YES;
                [(LCBaseViewController *)weakSelf.findViewController pushToViewController:con];
            };
            giftView.dismissBlock = ^{
                if (weakSelf.videoCellEvent) {
                    weakSelf.videoCellEvent(@"游戏消失", nil);
                }
                
               
            };
            [weakSelf.contentView addSubview:giftView];
            weakSelf.selectGameView = giftView;

            [giftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(0);
            }];
//            if (weakSelf.btnClickBlock){
//                weakSelf.btnClickBlock(4);
//            }
        }];
        _gameBtn = btn;
        [_gameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(25+(50-kUI_Width(36))/2.0);
            make.top.equalTo(0);
            make.height.equalTo(kUI_Width(36));
            make.width.equalTo(kUI_Width(36));
        }];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveGameToolImg")];
        [_gameBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(24));
        }];
        
        _gameBtn.hidden =  ![LCGameConfigManager shareManager].gameStatus ;
        
    }
    return _rightView;
}
- (UIView *)botView {
    if (!_botView) {
        _botView = [[UIView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-49-KSafeHeight-150, SCREEN_WIDTH*0.75, 140)];
        _botView.backgroundColor = [UIColor clearColor];
                
        //视频标题
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor whiteColor];
        _titleL.shadowOffset = CGSizeMake(1,1);//设置阴影
        _titleL.numberOfLines = 3;
        _titleL.font = RegularFont(15);
        [_botView addSubview:_titleL];
        
        //视频作者名称
        _nameL = [[UILabel alloc]init];
        _nameL.textAlignment = NSTextAlignmentLeft;
        _nameL.textColor = [UIColor whiteColor];
        _nameL.shadowOffset = CGSizeMake(1,1);//设置阴影
        _nameL.font = RegularFont(20);
        UITapGestureRecognizer *nametap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
        //nametap.numberOfTouchesRequired = 1;
        _nameL.userInteractionEnabled = YES;
        [_nameL addGestureRecognizer:nametap];
        [_botView addSubview:_nameL];
        
        _shopButton = [UIButton buttonWithType:0];
        _shopButton.frame = CGRectMake(5, _botView.height-35, _botView.width*0.7, 30);
        _shopButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _shopButton.layer.cornerRadius = 15;
        _shopButton.layer.masksToBounds = YES;
        [_shopButton addTarget:self action:@selector(shopButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_shopButton setBackgroundImage:[UIImage imageNamed:@"startLive_back"] forState:0];
        [_shopButton setTitleColor:[UIColor whiteColor] forState:0];
        [_shopButton setTitle:KLanguage(@"查看同款商品") forState:0];

        [_botView addSubview:_shopButton];
        _shopButton.hidden = YES;

    }
    return _botView;
}
-(UIButton*)setUpImgDownText:(UIButton *)btn {
    /*
     多处使用，不要随意更改，
     */
    CGFloat totalH = btn.imageView.frame.size.height + btn.titleLabel.frame.size.height;
    CGFloat spaceH = 5;
    //设置按钮图片偏移
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalH - btn.imageView.frame.size.height),0.0, 0.0, -btn.titleLabel.frame.size.width)];
    //设置按钮标题偏移
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(spaceH, -btn.imageView.frame.size.width, -(totalH - btn.titleLabel.frame.size.height),0.0)];
    
    return btn;
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    CGFloat coverRatio = 1.78;
    if (![NSString checkNull:minstr([_dataDic valueForKey:@"anyway"])]) {
        coverRatio = [minstr([_dataDic valueForKey:@"anyway"]) floatValue];
    }
    if (coverRatio > 1) {
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
    }else {
        _bgImgView.contentMode = UIViewContentModeScaleAspectFit;

        _bgImgView.clipsToBounds = NO;
    }
    [_bgImgView sd_setImageWithURL:[NSURL URLWithString:minstr([_dataDic valueForKey:@"thumb"])] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    id userinfo = [dataDic valueForKey:@"userinfo"];
    NSString *dataUid;
    NSString *dataIcon;
    NSString *dataUname;

    if ([userinfo isKindOfClass:[NSDictionary class]]) {
        dataUid = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"id"]];
        dataIcon = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"avatar"]];
        dataUname = [NSString stringWithFormat:@"@%@",[userinfo valueForKey:@"user_nicename"]];
    }else{
        dataUid = @"0";
        dataIcon = @"";
        dataUname = @"";
    }

    [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dataIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];

    NSString * _shares =[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"shares"]];
    NSString * _likes = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"likes"]];
    NSString * _islike = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"islike"]];
    NSString * _comments = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"comments"]];
    NSString *isattent = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"isattent"]]];
    WS(weakSelf);
    //点赞数 评论数 分享数
    if ([_islike isEqual:@"1"]) {
        [_likebtn setImage:[UIImage imageNamed:@"home_zan_sel"] forState:0];
        //weakSelf.likebtn.userInteractionEnabled = NO;
    } else{
        [_likebtn setImage:[UIImage imageNamed:@"home_zan"] forState:0];
        //weakSelf.likebtn.userInteractionEnabled = YES;
    }
    [_likebtn setTitle:[NSString stringWithFormat:@"%@",_likes] forState:0];
    _likebtn = [self setUpImgDownText:_likebtn];
    [_enjoyBtn setTitle:[NSString stringWithFormat:@"%@",_shares] forState:0];
    _enjoyBtn = [self setUpImgDownText:_enjoyBtn];
    [_commentBtn setTitle:[NSString stringWithFormat:@"%@",_comments] forState:0];
    _commentBtn = [self setUpImgDownText:_commentBtn];
    
    if ( [isattent isEqual:@"1"]) {
        [_followBtn setImage:[UIImage imageNamed:@"home_follow_sel"] forState:0];
        //_followBtn.hidden = YES;
    }else{
        [_followBtn setImage:[UIImage imageNamed:@"home_follow"] forState:0];
    }
    _followBtn.hidden = NO;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.7, 1.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    animation.values = values;
    [_followBtn.layer addAnimation:animation forKey:nil];

    _titleL.text = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"title"]];
    _nameL.text = dataUname;
    //计算名称长度
    CGSize titleSize = [_titleL.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH*0.75, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:RegularFont(20)} context:nil].size;
    _titleL.frame = CGRectMake(0, _botView.height-titleSize.height, titleSize.width, titleSize.height);
    _nameL.frame = CGRectMake(0, _titleL.top-25, _botView.width, 25);
    NSString *isgoods = minstr([dataDic valueForKey:@"goodsid"]);
    NSString *goodsType = minstr([dataDic valueForKey:@"type"]);
    if (![isgoods isEqual:@"0"]) {
        _titleL.frame = CGRectMake(0, _botView.height-titleSize.height-40, titleSize.width, titleSize.height);
    }
    _nameL.frame = CGRectMake(0, _titleL.top-25, _botView.width, 25);
    _followBtn.frame = CGRectMake(_iconBtn.left+12, _iconBtn.bottom-13, 26, 26);

    
    if (![goodsType isEqual:@"0"]) {
        _shopButton.hidden = NO;
        
    }else{
        _shopButton.hidden = YES;
    }

    //0 没有。1商品。2.付费内容
    if ([goodsType isEqual:@"1"]) {
        [_shopButton setTitle:KLanguage(@"查看商品详情") forState:0];
    }else if([goodsType isEqual:@"2"]){
        [_shopButton setTitle:KLanguage(@"查看付费内容") forState:0];
    }

}
-(void)guanzhuzhubo
{
    
    if ([[LCUserInfoManager shareManager].userInfo.ID intValue]<0) {
//        [PublicObj warnLogin];
        return;
    }
    WS(weakSelf);
    NSDictionary *userDic = [_dataDic valueForKey:@"userinfo"];
    NSString *videoUserID = minstr([userDic valueForKey:@"id"]);

    NSString *url = @"=User.setAttent";
    NSDictionary *subdic = @{
                            
                             @"touid":videoUserID,
                       
                             };
    [[LCNetWorkManager manager] requestUrl:url method:@"POST" params:subdic success:^(id  _Nullable result) {
        NSString *isattent =minstr([[[result valueForKey:@"info"] firstObject] valueForKey:@"isattent"]);
        
        NSDictionary *newDic = @{@"isattent":isattent};
        [weakSelf updateDataDic:newDic];
        if (weakSelf.videoCellEvent) {
            weakSelf.videoCellEvent(@"视频-关注", newDic);
        }

        if ([isattent isEqual:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                animation.duration = 1.0;
                NSMutableArray *values = [NSMutableArray array];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
                
                animation.values = values;
                [_followBtn.imageView.layer addAnimation:animation forKey:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_followBtn setImage:[UIImage imageNamed:@"home_follow_sel"] forState:0];
                });
            });
        }else{
             [_followBtn setImage:[UIImage imageNamed:@"home_follow"] forState:0];
        }
        
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD showMaskViewWithFailure:error.domain];
    }];
    

}
 //点赞
 -(void)dolike{
     if ([[LCUserInfoManager shareManager].userInfo.ID intValue]<0) {
//         [PublicObj warnLogin];
         return;
     }
     WS(weakSelf);
     NSString *url = [NSString stringWithFormat:@"Video.addLike&uid=%@&videoid=%@&type=%@&token=%@",[LCUserInfoManager shareManager].userInfo.ID,minstr([_dataDic valueForKey:@"id"]),@"0",[LCUserInfoManager shareManager].userInfo.token];
     [[LCNetWorkManager manager] requestUrl:url method:@"POST" params:nil success:^(id  _Nullable result) {
         NSDictionary *info = [[result valueForKey:@"info"] firstObject];
         NSString *islike = [NSString stringWithFormat:@"%@",[info valueForKey:@"islike"]];
         NSString *likes  = [NSString stringWithFormat:@"%@",[info valueForKey:@"likes"]];
         [_likebtn setTitle:[NSString stringWithFormat:@"%@",likes] forState:0];
         NSDictionary *newDic = @{@"islike":islike,@"likes":likes};
         [weakSelf updateDataDic:newDic];
         
         if (weakSelf.videoCellEvent) {
             weakSelf.videoCellEvent(@"视频-点赞", newDic);
         }

         if ([islike isEqual:@"1"]) {
             NSMutableArray *m_sel_arr = [NSMutableArray array];
             for (int i=1; i<=15; i++) {
                 UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"icon_video_zan_%02d",i]];
                 [m_sel_arr addObject:img];
             }
             [UIView animateWithDuration:0.8 animations:^{
                 _likebtn.imageView.animationImages = m_sel_arr;
                 _likebtn.imageView.animationDuration = 0.8;
                 _likebtn.imageView.animationRepeatCount = 1;
                 [_likebtn.imageView startAnimating];
             } completion:^(BOOL finished) {
                 [_likebtn setImage:[UIImage imageNamed:@"icon_video_zan_15"] forState:0];
             }];
         }else{
                 [_likebtn setImage:[UIImage imageNamed:@"icon_video_zan_01"] forState:0];
         }
     } failure:^(NSError * _Nullable error) {
         [SVProgressHUD showMaskViewWithFailure:error.domain];
     }];
     

 }

-(void)zhuboMessage{
//    NSString *_hostid = [[_dataDic valueForKey:@"userinfo"] valueForKey:@"id"];
//    otherUserMsgVC *center = [[otherUserMsgVC alloc]init];
//    if ([_hostid isEqual:[LCUserInfoManager shareManager].userInfo.ID]) {
//        center.userID =[LCUserInfoManager shareManager].userInfo.ID;
//    }else{
//        center.userID =_hostid;
//    }
//    center.hidesBottomBarWhenPushed = YES;
//    [[MXBADelegate sharedAppDelegate] pushViewController:center animated:YES];
    
}
-(void)messgaebtn{
    if (self.videoCellEvent) {
        self.videoCellEvent(@"评论",_dataDic);
    }

}
-(void)doenjoy{
    if (self.videoCellEvent) {
        self.videoCellEvent(@"分享",_dataDic);
    }

}
-(void)shopButtonClick{
//    NSString *goodsid = minstr([_dataDic valueForKey:@"goodsid"]);
//    NSLog(@"yyyyyyyyyyyyy----isgoods:%@ \n  dic:%@",goodsid, _dataDic);
//    //0 没有。1商品。2.付费内容
//    if ([minstr([_dataDic valueForKey:@"type"]) isEqual:@"1"]) {
//        
//        [PublicObj checkGoodsExistenceWithID:minstr([_dataDic valueForKey:@"goodsid"]) Existence:^(NSString *code, NSString *msg) {
//            if ([code isEqual:@"0"]) {
//                if ([minstr([_dataDic valueForKey:@"goods_type"]) isEqual:@"1"]) {
//                    OutsideGoodsDetailVC *detail = [[OutsideGoodsDetailVC alloc]init];
//                    detail.goodsID = minstr([_dataDic valueForKey:@"goodsid"]);
//                    detail.liveUid =minstr([[_dataDic valueForKey:@"userinfo"] valueForKey:@"id"]);
//
//                    [[MXBADelegate sharedAppDelegate] pushViewController:detail animated:YES];
//                }else{
//                    CommodityDetailVC *detail = [[CommodityDetailVC alloc]init];
//                    detail.goodsID = minstr([_dataDic valueForKey:@"goodsid"]);
//                    detail.liveUid =minstr([[_dataDic valueForKey:@"userinfo"] valueForKey:@"id"]);
//                    [[MXBADelegate sharedAppDelegate] pushViewController:detail animated:YES];
//                }
//            }else{
//                [SVProgressHUD showMaskViewWithFailure:msg];
//
//            }
//        }];
//
//
//    }else if ([minstr([_dataDic valueForKey:@"type"]) isEqual:@"2"]) {
//           PayVideoDetailVC *detail = [[PayVideoDetailVC alloc]init];
//           detail.object_id = goodsid;
//           [[MXBADelegate sharedAppDelegate]pushViewController:detail animated:YES];
//    }
}
///点赞、评论、关注后这里也更新一下
-(void)updateDataDic:(NSDictionary *)dic {
 NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:_dataDic];
 [m_dic addEntriesFromDictionary:dic];
 _dataDic = [NSDictionary dictionaryWithDictionary:m_dic];
}
@end
