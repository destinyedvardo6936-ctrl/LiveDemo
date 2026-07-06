//
//  LCSearchViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCSearchViewController.h"
#import "LCSearchRecommendView.h"
#import "LCSearchResultViewController.h"
@interface LCSearchViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *searchTextField;
@property (nonatomic , weak) LCSearchRecommendView *recommendView;
@property (nonatomic,weak)LCSearchResultViewController *resultCon;
@end

@implementation LCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    searchTextField.backgroundColor = Color(@"#F8F8F8");
    searchTextField.font = RegularFont(12);
    searchTextField.textColor = Color(@"#333333");
    searchTextField.layer.cornerRadius = kUI_Width(28)/2.0;
    NSAttributedString *att = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入搜索内容") attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#CCCCCC")}];
    searchTextField.attributedPlaceholder = att;
    searchTextField.returnKeyType = UIReturnKeySearch;
    UIView *customLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUI_Width(42), kUI_Width(28))];
    customLeftView.backgroundColor = [UIColor clearColor];
     UIImageView *imageView = [[UIImageView alloc] initWithImage:image(@"icon_searchImg")];
     imageView.frame = CGRectMake(kUI_Width(12), (kUI_Width(28) - kUI_Width(16)) / 2.0, kUI_Width(18), kUI_Width(18));
     [customLeftView addSubview:imageView];
    searchTextField.leftView = customLeftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.clearsOnBeginEditing = YES;
    searchTextField.delegate = self;
    [self.navView addSubview:searchTextField];
    _searchTextField = searchTextField;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:KLanguage(@"取消") forState:UIControlStateNormal];
    closeBtn.titleLabel.font = RegularFont(16);

    [closeBtn setTitleColor:Color(@"#FE604A") forState:(UIControlStateNormal)];
    WS(weakSelf)
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf popBack];
    }];
    [self.navView addSubview:closeBtn];
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(28));
        make.top.equalTo((kNavBarHeight - kStatusBarHeight - kUI_Width(28))/2.0+kStatusBarHeight);
        make.right.equalTo(-kUI_Width(56));
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.height.equalTo(kUI_Width(28));
        make.width.equalTo(kUI_Width(56));
        make.centerY.mas_equalTo(searchTextField.mas_centerY);
    }];
    
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(kUI_Width(10));
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
}
- (void)lc_bindViewModel{
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        if (weakSelf.searchTextField.text.length) {
            weakSelf.searchTextField.rightView.hidden = NO;
            weakSelf.recommendView.hidden = YES;
            
        }else{
             weakSelf.searchTextField.rightView.hidden = YES;
         
            weakSelf.recommendView.hidden = NO;
            
        }
    }];
}
#pragma mark----UITextFieldDelegate----
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length) {
        [self removeResultView];
       
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    

    if (textField.text.length) {
        
        
        [self addResultView];
    } else{
        [SVProgressHUD showMaskViewWithInfo:KLanguage(@"请输入搜索内容")];
    }

    return YES;
}
- (void)addResultView{
    if (_resultCon) {
        _resultCon.searchStr = self.searchTextField.text;
        
        [_resultCon reloadData];
        if (!_resultCon.view.superview) {
            [self.view addSubview:_resultCon.view];
            [_resultCon.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.navView.mas_bottom);
                make.left.right.bottom.equalTo(0);
            }];
        }
        if (![self.childViewControllers containsObject:_resultCon]) {
            [self addChildViewController:_resultCon];
        }
        
        [self.view bringSubviewToFront:self.navView];
        
        return;
    }
    LCSearchResultViewController *con = [[LCSearchResultViewController alloc]init];
    _resultCon = con;
    _resultCon.searchStr = self.searchTextField.text;
   
    [self addChildViewController:_resultCon];
    [self.view addSubview:_resultCon.view];
    [_resultCon.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.right.bottom.equalTo(0);
    }];
    [_resultCon didMoveToParentViewController:self];
}
- (void)removeResultView{
    if (_resultCon) {
        [_resultCon releaseController];
        [_resultCon willMoveToParentViewController:nil];
        [_resultCon.view removeFromSuperview];
        [_resultCon removeFromParentViewController];
        
        _resultCon = nil;
    }
}
#pragma mark---- 懒加载 ----
- (LCSearchRecommendView *)recommendView{
    if(_recommendView == nil){
        LCSearchRecommendView *view = [[LCSearchRecommendView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:view];
        _recommendView = view;
        
    }
    return _recommendView;
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
