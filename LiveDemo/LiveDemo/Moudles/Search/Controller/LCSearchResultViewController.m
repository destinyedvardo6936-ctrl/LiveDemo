//
//  LCSearchResultViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCSearchResultViewController.h"
#import "LCSearchViewModel.h"
#import "LCSearchResultTableViewCell.h"
#import "LCUserHomeViewController.h"
#import "LCLiveViewController.h"
@interface LCSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCSearchViewModel *viewModel;
@end

@implementation LCSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)reloadData{}
- (void)refreshViewWithoutData{}
- (void)releaseController{}
- (void)lc_addSubviews{
    self.view.backgroundColor = Color(@"#FFFFFF");
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
    }];
    self.emptyDataView.title = KLanguage(@"主播在赶来的路上~");

    self.emptyDataView.customImageFrame = CGRectMake((self.view.width - kUI_Width(157))/2.0, kUI_Width(136), kUI_Width(157), kUI_Width(157));
    [self.emptyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
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
        
        self.emptyDataView.hidden = self.viewModel.dataArray.count;

        
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
    return self.viewModel.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return kUI_Width(16)+ kUI_Width(10);
    }
    return kUI_Width(6);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return kUI_Width(6);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kUI_Width(70);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(16)+kUI_Width(10))];
        view.backgroundColor =tableView.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(16);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"搜索结果");
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(16));
            make.right.equalTo(-kUI_Width(12));
        }];
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf)
    
    LCSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCSearchResultTableViewCell"];
    
    cell.dataModel = self.viewModel.dataArray[indexPath.section];
    [[cell.jumpToLiveSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(LCRankArchorModel *  _Nullable x) {
        LCLiveViewController *con = [LCLiveViewController new];
        NSMutableArray *temp = [NSMutableArray array];
        if(!x.live.user_nicename.length){
            x.live.user_nicename = x.user_nicename;
        }
        [temp addObject:x.live];
        
        con.dataArray = temp;
        con.index = 0;

        [weakSelf pushToViewController:con];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCRankArchorModel *model = self.viewModel.dataArray[indexPath.section];
    LCUserHomeViewController *con = [LCUserHomeViewController new];
    con.userId = model.uid;
    [self pushToViewController:con];
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
        [_mainTableView registerClass:[LCSearchResultTableViewCell class] forCellReuseIdentifier:@"LCSearchResultTableViewCell"];
        
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




- (LCSearchViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCSearchViewModel new];
        _viewModel.searchText = self.searchStr;
       
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
