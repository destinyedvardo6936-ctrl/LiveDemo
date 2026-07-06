//
//  LCBetingRecordViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCTotalBetingRecordViewController.h"
#import "LCTotalBettingRecordViewModel.h"
#import "LCNoDataTableViewCell.h"
#import "LCBettingRecordTableViewCell.h"
@interface LCTotalBetingRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;

@property (nonatomic, copy) void (^scrollBlock)(UIScrollView *scrollView);
@property (nonatomic , strong)LCTotalBettingRecordViewModel *viewModel;
@end

@implementation LCTotalBetingRecordViewController

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
    return self.viewModel.dataArray.count ? self.viewModel.dataArray.count :1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return kUI_Width(14)+kUI_Width(12);
    }
    return 0.00000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.viewModel.dataArray.count){
        return tableView.height;
    }
    return kUI_Width(36);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView * view = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(14)+kUI_Width(12) ) ] ;
        view.backgroundColor = Color(@"#FFFFFF");
        NSArray *temp = @[KLanguage(@"彩种"),KLanguage(@"玩法"),KLanguage(@"倍数"),KLanguage(@"金额"),KLanguage(@"期号"),KLanguage(@"状态")];
        CGFloat width = (tableView.width - kUI_Width(12) * 2 - kUI_Width(90))/(temp.count  - 1);
        CGFloat x = kUI_Width(12);
        for (NSString *title in temp) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.text = title;
            label.textColor = Color(@"#333333");
            label.font = RegularFont(14);
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            NSInteger index = [temp indexOfObject:title];
            if (index == 4){
                label.frame = CGRectMake(x , 0, kUI_Width(90), kUI_Width(14));
                x += kUI_Width(90);
            }else{
                label.frame = CGRectMake(x, 0, width, kUI_Width(14));
                x += width;
            }
           
        }
        return view ;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 1)];
    view.backgroundColor = Color(@"#F2F2F6");
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.viewModel.dataArray.count){
        LCNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCNoDataTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleStr = KLanguage(@"暂无投注记录");
        return cell;
    }
    LCBettingRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCBettingRecordTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.dataModel = self.viewModel.dataArray[indexPath.section];
    return cell;
        
    
    
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
        [_mainTableView registerClass:[LCBettingRecordTableViewCell class] forCellReuseIdentifier:@"LCBettingRecordTableViewCell"];
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
- (LCTotalBettingRecordViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCTotalBettingRecordViewModel new];
        _viewModel.isBc = self.isBc;
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
