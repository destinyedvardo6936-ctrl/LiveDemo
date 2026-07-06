//
//  LCLiveActivitysView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/10.
//

#import "LCLiveActivitysView.h"
#import "LCActivitySegmentViewModel.h"
#import <JXCategoryTitleView.h>
#import "LCLiveActivityTableViewCell.h"
@interface LCLiveActivitysView ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate,JXCategoryTitleViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIView *navView;
@property (nonatomic , weak) UIImageView *contentView;
@property (nonatomic , weak) UIActivityIndicatorView *loadingView;
@property (nonatomic , weak) UILabel *noDataLabel;
@property (nonatomic , weak) JXCategoryTitleView *segmentControl;
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCActivitySegmentViewModel *segViewModel;
@property (nonatomic , strong) LCActivityListViewModel *viewModel;
@end
@implementation LCLiveActivitysView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(195));
            make.left.bottom.right.equalTo(0);
        }];
        [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(0);
            make.height.equalTo(kUI_Width(44));
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            make.top.mas_equalTo(self.navView.mas_bottom);
        }];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(-kUI_Width(12)/2.0 - kUI_Width(5)/2.0);
            make.centerX.equalTo(0);
            make.height.width.equalTo(kUI_Width(30));
            
        }];
        [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loadingView.mas_bottom).offset(kUI_Width(5));
            make.centerX.equalTo(0);
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
        }];
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            make.top.equalTo(kUI_Width(38));
        }];
        self.mainTableView.hidden = YES;
        
        @weakify(self)
        [[[self.segViewModel rac_valuesAndChangesForKeyPath:@"currentIndex" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew observer:self ] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            
            self.viewModel.dataModel = self.segViewModel.channelDataArray[self.segmentControl.selectedIndex];
//            [self.mainTableView reloadData];
            [self.loadingView startAnimating];
            self.loadingView.hidden = NO;
            self.noDataLabel.text = KLanguage(@"正在加载");
            self.noDataLabel.hidden = NO;
            self.mainTableView.hidden = YES;
            [self.viewModel.loadDataCommend execute:@(YES)];
            

        }];
        [[self.segViewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            
    //        self.loadingView.hidden = YES;
            if ([x isKindOfClass:[NSError class]]) {
                NSError *er = x;
                [SVProgressHUD showErrorWithStatus:er.domain];
                return;
            }
          
            self.segmentControl.titles = self.segViewModel.channelTitleArray;
            
            [self.segmentControl reloadData];
            self.viewModel.dataModel = self.segViewModel.channelDataArray[self.segmentControl.selectedIndex];
//            [self.mainTableView reloadData];
            [self.loadingView startAnimating];
            self.loadingView.hidden = NO;
            self.noDataLabel.text = KLanguage(@"正在加载");
            self.noDataLabel.hidden = NO;
            self.mainTableView.hidden = YES;
            [self.viewModel.loadDataCommend execute:@(YES)];
            
        }];
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
            [self.loadingView stopAnimating];
            self.loadingView.hidden = YES;
            self.noDataLabel.text = KLanguage(@"正在加载");
            self.noDataLabel.hidden = YES;
           
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
            if(!self.viewModel.dataArray.count){
                [self.loadingView stopAnimating];
                self.loadingView.hidden = YES;
                self.noDataLabel.text = KLanguage(@"暂无数据");
                self.noDataLabel.hidden = NO;
                self.mainTableView.hidden = YES;
            }
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
      
        [self.segViewModel.loadDataCommend execute:@(YES)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonWithButton)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
- (void)leftButtonWithButton{
    if(self.dismissBlock){
        self.dismissBlock();
    }
    [self removeFromSuperview];
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if ([gestureRecognizer.view isDescendantOfView:self.contentView] && [gestureRecognizer isKindOfClass:<#(__unsafe_unretained Class)#>]) {
//    
//        return NO;
//    }
//    
//    return YES;
//}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
    
        return NO;
    }
    
    return YES;
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    self.isLoading = YES;
   [self.segViewModel.changeChannelIndexCommend execute:@(index)];
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kUI_Width(12);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"LCLiveActivityTableViewCell" configuration:^(LCLiveActivityTableViewCell * cell) {
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
    LCLiveActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCLiveActivityTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.dataModel = self.viewModel.dataArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCActivityModel *model = self.viewModel.dataArray[indexPath.section];
    if(self.activityClickBlock){
        self.activityClickBlock(model);
    }
    [self leftButtonWithButton];
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
//        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UIView *)navView{
    if(!_navView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        [self.backView addSubview:view];
        _navView = view;
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:image(@"ic_blackBack") forState:UIControlStateNormal];
        [backBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [_navView addSubview:backBtn];
        WS(weakSelf)
        [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf leftButtonWithButton];
        }];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = KLanguage(@"活动中心");
        label.font = RegularFont(18);
        label.textColor = Color(@"#333333");
        label.textAlignment = NSTextAlignmentCenter;
        [_navView addSubview:label];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(16));
            make.centerY.equalTo(0);
            make.height.width.equalTo(kUI_Width(20));
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(18));
            make.centerY.equalTo(0);
            make.left.equalTo(kUI_Width(30) + kUI_Width(16));
            make.right.equalTo(- (kUI_Width(30) + kUI_Width(16)));
        }];
        
    }
    return _navView;
}
- (UIImageView *)contentView{
    if(!_contentView){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveRoomActivitysBg")];
        [self.backView addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        _contentView = imgView;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = Color(@"#A79CED");
        [_contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(kUI_Width(38));
            make.height.equalTo(1);
        }];
        
    }
    return _contentView;
}
- (UIActivityIndicatorView *)loadingView{
    if(!_loadingView){
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        [self.contentView addSubview:view];
        _loadingView = view;
    }
    return _loadingView;
}
- (UILabel *)noDataLabel{
    if (_noDataLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.text = KLanguage(@"正在加载");
        label.textColor = Color(@"#FFFFFF ");
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _noDataLabel = label;
        
    }
    return _noDataLabel;
}
- (JXCategoryTitleView *)segmentControl{
    if (_segmentControl == nil) {
        JXCategoryTitleView *view = [[JXCategoryTitleView alloc]initWithFrame:CGRectZero];
        _segmentControl = view;
        _segmentControl.tag = 200;
        _segmentControl.delegate = self;
        _segmentControl.collectionView.scrollEnabled = NO;
        _segmentControl.titleDataSource = self;
//        _segmentControl.contentEdgeInsetLeft = kUI_Width(kViewMargin);
//        _segmentControl.contentEdgeInsetRight = kUI_Width(kViewMargin);
        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleCenter;
//        _segmentControl.titleLabelVerticalOffset = -kUI_Width(3);
        _segmentControl.titleFont = RegularFont(14);
        _segmentControl.titleSelectedFont = MediumFont(14);
        _segmentControl.titleColor = Color(@"#FFFFFF");
        _segmentControl.titleSelectedColor = Color(@"#FFFFFF ");
        _segmentControl.titleColorGradientEnabled = YES;

//        _segmentControl.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
//        _segmentControl.titleLabelVerticalOffset = _segmentControl.titleSelectedFont.lineHeight- _segmentControl.titleFont.lineHeight - kUI_Width(6);
       
        _segmentControl.titleColorGradientEnabled = YES;
//        _segmentControl.cellSpacing = kUI_Width(60);
                _segmentControl.averageCellSpacingEnabled = YES;
        
         
        _segmentControl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_segmentControl];

        
        _segmentControl.collectionView.scrollEnabled = NO;
        
    }
    return _segmentControl;
}

- (LCBaseTableView *)mainTableView{
    if (_mainTableView == nil){
        LCBaseTableView *tableView = [LCBaseTableView addTableGrouped];
        _mainTableView = tableView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_mainTableView];
        [_mainTableView registerClass:[LCLiveActivityTableViewCell class] forCellReuseIdentifier:@"LCLiveActivityTableViewCell"];
       
        WS(weakSelf)
//        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            
//            [weakSelf.viewModel.loadDataCommend execute:@(YES)];
//        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
          
                [weakSelf.viewModel.nextPageCommand execute:@(YES)];
            
        }];
        _mainTableView.mj_footer.hidden = YES;
    }
    return _mainTableView;
}
- (LCActivitySegmentViewModel *)segViewModel{
    if (_segViewModel == nil) {
        _segViewModel = [LCActivitySegmentViewModel new];
    }
    return _segViewModel;
}
- (LCActivityListViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCActivityListViewModel new];
        
    }
    return _viewModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
