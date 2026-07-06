//
//  LCVideoDetailCollectionHeaderView.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCVideoDetailCollectionHeaderView.h"

@interface LCVideoDetailCollectionHeaderView ()
@property (nonatomic , weak) UIButton *vipBtn;
@property (nonatomic , weak) UIView *vipTipView;
@property (nonatomic , weak) UILabel *timeLabel;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *countLabel;
@property (nonatomic , weak) UIButton *gameBtn;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCVideoDetailCollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self){
        [self.vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(7));
            make.left.equalTo(kUI_Width(12));
            make.width.equalTo(kUI_Width(121));
            make.height.equalTo(kUI_Width(46));
        }];
        [self.vipTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(46));
            make.top.equalTo(kUI_Width(7));
            make.left.mas_equalTo(self.vipBtn.mas_right).offset(kUI_Width(10));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.mas_equalTo(self.vipBtn.mas_bottom).offset(kUI_Width(10));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(15));
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel.mas_right).offset(kUI_Width(20));
            make.height.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.timeLabel.mas_top);
            make.right.mas_equalTo(self.gameBtn.mas_left).offset(-kUI_Width(20));
        }];
        [self.gameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(81));
            make.height.equalTo(kUI_Width(28));
            make.right.equalTo(-kUI_Width(12));
            make.bottom.mas_equalTo(self.timeLabel.mas_bottom);
        }];
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(kUI_Width(10));
            make.width.height.equalTo(kUI_Width(25));
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mainImgView.mas_centerY);
            make.height.equalTo(kUI_Width(16));
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(4));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
    }
    return self;
}
- (void)setDataModel:(LCVideoListModel *)dataModel{
    _dataModel = dataModel;
    if([LCUserInfoManager shareManager].userInfo.vip_type.intValue != 0){
        self.vipBtn.hidden = YES;
        self.vipTipView.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.mas_equalTo(self.vipBtn.mas_top);
        }];
    }else{
        self.vipBtn.hidden = NO;
        self.vipTipView.hidden = NO;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.mas_equalTo(self.vipBtn.mas_bottom).offset(kUI_Width(10));
        }];
    }
    RAC(self.titleLabel,text) = [RACObserve(_dataModel, title) takeUntil:self.rac_prepareForReuseSignal];
 
    RAC(self.timeLabel,text) = [[RACObserve(_dataModel, addtime) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(value.length){
            return [NSString stringWithFormat:@"%@  %@",value, KLanguage(@"发布")];
        }
        return nil;
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.countLabel,text) = [[RACObserve(_dataModel, views) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(value.length){
            return [NSString stringWithFormat:@"%@  %@",value, KLanguage(@"播放")];
        }
        return nil;
    }] takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----
- (UIButton *)vipBtn{
    if(_vipBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_videoVipBgImg") forState:UIControlStateNormal];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [self addSubview:btn];
        _vipBtn = btn;
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.vipClickedBlock){
                weakSelf.vipClickedBlock();
            }
        }];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_videoVipKaitongImg")];
        [btn addSubview:imgView];
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        topLabel.font = RegularFont(12);
        topLabel.textColor = Color(@"#C3AE7D");
        topLabel.text = KLanguage(@"无限观影");
        topLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:topLabel];
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        bottomLabel.font = BoldFont(14);
        bottomLabel.textColor = Color(@"#FFE58A");
        bottomLabel.text = KLanguage(@"开通VIP");
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:bottomLabel];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(20));
            make.left.equalTo(kUI_Width(8));
            make.centerY.equalTo(0);
        }];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(8));
            make.right.equalTo(-kUI_Width(8));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(8));
        }];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(topLabel.mas_width);
            make.top.mas_equalTo(topLabel.mas_bottom).offset(kUI_Width(4));
            make.left.mas_equalTo(topLabel.mas_left);
            make.height.equalTo(kUI_Width(14));
        }];
        
    }
    return _vipBtn;
}
- (UIView *)vipTipView{
    if(_vipTipView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:view];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorWithRed:255/255.0 green:155/255.0 blue:66/255.0 alpha:1.0].CGColor;
        view.backgroundColor = Color(@"#FFF5C8");
        view.layer.cornerRadius = kUI_Width(8);
        view.clipsToBounds = YES;
        _vipTipView = view;
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        topLabel.font = RegularFont(12);
        topLabel.textColor = Color(@"#C3AE7D");
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.text = KLanguage(@"非会员试看15秒");
        [view addSubview:topLabel];
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        bottomLabel.font = BoldFont(14);
        bottomLabel.textColor = Color(@"#C58311");
        bottomLabel.text = KLanguage(@"开通VIP随心看");
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:bottomLabel];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(20));
            make.right.equalTo(-kUI_Width(20));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(8));
        }];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(topLabel.mas_width);
            make.top.mas_equalTo(topLabel.mas_bottom).offset(kUI_Width(6));
            make.left.mas_equalTo(topLabel.mas_left);
            make.height.equalTo(kUI_Width(14));
        }];
    }
    return _vipTipView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(14);
        label.textColor = Color(@"#333333");
        label.numberOfLines = 0;
        _titleLabel = label;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#979797");
        
        _timeLabel = label;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}
- (UILabel *)countLabel{
    if (!_countLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#979797");
        
        _countLabel = label;
        [self addSubview:_countLabel];
    }
    return _countLabel;
}
- (UIButton *)gameBtn{
    if(_gameBtn == nil){
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setBackgroundImage:image(@"icon_liveGameCenterBg") forState:UIControlStateNormal];
        [sendBtn setTitle:KLanguage(@"游戏中心") forState:UIControlStateNormal];
        [sendBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        sendBtn.titleLabel.font = MediumFont(14);
        [self addSubview:sendBtn];
        _gameBtn = sendBtn;
        WS(weakSelf)
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.gameCenterClickBlock){
                weakSelf.gameCenterClickBlock();
            }
            
        }];
    }
    return _gameBtn;
}
- (UIImageView *)mainImgView{
    if (_mainImgView == nil){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_videoListHeaderImg");
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImgView = imgView;
        [self addSubview:_mainImgView];
    }
    return _mainImgView;
}
- (UILabel *)mainLabel{
    if (!_mainLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(16);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"相关视频");
        _mainLabel = label;
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}
@end
