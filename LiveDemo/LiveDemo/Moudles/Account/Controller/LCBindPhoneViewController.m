//
//  LCBindPhoneViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCBindPhoneViewController.h"
#import "LCAreaNumberViewController.h"
#import "LCAreaNumberModel.h"
#import "LCBindPhoneViewModel.h"
@interface LCBindPhoneViewController ()<UITextFieldDelegate>
{
    dispatch_source_t _timer;
}
@property (nonatomic , weak) UIView *locationBgView;
@property (nonatomic , weak) UILabel *locationLabel;

@property (nonatomic , weak) UIView *phoneBgView;
@property (nonatomic , weak) UILabel *phoneAreaLabel;
@property (nonatomic , weak) UITextField *phoneTextField;

@property (nonatomic , weak) UIView *codeBgView;
@property (nonatomic , weak) UITextField *codeTextField;
@property (nonatomic , weak) UIButton *codeBtn;

@property (nonatomic , weak) UIButton *doneBtn;

@property (nonatomic , strong) LCBindPhoneViewModel *viewModel;
@end

@implementation LCBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"手机绑定")];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.locationBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(kUI_Width(8));
        make.height.equalTo(kUI_Width(48));
        make.left.equalTo(kUI_Width(kViewMargin));
        make.right.equalTo(-kUI_Width(kViewMargin));
    }];
    [self.phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationBgView.mas_bottom);
        make.height.equalTo(kUI_Width(48));
        make.left.equalTo(kUI_Width(kViewMargin));
        make.right.equalTo(-kUI_Width(kViewMargin));
    }];
    [self.codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneBgView.mas_bottom);
        make.height.equalTo(kUI_Width(48));
        make.left.equalTo(kUI_Width(kViewMargin));
        make.right.equalTo(-kUI_Width(kViewMargin));
    }];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeBgView.mas_bottom).offset(kUI_Width(32));
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
        UIActivityIndicatorView *load = [self.doneBtn viewWithTag:201];
       
        [load stopAnimating];
        load.hidden = YES;
        self.doneBtn.selected = NO;
        UILabel *label = [self.doneBtn viewWithTag:200];
        label.hidden = NO;
        [SVProgressHUD dismiss];
        if ([x isKindOfClass:[NSError class]]) {
            NSError *error = x;
            [SVProgressHUD showMaskViewWithFailure:error.domain];
            
            return;
        }
        LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
        model.mobile = self.phoneTextField.text;
        [[LCUserInfoManager shareManager]updateUserInfo:model];
        [self popBack];
    }];
    [[self.phoneTextField.rac_textSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.viewModel.phone = x;
        if (x.length > 0) {
            self.codeBtn.enabled = YES;
        }else{
            
            [self cancelTimer];
            self.codeBtn.enabled = NO;
            
        }
    }];
    [[self.codeTextField.rac_textSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.viewModel.code = x;
        
    }];
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, phone),RACObserve(self.viewModel, code),RACObserve(self.viewModel, country_code)]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        
        self.doneBtn.enabled = (self.viewModel.phone.length > 0) && (self.viewModel.code.length >0) && (self.viewModel.country_code.length > 0) ;
        
    }];
    [[self.viewModel.codeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSError class]]) {
            NSError *error = x;
            [self cancelTimer];
            self.phoneTextField.enabled = YES;
            [SVProgressHUD showErrorWithStatus:error.domain];
            return;
        }
        
        [self.codeTextField becomeFirstResponder];
    }];
    
}
- (void)dealloc{
    [self cancelTimer];
}
- (void)startTimer{
    [self cancelTimer];
    self.codeBtn.enabled = NO;
    self.phoneTextField.enabled = NO;
    __block NSInteger count = 61;
    WS(weakSelf)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            count--;
            if (count == 0) {
                self.phoneTextField.enabled = YES;
                [weakSelf cancelTimer];
               
                [weakSelf.codeBtn setTitle:KLanguage(@"重新获取")  forState:UIControlStateNormal];
                [weakSelf.codeBtn sizeToFit];
                return;
            }
//            [weakSelf.checkCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSString *str = [NSString stringWithFormat:@"%lds%@", count,KLanguage(@"后重新获取") ];
            [weakSelf.codeBtn setTitle:str forState:UIControlStateNormal];
//            [weakSelf.checkCodeBtn setTitle:str forState:UIControlStateSelected];
            [weakSelf.codeBtn sizeToFit];

        });
    });
    dispatch_resume(_timer);
}
- (void)cancelTimer {
    self.codeBtn.enabled = YES;
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    [self.codeBtn setTitle:KLanguage(@"获取验证码")  forState:UIControlStateNormal];
    [self.codeBtn setTitle:KLanguage(@"获取验证码") forState:UIControlStateSelected];
    
//    [self.checkCodeBtn setTitleColor:[UIColor colorWithHexString:kColor_9C9C9C] forState:UIControlStateNormal];
}
#pragma mark---- 懒加载 ----
- (UIView *)locationBgView{
    if(_locationBgView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        _locationBgView = view;
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.font = RegularFont(15);
        leftLabel.textColor = Color(@"#333333 ");
        leftLabel.text = KLanguage(@"国家和地区");
        [_locationBgView addSubview:leftLabel];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBgView addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            LCAreaNumberViewController *con = [LCAreaNumberViewController new];
            [[con.selectSubject takeUntil:weakSelf.rac_willDeallocSignal] subscribeNext:^(LCAreaNumberModel *  _Nullable model) {
                weakSelf.locationLabel.text = model.name;
                weakSelf.phoneAreaLabel.text = [NSString stringWithFormat:@"+%@", model.tel];
                weakSelf.viewModel.country_code = model.tel;
            }];
            [weakSelf pushToViewController:con];
        }];
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        rightLabel.font = RegularFont(15);
        rightLabel.textColor = Color(@"#CCCCCC");
        rightLabel.text = KLanguage(@"中国");
      
        [btn addSubview:rightLabel];
        _locationLabel = rightLabel;
    
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = ColorAlpha(@"#D8D8D8", 0.52);
        [_locationBgView addSubview:lineView];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(30));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(15));
            make.width.mas_lessThanOrEqualTo(kUI_Width(120));
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(30));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(15));
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.bottom.equalTo(0);
            make.right.equalTo(0);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(30));
            make.right.equalTo(-kUI_Width(30));
            make.height.equalTo(kUI_Width(1));
            make.bottom.equalTo(0);
        }];
    }
    return _locationBgView;
}
- (UIView *)phoneBgView{
    if(_phoneBgView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        _phoneBgView = view;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectZero];
        leftView.backgroundColor = [UIColor clearColor];
        [_phoneBgView addSubview:leftView];
       
       
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.font = MediumFont(15);
        leftLabel.textColor = Color(@"#333333 ");
        leftLabel.text = @"+86";
        [leftView addSubview:leftLabel];
        [leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [leftLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _phoneAreaLabel = leftLabel;
        UIView *verLine = [[UIView alloc]initWithFrame:CGRectZero];
        verLine.backgroundColor = Color(@"#FC236E");
        [leftView addSubview:verLine];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(30));
            
        }];
        
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
        
        textField.textColor = Color(@"#333333");
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入手机号")  attributes:@{
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
        [self.view addSubview:view];
        _codeBgView = view;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectZero];
        leftView.backgroundColor = [UIColor clearColor];
        [_codeBgView addSubview:leftView];
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.font = MediumFont(15);
        leftLabel.textColor = Color(@"#333333 ");
        leftLabel.text = KLanguage(@"验证码");
        [leftView addSubview:leftLabel];
        [leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [leftLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
       
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(30));
            
        }];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(0);
            make.height.equalTo(kUI_Width(21));
            make.right.equalTo(0);
        }];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.delegate = self;
        textField.font = RegularFont(15);
        textField.backgroundColor = [UIColor clearColor];
        textField.clipsToBounds = YES;
        
        textField.textColor = Color(@"#333333");
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入验证码")  attributes:@{
            NSForegroundColorAttributeName:Color(@"#CCCCCC"),NSFontAttributeName:RegularFont(15)
        }];
        [_codeBgView addSubview:textField];
        _codeTextField = textField;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = Color(@"#FD7DB6");
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(12);
        [btn setTitle:KLanguage(@"获取验证码") forState:UIControlStateNormal];
        btn.layer.cornerRadius = kUI_Width(32)/2.0;
        [_codeBgView addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(!weakSelf.phoneTextField.text){
                [SVProgressHUD showMaskViewWithInfo:@""];
                return;
            }
            [weakSelf startTimer];
            [weakSelf.viewModel.codeCommand execute:@(YES)];
        }];
        _codeBtn = btn;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = ColorAlpha(@"#D8D8D8", 0.52);
        [_codeBgView addSubview:lineView];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).offset(kUI_Width(10));
         
            make.top.bottom.equalTo(0);
            make.right.mas_equalTo(_codeBtn.mas_left).offset(-kUI_Width(10));
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(30));
            make.centerY.equalTo(0);
            make.width.equalTo(kUI_Width(110));
            make.height.equalTo(kUI_Width(32));
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
- (UIButton *)doneBtn{
    if(!_doneBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_loginBtnBg") forState:UIControlStateNormal];
        [btn setBackgroundImage:image(@"icon_loginBtnBg") forState:UIControlStateSelected];
        [self.view addSubview:btn];
        _doneBtn = btn;
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.font = BoldFont(18);
        leftLabel.textColor = Color(@"#FFFFFF");
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = KLanguage(@"验证") ;
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
    return _doneBtn;
}
- (LCBindPhoneViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCBindPhoneViewModel new];
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
