//
//  LCRechargeSubViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCRechargeSubViewController.h"
#import "LCRechargeViewModel.h"
#import "LCRechargeMoneyTableViewCell.h"
#import "LCRechargeSubPayWayTableViewCell.h"
@interface LCRechargeSubViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void (^scrollBlock)(UIScrollView *scrollView);
@property (nonatomic , strong) LCRechargeViewModel *viewModel;
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@end

@implementation LCRechargeSubViewController

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
    [[self.viewModel.otherSubmitSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        [SVProgressHUD dismiss];
        NSDictionary *dic = x[@"info"];
        NSURL *url = [NSURL URLWithString:dic[@"purl"]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:url];
                    }
            
        }
        
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
    if (section == 1 ){
        return 1;
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
    if(indexPath.section == 0){
        NSInteger col = self.viewModel.subPayWayArray.count / 3 + (self.viewModel.subPayWayArray.count % 3 > 0 ? 1:0);
        return kUI_Width(113)/2.0 * col + (col > 0?(col - 1)*kUI_Width(10) : 0) + kUI_Width(10) * 2;
    }
    
    NSInteger col = self.viewModel.selectSubTypeModel.moneylist.count / 3 + (self.viewModel.selectSubTypeModel.moneylist.count % 3 > 0 ? 1:0);
    return kUI_Width(113)/2.0 * col + (col > 0?(col - 1)*kUI_Width(10) : 0) + kUI_Width(10) * 2;
    
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
    tipLabel.text = section == 1? KLanguage(@"选择充值金额"):[NSString stringWithFormat:@"%@%@",self.dataModel.name,KLanguage(@"充值")];
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
        LCRechargeMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCRechargeMoneyTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArr = self.viewModel.selectSubTypeModel.moneylist;
        WS(weakSelf)
        cell.labelSelectedBlock = ^(LCRechargeMoneyModel * _Nonnull model) {
            weakSelf.viewModel.selectMoneyModel = model;
            if(!weakSelf.viewModel.selectSubTypeModel){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请选择充值方式") ];
                return;
            }
            [SVProgressHUD showWithMaskView];
            [weakSelf.viewModel.otherSubmitCommand execute:@(YES)];
        };
        return cell;
    }
    LCRechargeSubPayWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCRechargeSubPayWayTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataArr = self.viewModel.subPayWayArray;
    WS(weakSelf)
    cell.labelSelectedBlock = ^(LCRechargeSubTypeModel * _Nonnull model) {
        weakSelf.viewModel.selectSubTypeModel = model;
        [weakSelf.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
    };
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
        [_mainTableView registerClass:[LCRechargeMoneyTableViewCell class] forCellReuseIdentifier:@"LCRechargeMoneyTableViewCell"];
        [_mainTableView registerClass:[LCRechargeSubPayWayTableViewCell class] forCellReuseIdentifier:@"LCRechargeSubPayWayTableViewCell"];
       
        
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
