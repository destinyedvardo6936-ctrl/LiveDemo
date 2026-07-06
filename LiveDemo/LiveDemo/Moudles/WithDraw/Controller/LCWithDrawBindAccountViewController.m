//
//  LCWithDrawBindAccountViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawBindAccountViewController.h"
#import "LCWithDrawBindAccountViewModel.h"
#import "LCWithDrawBindAccountTableCell.h"
@interface LCWithDrawBindAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCWithDrawBindAccountViewModel *viewModel;

@end

@implementation LCWithDrawBindAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
   
    [self.navView setCenterLabelText:self.dataModel.modelId.length?KLanguage(@"账户绑定"):KLanguage(@"账户绑定")];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];

    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];

    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(kNavBarHeight);
        make.bottom.equalTo(0);
    }];
    
}
- (void)lc_bindViewModel{
    @weakify(self)
    

    [[self.viewModel.addAccountSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainTableView.hidden = NO;
        
        [SVProgressHUD showNoMaskViewWithSuccess:!self.dataModel.modelId.length? KLanguage(@"添加成功"):KLanguage(@"修改成功")];
        [self popBack];
        
    }];
    
   
}

#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.dataModel.type intValue] == 1){
        return 2;
    }else if ([self.dataModel.type intValue] == 2){
        return 1;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return kUI_Width(12);
    }
    
    return kUI_Width(2);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if([self.dataModel.type intValue] == 1 && section == 1){
        return kUI_Width(42) * 2 + kUI_Width(40);
    }else if ([self.dataModel.type intValue] == 2 && section == 0){
        return kUI_Width(42) * 2 + kUI_Width(40);
    }else if ([self.dataModel.type intValue] == 3 && section == 2){
        return kUI_Width(42) * 2 + kUI_Width(40);
    }
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_Width(40);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(([self.dataModel.type intValue] == 1 && section == 1)||([self.dataModel.type intValue] == 2 && section == 0) ||([self.dataModel.type intValue] == 3 && section == 2)){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(42) * 2 + kUI_Width(40))];
        view.backgroundColor = tableView.backgroundColor;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_bindBankBtnBg") forState:UIControlStateNormal];
        [btn setTitle:self.dataModel.modelId.length?KLanguage(@"点击修改"):KLanguage(@"点击绑定")  forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(18);
        
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(205));
            make.height.equalTo(kUI_Width(40));
            make.centerX.equalTo(0);
            make.top.equalTo(kUI_Width(42));
        }];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if([weakSelf.viewModel.dataModel.type intValue] == 1)
            if(!weakSelf.viewModel.dataModel.account.length){
                [SVProgressHUD showNoMaskViewWithInfo:[weakSelf.viewModel.dataModel.type intValue] == 3? KLanguage(@"请填写银行卡号") :KLanguage(@"请填写账户") ];
                return;
            }
            if(!weakSelf.viewModel.dataModel.name.length && [weakSelf.viewModel.dataModel.type intValue] != 2){
                [SVProgressHUD showNoMaskViewWithInfo:[weakSelf.viewModel.dataModel.type intValue] == 3? KLanguage(@"请填写持卡人"):KLanguage(@"请填写姓名")];
                return;
            }
            if(!weakSelf.viewModel.dataModel.account_bank.length && [weakSelf.viewModel.dataModel.type intValue] == 3){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请填写银行名称")];
                return;
            }
            [weakSelf.viewModel.addAccountCommand execute:@(YES)];
        }];
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LCWithDrawBindAccountTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCWithDrawBindAccountTableCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([self.dataModel.type intValue] == 1 ){
        cell.leftTitle =  indexPath.section == 0 ? KLanguage(@"支付宝账户") :KLanguage(@"姓名") ;
        cell.rightHoldTitle = indexPath.section == 0 ?KLanguage(@"请输入支付宝账户"):KLanguage(@"请输入姓名");
        cell.rightTitle = self.viewModel.dataModel.account;
    }else if ([self.dataModel.type intValue]== 2){
        cell.leftTitle =  KLanguage(@"地址") ;
        cell.rightHoldTitle = KLanguage(@"请输入地址");
        cell.rightTitle = self.viewModel.dataModel.account;
        
    }else{
        switch (indexPath.section) {
            case 0:
            {
                cell.leftTitle = KLanguage(@"持卡人");
                cell.rightHoldTitle = KLanguage(@"请输入持卡人");
                cell.rightTitle = self.viewModel.dataModel.name;
            }
                
                break;
            case 1:
            {
                cell.leftTitle = KLanguage(@"银行卡号");
                cell.rightHoldTitle = KLanguage(@"请输入银行卡号");
                cell.rightTitle = self.viewModel.dataModel.account;
                
            }
                
                break;
            case 2:
            {
                cell.leftTitle = KLanguage(@"银行名称");
                cell.rightHoldTitle = KLanguage(@"请输入银行名称");
                cell.rightTitle = self.viewModel.dataModel.account_bank;
               
            }
                
                break;
            
           
            default:
                break;
        }
    }
    WS(weakSelf)
    cell.textChangeBlock = ^(NSString * _Nonnull leftTitle, NSString * _Nonnull text) {
        if([weakSelf.dataModel.type intValue] == 1){
            if([leftTitle isEqualToString:KLanguage(@"姓名")]){
                weakSelf.viewModel.dataModel.name = text;
            }else{
                weakSelf.viewModel.dataModel.account = text;
            }
        }else if ([weakSelf.dataModel.type intValue] == 2){
           
                weakSelf.viewModel.dataModel.account = text;
            
        }else{
            if([leftTitle isEqualToString:KLanguage(@"持卡人")]){
                weakSelf.viewModel.dataModel.name = text;
            }else if ([leftTitle isEqualToString:KLanguage(@"银行卡号")]){
                weakSelf.viewModel.dataModel.account = text;
            }else{
                weakSelf.viewModel.dataModel.account_bank = text;
            }
        }
    };
    return cell;
        
    
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//}
#pragma mark---- 懒加载 ----

- (LCBaseTableView *)mainTableView{
    if (_mainTableView == nil){
        LCBaseTableView *tableView = [LCBaseTableView addTableGrouped];
        _mainTableView = tableView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
//        _mainTableView.contentInset = UIEdgeInsetsMake(kUI_Width(6), kUI_Width(12), 0, kUI_Width(12));
        _mainTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_mainTableView];
        [_mainTableView registerClass:[LCWithDrawBindAccountTableCell class] forCellReuseIdentifier:@"LCWithDrawBindAccountTableCell"];
       
       
    }
    return _mainTableView;
}
- (LCWithDrawBindAccountViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCWithDrawBindAccountViewModel new];
        _viewModel.dataModel = self.dataModel;
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
