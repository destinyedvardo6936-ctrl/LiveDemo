//
//  LCWithDrawViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawViewController.h"
#import "LCWithDrawViewModel.h"
#import "LCWithDrawHeaderTableViewCell.h"
#import "LCWithDrawTextFieldTableViewCell.h"
#import "LCWithDrawAccountTableViewCell.h"
#import "LCWithDrawBindAccountViewController.h"
@interface LCWithDrawViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) UIImageView *contentView;
@property (nonatomic , weak) UIButton *withdrawBtn;
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCWithDrawViewModel *viewModel;
@end

@implementation LCWithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)lc_addSubviews{
    [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(0);
        
    }];
    [self.navView setCenterLabelText:KLanguage(@"现金提现") ];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setBottomBackgroundColor:[UIColor clearColor]];
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_Image];
    [self.navView setCustomLeftImageStr:@"icon_withDrawBack"];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(kNavBarHeight);
        make.bottom.mas_equalTo(self.withdrawBtn.mas_top);
    }];
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kUI_Width(205));
        make.height.equalTo(kUI_Width(40));
        make.bottom.equalTo(-KSafeHeight);
        make.centerX.equalTo(0);
    }];
    
}
- (void)lc_bindViewModel{
    @weakify(self)
  
    [[self.viewModel.coinCountSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
       
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainTableView.hidden = NO;
        
      
       
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        } ];
        
        
    }];
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
       
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainTableView.hidden = NO;
        
      
       
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        } ];
        
        
    }];
    [[self.viewModel.withdrawSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
       
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        [SVProgressHUD showNoMaskViewWithSuccess:KLanguage(@"提现申请已提交") ];
        [self popBack];
        
    }];
   
   
}
- (void)lc_updatePageNewData{
   
    [self.viewModel.coinCountCommand execute:@(YES)];
    [self.viewModel.loadDataCommend execute:@(YES)];
    
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2 || section == 1){
        
        return kUI_Width(16)+kUI_Width(12)+kUI_Width(14);
    }
    return kUI_Width(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2){
        return kUI_Width(12) * 2+kUI_Width(12);
    }
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 2){
        return kUI_Width(73);
    }
    if(indexPath.section == 1){
        return kUI_Width(33);
    }
    return kUI_Width(130);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1 || section == 2){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(16)+kUI_Width(12)+kUI_Width(14))];
        view.backgroundColor = tableView.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(16);
        label.textColor = Color(@"#333333");
        label.text = section == 1 ?KLanguage(@"提现数量") : KLanguage( @"提现到");
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(16));
            make.height.equalTo(kUI_Width(16));
            make.right.equalTo(-kUI_Width(16));
            make.top.equalTo(kUI_Width(12));
        }];
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 2){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(12) * 2+kUI_Width(12))];
        view.backgroundColor = tableView.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.textColor = Color(@"#666666");
        label.font = RegularFont(12);
        label.text = [NSString stringWithFormat:@"%@%@",KLanguage(@"提示"),self.viewModel.dataModel.tips];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.left.equalTo(kUI_Width(16));
        }];
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        LCWithDrawHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCWithDrawHeaderTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.viewModel.dataModel;
        return cell;
    }
    if(indexPath.section == 1 ){
        LCWithDrawTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCWithDrawTextFieldTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel =self.viewModel.dataModel;
        WS(weakSelf)
        [[cell.textSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
            weakSelf.viewModel.money = x;
        }];
        
        return cell;
    }
    LCWithDrawAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCWithDrawAccountTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    cell.dataModel = self.viewModel.accountModel;
    WS(weakSelf)
    [[cell.clickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(LCWithDrawAccountModel  *_Nullable x) {
        LCWithDrawBindAccountViewController *con = [LCWithDrawBindAccountViewController new];
        con.dataModel = x;
        [weakSelf pushToViewController:con];
    }];
    return cell;
        
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark---- 懒加载 ----
- (UIImageView *)contentView{
    if(_contentView == nil){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_withDrawBg")];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imgView];
        _contentView = imgView;
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}
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
        [self.contentView addSubview:_mainTableView];
        [_mainTableView registerClass:[LCWithDrawHeaderTableViewCell class] forCellReuseIdentifier:@"LCWithDrawHeaderTableViewCell"];
        [_mainTableView registerClass:[LCWithDrawTextFieldTableViewCell class] forCellReuseIdentifier:@"LCWithDrawTextFieldTableViewCell"];
        [_mainTableView registerClass:[LCWithDrawAccountTableViewCell class] forCellReuseIdentifier:@"LCWithDrawAccountTableViewCell"];

    }
    return _mainTableView;
}
- (UIButton *)withdrawBtn{
    if(!_withdrawBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_bindBankBtnBg") forState:UIControlStateNormal];;
        [btn setTitle:KLanguage(@"点击提现")  forState:UIControlStateNormal];
       
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        
        btn.titleLabel.font = BoldFont(18);
        [self.contentView addSubview:btn];
        _withdrawBtn = btn;
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
                if(!weakSelf.viewModel.money){
                    [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请填写提现金额")];
                    return;
                }
                if(!weakSelf.viewModel.accountModel.modelId){
                    [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请添加提现账户") ];
                    return;
                }
                [weakSelf.viewModel.withdrawCommand execute:@(YES)];
            
            
        }];
    }
    return _withdrawBtn;
}
- (LCWithDrawViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCWithDrawViewModel new];
        _viewModel.type = self.type;
    }
    return _viewModel;
}

@end
