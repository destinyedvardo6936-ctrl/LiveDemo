//
//  LCAccountDetailsViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCAccountDetailsViewController.h"
#import "LCAccountDetailsTableViewCell.h"
#import "LCAccountDetailsViewModel.h"
#import "LCNoDataTableViewCell.h"
@interface LCAccountDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;


@property (nonatomic , strong)LCAccountDetailsViewModel *viewModel;


@end

@implementation LCAccountDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"账目明细")];
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
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[[self.viewModel.loadDataCommend.executing skip:1] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            self.mainTableView.mj_footer.hidden = YES;
            if (self.mainTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.mainTableView.mj_footer resetNoMoreData];
                
            }
        }else{
            self.mainTableView.mj_footer.hidden = NO;
        }
    }];
//      [[self.viewModel.nextPageCommand.executing takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
//          @strongify(self)
//          self.isPreloading = x.boolValue;
//    }];
    
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
        
        self.mainTableView.mj_footer.hidden = !self.viewModel.dataArray.count;
        
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        }];
        
        
    }];

    
    
    [[self.viewModel.noMoreDataSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber  *_Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    [self.mainTableView.mj_header beginRefreshing];
}


#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count ? self.viewModel.dataArray.count :1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return kUI_Width(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.viewModel.dataArray.count){
        return tableView.height;
    }
    return [tableView fd_heightForCellWithIdentifier:@"LCAccountDetailsTableViewCell" configuration:^(LCAccountDetailsTableViewCell * cell) {
        cell.dataModel = self.viewModel.dataArray[indexPath.section];
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.viewModel.dataArray.count){
        LCNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCNoDataTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleStr = KLanguage(@"暂无充值记录");
        return cell;
    }
//    return nil;
    LCAccountDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCAccountDetailsTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.dataModel = self.viewModel.dataArray[indexPath.section];
    return cell;
        
    
    
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
        [_mainTableView registerClass:[LCAccountDetailsTableViewCell class] forCellReuseIdentifier:@"LCAccountDetailsTableViewCell"];
        [_mainTableView registerClass:[LCNoDataTableViewCell class] forCellReuseIdentifier:@"LCNoDataTableViewCell"];
       
        WS(weakSelf)
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.loadDataCommend execute:@(YES)];
        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
          
                [weakSelf.viewModel.nextPageCommand execute:@(YES)];
            
        }];
        _mainTableView.mj_footer.hidden = YES;
    }
    return _mainTableView;
}
- (LCAccountDetailsViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCAccountDetailsViewModel new];
     
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
