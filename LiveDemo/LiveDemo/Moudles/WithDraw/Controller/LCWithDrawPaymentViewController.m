//
//  LCWithDrawViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCWithDrawPaymentViewController.h"
#import "LCTitleNoticeView.h"
#import "LCWithDrawPaymentCell.h"
#import "LCShelterGradientView.h"
#import "LCWithDrawPaymentViewModel.h"
#import "LCWithDrawViewController.h"
#import "LCCommonWebViewController.h"
@interface LCWithDrawPaymentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic, weak) LCShelterGradientView *noticeBackView;
@property (nonatomic, weak) LCTitleNoticeView *noticeView;
@property (nonatomic , strong) LCWithDrawPaymentViewModel *viewModel;
@end

@implementation LCWithDrawPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"提现")];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:KLanguage(@"提现记录") forState:UIControlStateNormal];
    [btn setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
    btn.titleLabel.font = RegularFont(14);
    [self.navView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - kUI_Width(14))/2.0);
        make.height.equalTo(kUI_Width(14));
        
    }];
    WS(weakSelf)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            //充值记录
        LCCommonWebViewController *con = [LCCommonWebViewController new];

        
        con.titleStr = KLanguage(@"提现记录");
        con.url = weakSelf.withDrawRecordUrl;
        [weakSelf pushToViewController:con];
    }];
    [self.noticeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(kUI_Width(10));
        make.left.equalTo(kUI_Width(kViewMargin));
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(28));
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.noticeBackView.mas_bottom).offset(kUI_Width(10));
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[self.viewModel.noticeSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        
        self.noticeView.dataArray = self.viewModel.noticeArray;
       
        

    }];
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
       
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainTableView.hidden = NO;
        
      
       
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        } ];
        
        
    }];
    [self.viewModel.loadDataCommend execute:@(YES)];
    [self.viewModel.noticeCommand execute:@(YES)];
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kUI_Width(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"LCWithDrawPaymentCell" configuration:^(LCWithDrawPaymentCell * cell) {
        
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCWithDrawPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCWithDrawPaymentCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataModel = self.viewModel.dataArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCWithDrawPaymentModel *model = self.viewModel.dataArray[indexPath.section];
    LCWithDrawViewController *con = [LCWithDrawViewController new];
    con.type = model.type;
    [self pushToViewController:con];
}
#pragma mark---- 懒加载 ----
- (LCShelterGradientView *)noticeBackView {
    if (_noticeBackView == nil) {
        LCShelterGradientView *view = [[LCShelterGradientView alloc] init];
        [self.view addSubview:view];
        view.clipsToBounds = YES;
        _noticeBackView = view;
        _noticeBackView.gradientLayer.startPoint = CGPointMake(1, 0.5);
        _noticeBackView.gradientLayer.endPoint = CGPointMake(0, 0.5);
        _noticeBackView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:253/255.0 green:181/255.0 blue:209/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:249/255.0 green:126/255.0 blue:165/255.0 alpha:1.0].CGColor];
        _noticeBackView.gradientLayer.locations = @[@(0), @(1.0f)];
        _noticeBackView.layer.cornerRadius = kUI_Width(4);
        _noticeBackView.layer.cornerRadius = kUI_Width(4);
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_homeNotice")];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(22));
            make.left.equalTo(kUI_Width(kViewMargin));
            make.centerY.equalTo(0);
        }];
        LCTitleNoticeView *noticeView = [[LCTitleNoticeView alloc]initWithFrame:CGRectZero];
        [view addSubview:noticeView];
        _noticeView = noticeView;
        [_noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.top.bottom.equalTo(0);
        }];
    }

    return _noticeBackView;
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
        [self.view addSubview:_mainTableView];
        [_mainTableView registerClass:[LCWithDrawPaymentCell class] forCellReuseIdentifier:@"LCWithDrawPaymentCell"];
       
        
    }
    return _mainTableView;
}
- (LCWithDrawPaymentViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCWithDrawPaymentViewModel new];
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
