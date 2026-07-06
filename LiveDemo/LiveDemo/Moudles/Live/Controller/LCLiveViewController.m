//
//  LCLiveViewController.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCLiveViewController.h"
#import "LCLiveViewModel.h"
#import "LCLiveDetailViewController.h"
@interface LCLiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCLiveViewModel *viewModel;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, LCLiveDetailViewController *> *validListDict;
@end

@implementation LCLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSInteger currentIndex = [self.viewModel.dataArray indexOfObject:self.viewModel.currentModel];
    LCLiveDetailViewController *currentCon = self.validListDict[@(currentIndex)];
            [currentCon pausePlayAndSocket];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSInteger currentIndex = [self.viewModel.dataArray indexOfObject:self.viewModel.currentModel];
    LCLiveDetailViewController *currentCon = self.validListDict[@(currentIndex)];
            [currentCon resumePlayAndSocket];
}
- (void)lc_addSubviews{
    self.needHiddenInteractivePopGestureRecognizer = YES;
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.index] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        } completion:^(BOOL finished) {
            self.viewModel.currentModel = self.viewModel.dataArray[self.index];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LCLiveDetailViewController *currentCon = self.validListDict[@(self.index)];
                        [currentCon startRequest];
            });
            
        }];
    });
    

   
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveNeedMakeScrollEnabled object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.mainTableView.scrollEnabled = [x.object boolValue];
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveSkipNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        LCHomeListModel *currentModel = x.object;
        if([self.viewModel.dataArray containsObject:currentModel]){
            NSInteger index = [self.viewModel.dataArray indexOfObject:currentModel];
            if(index < self.viewModel.dataArray.count - 1){
                [UIView animateWithDuration:0 animations:^{
                    [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index + 1] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                } completion:^(BOOL finished) {
                    LCLiveDetailViewController *con = self.validListDict[@(index)];
                                        [con releasePlayer];
                                        [con willMoveToParentViewController:nil];
                                        [con.view removeFromSuperview];
                                        [con removeFromParentViewController];
                                        [self.validListDict removeObjectForKey:@(index)];
                    self.viewModel.currentModel = self.viewModel.dataArray[index + 1];
                    
                    LCLiveDetailViewController *currentCon = self.validListDict[@(index+1)];
                            [currentCon startRequest];
                }];
               
               
            }else if(index == self.viewModel.dataArray.count - 1){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"没有更多直播间了")];
                [self popBack];
            }
        }
        
    }];
//    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCOtherLiveSelectNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
//        RACTuple *tuple = x.object;
//        NSArray *att = tuple[0];
//
//    }];
    [[self.viewModel.lastLivePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if([x isKindOfClass: NSError.class]){
            
            return;
        }
        if(!x){
            return;
        }

        NSIndexSet *indexPathArr = x;
       
        [self.mainTableView beginUpdates];
        [self.mainTableView insertSections:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
//        [self.mainTableView moveSection:0 toSection:3];
        [self.mainTableView endUpdates];
//        [UIView animateWithDuration:0 animations:^{
//                    if((indexPathArr.count * SCREEN_HEIGHT > self.mainTableView.contentOffset.y+self.mainTableView.height)||(indexPathArr.count * SCREEN_HEIGHT < self.mainTableView.contentOffset.y-self.mainTableView.height)){
//                        self.mainTableView.bounces = NO;
//                            // 设置contentOffset
//                            [self.mainTableView setContentOffset:CGPointMake(0,  indexPathArr.count * SCREEN_HEIGHT) animated:NO];
//                            // 再将bounces属性设置为YES
//                            self.mainTableView.bounces = YES;
//
//                    }else{
//                        self.mainTableView.contentOffset = CGPointMake(0,  indexPathArr.count * SCREEN_HEIGHT) ;
//                    }
//        } completion:^(BOOL finished) {
//            NSMutableArray *temp = [NSMutableArray array];
//            for (NSNumber *num in self.validListDict.allKeys) {
//                if(num.integerValue != indexPathArr.count){
//                    [temp addObject:num];
//                }
//
//            }
//            for (NSNumber *num in temp) {
//                LCLiveDetailViewController *con = self.validListDict[num];
//                                    [con releasePlayer];
//                                    [con willMoveToParentViewController:nil];
//                                    [con.view removeFromSuperview];
//                                    [con removeFromParentViewController];
//                                    [self.validListDict removeObjectForKey:num];
//            }
            self.viewModel.currentModel = self.viewModel.dataArray[indexPathArr.count];
            
            LCLiveDetailViewController *currentCon = self.validListDict[@(indexPathArr.count)];
                    [currentCon startRequest];
//        }];


//

    }];
    [[self.viewModel.nextLivePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if([x isKindOfClass: NSError.class]){
            
            return;
        }
        if(!x){
            return;
        }
        NSIndexSet *indexPathArr = x;
        
        [self.mainTableView beginUpdates];
        [self.mainTableView insertSections:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
        [self.mainTableView endUpdates];
    }];
    [[RACObserve(self.viewModel, currentModel) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger index = [self.viewModel.dataArray indexOfObject:x];
//        if(index == 0){
//            [self.viewModel.lastLivePageCommand execute:@(YES)];
//        }else
            if (index == self.viewModel.dataArray.count - 1){
            [self.viewModel.nextLivePageCommand execute:@(YES)];
        }
    }];
}

#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"创建cell indexpath:%ld",indexPath.section);
    LCBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveCell"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"即将展示cell indexpath:%ld",indexPath.section);
//    NSLog(@"当前section:%ld",indexPath.section);
    
    LCLiveDetailViewController *con = self.validListDict[@(indexPath.section)];
    if (!con){
//        NSLog(@"当前section:%ld不存在",indexPath.section);
        con = [LCLiveDetailViewController new];
        con.dataModel = self.viewModel.dataArray[indexPath.section];
        self.validListDict[@(indexPath.section)] = con;
    }
    [self addChildViewController:con];
    con.view.frame = cell.contentView.bounds;
   
    
       // 3. 添加子视图， 调用 addSubview
    [cell.contentView addSubview:con.view];
       // 4. 调用 didMoveToParentViewController
    [con didMoveToParentViewController:self];
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"已经结束展示cell indexpath:%ld",indexPath.section);
    LCLiveDetailViewController *con = self.validListDict[@(indexPath.section)];
    [con releasePlayer];
    [con willMoveToParentViewController:nil];
       [con.view removeFromSuperview];
       [con removeFromParentViewController];
    [self.validListDict removeObjectForKey:@(indexPath.section)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"结束减速");
    NSInteger lastIndex = [self.viewModel.dataArray indexOfObject:self.viewModel.currentModel];
    NSArray *visiableCells = [(UITableView *)scrollView indexPathsForVisibleRows];
    NSIndexPath *indexpath = [visiableCells firstObject];

   
    if(indexpath.section != lastIndex){
        self.viewModel.currentModel = self.viewModel.dataArray[indexpath.section];
    }
    if(lastIndex != indexpath.section){
        NSLog(@"当前滑动section:%ld销毁",lastIndex);
        LCLiveDetailViewController *con = self.validListDict[@(lastIndex)];
        [con releasePlayer];
        [con willMoveToParentViewController:nil];
        [con.view removeFromSuperview];
        [con removeFromParentViewController];
        [self.validListDict removeObjectForKey:@(lastIndex)];

        LCLiveDetailViewController *currentCon = self.validListDict[@(indexpath.section)];
        [currentCon startRequest];

    }
    
//    NSLog(@"当前section:%ld销毁",indexpath.section);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.isDragging /*|| scrollView.isTracking*/ || scrollView.isDecelerating) {
//        return;
//    }
//    NSLog(@"s是否正在拖拽%d",scrollView.isTracking);
//    NSLog(@"s是否正在减速%d",scrollView.isDecelerating);
    if(scrollView.isTracking || scrollView.isDecelerating||scrollView.isDragging){
        return;
    }
//    NSLog(@"滑动");
//    if(!self.viewModel.currentModel){
//        NSArray *visiableCells = [(UITableView *)scrollView indexPathsForVisibleRows];
//        NSIndexPath *indexpath = [visiableCells firstObject];
//
//        self.viewModel.currentModel = self.viewModel.dataArray[indexpath.section];
//        LCLiveDetailViewController *currentCon = self.validListDict[@(indexpath.section)];
//        [currentCon startRequest];
//    }else{
//        NSInteger lastIndex = [self.viewModel.dataArray indexOfObject:self.viewModel.currentModel];
//        NSArray *visiableCells = [(UITableView *)scrollView indexPathsForVisibleRows];
//        NSIndexPath *indexpath = [visiableCells firstObject];
//        if(lastIndex != indexpath.section){
//            self.viewModel.currentModel = self.viewModel.dataArray[indexpath.section];
//        }
//        LCLiveDetailViewController *currentCon = self.validListDict[@(indexpath.section)];
//        [currentCon startRequest];
//
//    }
//
       
    
}

#pragma mark---- 懒加载 ----
- (LCBaseTableView *)mainTableView{
    if (_mainTableView == nil){
        LCBaseTableView *tableView = [LCBaseTableView addTablePlain];
        _mainTableView = tableView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.pagingEnabled = YES;
        _mainTableView.bounces = NO;
        _mainTableView.backgroundColor = Color(@"#000000");
        [self.view addSubview:_mainTableView];
        [_mainTableView registerClass:[LCBaseTableViewCell class] forCellReuseIdentifier:@"LiveCell"];
        
//        WS(weakSelf)
//        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//            [weakSelf.viewModel.loadDataCommend execute:@(YES)];
//        }];
//        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//
//                [weakSelf.viewModel.nextPageCommand execute:@(YES)];
//
//        }];
//        _mainTableView.mj_footer.hidden = YES;
    }
    return _mainTableView;
}
- (NSMutableDictionary<NSNumber *,LCLiveDetailViewController *> *)validListDict{
    if (!_validListDict){
        _validListDict = [NSMutableDictionary dictionary];
    }
    return _validListDict;
}
- (LCLiveViewModel *)viewModel{
    if (_viewModel == nil){
        _viewModel = [LCLiveViewModel new];
        _viewModel.origalArr = self.dataArray;
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
