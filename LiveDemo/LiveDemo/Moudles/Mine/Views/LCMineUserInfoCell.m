//
//  LCMineUserInfoCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/6.
//

#import "LCMineUserInfoCell.h"

@interface LCMineUserInfoCell ()
@property(nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic , weak) UIButton *editBtn;
@property(nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic , weak) UIImageView *levelBackImgView;
@property (nonatomic , weak) UIImageView *levelImgView;
@property (nonatomic , weak) UILabel *levelLabel;
@property (nonatomic , weak) UIImageView *sexImgView;
@property(nonatomic, weak) UILabel *userIDLabel;
@property (nonatomic , weak) UIButton *userIdCopyBtn;
@property(nonatomic, weak) UILabel *profileLabel;
@property (nonatomic , weak) UIButton *accessBtn;
@property (nonatomic, weak) UILabel *followCountLabel;
@property (nonatomic, weak) UILabel *followTipLabel;
@property (nonatomic, weak) UILabel *fansCountLabel;
@property (nonatomic, weak) UILabel *fansTipLabel;

@end
@implementation LCMineUserInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(24));
            make.top.equalTo(0);
            make.width.height.equalTo(kUI_Width(70));
        }];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(20));
            make.top.mas_equalTo(self.avatarImageView.mas_top).offset(kUI_Width(62));
            make.centerX.mas_equalTo(self.avatarImageView.mas_centerX);
        }];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView.mas_top);
            make.height.equalTo(kUI_Width(18));
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(kUI_Width(20));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
        [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(14));
            make.left.mas_equalTo(self.userNameLabel.mas_left);
            make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(kUI_Width(9));
        }];
        [self.levelBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(16));
            make.centerY.mas_equalTo(self.sexImgView.mas_centerY);
            make.left.mas_equalTo(self.sexImgView.mas_right).offset(kUI_Width(6));
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
        [self.userIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(12));
            make.left.mas_equalTo(self.userNameLabel.mas_left);
            make.top.mas_equalTo(self.sexImgView.mas_bottom).offset(kUI_Width(9));
        }];
        [self.userIdCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(16));
            make.left.mas_equalTo(self.userIDLabel.mas_right).offset(kUI_Width(8));
            make.centerY.mas_equalTo(self.userIDLabel.mas_centerY);
            make.width.equalTo(kUI_Width(28));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
        [self.profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userNameLabel.mas_left);
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.userIDLabel.mas_bottom).offset(kUI_Width(8));
        }];
        [self.accessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(14));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.avatarImageView.mas_top).offset(kUI_Width(34));
        }];
        [self.followCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(25));
            make.top.mas_equalTo(self.profileLabel.mas_bottom).offset(kUI_Width(10));
            make.centerX.equalTo(-SCREEN_WIDTH/4.0);
            
        }];
        [self.followTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.followCountLabel.mas_bottom);
            make.height.equalTo(kUI_Width(14));
            make.centerX.mas_equalTo(self.followCountLabel.mas_centerX);
            make.bottom.equalTo(-kUI_Width(10));
            
        }];
        [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(25));
            make.top.mas_equalTo(self.followCountLabel.mas_top);
            make.centerX.equalTo(SCREEN_WIDTH/4.0);
            
        }];
        [self.fansTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fansCountLabel.mas_bottom);
            make.height.equalTo(kUI_Width(14));
            make.centerX.mas_equalTo(self.fansCountLabel.mas_centerX);
            
        }];
    }
    return self;
}
- (void)setDataModel:(LCUserInfoModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    
    [[RACObserve(_dataModel, avatar) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *_Nullable x) {
        @strongify(self);

       
            [self.avatarImageView setImageStr:x];
        
    }];
    
    RAC(self.userNameLabel, text) = [RACObserve(_dataModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.userIDLabel, text) = [[RACObserve(_dataModel, ID) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value){
            return nil;
        }
        return  [NSString stringWithFormat:@"ID:%@",value];
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.followCountLabel, text) = [RACObserve(_dataModel, follows) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.fansCountLabel, text) = [RACObserve(_dataModel, fans) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.profileLabel, text) = [RACObserve(_dataModel, signature) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.levelLabel, text) = [RACObserve(_dataModel, level) takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, sex) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if([x isEqualToString:@"1"]){
            self.sexImgView.image = image(@"icon_sexFamale");
        }else{
            self.sexImgView.image = image(@"icon_sexWomen");
        }
    }];
//    RAC(self.postCountLabel, text) = [RACObserve(self.viewModel, postCount) takeUntil:self.rac_willDeallocSignal];
}
#pragma mark---- 懒加载 ----
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        imgView.userInteractionEnabled = YES;

        _avatarImageView =  imgView;
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kUI_Width(70)/2.0;
        [self.contentView addSubview:_avatarImageView];
        
    }
    return _avatarImageView;
}
- (UIButton *)editBtn{
    if(!_editBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        [self.contentView addSubview:btn];
        btn.layer.cornerRadius = kUI_Width(20)/2.0;
        btn.backgroundColor = Color(@"#666666");
        _editBtn = btn;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(10);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"编辑资料");
        [btn addSubview:label];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_mineEditImg")];
        [btn addSubview:imgView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(8));
            make.top.bottom.equalTo(0);
        }];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(kUI_Width(2));
            make.width.height.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
            make.right.equalTo(-kUI_Width(8));
        }];

        WS(weakSelf)
        [[_editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.editSubject sendNext:@(YES)];
        }];
    }
    return _editBtn;
}
- (UIImageView *)sexImgView{
    if (!_sexImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_sexFamale");
        _sexImgView = imgView;
        [self.contentView addSubview:_sexImgView];
    }
    return _sexImgView;
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
- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        UILabel *lab = [UILabel new];
        lab.font = BoldFont(18);
        lab.textColor = Color(@"#333333");
//        lab.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//
//        }];
//        [lab addGestureRecognizer:tap];
        _userNameLabel = lab;
        [self.contentView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}
- (UILabel *)userIDLabel {
    if (!_userIDLabel) {
        UILabel *lab = [UILabel new];
        lab.font = RegularFont(12);
        lab.textColor = Color(@"#999999");
//        lab.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//
//        }];
//        [lab addGestureRecognizer:tap];
        _userIDLabel = lab;
        [self.contentView addSubview:_userIDLabel];
    }
    return _userIDLabel;
}
- (UIButton *)userIdCopyBtn{
    if(!_userIdCopyBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:KLanguage(@"复制") forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#3894FF") forState:UIControlStateNormal];
        btn.titleLabel.font = RegularFont(10);
        btn.layer.cornerRadius = kUI_Width(4);
        btn.backgroundColor = Color(@"#EDEDED");
        btn.clipsToBounds = YES;
        [self.contentView addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:[[weakSelf userIDLabel]text]];
            [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"已复制成功") ];
        }];
        _userIdCopyBtn = btn;
    }
    return _userIdCopyBtn;
}
- (UILabel *)profileLabel {
    if (!_profileLabel) {
        UILabel *lab = [UILabel new];
        lab.font = RegularFont(12);
        lab.textColor = Color(@"#999999");
        lab.numberOfLines = 0;
//        lab.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//
//        }];
//        [lab addGestureRecognizer:tap];
        [lab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [lab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _profileLabel = lab;
        [self.contentView addSubview:_profileLabel];
    }
    return _profileLabel;
}
- (UIButton *)accessBtn{
    if(!_accessBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image(@"icon_mineUserInfoAcess") forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        _accessBtn = btn;
        WS(weakSelf)
        [[_accessBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.editSubject sendNext:@(YES)];
        }];
    }
    return _accessBtn;
}
- (UILabel *)followCountLabel{
    if (_followCountLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _followCountLabel = label;
        _followCountLabel.font = BoldFont(18);
        _followCountLabel.textColor = Color(@"#333333");
        _followCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _followCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_followCountLabel];
        _followCountLabel.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.followClickSubject sendNext:@(YES)];
        }];
        [_followCountLabel addGestureRecognizer:tap];
    }

    return _followCountLabel;
}
- (UILabel *)followTipLabel{
    if (_followTipLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _followTipLabel = label;
        _followTipLabel.font = RegularFont(14);
        _followTipLabel.text = KLanguage(@"关注");
        _followTipLabel.textColor = Color(@"#999999");
        _followTipLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _followTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_followTipLabel];
        _followTipLabel.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.followClickSubject sendNext:@(YES)];
        }];
        [_followTipLabel addGestureRecognizer:tap];
    }

    return _followTipLabel;
}
- (UILabel *)fansTipLabel{
    if (_fansTipLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _fansTipLabel = label;
        _fansTipLabel.font = RegularFont(14);
        _fansTipLabel.text = KLanguage(@"粉丝");
        _fansTipLabel.textColor = Color(@"#999999");
        _fansTipLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _fansTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_fansTipLabel];
        _fansTipLabel.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.fansClickSubject sendNext:@(YES)];
        }];
        [_fansTipLabel addGestureRecognizer:tap];
    }

    return _fansTipLabel;
}
- (UILabel *)fansCountLabel{
    if (_fansCountLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _fansCountLabel = label;
        _fansCountLabel.font = RegularFont(18);
        _fansCountLabel.textColor = Color(@"#333333");
        _fansCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _fansCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_fansCountLabel];
        _fansCountLabel.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.fansClickSubject sendNext:@(YES)];
        }];
        [_fansCountLabel addGestureRecognizer:tap];
    }

    return _fansCountLabel;
}
- (RACSubject *)editSubject{
    if(!_editSubject){
        _editSubject = [RACSubject subject];
    }
    return _editSubject;
}
- (RACSubject *)userIdCopySubject{
    if(!_userIdCopySubject){
        _userIdCopySubject = [RACSubject subject];
    }
    return _userIdCopySubject;
}
- (RACSubject *)followClickSubject{
    if(!_followClickSubject){
        _followClickSubject = [RACSubject subject];
    }
    return _followClickSubject;
}
- (RACSubject *)fansClickSubject{
    if(!_fansClickSubject){
        _fansClickSubject = [RACSubject subject];
    }
    return _fansClickSubject;
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
