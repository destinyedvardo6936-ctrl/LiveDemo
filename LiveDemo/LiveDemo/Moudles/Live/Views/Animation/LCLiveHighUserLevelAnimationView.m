//
//  LCLiveHighUserLevelAnimationView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/8.
//

#import "LCLiveHighUserLevelAnimationView.h"

@interface LCLiveHighUserLevelAnimationView ()
@property(nonatomic,weak)UIImageView *userMoveImageV;//进入动画背景
@property(nonatomic,weak)UIView *msgView;//显示用户信息
@property (nonatomic , weak) UIImageView *userImgView;
@property (nonatomic , weak) UIImageView *starImgView;
@property (nonatomic , weak) UIImageView *levelImgView;

@property (nonatomic , weak) UILabel *nameLabel;

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , assign) BOOL isAnimation;
@end
@implementation LCLiveHighUserLevelAnimationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.userMoveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( 2 *SCREEN_WIDTH);
            make.height.equalTo(kUI_Width(40));
            make.width.equalTo(kUI_WidthWithFloat(623/2.0));
            make.centerY.equalTo(0);
        }];
        [self.msgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(- (2 *SCREEN_WIDTH));
            make.height.equalTo(kUI_Width(30));
            make.centerY.equalTo(0);
        }];
    }
    return self;
}
-(void)addUserMove:(LCLiveUserModel *)model{
    [self.dataArray addObject:model];
    if(self.isAnimation){
        
    }else{
        [self startAnimationWithModel:model];
    }
}
- (void)fillDataWithModel:(LCLiveUserModel *)model{
    [self.userImgView setImageStr:model.avatar];
    NSTextAttachment *adminAttchment = [[NSTextAttachment alloc]init];
    adminAttchment.bounds = CGRectMake(0, 0, kUI_Width(17), kUI_Width(12));
    adminAttchment.image = image(@"chat_admin");
    NSAttributedString *adminString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(adminAttchment)];
    NSTextAttachment *shouAttchment = [[NSTextAttachment alloc]init];
    shouAttchment.bounds = CGRectMake(0, 0, kUI_Width(12), kUI_Width(12));
    shouAttchment.image = image(@"chat_shou_month");
    NSAttributedString *shouString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(shouAttchment)];
    
    NSTextAttachment *yearAttchment = [[NSTextAttachment alloc]init];
    yearAttchment.bounds = CGRectMake(0, 0, kUI_Width(12), kUI_Width(12));
    yearAttchment.image = image(@"chat_shou_year");
    NSAttributedString *yearString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(yearAttchment)];


    NSTextAttachment *vipAttchment = [[NSTextAttachment alloc]init];
    vipAttchment.bounds = CGRectMake(0, 0, kUI_Width(24), kUI_Width(12));//设置frame
    vipAttchment.image =image(@"chat_vip") ;
    NSAttributedString *vipString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(vipAttchment)];
    NSTextAttachment *liangAttchment = [[NSTextAttachment alloc]init];
    liangAttchment.bounds = CGRectMake(0, 0, kUI_Width(16), kUI_Width(12));
    liangAttchment.image = image(@"chat_liang");
   
    NSArray *arr = [LCConfigManager shareManager].configModel.level;
    LCUserLevelModel *levelModel = nil;
    for (LCUserLevelModel *le in arr) {
        if([le.levelid integerValue] == [model.level integerValue]){
            levelModel = le;
        }
    }
    [self.levelImgView setImageStr:levelModel.thumb];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:model.user_nicename attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#86D9EF")}];
    [noteStr appendAttributedString:[[NSAttributedString alloc]initWithString:KLanguage(@"   进入直播间") attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#FFFFFF")}]];
    NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@" "];
//    //插入靓号图标
//    if (![_model.liangname isEqual:@"0"] && ![_model.liangname isEqual:@"(null)"] && _model.liangname !=nil && _model.liangname !=NULL) {
//        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
//        [noteStr insertAttributedString:liangString atIndex:0];//插入到第几个下标
//    }
    //插入守护图标
    if ([model.guard_type intValue] == 1) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:shouString atIndex:0];//插入到第几个下标
    }
    if ([model.guard_type intValue] == 2) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:yearString atIndex:0];//插入到第几个下标
    }
    //插入管理图标
    if ([model.issuper integerValue] == 1) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:adminString atIndex:0];//插入到第几个下标
    }
    //插入VIP图标
    if ([model.vip_type integerValue] == 1) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:vipString atIndex:0];//插入到第几个下标
    }
    
    
    self.nameLabel.attributedText = noteStr;
}
- (void)startAnimationWithModel:(LCLiveUserModel *)model{
    self.isAnimation = YES;
    [self fillDataWithModel:model];
    [self.userImgView layoutIfNeeded];
    CGMutablePathRef path = CGPathCreateMutable();
    //CGPathAddArc函数是通过圆心和半径定义一个圆，然后通过两个弧度确定一个弧线。注意弧度是以当前坐标环境的X轴开始的。
    //需要注意的是由于ios中的坐标体系是和Quartz坐标体系中Y轴相反的，所以iOS UIView在做Quartz绘图时，Y轴已经做了Scale为-1的转换，因此造成CGPathAddArc函数最后一个是否是顺时针的参数结果正好是相反的，也就是说如果设置最后的参数为1，根据参数定义应该是顺时针的，但实际绘图结果会是逆时针的！
    //严格的说，这个方法只是确定一个中心点后，以某个长度作为半径，以确定的角度和顺逆时针而进行旋转，半径最低设置为1，设置为0则动画不会执行
    
    CGPathAddArc(path, NULL, self.userImgView.centerX, self.userImgView.centerY, self.userImgView.width + 1, 0,M_PI * 2, 0);
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    CGPathRelease(path);
    animation.duration = 3;
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    animation.rotationMode =kCAAnimationRotateAuto;
    animation.fillMode =kCAFillModeForwards;
    WS(weakSelf)
    [UIView animateWithDuration:0.5 animations:^{
//        _userMoveImageV.frame = CGRectMake(-15,10,SCREEN_WIDTH*0.8,40);
        weakSelf.userMoveImageV.transform = CGAffineTransformMakeTranslation(- SCREEN_WIDTH- (SCREEN_WIDTH - kUI_Width(80)), 0);
        weakSelf.msgView.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH+(SCREEN_WIDTH + kUI_Width(80)), 0);
        
    }completion:^(BOOL finished) {
        [weakSelf.starImgView.layer addAnimation:animation forKey:nil];
    }];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 animations:^{
//            _userMoveImageV.frame = CGRectMake(-15,10,SCREEN_WIDTH*0.8,40);
//            _userMoveImageV.alpha = 0;
            weakSelf.userMoveImageV.transform = CGAffineTransformTranslate(weakSelf.userMoveImageV.transform,-(kUI_Width(80) - kUI_Width(10)), 0);
            weakSelf.msgView.transform = CGAffineTransformTranslate(weakSelf.msgView.transform,(kUI_Width(80) - kUI_Width(10)), 0);
//            _userMoveImageV.x = 10;
//            _msgView.x = 10;

        }] ;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.userMoveImageV.transform = CGAffineTransformIdentity;
            weakSelf.msgView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            weakSelf.isAnimation = NO;
            if([weakSelf.dataArray indexOfObject:model] < weakSelf.dataArray.count - 1){
                NSInteger index = [weakSelf.dataArray indexOfObject:model] + 1;
                [weakSelf startAnimationWithModel:weakSelf.dataArray[index]];
            }else{
                [weakSelf.dataArray removeAllObjects];
            }
            
        }];

    });
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UIImageView *)userMoveImageV{
    if(!_userMoveImageV){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_userEnterAnimationBg")];
        [self addSubview:imgView];
        _userMoveImageV = imgView;
    }
    return _userMoveImageV;
}
- (UIView *)msgView{
    if(_msgView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        _msgView = view;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kUI_Width(30)/2.0;
        [_msgView addSubview:imgView];
        _userImgView = imgView;
        UIImageView *starImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        starImgView.image = image(@"icon_userEnterStarImg") ;
        [_msgView addSubview:starImgView];
        _starImgView = starImgView;
        UIImageView *levelImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_msgView addSubview:levelImgView];
        levelImgView.contentMode = UIViewContentModeScaleAspectFill;
        _levelImgView = levelImgView;
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectZero];
    
        nameL.textColor = Color(@"#FFFFFF");
        nameL.font = RegularFont(12);
        [nameL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [nameL setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_msgView addSubview:nameL];
        _nameLabel = nameL;
        [_userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.height.equalTo(kUI_Width(30));
            make.left.equalTo(kUI_Width(10));
            
        }];
        [starImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_userImgView.mas_right).offset(-kUI_Width(1));
            make.centerY.equalTo(0);
            make.height.width.equalTo(kUI_Width(12));
        }];
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(starImgView.mas_right).offset(kUI_Width(5));
            make.centerY.equalTo(0);
            make.width.height.equalTo(kUI_Width(12));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(levelImgView.mas_right).offset(kUI_Width(5));
            make.height.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
            make.right.equalTo(-kUI_Width(10));
        }];
    }
    return _msgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
