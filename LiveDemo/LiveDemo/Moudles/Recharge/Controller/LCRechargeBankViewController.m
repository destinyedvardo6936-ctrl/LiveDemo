//
//  LCRechargeBankViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCRechargeBankViewController.h"
#import "LCRechargeViewModel.h"
#import "LCRechargeBankMoneyCollectionCell.h"
#import "LCRechargeBankTableViewCell.h"
@interface LCRechargeBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void (^scrollBlock)(UIScrollView *scrollView);
@property (nonatomic , strong) LCRechargeViewModel *viewModel;
@property (nonatomic , weak) LCBaseTableView *mainTableView;

@end

@implementation LCRechargeBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
}
- (void)lc_bindViewModel{
    @weakify(self)
    
//      [[self.viewModel.nextPageCommand.executing takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
//          @strongify(self)
//          self.isPreloading = x.boolValue;
//    }];
    
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

    [[self.viewModel.bankOrVirtualSubmitSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        [SVProgressHUD showNoMaskViewWithSuccess:KLanguage(@"提交成功")];
        
        
    }];
    
    
    [self.viewModel.loadDataCommend execute:@(YES)];
}
#pragma mark---- JXPagerViewListViewDelegate ----
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.mainTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollBlock = callback;
}

- (void)listScrollViewWillResetContentOffset {
    //当前的listScrollView需要重置的时候，就把所有列表的contentOffset都重置了
    self.mainTableView.contentOffset = CGPointZero;
    
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1 ){
        if(self.viewModel.personArray.count){
            return 1;
        }else{
            return 0;
        }
        
    }
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kUI_Width(16);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        //联系人 银行卡  虚拟币
        return [tableView fd_heightForCellWithIdentifier:@"LCRechargeBankTableViewCell" configuration:^(LCRechargeBankTableViewCell *cell) {
            
        }];
    }
   
   
    return kUI_Width(55) + kUI_Width(10) * 2;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(16))];
    view.backgroundColor = Color(@"#FFFFFF");
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_rechargeTipAcessImg")];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(12));
        make.width.equalTo(kUI_Width(4));
        make.height.equalTo(kUI_Width(16));
        make.top.equalTo(0);
    }];
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tipLabel.text = section == 0? KLanguage(@"请输入充值金额"):KLanguage(@"请转账到以下帐号：转账后请提交信息");
    tipLabel.textColor = Color(@"#333333");
    tipLabel.font = BoldFont(16);
    [view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(4));
        make.height.equalTo(kUI_Width(16));
        make.top.equalTo(0);
        make.right.equalTo(-kUI_Width(16));
    }];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        LCRechargeBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCRechargeBankTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.viewModel.personArray[indexPath.row];
        WS(weakSelf)
        cell.submitBlock = ^{
            if(!weakSelf.viewModel.selectMoneyModel){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请输入充值金额") ];
                return;
            }
            [SVProgressHUD showWithMaskView];
            [weakSelf.viewModel.bankOrVirtualSubmitCommand execute:@(YES)];
            
        };
        return cell;
    }
    LCRechargeBankMoneyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCRechargeBankMoneyCollectionCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.dataArr = self.viewModel.moneyArray;
    WS(weakSelf)
    cell.inputBlock = ^(NSString * _Nonnull input) {
        LCRechargeMoneyModel *model = [LCRechargeMoneyModel new];
        model.money = input;
        weakSelf.viewModel.selectMoneyModel = model;
    };
//    cell.labelSelectedBlock = ^(LCRechargeMoneyModel * _Nonnull model) {
//        weakSelf.viewModel.selectMoneyModel = model;
//    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollBlock) {
        self.scrollBlock(scrollView);
    }
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
        _mainTableView.backgroundColor = Color(@"#FFFFFF");
        [self.view addSubview:_mainTableView];
        [_mainTableView registerClass:[LCRechargeBankMoneyCollectionCell class] forCellReuseIdentifier:@"LCRechargeBankMoneyCollectionCell"];
        [_mainTableView registerClass:[LCRechargeBankTableViewCell class] forCellReuseIdentifier:@"LCRechargeBankTableViewCell"];
       
        
    }
    return _mainTableView;
}
- (LCRechargeViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCRechargeViewModel new];
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
