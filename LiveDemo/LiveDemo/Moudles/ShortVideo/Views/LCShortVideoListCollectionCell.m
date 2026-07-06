//
//  LCShortVideoListCollectionCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/8.
//

#import "LCShortVideoListCollectionCell.h"
#import "LCBlackShelterView.h"
@interface LCShortVideoListCollectionCell ()
@property (nonatomic,weak)UIImageView *mainImgView;
@property (nonatomic , weak) UIImageView *vipImgView;
@property (nonatomic , weak) LCBlackShelterView *backView;
@property (nonatomic , weak) UILabel *titleLabel;

@property (nonatomic , weak) UIImageView *userImgView;
@property (nonatomic , weak) UILabel *userNameLabel;
@property (nonatomic , weak) UIImageView *onLiveView;
@property (nonatomic , weak) UILabel *numberLabel;
@end
@implementation LCShortVideoListCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
            
        }];
        [self.vipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(kUI_Width(5));
            make.height.equalTo(kUI_Width(14));
            make.width.equalTo(kUI_Width(28));
        }];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.left.equalTo(kUI_Width(8));
            
            make.top.equalTo(0);
            make.right.equalTo(-kUI_Width(8));
        }];
        [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(25));
            make.left.equalTo(kUI_Width(8));
            make.bottom.equalTo(-kUI_Width(8));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(10));
        }];
        
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userImgView.mas_right).offset(kUI_Width(5));
            make.height.equalTo(kUI_Width(14));
            make.centerY.mas_equalTo(self.userImgView.mas_centerY);
            make.right.mas_equalTo(self.onLiveView.mas_left).offset(-kUI_Width(5));
           
        }];
        [self.onLiveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(10));
            make.centerY.mas_equalTo(self.userImgView.mas_centerY);
            make.right.mas_equalTo(self.numberLabel.mas_left).offset(-kUI_Width(4));
            
        }];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(8));
            make.height.equalTo(kUI_Width(14));
            make.centerY.mas_equalTo(self.onLiveView.mas_centerY);
        }];
    }
    return self;
}
- (void)setDataModel:(LCShortVideoListModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, thumb) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.mainImgView setImageStr:x];
        

    }];
    [[RACObserve(_dataModel.userinfo,avatar ) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.userImgView setImageStr:x];
        

    }];
    [[RACObserve(_dataModel,isvip ) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.vipImgView.hidden = ![x boolValue];
        

    }];
    RAC(self.titleLabel,text) = [RACObserve(_dataModel, title) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.numberLabel,text) = [RACObserve(_dataModel, views) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.userNameLabel,text) = [RACObserve(_dataModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];

 
   

}

#pragma mark----懒加载----

- (UIImageView *)mainImgView{
    if (_mainImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _mainImgView = imgView;
        //        _mainImgView.backgroundColor =Color(kColor_000000);
        _mainImgView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImgView.layer.masksToBounds = YES;
        _mainImgView.layer.cornerRadius = kUI_Width(8);
        _mainImgView.clipsToBounds = YES;
        [self.contentView addSubview:_mainImgView];
    }
    return _mainImgView;
}
- (UIImageView *)vipImgView {
    if (_vipImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _vipImgView = imgView;
        _vipImgView.image = image(@"icon_videoListVip");
        _vipImgView.contentMode = UIViewContentModeScaleAspectFit;
    
//        _mainImgView.layer.masksToBounds = YES;
//        _mainImgView.clipsToBounds = YES;
        [self.mainImgView addSubview:_vipImgView];
    }

    return _vipImgView;
}
- (LCBlackShelterView *)backView{
    if (_backView == nil) {
        LCBlackShelterView *gradientView = [LCBlackShelterView new];
      
        gradientView.gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientView.gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientView.gradientLayer.locations = @[@(0), @(1.0f)];
        gradientView.gradientLayer.colors = @[(__bridge id)ColorAlpha(@"#000000", 0).CGColor, (__bridge id)ColorAlpha(@"#000000", 1).CGColor];
//        //设置gradientView布局和JXCategoryIndicatorBackgroundView一样
//        gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _backView = gradientView;
        [self.mainImgView addSubview:_backView];
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel = label;
        _titleLabel.font = MediumFont(16);
        
        _titleLabel.textColor = Color(@"#FFFFFF");
        _titleLabel.numberOfLines = 2;
        [self.backView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UIImageView *)userImgView{
    if (_userImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _userImgView = imgView;
        //        _mainImgView.backgroundColor =Color(kColor_000000);
        _userImgView.contentMode = UIViewContentModeScaleAspectFill;
        _userImgView.layer.masksToBounds = YES;
        _userImgView.layer.cornerRadius = kUI_Width(25)/2.0;
        _userImgView.clipsToBounds = YES;
        [self.backView addSubview:_userImgView];
    }
    return _userImgView;
}
- (UILabel *)userNameLabel{
    if (_userNameLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _userNameLabel = label;
        _userNameLabel.font = RegularFont(14);
        
        _userNameLabel.textColor = Color(@"#FFFFFF");
        
        [self.backView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (UIImageView *)onLiveView{
    if (_onLiveView == nil) {
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectZero];
        _onLiveView = view;
        _onLiveView.image = image(@"icon_shortVideoPlayImg");
        
        [self.backView addSubview:_onLiveView];
        
    }
    return _onLiveView;
}

- (UILabel *)numberLabel{
    if (_numberLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _numberLabel = label;
        _numberLabel.font = RegularFont(14);
        
        _numberLabel.textColor = Color(@"#FFFFFF");
        
    
        [self.backView addSubview:_numberLabel];
    }
    return _numberLabel;
}

@end
