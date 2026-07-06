//
//  LCMyWalletViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCMyWalletViewController.h"
#import "LCMyWalletViewModel.h"
#import "LCMyWalletBalanceTableViewCell.h"
#import "LCMyLeftZSTableViewCell.h"
#import "LCMySendZSTableViewCell.h"
#import "LCWithDrawPaymentViewController.h"
#import "LCRechageViewController.h"
#import "LCCommonWebViewController.h"
#import "LCRechargeRecordViewController.h"
#import "LCLocalDataTools.h"
@interface LCMyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCMyWalletViewModel *viewModel;

@end

@implementation LCMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)lc_addSubviews{
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"我的钱包")];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.top.equalTo(kNavBarHeight );
        make.right.equalTo(0);
//        make.right.mas_equalTo(searchBtn.mas_left);
    }];
   
//    self.pagerView.defaultSelectedIndex = 1;
}
- (void)lc_bindViewModel{
   
    @weakify(self)
   
    
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.mainTableView.mj_header.isRefreshing) {
            [self.mainTableView.mj_header endRefreshing];
        }
        if (self.mainTableView.mj_footer.isRefreshing) {
            [self.mainTableView.mj_footer endRefreshing];
        }
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainTableView.hidden = NO;
        
      
        
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        }];
        
        
    }];

    
    
    
    [self.viewModel.loadDataCommend execute:@(YES)];

}

#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
        return kUI_Width(10);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return   [tableView fd_heightForCellWithIdentifier:@"LCMyWalletBalanceTableViewCell" configuration:^(LCMyWalletBalanceTableViewCell * cell) {
            
        }];
    }else if (indexPath.section == 1){
        return [tableView fd_heightForCellWithIdentifier:@"LCMyLeftZSTableViewCell" configuration:^(LCMyLeftZSTableViewCell * cell) {
            
        }];
    }
    return [tableView fd_heightForCellWithIdentifier:@"LCMySendZSTableViewCell" configuration:^(LCMySendZSTableViewCell * cell) {
        
    }];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        LCMyWalletBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMyWalletBalanceTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(weakSelf)
        cell.balanceStr = self.viewModel.balanceStr;
        [[cell.recordSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            LCRechargeRecordViewController *con = [LCRechargeRecordViewController new];

            
          
            [weakSelf pushToViewController:con];
        }];
        [[cell.rechargeSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            LCRechageViewController *con = [LCRechageViewController new];
            con.needBack = YES;
            [weakSelf pushToViewController:con];
        }];
        [[cell.withdrawSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            
            LCWithDrawPaymentViewController *con = [LCWithDrawPaymentViewController new];
            [weakSelf pushToViewController:con];
        }];
        return cell;
    }else if (indexPath.section == 1){
        LCMyLeftZSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMyLeftZSTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(weakSelf)
        [[cell.btnClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            
        }];
        
        return cell;
    }
    LCMySendZSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMySendZSTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WS(weakSelf)
    [[cell.btnClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        
    }];
    return cell;
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark---- 懒加载 ----
- (LCMyWalletViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [LCMyWalletViewModel new];
    }
    return _viewModel;
}




- (LCBaseTableView *)mainTableView{
    if (_mainTableView == nil){
        LCBaseTableView *tableView = [LCBaseTableView addTableGrouped];
        _mainTableView = tableView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_mainTableView];
        [_mainTableView registerClass:[LCMySendZSTableViewCell class] forCellReuseIdentifier:@"LCMySendZSTableViewCell"];
        [_mainTableView registerClass:[LCMyLeftZSTableViewCell class] forCellReuseIdentifier:@"LCMyLeftZSTableViewCell"];
        [_mainTableView registerClass:[LCMyWalletBalanceTableViewCell class] forCellReuseIdentifier:@"LCMyWalletBalanceTableViewCell"];
       
        
    }
    return _mainTableView;
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
