//
//  LCUserHomeTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCUserHomeTableViewCell.h"
#import "LCUserContributeView.h"
@interface LCUserHomeTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic, weak) UILabel *followCountLabel;
@property (nonatomic, weak) UILabel *followTipLabel;
@property (nonatomic, weak) UILabel *fansCountLabel;
@property (nonatomic, weak) UILabel *fansTipLabel;
@property (nonatomic, weak) UILabel *giftCountLabel;
@property (nonatomic, weak) UILabel *giftTipLabel;
@property (nonatomic, weak) UILabel *profileTipLabel;
@property (nonatomic , weak) UIView *profileBackView;
@property (nonatomic, weak) UILabel *profileLabel;
@property (nonatomic , weak) UIView *profitBackView;
@property (nonatomic , weak) LCUserContributeView *usersView;
@property (nonatomic, weak) UILabel *infoTipLabel;
@property (nonatomic, weak) UILabel *userIdLabel;
@property (nonatomic, weak) UILabel *areaLabel;
//@property (nonatomic, weak) UILabel *jobLabel;
@property (nonatomic, weak) UILabel *ageLabel;
@end
@implementation LCUserHomeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            
        }];
        [self.fansTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(12));
            make.width.lessThanOrEqualTo(kUI_Width(32));
        }];
        [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fansTipLabel.mas_right).offset(kUI_Width(5));
            make.height.equalTo(kUI_Width(12));
            make.centerY.mas_equalTo(self.fansTipLabel.mas_centerY);
            make.width.lessThanOrEqualTo(kUI_Width(40));
        }];
        [self.followTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fansCountLabel.mas_right).offset(kUI_Width(30));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(12));
            make.width.lessThanOrEqualTo(kUI_Width(32));
        }];
        [self.followCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followTipLabel.mas_right).offset(kUI_Width(5));
            make.height.equalTo(kUI_Width(12));
            make.centerY.mas_equalTo(self.fansTipLabel.mas_centerY);
            make.width.lessThanOrEqualTo(kUI_Width(40));
        }];
        [self.giftTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followCountLabel.mas_right).offset(kUI_Width(30));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(12));
            make.width.lessThanOrEqualTo(kUI_Width(70));
        }];
        [self.giftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.giftTipLabel.mas_right).offset(kUI_Width(5));
            make.height.equalTo(kUI_Width(12));
            make.centerY.mas_equalTo(self.fansTipLabel.mas_centerY);
            make.width.lessThanOrEqualTo(kUI_Width(40));
        }];
        
        [self.profileTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(16));
            make.top.mas_equalTo(self.fansTipLabel.mas_bottom).offset(kUI_Width(12));
            make.right.lessThanOrEqualTo(-kUI_Width(12));
        }];
        [self.profileBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.mas_equalTo(self.profileTipLabel.mas_bottom).offset(kUI_Width(12));
        }];
        [self.profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(kUI_Width(12));
            make.right.bottom.equalTo(-kUI_Width(12));
        }];
        [self.profitBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(49));
            make.top.mas_equalTo(self.profileBackView.mas_bottom).offset(kUI_Width(12));
        }];
        
        [self.infoTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(16));
            make.top.mas_equalTo(self.profitBackView.mas_bottom).offset(kUI_Width(12));
            make.right.lessThanOrEqualTo(-kUI_Width(12));
        }];
        [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.top.mas_equalTo(self.infoTipLabel.mas_bottom).offset(kUI_Width(20));
            make.right.lessThanOrEqualTo(-kUI_Width(12));
        }];
        [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.top.mas_equalTo(self.userIdLabel.mas_bottom).offset(kUI_Width(20));
            make.right.lessThanOrEqualTo(-kUI_Width(12));
        }];
//        [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(12));
//            make.height.equalTo(kUI_Width(14));
//            make.top.mas_equalTo(self.areaLabel.mas_bottom).offset(kUI_Width(20));
//            make.right.lessThanOrEqualTo(-kUI_Width(12));
//        }];
        [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.top.mas_equalTo(self.areaLabel.mas_bottom).offset(kUI_Width(20));
            make.right.lessThanOrEqualTo(-kUI_Width(12));
            make.bottom.equalTo(0);
        }];
    }
    return self;
}

- (void)setDataModel:(LCUserHomeModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    RAC(self.followCountLabel, text) = [RACObserve(_dataModel, follows) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.fansCountLabel, text) = [RACObserve(_dataModel, fans) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.profileLabel, text) = [RACObserve(_dataModel, signature) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.userIdLabel, text) = [[RACObserve(_dataModel, modelId) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return KLanguage(@"会员ID ：");
        }
        return [NSString stringWithFormat:@"%@%@",KLanguage(@"会员ID ："),value];
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.areaLabel, text) = [[RACObserve(_dataModel, city) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return KLanguage(@"家乡 ：");
        }
        return [NSString stringWithFormat:@"%@%@",KLanguage(@"家乡 ："),value];
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.ageLabel, text) = [[RACObserve(_dataModel, birthday) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return KLanguage(@"生日 ：");
        }
        return [NSString stringWithFormat:@"%@%@",KLanguage(@"生日 ："),value];
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    self.usersView.dataArray = self.dataModel.contribute;
    
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.backView layoutIfNeeded];
    [self.backView acs_radiusWithRadius:kUI_Width(16) corner:UIRectCornerTopLeft|UIRectCornerTopRight frame:self.backView.bounds];
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
       
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UILabel *)followCountLabel{
    if (_followCountLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.backView addSubview:label];
        _followCountLabel = label;
        _followCountLabel.font = RegularFont(12);
        _followCountLabel.textColor = Color(@"#666666");
//        [_followCountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_followCountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        _followCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        _followCountLabel.textAlignment = NSTextAlignmentCenter;
        
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
        [self.backView addSubview:label];
        _followTipLabel.font = RegularFont(12);
        _followTipLabel.text = KLanguage(@"关注");
        _followTipLabel.textColor = Color(@"#999999");
//        [_followTipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_followTipLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [self.backView addSubview:_followTipLabel];
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
        [self.backView addSubview:label];
        _fansTipLabel = label;
        _fansTipLabel.font = RegularFont(12);
        _fansTipLabel.text = KLanguage(@"粉丝");
        _fansTipLabel.textColor = Color(@"#999999");
//        [_fansTipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_fansTipLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
       
//        [self.backView addSubview:_fansTipLabel];
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
        [self.backView addSubview:label];
        _fansCountLabel = label;
        
        _fansCountLabel.font = RegularFont(12);
        _fansCountLabel.textColor = Color(@"#666666");
//        [_fansCountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_fansCountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [self.backView addSubview:_fansCountLabel];
        _fansCountLabel.userInteractionEnabled = YES;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.fansClickSubject sendNext:@(YES)];
        }];
        [_fansCountLabel addGestureRecognizer:tap];
    }

    return _fansCountLabel;
}
- (UILabel *)giftTipLabel{
    if (_giftTipLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.backView addSubview:label];
        _giftTipLabel = label;
        _giftTipLabel.font = RegularFont(12);
        _giftTipLabel.text = KLanguage(@"送出礼物：");
        _giftTipLabel.textColor = Color(@"#999999");
//        [_giftTipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_giftTipLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
       
//        [self.backView addSubview:_giftTipLabel];
//        _giftTipLabel.userInteractionEnabled = YES;
//        WS(weakSelf)
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//            [weakSelf.fansClickSubject sendNext:@(YES)];
//        }];
//        [_giftTipLabel addGestureRecognizer:tap];
    }

    return _giftTipLabel;
}
- (UILabel *)giftCountLabel{
    if (_giftCountLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _giftCountLabel = label;
        _giftCountLabel.font = RegularFont(12);
        _giftCountLabel.textColor = Color(@"#666666");
//        [_giftCountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_giftCountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:_giftCountLabel];
        _giftCountLabel.userInteractionEnabled = YES;
//        WS(weakSelf)
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//            [weakSelf.fansClickSubject sendNext:@(YES)];
//        }];
//        [_giftCountLabel addGestureRecognizer:tap];
    }

    return _giftCountLabel;
}
- (UILabel *)profileTipLabel{
    if (_profileTipLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _profileTipLabel = label;
        _profileTipLabel.font = BoldFont(16);
        _profileTipLabel.textColor = Color(@"#333333");
        _profileTipLabel.text = KLanguage(@"关于TA");
//        [_profileTipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_profileTipLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:_profileTipLabel];

    }

    return _profileTipLabel;
}
- (UIView *)profileBackView{
    if(!_profileBackView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.layer.cornerRadius = kUI_Width(4);
        view.layer.borderWidth = 1;
        view.layer.borderColor = Color(@"#D4D4D4").CGColor;
        [self.backView addSubview:view];
        _profileBackView = view;
    }
    return _profileBackView;
}
- (UILabel *)profileLabel{
    if (_profileLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _profileLabel = label;
        _profileLabel.font = RegularFont(14);
        _profileLabel.textColor = Color(@"#333333");
        _profileLabel.text = KLanguage(@"个人介绍");
        _profileLabel.numberOfLines = 0;
        [_profileLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_profileLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.profileBackView addSubview:_profileLabel];

    }

    return _profileLabel;
}
- (UIView *)profitBackView{
    if(!_profitBackView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FCF2F6");
        view.clipsToBounds = YES;
        view.layer.cornerRadius = kUI_Width(4);
       
        [self.backView addSubview:view];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.contributeClickSubject sendNext:@(YES)];
        }];
        [view addGestureRecognizer:tap];
        _profitBackView = view;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_userHomeProfitImg")];
        [_profitBackView addSubview:imgView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = KLanguage(@"个人礼物榜");
        label.font = MediumFont(14);
        label.textColor = Color(@"#F24783");
        [_profitBackView addSubview:label];
        LCUserContributeView *userView = [[LCUserContributeView alloc]initWithFrame:CGRectZero];
        [_profitBackView addSubview:userView];
        _usersView = userView;
        UIImageView *accessImgView = [[UIImageView alloc]initWithImage:image(@"icon_userHomeProfitAccessImg")];
        [_profitBackView addSubview:accessImgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.width.height.equalTo(kUI_Width(32));
            make.centerY.equalTo(0);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(8));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(20));
            make.width.lessThanOrEqualTo(kUI_Width(100));
        }];
        [accessImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(20));
            make.right.equalTo(-kUI_Width(12));
            make.centerY.equalTo(0);
        }];
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(kUI_Width(80));
            make.right.mas_equalTo(accessImgView.mas_left).offset(-kUI_Width(20));
            make.height.equalTo(kUI_Width(32));
            make.centerY.equalTo(0);
        }];
        
        
    }
    return _profitBackView;
}
- (UILabel *)infoTipLabel{
    if (_infoTipLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoTipLabel = label;
        _infoTipLabel.font = BoldFont(16);
        _infoTipLabel.textColor = Color(@"#666666");
        _infoTipLabel.text = KLanguage(@"个人信息");
        [_infoTipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_infoTipLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:_infoTipLabel];

    }

    return _infoTipLabel;
}
- (UILabel *)userIdLabel{
    if (_userIdLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _userIdLabel = label;
        _userIdLabel.font = RegularFont(14);
        _userIdLabel.textColor = Color(@"#666666");
        _userIdLabel.text = KLanguage(@"会员ID ：");
        [_userIdLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_userIdLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:_userIdLabel];

    }

    return _userIdLabel;
}
- (UILabel *)areaLabel{
    if (_areaLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _areaLabel = label;
        _areaLabel.font = RegularFont(14);
        _areaLabel.textColor = Color(@"#666666");
        _areaLabel.text = KLanguage(@"家乡 ：");
        [_areaLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_areaLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:_areaLabel];

    }

    return _areaLabel;
}
//- (UILabel *)jobLabel{
//    if (_jobLabel == nil) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        _jobLabel = label;
//        _jobLabel.font = RegularFont(14);
//        _jobLabel.textColor = Color(@"#666666");
//        _jobLabel.text = KLanguage(@"职业 ：");
//        [_jobLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_jobLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [self.backView addSubview:_jobLabel];
//
//    }
//
//    return _jobLabel;
//}
- (UILabel *)ageLabel{
    if (_ageLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _ageLabel = label;
        _ageLabel.font = RegularFont(14);
        _ageLabel.textColor = Color(@"#666666");
        _ageLabel.text = KLanguage(@"生日 ：");
        [_ageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_ageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:_ageLabel];

    }

    return _ageLabel;
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
- (RACSubject *)contributeClickSubject{
    if(!_contributeClickSubject){
        _contributeClickSubject = [RACSubject subject];
    }
    return _contributeClickSubject;
}
//- (RACSubject *)jumpToLiveSubject{
//    if(!_jumpToLiveSubject){
//        _jumpToLiveSubject = [RACSubject subject];
//    }
//    return _jumpToLiveSubject;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
