//
//  LCLiveListCollectionViewCell.m
//  liveCommon
//
//  Created by mrgao on 2022/9/30.
//

#import "LCLiveListCollectionViewCell.h"
#import "LCBlackShelterView.h"

@interface LCLiveListCollectionViewCell ()

@property (nonatomic,weak)UIImageView *mainImgView;
@property (nonatomic , weak) UIImageView *gameBackImgView;
@property (nonatomic , weak) UILabel *gameLabel;
@property (nonatomic , weak) UIView *chargeTypeBackView;
@property (nonatomic , weak) UILabel *chargeTypeLabel;
@property (nonatomic , weak) UIView *priceBackView;
@property (nonatomic , weak) UILabel *priceLabel;
@property (nonatomic , weak) LCBlackShelterView *backView;
@property (nonatomic , weak) UILabel *userNameLabel;
@property (nonatomic , weak) UILabel *locationLabel;
@property (nonatomic , weak) UIImageView *onLiveView;
@property (nonatomic , weak) UILabel *numberLabel;

@end

@implementation LCLiveListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [self.gameBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(kUI_Width(10));
            make.height.equalTo(kUI_Width(20));
            make.width.equalTo(kUI_Width(104));
        }];
        [self.gameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(24));
            make.right.equalTo(-kUI_Width(8));
            make.top.bottom.equalTo(0);
        }];
        [self.chargeTypeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.gameBackImgView.mas_bottom);
            make.left.equalTo(kUI_Width(10));
            make.height.equalTo(kUI_Width(18));
        }];
        [self.chargeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(6));
            make.right.equalTo(-kUI_Width(6));
            make.top.bottom.equalTo(0);
        }];
        [self.priceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chargeTypeBackView.mas_bottom);
            make.left.equalTo(kUI_Width(10));
            make.height.equalTo(kUI_Width(16));
        }];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(6));
            make.right.equalTo(-kUI_Width(6));
            make.top.bottom.equalTo(0);
        }];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            make.height.equalTo(kUI_Width(49));
        }];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(8));
            make.bottom.equalTo(-kUI_Width(6));
        }];
        [self.onLiveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(5));
            make.centerY.mas_equalTo(self.numberLabel.mas_centerY);
            make.right.mas_equalTo(self.numberLabel.mas_left).offset(-kUI_Width(4));
        }];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(6));
            make.bottom.equalTo(-kUI_Width(6));
            make.right.mas_lessThanOrEqualTo(self.onLiveView.mas_left).offset(-kUI_Width(6));
        }];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(6));
            make.right.equalTo(-kUI_Width(6));
            make.bottom.mas_equalTo(self.locationLabel.mas_top).offset(-kUI_Width(2));
        }];
    }
    return self;
}

- (void)setDataModel:(LCHomeListModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, thumb) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.mainImgView setImageStr:x];
    }];
    [[RACObserve(_dataModel, caipiao) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(LCGameListModel * _Nullable x) {
        @strongify(self);
        self.gameBackImgView.hidden = !x.name.length;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }];

    RAC(self.gameLabel,text) = [RACObserve(_dataModel.caipiao, name) takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, type) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);

        switch (x.intValue) {
            case 0:
            {
                self.chargeTypeBackView.hidden = YES;
                self.priceBackView.hidden = YES;
            }
                break;
            case 1:
            {
                self.chargeTypeBackView.hidden = YES;
                self.priceBackView.hidden = YES;
            }
                break;
            case 2:
            {
                self.chargeTypeBackView.hidden = NO;
                self.priceBackView.hidden = NO;
                self.chargeTypeLabel.text = KLanguage(@"按时收费");
            }
                break;
            case 3:
            {
                self.chargeTypeBackView.hidden = NO;
                self.priceBackView.hidden = NO;
                self.chargeTypeLabel.text = KLanguage(@"按时收费");
            }
                break;
            default:
                break;
        }
    }];
    RAC(self.userNameLabel,text) = [RACObserve(_dataModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.locationLabel,text) = [RACObserve(_dataModel, city) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.numberLabel,text) = [RACObserve(_dataModel, nums) takeUntil:self.rac_prepareForReuseSignal];

    RAC(self.priceLabel,text) = [[RACObserve(_dataModel, type_val) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(value.length){
            return [NSString stringWithFormat:@"%@%@/%@",value,[LCConfigManager shareManager].configModel.name_coin, KLanguage(@"分钟")];
        }
        return nil;
    }] takeUntil:self.rac_prepareForReuseSignal];
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.chargeTypeBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(self.gameBackImgView.hidden){
            make.top.mas_equalTo(self.gameBackImgView.mas_top);
        }else{
            make.top.mas_equalTo(self.gameBackImgView.mas_bottom);
        }

        make.left.equalTo(kUI_Width(10));
        make.height.equalTo(kUI_Width(18));
    }];
    [self.priceBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(self.chargeTypeBackView.hidden){
            make.top.mas_equalTo(self.chargeTypeBackView.mas_top);
        }else{
            make.top.mas_equalTo(self.chargeTypeBackView.mas_bottom);
        }
        make.left.equalTo(kUI_Width(10));
        make.height.equalTo(kUI_Width(16));
    }];
}

#pragma mark----懒加载----

- (UIImageView *)mainImgView{
    if (_mainImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mainImgView = imgView;
        _mainImgView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImgView.layer.masksToBounds = YES;
        _mainImgView.layer.cornerRadius = kUI_Width(5);
        _mainImgView.clipsToBounds = YES;
        [self.contentView addSubview:_mainImgView];
    }
    return _mainImgView;
}

- (UIImageView *)gameBackImgView{
    if (_gameBackImgView == nil) {
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectZero];
        _gameBackImgView = view;
        _gameBackImgView.image = image(@"icon_homeGameTypebg");
        _gameBackImgView.hidden = YES;
        [self.mainImgView addSubview:_gameBackImgView];
    }
    return _gameBackImgView;
}

- (UILabel *)gameLabel{
    if (_gameLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _gameLabel = label;
        _gameLabel.font = MediumFont(12);
        _gameLabel.textColor = Color(@"#FFFFFF");
        [self.gameBackImgView addSubview:_gameLabel];
    }
    return _gameLabel;
}

- (UIView *)chargeTypeBackView{
    if (_chargeTypeBackView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _chargeTypeBackView = view;
        _chargeTypeBackView.backgroundColor = ColorAlpha(@"#000000", 0.5);
        _chargeTypeBackView.layer.cornerRadius = kUI_Width(5);
        _chargeTypeBackView.clipsToBounds = YES;
        [self.mainImgView addSubview:_chargeTypeBackView];
    }
    return _chargeTypeBackView;
}

- (UILabel *)chargeTypeLabel{
    if (_chargeTypeLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _chargeTypeLabel = label;
        _chargeTypeLabel.font = RegularFont(11);
        _chargeTypeLabel.textColor = Color(@"#FFFFFF");
        [self.chargeTypeBackView addSubview:_chargeTypeLabel];
    }
    return _chargeTypeLabel;
}

- (UIView *)priceBackView{
    if (_priceBackView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _priceBackView = view;
        _priceBackView.backgroundColor = ColorAlpha(@"#000000", 0.5);
        _priceBackView.layer.cornerRadius = kUI_Width(5);
        _priceBackView.clipsToBounds = YES;
        [self.mainImgView addSubview:_priceBackView];
    }
    return _priceBackView;
}

- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _priceLabel = label;
        _priceLabel.font = RegularFont(11);
        _priceLabel.textColor = Color(@"#FFFFFF");
        [self.priceBackView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (LCBlackShelterView *)backView{
    if (_backView == nil) {
        LCBlackShelterView *gradientView = [LCBlackShelterView new];
        gradientView.gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientView.gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientView.gradientLayer.locations = @[@(0), @(1.0f)];
        gradientView.gradientLayer.colors = @[(__bridge id)ColorAlpha(@"#000000", 0).CGColor, (__bridge id)ColorAlpha(@"#000000", 1).CGColor];
        _backView = gradientView;
        [self.mainImgView addSubview:_backView];
    }
    return _backView;
}

- (UILabel *)userNameLabel{
    if (_userNameLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _userNameLabel = label;
        _userNameLabel.font = MediumFont(10);
        _userNameLabel.textColor = Color(@"#FFFFFF");
        [self.backView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (UILabel *)locationLabel{
    if (_locationLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _locationLabel = label;
        _locationLabel.font = RegularFont(10);
        _locationLabel.textColor = Color(@"#FFFFFF");
        [self.backView addSubview:_locationLabel];
    }
    return _locationLabel;
}

- (UIImageView *)onLiveView{
    if (_onLiveView == nil) {
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectZero];
        _onLiveView = view;
        _onLiveView.image = image(@"icon_homeOnlive");
        [self.backView addSubview:_onLiveView];
    }
    return _onLiveView;
}

- (UILabel *)numberLabel{
    if (_numberLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _numberLabel = label;
        _numberLabel.font = MediumFont(10);
        _numberLabel.textColor = Color(@"#FFFFFF");
        [self.backView addSubview:_numberLabel];
    }
    return _numberLabel;
}

@end
