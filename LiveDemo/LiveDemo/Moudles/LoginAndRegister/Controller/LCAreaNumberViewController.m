//
//  LCAreaNumberViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/30.
//

#import "LCAreaNumberViewController.h"
#import "LCAreaNumberTableViewCell.h"
#import "LCAreaNumberViewModel.h"
#import "MJNIndexView.h"
#import "LCAreaNumberHeaderView.h"
@interface LCAreaNumberViewController ()<UITableViewDelegate,UITableViewDataSource,MJNIndexViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
//索引
@property(nonatomic, weak) MJNIndexView *indexView;
@property (nonatomic , strong) LCAreaNumberViewModel *viewModel;
@end

@implementation LCAreaNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelText:KLanguage(@"区号选择")];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(0);
    }];
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(0);
    }];
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[self.viewModel.loadDataLoadingSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSError class]]) {
            NSError *error = x;
            [SVProgressHUD showNoMaskViewWithFailure:error.domain];
            
            return;
        }
        
       
        [self.mainTableView reloadData];
        [self.indexView refreshIndexItems];
    }];
    
    
    [self.viewModel.loadDataCommend execute:@(YES)];
}
#pragma mark ---tableView delegate---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel.dataArray.count > 0) {
        return self.viewModel.dataArray.count;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.viewModel.dataArray.count) {

        LCAreaNumberSectionModel *sectionModel = self.viewModel.dataArray[section];
        return sectionModel.lists.count;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kUI_Width(34);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kUI_Width(37);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LCAreaNumberHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LCAreaNumberHeaderView"];
    headView.backgroundColor = tableView.backgroundColor;
    headView.contentView.backgroundColor = tableView.backgroundColor;
    LCAreaNumberSectionModel *model =self.viewModel.dataArray[section];
    headView.titleStr = model.title;
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCAreaNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCAreaNumberTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    LCAreaNumberSectionModel *sectionModel = self.viewModel.dataArray[indexPath.section];
    if (indexPath.row < sectionModel.lists.count) {
        LCAreaNumberModel *brandModel = sectionModel.lists[indexPath.row];
        cell.dataModel = brandModel;
    }



    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCAreaNumberSectionModel *sectionModel = self.viewModel.dataArray[indexPath.section];
    if (indexPath.row < sectionModel.lists.count) {

        LCAreaNumberModel *brandModel = sectionModel.lists[indexPath.row];
        [self.selectSubject sendNext:brandModel];
        [self popBack];
    }

}
#pragma mark - MJNIndexViewDataSource

- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (LCAreaNumberSectionModel *sectionModel in self.viewModel.dataArray) {
        [titles addObject:[NSString stringWithFormat:@"%@", sectionModel.title]];
    }
    return titles;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0
                                                     inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
        [_mainTableView registerClass:[LCAreaNumberTableViewCell class] forCellReuseIdentifier:@"LCAreaNumberTableViewCell"];
        [_mainTableView registerClass:[LCAreaNumberHeaderView class] forHeaderFooterViewReuseIdentifier:@"LCAreaNumberHeaderView"];
        
    }
    return _mainTableView;
}
- (MJNIndexView *)indexView {
    if (!_indexView) {

        MJNIndexView *indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _indexView = indexView;
        _indexView.backgroundColor = [UIColor clearColor];
        _indexView.dataSource = self;
        _indexView.selectedItemFontColor = Color(@"#738CC2");
        _indexView.fontColor = Color(@"#666666");
        _indexView.font = BoldFont(14);
        _indexView.selectedItemFont = BoldFont(16);
        _indexView.itemsAligment = NSTextAlignmentCenter;
        _indexView.curtainFade = 0.0;
        _indexView.rightMargin = kUI_Width(12);
        _indexView.maxItemDeflection = 75;
        _indexView.rangeOfDeflection = 3;
        _indexView.darkening = NO;
//        _indexView.hidden = YES;
        [self.view addSubview:_indexView];
    }
    return _indexView;
}
- (LCAreaNumberViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCAreaNumberViewModel new];
    }
    return _viewModel;
}
    - (RACSubject *)selectSubject{
        if(_selectSubject == nil){
            _selectSubject = [RACSubject subject];
        }
        return _selectSubject;
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
