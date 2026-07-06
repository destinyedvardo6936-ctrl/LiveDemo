//
//  LCSettingViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCSettingViewController.h"
#import "LCSettingTitleCell.h"
#import "LCSettingSwitchCell.h"
#import "LCSettingButtonCell.h"
#import "LCSettingViewModel.h"
#import "LCSettingLogoutBtnCell.h"
#import "LCLanguageManager.h"
#import "LCLoginViewController.h"
#import "LCAccountSecurityViewController.h"
#import "LCCommonWebViewController.h"
#import "LCTabBarViewController.h"
#import "AppDelegate.h"
@interface LCSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCSettingViewModel *viewModel;
@end

@implementation LCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelText:KLanguage(@"设置")];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0 );
        make.bottom.equalTo(0);
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
    [[self.viewModel.logoutSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        UIApplication *app =[UIApplication sharedApplication];
        AppDelegate *app2 = (AppDelegate *)app.delegate;
        
        
        app2.window.rootViewController = [LCTabBarViewController new];
    }];
    
}

- (void)lc_updatePageNewData{
    [self.viewModel.loadDataCommend execute:@(YES)];
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == self.viewModel.dataArray.count - 1){
        return kUI_Width(70);
    }
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == self.viewModel.dataArray.count){
        return [tableView fd_heightForCellWithIdentifier:@"LCSettingLogoutBtnCell" configuration:^(LCSettingLogoutBtnCell * cell) {
          
        }];
    }
    LCSettingModel *model = self.viewModel.dataArray[indexPath.section];
    switch (model.type) {
        case 0:
            {
                return [tableView fd_heightForCellWithIdentifier:@"LCSettingTitleCell" configuration:^(LCSettingTitleCell * cell) {
                  
                }];
            }
            break;
        case 1:
            {
                return [tableView fd_heightForCellWithIdentifier:@"LCSettingSwitchCell" configuration:^(LCSettingSwitchCell * cell) {
                    cell.dataModel = model;
                }];
            }
            break;
        case 2:
            {
                return [tableView fd_heightForCellWithIdentifier:@"LCSettingButtonCell" configuration:^(LCSettingButtonCell * cell) {
                    cell.dataModel = model;
                }];
            }
            break;
        default:
            break;
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
    if(indexPath.section == self.viewModel.dataArray.count){
        LCSettingLogoutBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCSettingLogoutBtnCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        [[cell.clickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            [UIAlertController showAlertInViewController:weakSelf withTitle:KLanguage(@"提示") message:KLanguage(@"确定退出登录？") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(controller.destructiveButtonIndex == buttonIndex){
                    [weakSelf.viewModel.logoutCommand execute:@(YES)];
                    
                }
            }];
//            LCLoginViewController *con = [LCLoginViewController new];
//            [weakSelf pushToViewController:con];
        }];
        return cell;
    }
    LCSettingModel *model = self.viewModel.dataArray[indexPath.section];
    switch (model.type) {
        case 0:
            {
                LCSettingTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCSettingTitleCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = tableView.backgroundColor;
                cell.dataModel = model;
                
                return cell;
                
            }
            break;
        case 1:
            {
                LCSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCSettingSwitchCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = tableView.backgroundColor;
                cell.dataModel = model;
                [[cell.clickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                    
                }];
                return cell;
//                return [tableView fd_heightForCellWithIdentifier:@"LCSettingSwitchCell" configuration:^(LCSettingSwitchCell * cell) {
//                    cell.dataModel = model;
//                }];
            }
            break;
        case 2:
            {
                LCSettingButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCSettingButtonCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = tableView.backgroundColor;
                cell.dataModel = model;
                WS(weakSelf)
                [[cell.clickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(LCSettingModel *  _Nullable x) {
                    if([x.rightValue isEqualToString:KLanguage(@"最新")]){
                        //更新
                        [SVProgressHUD showMaskViewWithInfo:KLanguage(@"已是最新版本")];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.viewModel.versionModel.url]];
                    }
                }];
                return cell;
//                return [tableView fd_heightForCellWithIdentifier:@"LCSettingButtonCell" configuration:^(LCSettingButtonCell * cell) {
//                    cell.dataModel = model;
//                }];
            }
            break;
        default:
            break;
    }

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == self.viewModel.dataArray.count){
        return;
    }
    LCSettingModel *model = self.viewModel.dataArray[indexPath.section];
    if(model.type == 1){
        return;
    }else if (model.type == 0){
        if(indexPath.section == 0){
            LCAccountSecurityViewController *con = [LCAccountSecurityViewController new];
            [self pushToViewController:con];
        }else if(indexPath.section == 1){
            [UIAlertController showActionSheetInViewController:self withTitle:KLanguage(@"选择语言") message:nil cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:nil otherButtonTitles:[[LCLanguageManager shareManager] getAllLanguageDescirbe] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                
            } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex != controller.cancelButtonIndex){
                    
                    [self.viewModel.changeLanguageCommand execute:action.title];
                }
            }];
        }else if(indexPath.section == 2){
            LCCommonWebViewController *con = [LCCommonWebViewController new];
            
            
            con.titleStr = model.leftTitle;
            con.url = [self addurl:[LCConfigManager shareManager].configModel.login_private_url];
            [self pushToViewController:con];
        }
        
    }
}
//所有h5需要拼接uid和token
-(NSString *)addurl:(NSString *)url{
    return [url stringByAppendingFormat:@"?lang=%@",[[LCLanguageManager shareManager]getLanguageEncode]];
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
        _mainTableView.contentInset = UIEdgeInsetsMake(kUI_Width(10), 0, 0, 0);
        _mainTableView.backgroundColor = Color(@"#F7F7F7");
        [self.view addSubview:_mainTableView];
        [_mainTableView registerClass:[LCSettingTitleCell class] forCellReuseIdentifier:@"LCSettingTitleCell"];
        [_mainTableView registerClass:[LCSettingSwitchCell class] forCellReuseIdentifier:@"LCSettingSwitchCell"];
        [_mainTableView registerClass:[LCSettingButtonCell class] forCellReuseIdentifier:@"LCSettingButtonCell"];
        [_mainTableView registerClass:[LCSettingLogoutBtnCell class] forCellReuseIdentifier:@"LCSettingLogoutBtnCell"];

       
        
    }
    return _mainTableView;
}
- (LCSettingViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCSettingViewModel new];
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
