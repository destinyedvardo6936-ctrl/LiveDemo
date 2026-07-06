//
//  LCHomeRecommendArchorSubCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/21.
//

#import "LCHomeRecommendArchorSubCell.h"
#import "LCBlackShelterView.h"

static CGFloat LCHomeCompactInfoHeight(void) {
    return kUI_Width(42);
}

@interface LCHomeRecommendArchorSubCell ()
@property (nonatomic,weak)UIImageView *mainImgView;
@property (nonatomic , weak) LCBlackShelterView *backView;
@property (nonatomic , weak) UILabel *userNameLabel;
@property (nonatomic , weak) UILabel *locationLabel;
@property (nonatomic , weak) UIImageView *onLiveView;
@property (nonatomic , weak) UILabel *numberLabel;
@end

@implementation LCHomeRecommendArchorSubCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];

        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            make.height.equalTo(LCHomeCompactInfoHeight());
        }];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(2));
            make.bottom.equalTo(-kUI_Width(4));
        }];
        [self.onLiveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(4));
            make.centerY.mas_equalTo(self.numberLabel.mas_centerY);
            make.right.mas_equalTo(self.numberLabel.mas_left).offset(-kUI_Width(4));
        }];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(2));
            make.bottom.equalTo(-kUI_Width(4));
            make.right.mas_lessThanOrEqualTo(self.onLiveView.mas_left).offset(-kUI_Width(4));
        }];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(2));
            make.right.equalTo(-kUI_Width(2));
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

    RAC(self.userNameLabel,text) = [RACObserve(_dataModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.locationLabel,text) = [RACObserve(_dataModel, city) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.numberLabel,text) = [RACObserve(_dataModel, nums) takeUntil:self.rac_prepareForReuseSignal];
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
        _userNameLabel.font = MediumFont(9);
        _userNameLabel.textColor = Color(@"#FFFFFF");
        [self.backView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (UILabel *)locationLabel{
    if (_locationLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _locationLabel = label;
        _locationLabel.font = RegularFont(9);
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
        _numberLabel.font = MediumFont(7);
        _numberLabel.textColor = Color(@"#FFFFFF");
        [self.backView addSubview:_numberLabel];
    }
    return _numberLabel;
}

@end
