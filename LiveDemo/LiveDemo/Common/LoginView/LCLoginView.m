//
//  LCLoginView.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import "LCLoginView.h"
#import "LCShelterGradientView.h"
#import "LCTouristLoginViewModel.h"
@interface LCLoginView ()
@property (nonatomic,weak)UIImageView *backgroundImgView;
@property (nonatomic,weak)UILabel *tipLabel;
@property (nonatomic,weak)UILabel *contentLabel;
@property (nonatomic , weak) LCShelterGradientView *touristBgView;
@property (nonatomic,weak)UIButton *touristButton;
@property (nonatomic,weak)UIButton *loginButton;
@property (nonatomic,weak)UIButton *loginByAccountButton;
@property (nonatomic , strong) LCTouristLoginViewModel *viewModel;
@end
@implementation LCLoginView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorAlpha(@"#000000", 0.44);
        [self.backgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.equalTo(kUI_Width(310));
            make.height.equalTo(kUI_Width(kUI_Width(299)));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(37));
            make.centerX.equalTo(0);
            make.height.equalTo(kUI_Width(25));
        }];
       
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(130));
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.bottom.mas_equalTo(self.touristButton.mas_top).offset(-kUI_Width(10));
        }];
        [self.touristBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(22));
            make.left.equalTo(kUI_WidthWithFloat(25.5));
            make.height.equalTo(kUI_WidthWithFloat(37.5));
            make.width.equalTo(kUI_Width(118));
        }];
        [self.touristButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_WidthWithFloat(1.5));
            make.left.equalTo(kUI_WidthWithFloat(1.5));
            make.height.equalTo(kUI_WidthWithFloat(37.5)-kUI_Width(3));
            make.width.equalTo(kUI_Width(118) - kUI_Width(3));
        }];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(22));
            make.right.equalTo(-kUI_WidthWithFloat(25.5));
            make.height.equalTo(kUI_WidthWithFloat(37.5));
            make.width.equalTo(kUI_Width(118));
        }];
        
        
        @weakify(self)
        
        [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self);
           
            [SVProgressHUD dismiss];
            if ([x isKindOfClass:[NSError class]]) {
                NSError *error = x;
                [SVProgressHUD showMaskViewWithFailure:error.domain];
                
                return;
            }
            [self removeFromSuperview];
        }];
    }
    return self;
}

#pragma mark----懒加载----
- (UIImageView *)backgroundImgView{
    if (_backgroundImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_loginViewBg")];
        _backgroundImgView = imgView;
        _backgroundImgView.userInteractionEnabled = YES;
        [self addSubview:_backgroundImgView];
    }
    return _backgroundImgView;
}

- (UILabel *)tipLabel{
    if (_tipLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipLabel = label;
        _tipLabel.text = KLanguage(@"请选择登陆方式") ;
        _tipLabel.font = BoldFont(18);
        _tipLabel.textColor = Color(@"#FFFFFF");
        [self.backgroundImgView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel = label;
//        _contentLabel.text = @"发现新版本";
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = RegularFont(14);
        _contentLabel.textColor = Color(@"#333333");
        [self.backgroundImgView addSubview:_contentLabel];
    }
    return _contentLabel;
}
- (LCShelterGradientView *)touristBgView{
    if(_touristBgView == nil){
        LCShelterGradientView *topView = [[LCShelterGradientView alloc]initWithFrame:CGRectZero];
              
          topView.gradientLayer.startPoint =CGPointMake(0.5, 0);
          topView.gradientLayer.endPoint = CGPointMake(0.5, 1);
          topView.gradientLayer.colors = @[(__bridge id)Color(@"#F29FC7").CGColor, (__bridge id)Color(@"#F04373").CGColor];
         topView.gradientLayer.locations = @[@(0), @(1.0f)];
        _touristBgView = topView;
        _touristBgView.layer.cornerRadius = kUI_WidthWithFloat(37.5) /2.0;
           [self.backgroundImgView addSubview:topView];
    }
    return _touristBgView;
}
- (UIButton *)touristButton{
    if (_touristButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _touristButton = btn;
        [_touristButton setTitle:KLanguage(@"游客登陆") forState:UIControlStateNormal];
        [_touristButton setTitleColor:Color(@"#F14F91") forState:UIControlStateNormal];
        _touristButton.titleLabel.font = MediumFont(14);
        _touristButton.backgroundColor = Color(@"#FFFFFF");
        _touristButton.layer.cornerRadius = (kUI_WidthWithFloat(37.5) - kUI_Width(3))/2.0;
        [self.touristBgView addSubview:_touristButton];
        WS(weakSelf)
        [[_touristButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [SVProgressHUD showWithMaskView];
            [weakSelf.viewModel.loadDataCommend execute:@(YES)];
        }];
    }
    return _touristButton;
}
- (UIButton *)loginButton{
    if (_loginButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton = btn;
        [_loginButton setBackgroundImage:image(@"icon_phoneLoginRegisterBg") forState:UIControlStateNormal];
        [_loginButton setTitle:KLanguage(@"登录/注册") forState:UIControlStateNormal];
        [_loginButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _loginButton.titleLabel.font = MediumFont(14);
        [self.backgroundImgView addSubview:_loginButton];
        WS(weakSelf)
        [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.loginClickBlock){
                weakSelf.loginClickBlock();
            }
            [weakSelf removeFromSuperview];
        }];
     
    }
    return _loginButton;
}

- (LCTouristLoginViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCTouristLoginViewModel new];
    }
    return _viewModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
