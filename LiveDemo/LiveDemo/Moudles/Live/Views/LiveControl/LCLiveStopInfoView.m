//
//  LCLiveStopInfoView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/30.
//

#import "LCLiveStopInfoView.h"

@interface LCLiveStopInfoView ()
@property (nonatomic , weak) UIImageView *userImgView;
@property (nonatomic , weak) UILabel *userNameLabal;
@property (nonatomic , weak) UIView *labelBackView;
@end
@implementation LCLiveStopInfoView
- (instancetype)initWithFrame:(CGRect)frame dataDic:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *lastView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        lastView.userInteractionEnabled = YES;
        [lastView setImageStr:[LCUserInfoManager shareManager].userInfo.avatar];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
        [lastView addSubview:effectview];
       
        
        UILabel *labell= [[UILabel alloc]initWithFrame:CGRectMake(0,24+kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT*0.17)];
        labell.textColor = normalColors;
        labell.text = KLanguage(@"直播已结束");
        labell.textAlignment = NSTextAlignmentCenter;
        labell.font = MediumFont(20);
        [lastView addSubview:labell];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.1, labell.bottom+50, SCREEN_WIDTH*0.8, SCREEN_WIDTH*0.8*8/13)];
        backView.backgroundColor = ColorAlpha(@"#000000", 0.2);
        backView.layer.cornerRadius = 5.0;
        backView.layer.masksToBounds = YES;
        [lastView addSubview:backView];
        _labelBackView = backView;
        UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, labell.bottom, 100, 100)];
        [headerImgView sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"icon_avatar_placeholder"]];
        headerImgView.layer.masksToBounds = YES;
        headerImgView.layer.cornerRadius = 50;
        [lastView addSubview:headerImgView];
        _userImgView = headerImgView;
        
        UILabel *nameL= [[UILabel alloc]initWithFrame:CGRectMake(0,50, backView.width, backView.height*0.55-50)];
        nameL.textColor = [UIColor whiteColor];
        nameL.text = minstr([dic valueForKey:@"user_nicename"]);
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.font = MediumFont(18);
        [backView addSubview:nameL];
        _userNameLabal = nameL;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, nameL.bottom, backView.width-20, 1)];
        lineView.backgroundColor = ColorAlpha(@"#585452", 1);
        [backView addSubview:lineView];
        
        
        NSArray *labelArray = @[KLanguage(@"直播时长"),[NSString stringWithFormat:@"%@%@",KLanguage(@"收获"),[LCConfigManager shareManager].configModel.name_votes],@"观看人数"];
        for (int i = 0; i < labelArray.count; i++) {
            UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*backView.width/3, nameL.bottom, backView.width/3, backView.height/4)];
            topLabel.font = [UIFont boldSystemFontOfSize:18];
            topLabel.textColor = [UIColor whiteColor];
            topLabel.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                topLabel.text = minstr([dic valueForKey:@"length"]);
            }
            if (i == 1) {
                topLabel.text = minstr([dic valueForKey:@"votes"]);
            }
            if (i == 2) {
                topLabel.text = minstr([dic valueForKey:@"nums"]);
            }
            [backView addSubview:topLabel];
            UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(topLabel.left, topLabel.bottom, topLabel.width, 14)];
            footLabel.font = [UIFont systemFontOfSize:13];
            footLabel.textColor = ColorAlpha(@"#cacbcc", 1);
            footLabel.textAlignment = NSTextAlignmentCenter;
            footLabel.text = labelArray[i];
            [backView addSubview:footLabel];
        }
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH*0.1,SCREEN_HEIGHT *0.75, SCREEN_WIDTH*0.8,50);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        WS(weakSelf)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.backBlock){
                weakSelf.backBlock();
            }
            [weakSelf removeFromSuperview];
        }];
        
    //    [button setBackgroundColor:normalColors];
        [button setBackgroundImage:image(@"startLive_back") forState:UIControlStateNormal];
   
        [button setTitle:KLanguage(@"返回") forState:UIControlStateNormal];
        button.titleLabel.font = RegularFont(15);
        button.layer.cornerRadius = 25;
        button.layer.masksToBounds  =YES;
        [lastView addSubview:button];
        [self addSubview:lastView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
