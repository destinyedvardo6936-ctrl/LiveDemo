//
//  LCMineViewController.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCMineViewController.h"
#import "LCMineViewModel.h"
#import "LCMineUserInfoCell.h"
#import "LCMineFunTableViewCell.h"
#import "LCMineOptionTableViewCell.h"
#import "LCMineWalletAndMeaageCell.h"
#import "LCMineBannerTableViewCell.h"
#import "LCSettingViewController.h"
#import "LCMyBackpackViewController.h"
#import "LCAccountSecurityViewController.h"
#import "LCRevenueDetailViewController.h"
#import "LCMyWalletViewController.h"
#import "LCWithDrawPaymentViewController.h"
#import "LCUpdatePersonalInfoViewController.h"
#import "LCCommonWebViewController.h"
#import "LCFansListViewController.h"
#import "LCFollowListViewController.h"
#import "LCActivitysViewController.h"
#import "LCMessageListViewController.h"
#import "LCLanguageManager.h"
#import "LCBindPhoneViewController.h"
#import "LCBettingRecordPageViewController.h"
#import "LCRechargeRecordViewController.h"
#import "LCAccountDetailsViewController.h"

@interface LCMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCMineViewModel *viewModel;
@end

@implementation LCMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_None];
    [self.navView setBottomBackgroundColor:[UIColor clearColor]];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    UIButton *rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rankBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rankBtn setImage:image(@"icon_settingBtn") forState:UIControlStateNormal];
    WS(weakSelf)
    [[rankBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        LCSettingViewController *con = [LCSettingViewController new];
        [weakSelf pushToViewController:con];
    }];
    [self.navView addSubview:rankBtn];
    
    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - kUI_Width(24))/2.0);
        make.width.height.equalTo(kUI_Width(24));
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}
- (void)lc_bindViewModel{
    @weakify(self)

    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
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
    [[self.viewModel.bannerSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
      

        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        }];
        
    }];
    [[self.viewModel.messageSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
      

        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        }];
        
    }];
    [[self.viewModel.applyAgentSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        NSDictionary *dic = x;

        [SVProgressHUD showSuccessWithStatus:dic[@"msg"]];
    
    }];


}
- (void)lc_updatePageNewData{
    [self.viewModel.loadDataCommend execute:@(YES)];
    [self.viewModel.bannerCommand execute:@(YES)];
    [self.viewModel.urlCommand execute:@(YES)];
    [self.viewModel.messageCommand execute:@(YES)];
  
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.bannerArray.count ? self.viewModel.dataArray.count + 4:self.viewModel.dataArray.count + 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( (self.viewModel.bannerArray.count && section >= 4)||( !self.viewModel.bannerArray.count&& section >= 3)){
        NSArray *arr =self.viewModel.bannerArray.count? self.viewModel.dataArray[section - 4]:self.viewModel.dataArray[section - 3];
        return arr.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kUI_Width(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [tableView fd_heightForCellWithIdentifier:@"LCMineUserInfoCell" configuration:^(LCMineUserInfoCell * cell) {
            cell.dataModel = self.viewModel.dataModel;
        }];
    }
    if(indexPath.section == 1){
        return [tableView fd_heightForCellWithIdentifier:@"LCMineFunTableViewCell" configuration:^(LCMineFunTableViewCell * cell) {
           
        }];
    }
    if(indexPath.section == 2 && self.viewModel.bannerArray.count){
        return kUI_Width(95);
    }
    if((indexPath.section == 3 && self.viewModel.bannerArray.count)||(!self.viewModel.bannerArray.count && indexPath.section == 2)){
        return [tableView fd_heightForCellWithIdentifier:@"LCMineWalletAndMeaageCell" configuration:^(LCMineWalletAndMeaageCell * cell) {
           
        }];
    }
    if((indexPath.section >= 4 && self.viewModel.bannerArray.count)||(!self.viewModel.bannerArray.count && indexPath.section >= 3)){
        NSArray *arr = self.viewModel.bannerArray.count? self.viewModel.dataArray[indexPath.section - 4]:self.viewModel.dataArray[indexPath.section - 3];
        return [tableView fd_heightForCellWithIdentifier:@"LCMineOptionTableViewCell" configuration:^(LCMineOptionTableViewCell * cell) {
            cell.dataModel = arr[indexPath.row];
        }];
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf)
    if(indexPath.section == 0){
        LCMineUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMineUserInfoCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.dataModel = self.viewModel.dataModel;
        [[cell.editSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            LCUpdatePersonalInfoViewController *con = [LCUpdatePersonalInfoViewController new];
            [weakSelf pushToViewController:con];
        }];
        [[cell.userIdCopySubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:weakSelf.viewModel.dataModel.ID];
            [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"已复制成功") ];
        }];
        [[cell.followClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            LCFollowListViewController *con = [LCFollowListViewController new];
            con.userId = weakSelf.viewModel.dataModel.ID;
            [weakSelf pushToViewController:con];
        }];
        [[cell.fansClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            LCFansListViewController *con = [LCFansListViewController new];
            con.userId = weakSelf.viewModel.dataModel.ID;
            [weakSelf pushToViewController:con];
        }];
        return cell;
    }
    if(indexPath.section == 1){
        LCMineFunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMineFunTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        
        [[cell.btnClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *  _Nullable x) {
            if([x intValue] == 0){
                if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
                    [UIAlertController showAlertInViewController:weakSelf withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if(buttonIndex == controller.destructiveButtonIndex){
                            LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                            [weakSelf pushToViewController:con];
                        }
                    }];
                    return;
                }
                LCMyWalletViewController *con = [LCMyWalletViewController new];
                LCMineUrlModel *model = nil;
                LCMineUrlModel *model1 = nil;
                for (LCMineUrlModel *m in weakSelf.viewModel.urlModelArr) {
                    if([m.modelId isEqualToString:@"32"]){
                        model = m;
                    }
                    if([m.modelId isEqualToString:@"26"]){
                        model1 = m;
                    }
                }
                con.withDrawRecordUrl = [weakSelf addurl:model1.href];
                con.rechargeRecordUrl = [weakSelf addurl:model.href];
                [weakSelf pushToViewController:con];
            }else if ([x intValue] == 1){
                if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
                    [UIAlertController showAlertInViewController:weakSelf withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if(buttonIndex == controller.destructiveButtonIndex){
                            LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                            [weakSelf pushToViewController:con];
                        }
                    }];
                    return;
                }
                LCWithDrawPaymentViewController *con = [LCWithDrawPaymentViewController new];
                LCMineUrlModel *model = nil;
                for (LCMineUrlModel *m in weakSelf.viewModel.urlModelArr) {
                    if([m.modelId isEqualToString:@"26"]){
                        model = m;
                    }
                }
                con.withDrawRecordUrl = [weakSelf addurl:model.href];
                [weakSelf pushToViewController:con];
            }else if ([x intValue] == 3){
                LCActivitysViewController *con = [LCActivitysViewController new];
                con.needBack = YES;
                [weakSelf pushToViewController:con];
            }else if ([x intValue] == 4){
                if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
                    [UIAlertController showAlertInViewController:weakSelf withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if(buttonIndex == controller.destructiveButtonIndex){
                            LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                            [weakSelf pushToViewController:con];
                        }
                    }];
                    return;
                }
                LCCommonWebViewController *con = [LCCommonWebViewController new];
                LCMineUrlModel *model = nil;
                for (LCMineUrlModel *m in weakSelf.viewModel.urlModelArr) {
                    if([m.modelId isEqualToString:@"8"]){
                        model = m;
                    }
                }
                
                con.titleStr = model.name;
                con.url = [weakSelf addurl:model.href];
                [weakSelf pushToViewController:con];
            }
        }];
        return cell;
       
    }
    if(indexPath.section == 2 && self.viewModel.bannerArray.count){
        LCMineBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMineBannerTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.dataArray = self.viewModel.bannerArray;
        cell.clickBlock = ^(NSInteger index) {
            LCCommonWebViewController *con = [LCCommonWebViewController new];
            LCBannerModel *banner = [weakSelf.viewModel.bannerArray objectAtIndex:index];
//            con.titleStr = banner.
            con.url = banner.slide_url;
            [weakSelf pushToViewController:con];
        };
        return cell;
    }
    if((indexPath.section == 3 && self.viewModel.bannerArray.count)||(!self.viewModel.bannerArray.count && indexPath.section == 2)){
        LCMineWalletAndMeaageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMineWalletAndMeaageCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.dataModel = self.viewModel.messageModel;
        [[cell.clickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *  _Nullable x) {
            if([x intValue] == 0){
                
            }else {
                LCMessageListViewController *con = [LCMessageListViewController new];
              
                [weakSelf pushToViewController:con];
            }
        }];
        return cell;
       
    }
    if((indexPath.section >= 4 && self.viewModel.bannerArray.count)||(!self.viewModel.bannerArray.count && indexPath.section >= 3)){
        LCMineOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMineOptionTableViewCell"];
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.backgroundColor = tableView.backgroundColor;
        NSArray *arr = self.viewModel.bannerArray.count? self.viewModel.dataArray[indexPath.section - 4]:self.viewModel.dataArray[indexPath.section - 3];
        cell.dataModel = arr[indexPath.row];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if((indexPath.section >= 4 && self.viewModel.bannerArray.count)||(!self.viewModel.bannerArray.count && indexPath.section >= 3)){
        if((indexPath.section == 4 && self.viewModel.bannerArray.count)||(!self.viewModel.bannerArray.count && indexPath.section == 3)){
            if(indexPath.row == 0){
                if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
                    [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if(buttonIndex == controller.destructiveButtonIndex){
                            LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                            [self pushToViewController:con];
                        }
                    }];
                    return;
                }
                LCRechargeRecordViewController *con = [LCRechargeRecordViewController new];
//                LCCommonWebViewController *con = [LCCommonWebViewController new];
//                LCMineUrlModel *model = nil;
//                for (LCMineUrlModel *m in self.viewModel.urlModelArr) {
//                    if([m.modelId isEqualToString:@"32"]){
//                        model = m;
//                    }
//                }
//
//                con.titleStr = model.name;
//                con.url = [self addurl:model.href];
                [self pushToViewController:con];
            }else if(indexPath.row == 1 && [LCGameConfigManager shareManager].gameStatus){
                if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
                    [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if(buttonIndex == controller.destructiveButtonIndex){
                            LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                            [self pushToViewController:con];
                        }
                    }];
                    return;
                }
                //投注记录
                LCBettingRecordPageViewController *con = [LCBettingRecordPageViewController new];
                [self pushToViewController:con];
            }else {
                if(![LCUserInfoManager shareManager].userInfo.isyouke.length){
                    [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if(buttonIndex == controller.destructiveButtonIndex){
                            LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                            [self pushToViewController:con];
                        }
                    }];
                    return;
                }
                //账目明细
                LCAccountDetailsViewController *con = [LCAccountDetailsViewController new];
               
                [self pushToViewController:con];
            }
        }else if((indexPath.section == 5 && self.viewModel.bannerArray.count)||(!self.viewModel.bannerArray.count && indexPath.section == 4)){
            //代理
            if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
                [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if(buttonIndex == controller.destructiveButtonIndex){
                        LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                        [self pushToViewController:con];
                    }
                }];
                return;
            }
            if([LCUserInfoManager shareManager].userInfo.isdaili.intValue == 0){
                [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"申请成为代理？") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if(buttonIndex == controller.destructiveButtonIndex){
                        [SVProgressHUD show];
                        [self.viewModel.applyAgentCommand execute:@(YES)];
                    }
                }];
            }else if ([LCUserInfoManager shareManager].userInfo.isdaili.intValue == 2){
                [SVProgressHUD showMaskViewWithInfo:KLanguage(@"申请在审核中")];
            }else if ([LCUserInfoManager shareManager].userInfo.isdaili.intValue == 1){
                LCCommonWebViewController *con = [LCCommonWebViewController new];
                LCMineUrlModel *model = nil;
                for (LCMineUrlModel *m in self.viewModel.urlModelArr) {
                    if([m.modelId isEqualToString:@"31"]){
                        model = m;
                    }
                }
                
                con.titleStr = model.name;
                con.url = [self addurl:model.href];
                [self pushToViewController:con];
            }
        }else{
            if(indexPath.row == 0){
                LCAccountSecurityViewController *con = [LCAccountSecurityViewController new];
                [self pushToViewController:con];
            }else if(indexPath.row == 1){
                LCMyBackpackViewController *con = [LCMyBackpackViewController new];
                [self pushToViewController:con];
            }else if(indexPath.row == 2){
                LCCommonWebViewController *con = [LCCommonWebViewController new];
                LCMineUrlModel *model = nil;
                for (LCMineUrlModel *m in self.viewModel.urlModelArr) {
                    if([m.modelId isEqualToString:@"3"]){
                        model = m;
                    }
                }
                
                con.titleStr = model.name;
                con.url = [self addurl:model.href];
                [self pushToViewController:con];
            }else if(indexPath.row == 3){
                LCCommonWebViewController *con = [LCCommonWebViewController new];
                LCMineUrlModel *model = nil;
                for (LCMineUrlModel *m in self.viewModel.urlModelArr) {
                    if([m.modelId isEqualToString:@"21"]){
                        model = m;
                    }
                }
                
                con.titleStr = model.name;
                con.url = [self addurl:model.href];
                [self pushToViewController:con];
            }else if(indexPath.row == 4){
                LCCommonWebViewController *con = [LCCommonWebViewController new];
                LCMineUrlModel *model = nil;
                for (LCMineUrlModel *m in self.viewModel.urlModelArr) {
                    if([m.modelId isEqualToString:@"6"]){
                        model = m;
                    }
                }
                
                con.titleStr = model.name;
                con.url = [self addurl:model.href];
                [self pushToViewController:con];
            }
            else if (indexPath.row == 5){
                LCSettingViewController *con = [LCSettingViewController new];
                [self pushToViewController:con];
            }
        }
    }
}
//所有h5需要拼接uid和token
-(NSString *)addurl:(NSString *)url{
    return [url stringByAppendingFormat:@"?uid=%@&token=%@&lang=%@",[LCUserInfoManager shareManager].userInfo.ID,[LCUserInfoManager shareManager].userInfo.token,[[LCLanguageManager shareManager]getLanguageEncode]];
}
#pragma mark---- 懒加载 ----
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
        [_mainTableView registerClass:[LCMineUserInfoCell class] forCellReuseIdentifier:@"LCMineUserInfoCell"];
        [_mainTableView registerClass:[LCMineFunTableViewCell class] forCellReuseIdentifier:@"LCMineFunTableViewCell"];
        [_mainTableView registerClass:[LCMineOptionTableViewCell class] forCellReuseIdentifier:@"LCMineOptionTableViewCell"];
        [_mainTableView registerClass:[LCMineWalletAndMeaageCell class] forCellReuseIdentifier:@"LCMineWalletAndMeaageCell"];
        [_mainTableView registerClass:[LCMineBannerTableViewCell class] forCellReuseIdentifier:@"LCMineBannerTableViewCell"];
       
        
    }
    return _mainTableView;
}
- (LCMineViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCMineViewModel new];
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
