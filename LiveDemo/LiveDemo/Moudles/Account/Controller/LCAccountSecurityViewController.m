//
//  LCAccountSecurityViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/1.
//

#import "LCAccountSecurityViewController.h"
#import "LCBindPhoneViewController.h"
@interface LCAccountSecurityViewController ()
@property (nonatomic , weak) UIImageView *tipImgView;
@property (nonatomic , weak) UILabel *securityLabel;
@property (nonatomic , weak) UIView *tipView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *leftTitleLabel;
@property (nonatomic , weak) UILabel *mainTitleLabel;
@property (nonatomic , weak) UIImageView *rightImgView;

@end

@implementation LCAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    self.view.backgroundColor = Color(@"#FFFFFF");
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelText:KLanguage(@"账号与安全")];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.tipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kUI_Width(104));
        make.height.equalTo(kUI_WidthWithFloat(92.5));
        make.centerX.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(kUI_Width(48));
    }];
    [self.securityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipImgView.mas_bottom).offset(kUI_Width(32));
        make.height.equalTo(kUI_Width(14));
        make.left.right.equalTo(0);
    }];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.securityLabel.mas_bottom).offset(kUI_Width(32));
        make.left.right.equalTo(0);
        make.height.equalTo(kUI_Width(28));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(12));
        make.height.equalTo(kUI_Width(12));
        make.centerY.equalTo(0);
        make.right.equalTo(-kUI_Width(12));
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(kViewMargin));
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(40));
        make.top.mas_equalTo(self.tipView.mas_bottom).offset(kUI_Width(11));
       
    }];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kUI_Width(20));
        make.centerY.equalTo(0);
    
        make.left.equalTo(kUI_Width(kViewMargin));
    }];
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kUI_Width(20));
        make.right.mas_equalTo(self.rightImgView.mas_left).offset(-kUI_Width(4));
        make.left.mas_greaterThanOrEqualTo(self.leftTitleLabel.mas_right).offset(kUI_Width(10));
        make.centerY.equalTo(0);
    }];
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(kUI_Width(14));
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.centerY.equalTo(0);
    }];
    
}
- (void)lc_updatePageViews{
    if([LCUserInfoManager shareManager].userInfo.mobile.length){
        self.tipImgView.image = image(@"icon_accountSecurityHigh");
        self.securityLabel.text = KLanguage(@"安全等级：高");
        self.securityLabel.textColor = Color(@"#52C9FF");
        self.tipView.hidden = YES;
        self.mainTitleLabel.text = KLanguage(@"已绑定");
    }else{
        self.tipImgView.image = image(@"icon_accountSecurityLow");
        self.securityLabel.text = KLanguage(@"安全等级：低");
        self.securityLabel.textColor = Color(@"#F5586B");
        self.tipView.hidden = NO;
        self.mainTitleLabel.text = KLanguage(@"去绑定手机号");
    }
}

#pragma mark---- 懒加载 ----
- (UIImageView *)tipImgView{
    if(!_tipImgView){
        UIImageView *imgView= [[UIImageView alloc]initWithImage:image(@"icon_accountSecurityLow")];
        [self.view addSubview:imgView];
        _tipImgView = imgView;
    }
    return _tipImgView;
}
- (UILabel *)securityLabel{
    if(!_securityLabel){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = Color(@"#F5586B");
        label.text = KLanguage(@"安全等级：低");
        label.font = RegularFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        _securityLabel = label;
    }
    return _securityLabel;
}
- (UIView *)tipView{
    if(!_tipView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFF6FA");
        _tipView = view;
        
        [self.view addSubview:_tipView];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        tipLabel.font = RegularFont(12);
        tipLabel.textColor = Color(@"#FF5267");
        tipLabel.text = KLanguage(@"提示：通过以下设置提高安全等级");
        [_tipView addSubview:tipLabel];
        _tipLabel = tipLabel;
    }
    return _tipView;
}
- (UIView *)backView{
    if(_backView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(4);
        [self.view addSubview:view];
        _backView = view;
        view.layer.cornerRadius = kUI_Width(4);
        view.layer.shadowColor = Color(@"#F1EEEF").CGColor;
        view.layer.shadowOffset = CGSizeMake(0,kUI_Width(1));
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = kUI_Width(2);
    }
    return _backView;
}
- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        UILabel *lab = [UILabel new];
        lab.font = MediumFont(14);
        lab.textColor = Color(@"#333333");
        lab.text = KLanguage(@"手机绑定");
        [lab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [lab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _leftTitleLabel = lab;
        [self.backView addSubview:_leftTitleLabel];
        
    }
    return _leftTitleLabel;
}
- (UILabel *)mainTitleLabel {
    if (!_mainTitleLabel) {
        UILabel *lab = [UILabel new];
        lab.font = RegularFont(14);
        lab.textColor = Color(@"#999999");
        lab.text = KLanguage(@"去绑定手机号");
        _mainTitleLabel = lab;
        [lab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [lab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:_mainTitleLabel];
        _mainTitleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            
        }];
        [_mainTitleLabel addGestureRecognizer:tap];
    }
    return _mainTitleLabel;
}
- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_mineUserInfoAcess")];
       
        _rightImgView =  imgView;
        
        [self.backView addSubview:_rightImgView];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if([LCUserInfoManager shareManager].userInfo.mobile.length){
                [SVProgressHUD showMaskViewWithInfo:KLanguage(@"已绑定") ];
                return;
            }
            LCBindPhoneViewController *con = [LCBindPhoneViewController new];
            [weakSelf pushToViewController:con];
        }];
        [_mainTitleLabel addGestureRecognizer:tap];
    }
    return _rightImgView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
