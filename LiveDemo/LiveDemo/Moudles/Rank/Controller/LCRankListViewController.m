//
//  LCRankListViewController.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCRankListViewController.h"
#import "LCRankViewModel.h"
#import "LCRankTopThreeCell.h"
#import "LCRankTableViewCell.h"
#import "LCUserHomeViewController.h"
#import "LCLiveViewController.h"
#import "LCNoDataTableViewCell.h"
@interface LCRankListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) LCRankViewModel *viewModel;

@end

@implementation LCRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color(@"#FC6891");
   
}
- (void)lc_addSubviews{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
    }];
//    self.emptyDataView.title = KLanguage(@"主播在赶来的路上~");
//    self.emptyDataView.backgroundColor = self.view.backgroundColor;
//    self.emptyDataView.customImageFrame = CGRectMake((self.view.width - kUI_Width(157))/2.0, kUI_Width(136), kUI_Width(157), kUI_Width(157));
//    [self.emptyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.right.equalTo(0);
//        make.top.equalTo(0);
//        make.bottom.equalTo(0);
//    }];
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
        
//        self.mainTableView.mj_footer.hidden = !self.viewModel.dataArray.count;

        
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
#pragma mark - JXCategoryListContentViewDelegate

/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。

 @return UIView
 */
- (UIView *)listView{
    return self.view;
}

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView{
    return self.mainTableView;
}

/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback

 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback{
    self.scrollCallback   = callback;
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count ? self.viewModel.dataArray.count : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section > 0){
        return kUI_Width(1);
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.dataArray.count == 0){
        return tableView.height ;
    }else{
        if(indexPath.section == 0){
            return kUI_Width(231);
        }
        return kUI_Width(79);
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section > 0){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(1))];
        view.backgroundColor = ColorAlpha(@"#D8D8D8", 0.35);
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf)
    if(self.viewModel.dataArray.count == 0){
        LCNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCNoDataTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleStr = KLanguage(@"虚位以待");
        cell.customBgColor = tableView.backgroundColor;
        return cell;
    }else{
        if( indexPath.section == 0){
            LCRankTopThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCRankTopThreeCell"];
            cell.isArchorList = self.isArchorList;
            cell.dataArray = self.viewModel.dataArray[indexPath.section];
            [[cell.followSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                [weakSelf.viewModel.followCommand execute:x];
            }];
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
            [[cell.userHomeSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(LCRankArchorModel *  _Nullable x) {
               
                LCUserHomeViewController *con = [LCUserHomeViewController new];
                con.userId = x.uid;
                [weakSelf pushToViewController:con];
            }];
            return cell;
        }
        LCRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCRankTableViewCell"];
        cell.isArchorList = self.isArchorList;
        cell.dataModel = self.viewModel.dataArray[indexPath.section];
        [[cell.followSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            [weakSelf.viewModel.followCommand execute:x];
        }];
        [[cell.jumpToLiveSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(LCRankArchorModel *  _Nullable x) {
            LCLiveViewController *con = [LCLiveViewController new];
                    NSMutableArray *temp = [NSMutableArray array];
                    [temp addObject:x.live];
            
                    con.dataArray = temp;
                    con.index = 0;
            
                    [weakSelf pushToViewController:con];
        }];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.viewModel.dataArray.count == 0){
        
    }else{
        if( indexPath.section != 0){
            LCRankArchorModel *model = self.viewModel.dataArray[indexPath.section];
            LCUserHomeViewController *con = [LCUserHomeViewController new];
            con.userId = model.uid;
            [self pushToViewController:con];
        }
    }
   
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
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
        [_mainTableView registerClass:[LCRankTableViewCell class] forCellReuseIdentifier:@"LCRankTableViewCell"];
        [_mainTableView registerClass:[LCRankTopThreeCell class] forCellReuseIdentifier:@"LCRankTopThreeCell"];
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
- (LCRankViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCRankViewModel new];
        _viewModel.isArchorList = self.isArchorList;
        _viewModel.type = self.type;
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
