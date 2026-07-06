//
//  LCRankTopThreeCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCRankTopThreeCell.h"

@interface LCRankTopThreeCell ()
@property (nonatomic , weak) UIImageView *backView;
@property (nonatomic , weak) UIImageView *firstHgImgView;
@property (nonatomic , weak) UIImageView *firstUserImgView;
@property (nonatomic , weak) UIImageView *firstLiveImgView;
@property (nonatomic , weak) UIImageView *firstInfoImgView;
@property (nonatomic , weak) UILabel *firstUserNameLabel;
@property (nonatomic , weak) UIImageView *firstLevelBackImgView;
@property (nonatomic , weak) UIImageView *firstLevelImgView;
@property (nonatomic , weak) UILabel *firstLevelLabel;
@property (nonatomic , weak) UIButton *firstFollowBtn;

@property (nonatomic , weak) UIImageView *secondHgImgView;
@property (nonatomic , weak) UIImageView *secondUserImgView;
@property (nonatomic , weak) UIImageView *secondLiveImgView;
@property (nonatomic , weak) UIImageView *secondInfoImgView;
@property (nonatomic , weak) UILabel *secondUserNameLabel;
@property (nonatomic , weak) UIImageView *secondLevelBackImgView;
@property (nonatomic , weak) UIImageView *secondLevelImgView;
@property (nonatomic , weak) UILabel *secondLevelLabel;
@property (nonatomic , weak) UILabel *secondCompareLevelLabel;
@property (nonatomic , weak) UIButton *secondFollowBtn;

@property (nonatomic , weak) UIImageView *thirdHgImgView;
@property (nonatomic , weak) UIImageView *thirdUserImgView;
@property (nonatomic , weak) UIImageView *thirdLiveImgView;
@property (nonatomic , weak) UIImageView *thirdInfoImgView;
@property (nonatomic , weak) UILabel *thirdUserNameLabel;
@property (nonatomic , weak) UIImageView *thirdLevelBackImgView;
@property (nonatomic , weak) UIImageView *thirdLevelImgView;
@property (nonatomic , weak) UILabel *thirdLevelLabel;
@property (nonatomic , weak) UILabel *thirdCompareLevelLabel;
@property (nonatomic , weak) UIButton *thirdFollowBtn;
@end
@implementation LCRankTopThreeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(0);
        }];
        [self.firstUserImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(kUI_Width(26));
            make.width.equalTo(kUI_Width(55));
            make.height.equalTo(kUI_Width(55));
        }];
        [self.firstLiveImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(0);
            make.width.equalTo(kUI_Width(55));
            make.height.equalTo(kUI_Width(55));
        }];
        [self.firstHgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(kUI_Width(10));
            make.width.equalTo(kUI_Width(32));
            make.height.equalTo(kUI_Width(20));
            
        }];
        [self.firstInfoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.mas_equalTo(self.firstUserImgView.mas_bottom).offset(kUI_Width(15));
            make.width.equalTo(kUI_Width(111));
            make.height.equalTo(kUI_Width(126));
        }];
        [self.firstUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.width.mas_equalTo(self.firstInfoImgView.mas_width);
            make.height.equalTo(kUI_Width(14));
            make.top.mas_equalTo(self.firstInfoImgView.mas_top).offset(kUI_Width(22));
        }];
        [self.firstLevelBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(34));
            make.height.equalTo(kUI_Width(16));
            make.centerX.equalTo(0);
            make.top.mas_equalTo(self.firstUserNameLabel.mas_bottom).offset(kUI_Width(7));
        }];
        [self.firstLevelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.height.equalTo(kUI_Width(12));
            make.left.equalTo(kUI_Width(4));
        }];
        [self.firstLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstLevelImgView.mas_right).offset(kUI_Width(3));
            make.right.equalTo(-kUI_Width(3));
            make.top.bottom.equalTo(0);
        }];
        [self.firstFollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(11));
            make.width.equalTo(kUI_Width(61));
            make.height.equalTo(kUI_Width(28));
            make.centerX.equalTo(0);
        }];
        
        [self.secondUserImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.secondInfoImgView.mas_centerX);
            make.top.equalTo(kUI_Width(51));
            make.width.equalTo(kUI_Width(55));
            make.height.equalTo(kUI_Width(55));
        }];
        [self.secondLiveImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(0);
            make.width.equalTo(kUI_Width(55));
            make.height.equalTo(kUI_Width(55));
        }];
        [self.secondHgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.secondInfoImgView.mas_centerX);
            make.top.equalTo(kUI_Width(33));
            make.width.equalTo(kUI_Width(32));
            make.height.equalTo(kUI_Width(20));
            
        }];
        [self.secondUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.secondInfoImgView.mas_centerX);
            make.top.mas_equalTo(self.secondUserImgView.mas_bottom).offset(kUI_Width(13));
            make.width.mas_equalTo(self.secondInfoImgView.mas_width);
            make.height.equalTo(kUI_Width(14));
        }];
        [self.secondInfoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.firstInfoImgView.mas_left);
            make.top.mas_equalTo(self.secondUserNameLabel.mas_bottom).offset(kUI_Width(3));
            make.width.equalTo(kUI_Width(111));
            make.height.equalTo(kUI_Width(77));
        }];
        
        [self.secondLevelBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(34));
            make.height.equalTo(kUI_Width(16));
            make.centerX.mas_equalTo(self.secondInfoImgView.mas_centerX);
            make.top.mas_equalTo(self.secondUserNameLabel.mas_bottom).offset(kUI_Width(7));
        }];
        [self.secondLevelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.height.equalTo(kUI_Width(12));
            make.left.equalTo(kUI_Width(4));
        }];
        [self.secondLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.secondLevelImgView.mas_right).offset(kUI_Width(3));
            make.right.equalTo(-kUI_Width(3));
            make.top.bottom.equalTo(0);
        }];
        [self.secondCompareLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.secondInfoImgView.mas_centerX);
            make.width.mas_equalTo(self.secondInfoImgView.mas_width);
            make.top.mas_equalTo(self.secondLevelBackImgView.mas_bottom).offset(kUI_Width(8));
            make.height.equalTo(kUI_Width(12));
        }];
        [self.secondFollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(11));
            make.width.equalTo(kUI_Width(61));
            make.height.equalTo(kUI_Width(28));
            make.centerX.mas_equalTo(self.secondInfoImgView.mas_centerX);
        }];
        
        [self.thirdUserImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.thirdInfoImgView.mas_centerX);
            make.top.equalTo(kUI_Width(51));
            make.width.equalTo(kUI_Width(55));
            make.height.equalTo(kUI_Width(55));
        }];
        [self.thirdLiveImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(0);
            make.width.equalTo(kUI_Width(55));
            make.height.equalTo(kUI_Width(55));
        }];
        [self.thirdHgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.thirdUserImgView.mas_centerX);
            make.top.equalTo(kUI_Width(33));
            make.width.equalTo(kUI_Width(32));
            make.height.equalTo(kUI_Width(20));
            
        }];
        [self.thirdUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.thirdInfoImgView.mas_centerX);
            make.top.mas_equalTo(self.thirdUserImgView.mas_bottom).offset(kUI_Width(13));
            make.width.mas_equalTo(self.thirdInfoImgView.mas_width);
            make.height.equalTo(kUI_Width(14));
        }];
        [self.thirdInfoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstInfoImgView.mas_right);
            make.top.mas_equalTo(self.thirdUserNameLabel.mas_bottom).offset(kUI_Width(3));
            make.width.equalTo(kUI_Width(111));
            make.height.equalTo(kUI_Width(77));
        }];
        
        [self.thirdLevelBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(34));
            make.height.equalTo(kUI_Width(16));
            make.centerX.mas_equalTo(self.thirdInfoImgView.mas_centerX);
            make.top.mas_equalTo(self.thirdUserNameLabel.mas_bottom).offset(kUI_Width(7));
        }];
        [self.thirdLevelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.height.equalTo(kUI_Width(12));
            make.left.equalTo(kUI_Width(4));
        }];
        [self.thirdLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.thirdLevelImgView.mas_right).offset(kUI_Width(3));
            make.right.equalTo(-kUI_Width(3));
            make.top.bottom.equalTo(0);
        }];
        [self.thirdCompareLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.thirdInfoImgView.mas_centerX);
            make.width.mas_equalTo(self.thirdInfoImgView.mas_width);
            make.top.mas_equalTo(self.thirdLevelBackImgView.mas_bottom).offset(kUI_Width(8));
            make.height.equalTo(kUI_Width(12));
        }];
        [self.thirdFollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(11));
            make.width.equalTo(kUI_Width(61));
            make.height.equalTo(kUI_Width(28));
            make.centerX.mas_equalTo(self.thirdInfoImgView.mas_centerX);
        }];
        
    }
    return self;
}
- (void)setIsArchorList:(BOOL)isArchorList{
    _isArchorList = isArchorList;
    self.firstLevelImgView.hidden = !_isArchorList;
    self.firstLiveImgView.hidden = !_isArchorList;
    self.firstFollowBtn.hidden = !_isArchorList;
    self.secondLevelBackImgView.hidden = !_isArchorList;
    self.secondLiveImgView.hidden = !_isArchorList;
    self.secondFollowBtn.hidden = !_isArchorList;
    self.secondCompareLevelLabel.hidden = !_isArchorList;
    self.thirdLevelBackImgView.hidden = !_isArchorList;
    self.thirdFollowBtn.hidden = !_isArchorList;
    self.thirdLiveImgView.hidden = !_isArchorList;
    self.thirdCompareLevelLabel.hidden = !_isArchorList;
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    @weakify(self)
    LCRankArchorModel *firstModel = [_dataArray firstObject];
    [[RACObserve(firstModel, avatar_thumb) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.firstUserImgView setImageStr:x];
    }];
    RAC(self.firstUserNameLabel,text) = [RACObserve(firstModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.firstLevelLabel,text) = [RACObserve(firstModel, level_anchor) takeUntil:self.rac_prepareForReuseSignal];
    
    [[RACObserve(firstModel, isAttention) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        self.firstFollowBtn.selected = x.boolValue;
    }];
    [[RACObserve(firstModel, islive) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        self.firstLiveImgView.hidden = !x.boolValue;
        if([x boolValue]){
            [self.firstLiveImgView startAnimating];
        }
        
    }];
    if(_dataArray.count > 1){
        LCRankArchorModel *secondModel = _dataArray[1];
        [[RACObserve(secondModel, avatar_thumb) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
            @strongify(self)
            [self.secondUserImgView setImageStr:x];
        }];
        [[RACObserve(secondModel, islive) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
            @strongify(self)
            self.secondLiveImgView.hidden = !x.boolValue;
            if([x boolValue]){
                [self.secondLiveImgView startAnimating];
            }
        }];
        RAC(self.secondUserNameLabel,text) = [RACObserve(secondModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.secondLevelLabel,text) = [RACObserve(secondModel, level_anchor) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.secondCompareLevelLabel,text) = [[RACObserve(secondModel, luohou) map:^NSString * _Nullable(NSString *  _Nullable value) {
            if(!value.length){
                return nil;
            }
            return [NSString stringWithFormat:@"%@%@%@",KLanguage(@"落后"),value,KLanguage(@"火力")];
        }] takeUntil:self.rac_prepareForReuseSignal];
        [[RACObserve(secondModel, isAttention) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
            @strongify(self)
            self.secondFollowBtn.selected = x.boolValue;
        }];
    }else{
        self.secondUserImgView.hidden = YES;
        self.secondHgImgView.hidden = YES;
        self.secondFollowBtn.hidden = YES;
        self.secondLevelBackImgView.hidden = YES;
    }
    if(_dataArray.count > 2){
        LCRankArchorModel *thirdModel = _dataArray[2];
        [[RACObserve(thirdModel, avatar_thumb) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
            @strongify(self)
            [self.thirdUserImgView setImageStr:x];
        }];
        [[RACObserve(thirdModel, islive) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
            @strongify(self)
            self.thirdLiveImgView.hidden = !x.boolValue;
            if([x boolValue]){
                [self.thirdLiveImgView startAnimating];
            }
        }];
        RAC(self.thirdUserNameLabel,text) = [RACObserve(thirdModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.thirdLevelLabel,text) = [RACObserve(thirdModel, level_anchor) takeUntil:self.rac_prepareForReuseSignal];
        [[RACObserve(thirdModel, isAttention) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
            @strongify(self)
            self.thirdFollowBtn.selected = x.boolValue;
        }];
        RAC(self.thirdCompareLevelLabel,text) = [[RACObserve(thirdModel, luohou) map:^NSString * _Nullable(NSString *  _Nullable value) {
            if(!value.length){
                return nil;
            }
            return [NSString stringWithFormat:@"%@%@%@",KLanguage(@"落后"),value,KLanguage(@"火力")];
        }] takeUntil:self.rac_prepareForReuseSignal];
    }else{
        self.thirdUserImgView.hidden = YES;
        self.thirdHgImgView.hidden = YES;
        self.thirdFollowBtn.hidden = YES;
        self.thirdLevelBackImgView.hidden = YES;
    }
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backView{
    if (_backView == nil){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image(@"icon_rankHeaderBg")];
        [self.contentView addSubview:imgView];
        _backView = imgView;
        _backView.contentMode = UIViewContentModeScaleAspectFill;
        _backView.userInteractionEnabled = YES;
        _backView.clipsToBounds = YES;
        
        
    }
    return _backView;
}
- (UIImageView *)firstUserImgView{
    if (_firstUserImgView == nil){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.backView addSubview:imgView];
        _firstUserImgView = imgView;
        _firstUserImgView.contentMode = UIViewContentModeScaleAspectFill;
        _firstUserImgView.userInteractionEnabled = YES;
        _firstUserImgView.clipsToBounds = YES;
        _firstUserImgView.layer.masksToBounds = YES;
        _firstUserImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        _firstUserImgView.layer.borderWidth = kUI_Width(2);
        _firstUserImgView.layer.borderColor = Color(@"#F19F19").CGColor;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count> 0){
                LCRankArchorModel *firstModel = [weakSelf.dataArray firstObject];
                if(![firstModel.islive boolValue]){
                    [weakSelf.userHomeSubject sendNext:firstModel];
                }
                
            }
        }];
        [_firstUserImgView addGestureRecognizer:tap];
    }
    return _firstUserImgView;
}
- (UIImageView *)firstLiveImgView{
    if(!_firstLiveImgView){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.firstUserImgView addSubview:imgView];
        _firstLiveImgView = imgView;
        _firstLiveImgView.contentMode = UIViewContentModeScaleAspectFill;
        _firstLiveImgView.userInteractionEnabled = YES;
        _firstLiveImgView.clipsToBounds = YES;
        _firstLiveImgView.layer.masksToBounds = YES;
        _firstLiveImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        _firstLiveImgView.animationImages = @[image(@"icon_onLiveImg1"),image(@"icon_onLiveImg2"),image(@"icon_onLiveImg3"),image(@"icon_onLiveImg4")];
        _firstLiveImgView.animationDuration = 0.8;                //设置帧动画时长
        _firstLiveImgView.animationRepeatCount = 0;
        _firstLiveImgView.hidden = YES;
//        [_gifImgView startAnimating];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count > 0){
                LCRankArchorModel *model = weakSelf.dataArray[0];
            
                [weakSelf.jumpToLiveSubject sendNext:model];
            }
           
        }];
        [_firstLiveImgView addGestureRecognizer:tap];
    }
    return _firstLiveImgView;
}
- (UIImageView *)firstHgImgView{
    if (_firstHgImgView == nil){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_firstHgImg")];
        [self.backView addSubview:imgView];
        _firstHgImgView = imgView;
    }
    return _firstHgImgView;
}
- (UIImageView *)firstInfoImgView{
    if (!_firstInfoImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_firstInfoImg");
        _firstInfoImgView = imgView;
        [self.backView addSubview:_firstInfoImgView];
    }
    return _firstInfoImgView;
}
- (UILabel *)firstUserNameLabel{
    if (!_firstUserNameLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(14);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _firstUserNameLabel = label;
        label.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count> 0){
                LCRankArchorModel *firstModel = weakSelf.dataArray[0];
                
                    [weakSelf.userHomeSubject sendNext:firstModel];
                
                
            }
        }];
        [_firstUserNameLabel addGestureRecognizer:tap];
    }
    return _firstUserNameLabel;
}
- (UIImageView *)firstLevelBackImgView{
    if (!_firstLevelBackImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelBackImg");
        _firstLevelBackImgView = imgView;
        [self.backView addSubview:_firstLevelBackImgView];
    }
    return _firstLevelBackImgView;
}
- (UIImageView *)firstLevelImgView{
    if (!_firstLevelImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelImg1");
        _firstLevelImgView = imgView;
        [self.firstLevelBackImgView addSubview:_firstLevelImgView];
    }
    return _firstLevelImgView;
}
- (UILabel *)firstLevelLabel{
    if (!_firstLevelLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(10);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.firstLevelBackImgView addSubview:label];
        _firstLevelLabel = label;
    }
    return _firstLevelLabel;
}
- (UIButton *)firstFollowBtn{
    if (!_firstFollowBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_rankNormalFollow") forState:UIControlStateNormal];
        [btn setBackgroundImage:image(@"icon_rankSelectFollow") forState:UIControlStateSelected];
        [btn setTitle:KLanguage(@"关注") forState:UIControlStateNormal];
        [btn setTitle:KLanguage(@"已关注") forState:UIControlStateSelected];
        btn.titleLabel.font = MediumFont(14);
        [self.backView addSubview:btn];
        _firstFollowBtn = btn;
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.dataArray.count > 0){
                LCRankArchorModel *model = weakSelf.dataArray[0];
            
                [weakSelf.followSubject sendNext:model];
            }
            
        }];
    }
    return _firstFollowBtn;
}


- (UIImageView *)secondUserImgView{
    if (_secondUserImgView == nil){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.backView addSubview:imgView];
        _secondUserImgView = imgView;
        _secondUserImgView.contentMode = UIViewContentModeScaleAspectFill;
        _secondUserImgView.userInteractionEnabled = YES;
        _secondUserImgView.clipsToBounds = YES;
        _secondUserImgView.layer.masksToBounds = YES;
        _secondUserImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        _secondUserImgView.layer.borderWidth = kUI_Width(2);
        _secondUserImgView.layer.borderColor = Color(@"#9EC5D3").CGColor;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count> 1){
                LCRankArchorModel *firstModel = weakSelf.dataArray[1];
                if(![firstModel.islive boolValue]){
                    [weakSelf.userHomeSubject sendNext:firstModel];
                }
                
            }
        }];
        [_secondUserImgView addGestureRecognizer:tap];
    }
    return _secondUserImgView;
}
- (UIImageView *)secondLiveImgView{
    if(!_secondLiveImgView){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image(@"icon_rankLiveImg")];
        [self.secondUserImgView addSubview:imgView];
      
        _secondLiveImgView = imgView;
        _secondLiveImgView.contentMode = UIViewContentModeScaleAspectFill;
        _secondLiveImgView.userInteractionEnabled = YES;
        _secondLiveImgView.clipsToBounds = YES;
        _secondLiveImgView.layer.masksToBounds = YES;
        _secondLiveImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        _secondLiveImgView.animationImages = @[image(@"icon_onLiveImg1"),image(@"icon_onLiveImg2"),image(@"icon_onLiveImg3"),image(@"icon_onLiveImg4")];
        _secondLiveImgView.animationDuration = 0.8;                //设置帧动画时长
        _secondLiveImgView.animationRepeatCount = 0;
        _secondLiveImgView.hidden = YES;
//        [_gifImgView startAnimating];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count > 1){
                LCRankArchorModel *model = weakSelf.dataArray[1];
            
                [weakSelf.jumpToLiveSubject sendNext:model];
            }
           
        }];
        [_secondLiveImgView addGestureRecognizer:tap];
    }
    return _secondLiveImgView;
}
- (UIImageView *)secondHgImgView{
    if (_secondHgImgView == nil){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_secondHgImg")];
        [self.backView addSubview:imgView];
        _secondHgImgView = imgView;
    }
    return _secondHgImgView;
}
- (UIImageView *)secondInfoImgView{
    if (!_secondInfoImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_secondInfoImg");
        _secondInfoImgView = imgView;
        [self.backView addSubview:_secondInfoImgView];
    }
    return _secondInfoImgView;
}
- (UILabel *)secondUserNameLabel{
    if (!_secondUserNameLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(14);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _secondUserNameLabel = label;
        label.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count> 1){
                LCRankArchorModel *firstModel = weakSelf.dataArray[1];
                
                    [weakSelf.userHomeSubject sendNext:firstModel];
                
                
            }
        }];
        [_secondUserNameLabel addGestureRecognizer:tap];
    }
    return _secondUserNameLabel;
}
- (UIImageView *)secondLevelBackImgView{
    if (!_secondLevelBackImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelBackImg");
        _secondLevelBackImgView = imgView;
        [self.backView addSubview:_secondLevelBackImgView];
    }
    return _secondLevelBackImgView;
}
- (UIImageView *)secondLevelImgView{
    if (!_secondLevelImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelImg1");
        _secondLevelImgView = imgView;
        [self.secondLevelBackImgView addSubview:_secondLevelImgView];
    }
    return _secondLevelImgView;
}
- (UILabel *)secondLevelLabel{
    if (!_secondLevelLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(10);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.secondLevelBackImgView addSubview:label];
        _secondLevelLabel = label;
    }
    return _secondLevelLabel;
}
- (UILabel *)secondCompareLevelLabel{
    if(!_secondCompareLevelLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(12);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _secondCompareLevelLabel = label;
    }
    return _secondCompareLevelLabel;
}
- (UIButton *)secondFollowBtn{
    if (!_secondFollowBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_rankNormalFollow") forState:UIControlStateNormal];
        [btn setBackgroundImage:image(@"icon_rankSelectFollow") forState:UIControlStateSelected];
        [btn setTitle:KLanguage(@"关注") forState:UIControlStateNormal];
        [btn setTitle:KLanguage(@"已关注") forState:UIControlStateSelected];
        btn.titleLabel.font = MediumFont(14);
        [self.backView addSubview:btn];
        _secondFollowBtn = btn;
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.dataArray.count > 1){
                LCRankArchorModel *model = weakSelf.dataArray[1];
                [weakSelf.followSubject sendNext:model];
            }
           
        }];
    }
    return _secondFollowBtn;
}


- (UIImageView *)thirdUserImgView{
    if (_thirdUserImgView == nil){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.backView addSubview:imgView];
        _thirdUserImgView = imgView;
        _thirdUserImgView.contentMode = UIViewContentModeScaleAspectFill;
        _thirdUserImgView.userInteractionEnabled = YES;
        _thirdUserImgView.clipsToBounds = YES;
        _thirdUserImgView.layer.masksToBounds = YES;
        _thirdUserImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        _thirdUserImgView.layer.borderWidth = kUI_Width(2);
        _thirdUserImgView.layer.borderColor = Color(@"#AF8762").CGColor;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count> 2){
                LCRankArchorModel *firstModel = weakSelf.dataArray[2];
                if(![firstModel.islive boolValue]){
                    [weakSelf.userHomeSubject sendNext:firstModel];
                }
                
            }
        }];
        [_thirdUserImgView addGestureRecognizer:tap];
    }
    return _thirdUserImgView;
}
- (UIImageView *)thirdLiveImgView{
    if(!_thirdLiveImgView){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image(@"icon_rankLiveImg")];
        [self.thirdUserImgView addSubview:imgView];
       
        _thirdLiveImgView = imgView;
        _thirdLiveImgView.contentMode = UIViewContentModeScaleAspectFill;
        _thirdLiveImgView.userInteractionEnabled = YES;
        _thirdLiveImgView.clipsToBounds = YES;
        _thirdLiveImgView.layer.masksToBounds = YES;
        _thirdLiveImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        _thirdLiveImgView.animationImages = @[image(@"icon_onLiveImg1"),image(@"icon_onLiveImg2"),image(@"icon_onLiveImg3"),image(@"icon_onLiveImg4")];
        _thirdLiveImgView.animationDuration = 0.8;                //设置帧动画时长
        _thirdLiveImgView.animationRepeatCount = 0;
        _thirdLiveImgView.hidden = YES;
//        [_gifImgView startAnimating];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count > 2){
                LCRankArchorModel *model = weakSelf.dataArray[2];
            
                [weakSelf.jumpToLiveSubject sendNext:model];
            }
           
        }];
        [_thirdLiveImgView addGestureRecognizer:tap];
    }
    return _thirdLiveImgView;
}
- (UIImageView *)thirdHgImgView{
    if (_thirdHgImgView == nil){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_thirdHgImg")];
        [self.backView addSubview:imgView];
        _thirdHgImgView = imgView;
    }
    return _thirdHgImgView;
}
- (UIImageView *)thirdInfoImgView{
    if (!_thirdInfoImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_thirdInfoImg");
        _thirdInfoImgView = imgView;
        [self.backView addSubview:_thirdInfoImgView];
    }
    return _thirdInfoImgView;
}
- (UILabel *)thirdUserNameLabel{
    if (!_thirdUserNameLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(14);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _thirdUserNameLabel = label;
        label.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.dataArray.count> 2){
                LCRankArchorModel *firstModel = weakSelf.dataArray[2];
                
                    [weakSelf.userHomeSubject sendNext:firstModel];
                
                
            }
        }];
        [_thirdUserNameLabel addGestureRecognizer:tap];
    }
    return _thirdUserNameLabel;
}
- (UIImageView *)thirdLevelBackImgView{
    if (!_thirdLevelBackImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelBackImg");
        _thirdLevelBackImgView = imgView;
        [self.backView addSubview:_thirdLevelBackImgView];
    }
    return _thirdLevelBackImgView;
}
- (UIImageView *)thirdLevelImgView{
    if (!_thirdLevelImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelImg1");
        _thirdLevelImgView = imgView;
        [self.thirdLevelBackImgView addSubview:_thirdLevelImgView];
    }
    return _thirdLevelImgView;
}
- (UILabel *)thirdLevelLabel{
    if (!_thirdLevelLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(10);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.thirdLevelBackImgView addSubview:label];
        _thirdLevelLabel = label;
    }
    return _thirdLevelLabel;
}
- (UILabel *)thirdCompareLevelLabel{
    if(!_thirdCompareLevelLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(12);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _thirdCompareLevelLabel = label;
    }
    return _thirdCompareLevelLabel;
}
- (UIButton *)thirdFollowBtn{
    if (!_thirdFollowBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_rankNormalFollow") forState:UIControlStateNormal];
        [btn setBackgroundImage:image(@"icon_rankSelectFollow") forState:UIControlStateSelected];
        [btn setTitle:KLanguage(@"关注") forState:UIControlStateNormal];
        [btn setTitle:KLanguage(@"已关注") forState:UIControlStateSelected];
        btn.titleLabel.font = MediumFont(14);
        [self.backView addSubview:btn];
        _thirdFollowBtn = btn;
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.dataArray.count > 2){
                LCRankArchorModel *model = weakSelf.dataArray[2];
                [weakSelf.followSubject sendNext:model];
            }
           
        }];
    }
    return _thirdFollowBtn;
}
- (RACSubject *)followSubject{
    if(!_followSubject){
        _followSubject = [RACSubject subject];
    }
    return _followSubject;
}
- (RACSubject *)jumpToLiveSubject{
    if(!_jumpToLiveSubject){
        _jumpToLiveSubject = [RACSubject subject];
    }
    return _jumpToLiveSubject;
}
- (RACSubject *)userHomeSubject{
    if(!_userHomeSubject){
        _userHomeSubject = [RACSubject subject];
    }
    return _userHomeSubject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
