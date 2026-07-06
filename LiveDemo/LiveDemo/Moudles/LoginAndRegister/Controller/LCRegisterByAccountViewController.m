//
//  LCRegisterByAccountViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCRegisterByAccountViewController.h"
#import "LCShelterGradientView.h"
#import "LCAreaNumberViewController.h"
#import "LCAreaNumberModel.h"
#import "AppDelegate.h"
#import "LCTabBarViewController.h"
#import "LCRegisterByAccountViewModel.h"
@interface LCRegisterByAccountViewController ()
@property (nonatomic , weak) UIImageView *contentView;

@property (nonatomic , weak) UIView *loginBgView;
@property (nonatomic , weak) UILabel *titleLabel;

//@property (nonatomic , weak) UIView *locationBgView;
//@property (nonatomic , weak) UILabel *locationLabel;

@property (nonatomic , weak) UIView *phoneBgView;
@property (nonatomic , weak) UILabel *phoneAreaLabel;
@property (nonatomic , weak) UITextField *phoneTextField;

@property (nonatomic , weak) UIView *codeBgView;
@property (nonatomic , weak) UITextField *codeTextField;

@property (nonatomic , weak) UIView *againPswBgView;
@property (nonatomic , weak) UITextField *againPswTextField;

@property (nonatomic , weak) UIButton *loginBtn;


@property (nonatomic , strong) LCRegisterByAccountViewModel *viewModel;
@end

@implementation LCRegisterByAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)lc_addSubviews{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(kUI_Width(300));
    }];
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_Image];
    [self.navView setCustomLeftImageStr:@"icon_loginBack"];
    [self.navView setBottomBackgroundColor:[UIColor clearColor]];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.loginBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(20));
        make.right.equalTo(-kUI_Width(20));
        make.centerY.equalTo(0);
        make.height.equalTo(kUI_Width(308)+kUI_Width(48));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(kUI_Width(21));
        make.height.equalTo(kUI_Width(24));
    }];
//    [self.locationBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(0);
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(21));
//        make.height.equalTo(kUI_Width(48));
//    }];
    [self.phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(21));
        make.height.equalTo(kUI_Width(48));
    }];
    [self.codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.mas_equalTo(self.phoneBgView.mas_bottom);
        make.height.equalTo(kUI_Width(48));
    }];
    [self.againPswBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.mas_equalTo(self.codeBgView.mas_bottom);
        make.height.equalTo(kUI_Width(48));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-kUI_Width(21));
        make.centerX.equalTo(0);
        make.width.equalTo(kUI_Width(227));
        make.height.equalTo(kUI_Width(42));
    }];
    
    
}
- (void)lc_bindViewModel{
    @weakify(self)
    
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        UIActivityIndicatorView *load = [self.loginBtn viewWithTag:201];
       
        [load stopAnimating];
        load.hidden = YES;
        self.loginBtn.selected = NO;
        UILabel *label = [self.loginBtn viewWithTag:200];
        label.hidden = NO;
        [SVProgressHUD dismiss];
        if ([x isKindOfClass:[NSError class]]) {
            NSError *error = x;
            [SVProgressHUD showMaskViewWithFailure:error.domain];
            
            return;
        }

        [self popBack];
    }];
    [[self.phoneTextField.rac_textSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.viewModel.account = x;
        
    }];
    [[self.codeTextField.rac_textSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.viewModel.passward = x;
        
    }];
    [[self.againPswTextField.rac_textSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.viewModel.againpassword = x;
        
    }];
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, account),RACObserve(self.viewModel, passward),RACObserve(self.viewModel, againpassword),RACObserve(self.viewModel, country_code)]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        
            self.loginBtn.enabled = (self.viewModel.account.length > 0) && (self.viewModel.passward.length >0) && (self.viewModel.country_code.length > 0)&& (self.viewModel.againpassword.length >0);
        
    }];
    
    
}

#pragma mark---- 懒加载 ----
- (UIImageView *)contentView{
    if (_contentView == nil) {
        UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectZero];
        topView.image = image(@"icon_loginBg");
        topView.contentMode = UIViewContentModeScaleAspectFill;
        _contentView = topView;
        [self.view addSubview:topView];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        CGFloat duration = 6.0f;
        animation.duration = duration;
        animation.values = @[@0,@-7.5,@-15,@-22.5,@-30,@-37.5,@-45,@-52.5,@-60,@-67.5,@-75,@-82.5,@-90,@-97.5,@-105,@-112.5,@-120,@-127.5,@-134,@-142.5,@-150,@-157.5,@-165,@-172.5,@-180,@-187.5,@-195,@-202.5,@-210,@-210,@-202.5,@-195,@-187.5,@-180,@-172.5,@-165,@-157.5,@-150,@-142.5,@-134,@-127.5,@-120,@-112.5,@-105,@-97.5,@-90,@-82.5,@-75,@-67.5,@-60,@-52.5,@-45,@-37.5,@-30,@-22.5,@-15,@-7.5,@0];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.repeatCount = HUGE_VALF;
        animation.removedOnCompletion = NO;
        [topView.layer addAnimation:animation forKey:@"anim"];
    }
    return _contentView;
}
- (UIView *)loginBgView{
    if(!_loginBgView){
        UIView *imgView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:imgView];
        imgView.backgroundColor = ColorAlpha(@"#000000", 0.53);
        imgView.layer.cornerRadius = kUI_Width(12);
        _loginBgView = imgView;
    }
    return _loginBgView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel = label;
        _titleLabel.font = BoldFont(24);
        _titleLabel.textColor = Color(@"#FFFFFF");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = KLanguage(@"注册");
        [self.loginBgView addSubview:_titleLabel];
        
    }
    return _titleLabel;
}
//- (UIView *)locationBgView{
//    if(_locationBgView == nil){
//        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
//        view.backgroundColor = [UIColor clearColor];
//        [self.loginBgView addSubview:view];
//        _locationBgView = view;
//        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        leftLabel.font = RegularFont(15);
//        leftLabel.textColor = Color(@"#CCCCCC");
//        leftLabel.text = KLanguage(@"国家和地区");
//        [_locationBgView addSubview:leftLabel];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_locationBgView addSubview:btn];
//        WS(weakSelf)
//        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            LCAreaNumberViewController *con = [LCAreaNumberViewController new];
//            [[con.selectSubject takeUntil:weakSelf.rac_willDeallocSignal] subscribeNext:^(LCAreaNumberModel *  _Nullable model) {
//                weakSelf.locationLabel.text = model.name;
//                weakSelf.phoneAreaLabel.text = [NSString stringWithFormat:@"+%@", model.tel];
//                weakSelf.viewModel.country_code = model.tel;
//            }];
//            [weakSelf pushToViewController:con];
//        }];
//        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        rightLabel.font = RegularFont(15);
//        rightLabel.textColor = Color(@"#CCCCCC");
//        rightLabel.text = KLanguage(@"中国");
//
//        [btn addSubview:rightLabel];
//        _locationLabel = rightLabel;
//        UIImageView *accessImgView = [[UIImageView alloc]initWithImage:image(@"icon_loginAccess")];
//        [btn addSubview:accessImgView];
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
//        lineView.backgroundColor = ColorAlpha(@"#D8D8D8", 0.52);
//        [_locationBgView addSubview:lineView];
//
//        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(30));
//            make.centerY.equalTo(0);
//            make.height.equalTo(kUI_Width(15));
//            make.width.mas_lessThanOrEqualTo(kUI_Width(120));
//        }];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(-kUI_Width(30));
//            make.centerY.equalTo(0);
//            make.height.equalTo(kUI_Width(15));
//        }];
//        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(0);
//            make.top.bottom.equalTo(0);
//            make.right.mas_equalTo(accessImgView.mas_left).offset(-kUI_Width(4));
//        }];
//        [accessImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(0);
//            make.width.height.equalTo(kUI_Width(14));
//            make.right.equalTo(0);
//        }];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(30));
//            make.right.equalTo(-kUI_Width(30));
//            make.height.equalTo(kUI_Width(1));
//            make.bottom.equalTo(0);
//        }];
//    }
//    return _locationBgView;
//}
- (UIView *)phoneBgView{
    if(_phoneBgView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.loginBgView addSubview:view];
        _phoneBgView = view;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectZero];
        leftView.backgroundColor = [UIColor clearColor];
        [_phoneBgView addSubview:leftView];
//        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_loginPhoneImg")];
//        [leftView addSubview:imgView];
//
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.font = MediumFont(15);
        leftLabel.textColor = Color(@"#FFFFFF");
        leftLabel.text = KLanguage(@"账户名称");
        [leftView addSubview:leftLabel];
        [leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [leftLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        _phoneAreaLabel = leftLabel;
        UIView *verLine = [[UIView alloc]initWithFrame:CGRectZero];
        verLine.backgroundColor = Color(@"#D8D8D8");
        [leftView addSubview:verLine];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(30));
//            make.width.equalTo(kUI_Width(12) + kUI_Width(20));
        }];
//        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(0);
//            make.left.equalTo(0);
//            make.width.height.equalTo(kUI_Width(21));
//        }];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.height.equalTo(kUI_Width(15));
            make.centerY.equalTo(0);
            make.right.mas_equalTo(verLine.mas_left).offset(-kUI_Width(4));
        }];
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.width.equalTo(kUI_Width(1));
            make.height.equalTo(kUI_Width(30));
            make.centerY.equalTo(0);
        }];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.delegate = self;
        textField.font = RegularFont(15);
        textField.backgroundColor = [UIColor clearColor];
        textField.clipsToBounds = YES;
        
        textField.textColor = Color(@"#FFFFFF");
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入账户名称")  attributes:@{
            NSForegroundColorAttributeName:Color(@"#CCCCCC"),NSFontAttributeName:RegularFont(15)
        }];
        [_phoneBgView addSubview:textField];
        _phoneTextField = textField;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = ColorAlpha(@"#D8D8D8", 0.52);
        [_phoneBgView addSubview:lineView];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).offset(kUI_Width(10));
         
            make.top.bottom.equalTo(0);
            make.right.equalTo(-kUI_Width(30));
        }];
       
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(30));
            make.right.equalTo(-kUI_Width(30));
            make.height.equalTo(kUI_Width(1));
            make.bottom.equalTo(0);
        }];
    }
    return _phoneBgView;
}
- (UIView *)codeBgView{
    if(_codeBgView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.loginBgView addSubview:view];
        _codeBgView = view;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectZero];
        leftView.backgroundColor = [UIColor clearColor];
        [_codeBgView addSubview:leftView];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_loginCodeImg")];
        [leftView addSubview:imgView];
       
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(30));
            
        }];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(0);
            make.width.height.equalTo(kUI_Width(21));
            make.right.equalTo(0);
        }];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.delegate = self;
        textField.font = RegularFont(15);
        textField.backgroundColor = [UIColor clearColor];
        textField.clipsToBounds = YES;
        
        textField.textColor = Color(@"#FFFFFF");
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.secureTextEntry = YES;
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入密码")  attributes:@{
            NSForegroundColorAttributeName:Color(@"#CCCCCC"),NSFontAttributeName:RegularFont(15)
        }];
        [_codeBgView addSubview:textField];
        _codeTextField = textField;
        
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = ColorAlpha(@"#D8D8D8", 0.52);
        [_codeBgView addSubview:lineView];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).offset(kUI_Width(10));
         
            make.top.bottom.equalTo(0);
            make.right.equalTo(-kUI_Width(30));
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(30));
            make.right.equalTo(-kUI_Width(30));
            make.height.equalTo(kUI_Width(1));
            make.bottom.equalTo(0);
        }];
    }
    return _codeBgView;
}
- (UIView *)againPswBgView{
    if(_againPswBgView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.loginBgView addSubview:view];
        _againPswBgView = view;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectZero];
        leftView.backgroundColor = [UIColor clearColor];
        [_againPswBgView addSubview:leftView];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_loginCodeImg")];
        [leftView addSubview:imgView];
       
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(30));
            
        }];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(0);
            make.width.height.equalTo(kUI_Width(21));
            make.right.equalTo(0);
        }];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.delegate = self;
        textField.font = RegularFont(15);
        textField.backgroundColor = [UIColor clearColor];
        textField.clipsToBounds = YES;
        
        textField.textColor = Color(@"#FFFFFF");
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.secureTextEntry = YES;
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请再次输入密码")  attributes:@{
            NSForegroundColorAttributeName:Color(@"#CCCCCC"),NSFontAttributeName:RegularFont(15)
        }];
        [_againPswBgView addSubview:textField];
        _againPswTextField = textField;
        
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = ColorAlpha(@"#D8D8D8", 0.52);
        [_againPswBgView addSubview:lineView];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).offset(kUI_Width(10));
         
            make.top.bottom.equalTo(0);
            make.right.equalTo(-kUI_Width(30));
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(30));
            make.right.equalTo(-kUI_Width(30));
            make.height.equalTo(kUI_Width(1));
            make.bottom.equalTo(0);
        }];
    }
    return _againPswBgView;
}
- (UIButton *)loginBtn{
    if(!_loginBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_loginBtnBg") forState:UIControlStateNormal];
        [btn setBackgroundImage:image(@"icon_loginBtnBg") forState:UIControlStateSelected];
        [self.loginBgView addSubview:btn];
        _loginBtn = btn;
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.font = BoldFont(18);
        leftLabel.textColor = Color(@"#FFFFFF");
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text =KLanguage(@"注册") ;
        leftLabel.tag = 200;
        [btn addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        loadView.color = Color(@"#FFFFFF");
        [btn addSubview:loadView];
        loadView.hidden = YES;
        loadView.tag = 201;
        [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(0);
            make.width.height.equalTo(kUI_Width(18));
        }];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(!x.selected){
                x.selected = YES;
                UILabel *label = [x viewWithTag:200];
                label.hidden = YES;
                UIActivityIndicatorView *load = [x viewWithTag:201];
                load.hidden = NO;
                [load startAnimating];
                [weakSelf.viewModel.loadDataCommend execute:@(YES)];
            }
        }];
    }
    return _loginBtn;
}

- (LCRegisterByAccountViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCRegisterByAccountViewModel new];
    }
    return _viewModel;
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
