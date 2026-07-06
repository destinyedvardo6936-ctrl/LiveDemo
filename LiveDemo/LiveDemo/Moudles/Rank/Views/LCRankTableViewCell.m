//
//  LCRankTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/26.
//

#import "LCRankTableViewCell.h"

@interface LCRankTableViewCell ()
@property (nonatomic , weak) UILabel *numberLabel;
@property (nonatomic , weak) UIImageView *userImgView;
@property (nonatomic , weak) UIImageView *gifImgView;

@property (nonatomic , weak) UILabel *userNameLabel;
@property (nonatomic , weak) UIImageView *levelBackImgView;
@property (nonatomic , weak) UIImageView *levelImgView;
@property (nonatomic , weak) UILabel *levelLabel;
@property (nonatomic , weak) UILabel *compareLevelLabel;
@property (nonatomic , weak) UIButton *followBtn;
@end
@implementation LCRankTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(kUI_Width(16));
            make.height.equalTo(kUI_Width(14));
        }];
        [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.numberLabel.mas_right).offset(kUI_Width(16));
            make.centerY.equalTo(0);
            make.width.equalTo(kUI_Width(55));
            make.height.equalTo(kUI_Width(55));
        }];
        [self.gifImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userImgView.mas_right).offset(kUI_Width(12));
            make.top.mas_equalTo(self.userImgView.mas_top).offset(kUI_Width(6));
            make.right.mas_lessThanOrEqualTo(self.followBtn.mas_left).offset(-kUI_Width(48));
            make.height.equalTo(kUI_Width(16));
        }];
        
        
        [self.levelBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(34));
            make.height.equalTo(kUI_Width(16));
            make.left.mas_equalTo(self.userNameLabel.mas_right).offset(kUI_Width(4));
            make.top.mas_equalTo(self.userNameLabel.mas_top);
        }];
        [self.levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.height.equalTo(kUI_Width(12));
            make.left.equalTo(kUI_Width(4));
        }];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.levelImgView.mas_right).offset(kUI_Width(3));
            make.right.equalTo(-kUI_Width(3));
            make.top.bottom.equalTo(0);
        }];
        [self.compareLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.userImgView.mas_bottom).offset(-kUI_Width(6));
            make.left.mas_equalTo(self.userNameLabel.mas_left);
            make.right.mas_lessThanOrEqualTo(self.followBtn.mas_left).offset(-kUI_Width(10));
            make.height.equalTo(kUI_Width(12));
        }];
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.equalTo(kUI_Width(61));
            make.height.equalTo(kUI_Width(28));
            make.right.equalTo(-kUI_Width(16));
        }];
    }
    return self;
}
- (void)setIsArchorList:(BOOL)isArchorList{
    _isArchorList = isArchorList;
    self.levelBackImgView.hidden = !_isArchorList;
    self.compareLevelLabel.hidden = !_isArchorList;
    self.followBtn.hidden = !_isArchorList;
    [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(_isArchorList){
            make.left.mas_equalTo(self.userImgView.mas_right).offset(kUI_Width(12));
            make.top.mas_equalTo(self.userImgView.mas_top).offset(kUI_Width(6));
            make.right.mas_lessThanOrEqualTo(self.followBtn.mas_left).offset(-kUI_Width(48));
            make.height.equalTo(kUI_Width(16));
        }else{
            make.left.mas_equalTo(self.userImgView.mas_right).offset(kUI_Width(12));
            make.centerY.mas_equalTo(self.userImgView.mas_centerY);
            make.right.equalTo(-kUI_Width(16));
            make.height.equalTo(kUI_Width(16));
        }
        
    }];
    
}
- (void)setDataModel:(LCRankArchorModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, avatar_thumb) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
            [self.userImgView setImageStr:x];
    
    }];
    RAC(self.levelLabel,text) = [RACObserve(_dataModel, level_anchor) takeUntil:self.rac_prepareForReuseSignal];
   
   
    
    RAC(self.userNameLabel,text) = [RACObserve(_dataModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.compareLevelLabel,text) = [[RACObserve(_dataModel, luohou) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return nil;
        }
        return [NSString stringWithFormat:@"%@%@%@",KLanguage(@"落后"),value,KLanguage(@"火力")];
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.numberLabel,text) = [[RACObserve(_dataModel, rankNum) map:^NSString * _Nullable(NSNumber *  _Nullable value) {
        return [NSString stringWithFormat:@"%ld",value.integerValue];
    }] takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, isAttention) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        self.followBtn.selected = x.boolValue;
    }];
    [[RACObserve(_dataModel, islive) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        self.gifImgView.hidden = ![x boolValue];
        if([x boolValue]){
            [self.gifImgView startAnimating];
        }
        
    }];
}
#pragma mark---- 懒加载 ----
- (UILabel *)numberLabel{
    if(!_numberLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(14);
        label.textColor = Color(@"#999999");
//        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _numberLabel = label;
    }
    return _numberLabel;
}
- (UIImageView *)userImgView{
    if (_userImgView == nil){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:imgView];
        _userImgView = imgView;
        _userImgView.contentMode = UIViewContentModeScaleAspectFill;
        _userImgView.userInteractionEnabled = YES;
        _userImgView.clipsToBounds = YES;
        _userImgView.layer.masksToBounds = YES;
        _userImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        
    }
    return _userImgView;
}
- (UIImageView *)gifImgView{
    if (_gifImgView == nil){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.userImgView addSubview:imgView];
        _gifImgView = imgView;
        _gifImgView.contentMode = UIViewContentModeScaleAspectFill;
        _gifImgView.userInteractionEnabled = YES;
        _gifImgView.clipsToBounds = YES;
        _gifImgView.layer.masksToBounds = YES;
        _gifImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        _gifImgView.animationImages = @[image(@"icon_onLiveImg1"),image(@"icon_onLiveImg2"),image(@"icon_onLiveImg3"),image(@"icon_onLiveImg4")];
        _gifImgView.animationDuration = 0.8;                //设置帧动画时长
        _gifImgView.animationRepeatCount = 0;
//        [_gifImgView startAnimating];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.jumpToLiveSubject sendNext:weakSelf.dataModel];
        }];
        [_gifImgView addGestureRecognizer:tap];
        
    }
    return _gifImgView;
}

- (UILabel *)userNameLabel{
    if (!_userNameLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(16);
        label.textColor = Color(@"#333333");
//        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _userNameLabel = label;
    }
    return _userNameLabel;
}
- (UIImageView *)levelBackImgView{
    if (!_levelBackImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelBackImg");
        _levelBackImgView = imgView;
        [self.contentView addSubview:_levelBackImgView];
    }
    return _levelBackImgView;
}
- (UIImageView *)levelImgView{
    if (!_levelImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelImg1");
        _levelImgView = imgView;
        [self.levelBackImgView addSubview:_levelImgView];
    }
    return _levelImgView;
}
- (UILabel *)levelLabel{
    if (!_levelLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(10);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.levelBackImgView addSubview:label];
        _levelLabel = label;
    }
    return _levelLabel;
}
- (UILabel *)compareLevelLabel{
    if(!_compareLevelLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(12);
        label.textColor = Color(@"#999999");
//        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _compareLevelLabel = label;
    }
    return _compareLevelLabel;
}
- (UIButton *)followBtn{
    if (!_followBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_rankNormalFollow") forState:UIControlStateNormal];
        [btn setBackgroundImage:image(@"icon_rankSelectFollow") forState:UIControlStateSelected];
        [btn setTitle:KLanguage(@"关注") forState:UIControlStateNormal];
        [btn setTitle:KLanguage(@"已关注") forState:UIControlStateSelected];
        btn.titleLabel.font = MediumFont(14);
        [self.contentView addSubview:btn];
        _followBtn = btn;
        WS(weakSelf)
        [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.followSubject sendNext:weakSelf.dataModel];
        }];
    }
    return _followBtn;
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
