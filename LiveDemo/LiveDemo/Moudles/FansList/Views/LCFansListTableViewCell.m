//
//  LCFansListTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCFansListTableViewCell.h"

@interface LCFansListTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *userImgView;

@property (nonatomic , weak) UILabel *userNameLabel;
@property (nonatomic , weak) UIImageView *levelBackImgView;
@property (nonatomic , weak) UIImageView *levelImgView;
@property (nonatomic , weak) UILabel *levelLabel;

@property (nonatomic , weak) UIImageView *sexImgView;

@property (nonatomic , weak) UIButton *followBtn;
@end
@implementation LCFansListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(70));
        }];
        [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
            make.width.equalTo(kUI_Width(55));
            make.height.equalTo(kUI_Width(55));
        }];
        
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userImgView.mas_right).offset(kUI_Width(8));
            make.top.mas_equalTo(self.userImgView.mas_top).offset(kUI_Width(6));
            make.right.mas_lessThanOrEqualTo(self.followBtn.mas_left).offset(-kUI_Width(12));
            make.height.equalTo(kUI_Width(18));
        }];
        [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(14));
            make.left.mas_equalTo(self.userImgView.mas_right).offset(kUI_Width(8));
            make.bottom.mas_equalTo(self.userImgView.mas_bottom).offset(-kUI_Width(8));
        }];
        
        [self.levelBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(34));
            make.height.equalTo(kUI_Width(16));
            make.left.mas_equalTo(self.sexImgView.mas_right).offset(kUI_Width(6));
            make.centerY.mas_equalTo(self.sexImgView.mas_centerY);
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
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.equalTo(kUI_Width(61));
            make.height.equalTo(kUI_Width(28));
            make.right.equalTo(-kUI_Width(12));
        }];
    }
    return self;
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
    [[RACObserve(_dataModel, sex) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if([x isEqualToString:@"1"]){
            self.sexImgView.image = image(@"icon_sexFamale");
        }else{
            self.sexImgView.image = image(@"icon_sexWomen");
        }
    }];
   

}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UIImageView *)userImgView{
    if (_userImgView == nil){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.backView addSubview:imgView];
        _userImgView = imgView;
        _userImgView.contentMode = UIViewContentModeScaleAspectFill;
        _userImgView.userInteractionEnabled = YES;
        _userImgView.clipsToBounds = YES;
        _userImgView.layer.masksToBounds = YES;
        _userImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        
    }
    return _userImgView;
}


- (UILabel *)userNameLabel{
    if (!_userNameLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(16);
        label.textColor = Color(@"#333333");
//        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _userNameLabel = label;
    }
    return _userNameLabel;
}
- (UIImageView *)sexImgView{
    if (!_sexImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_sexFamale");
        _sexImgView = imgView;
        [self.backView addSubview:_sexImgView];
    }
    return _sexImgView;
}
- (UIImageView *)levelBackImgView{
    if (!_levelBackImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_rankLevelBackImg");
        _levelBackImgView = imgView;
        [self.backView addSubview:_levelBackImgView];
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
- (UIButton *)followBtn{
    if (!_followBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_rankNormalFollow") forState:UIControlStateNormal];
        
        [btn setTitle:KLanguage(@"查看主页") forState:UIControlStateNormal];
       
        btn.titleLabel.font = MediumFont(12);
        [self.backView addSubview:btn];
        _followBtn = btn;
        WS(weakSelf)
        [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:weakSelf.dataModel];
        }];
    }
    return _followBtn;
}
- (RACSubject *)clickSubject{
    if(!_clickSubject){
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
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
