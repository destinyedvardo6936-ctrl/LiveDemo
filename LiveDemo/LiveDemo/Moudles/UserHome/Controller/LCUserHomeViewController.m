//
//  LCUserHomeViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCUserHomeViewController.h"
#import "LCUserHomeTableViewCell.h"
#import "LCUserHomeViewModel.h"
#import "LCFollowListViewController.h"
#import "LCFansListViewController.h"
#import "LCPersonalContributeRankViewController.h"
#import "LCLiveViewController.h"
#import "LCUpdatePersonalInfoViewController.h"
@interface LCUserHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , weak) UIImageView *userImgView;
@property (nonatomic , weak) UILabel *userNameLabel;
@property (nonatomic , weak) UILabel *levelLabel;
@property (nonatomic , weak) UIImageView *sexImgView;
@property (nonatomic , strong) LCUserHomeViewModel *viewModel;
@end

@implementation LCUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_Image];
    [self.navView setCustomLeftImageStr:@"icon_userHomeBack"];
    [self.navView setBottomBackgroundColor:[UIColor clearColor]];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainTableView.hidden = NO;
        [self createTableViewHeaderView];
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        }];
        
    }];
    self.mainTableView.hidden = YES;
    [self.viewModel.loadDataCommend execute:@(YES)];
}
-(void)createTableViewHeaderView{
    if(self.mainTableView.tableHeaderView){
        self.mainTableView.tableHeaderView = nil;
    }

    UIView *headerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, self.mainTableView.width, kNavBarHeight+kUI_Width(95)+kUI_Width(16)))];
    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.width, headerView.height)];
    [headerView addSubview:userImgView];
    _userImgView = userImgView;
    _userImgView.contentMode = UIViewContentModeScaleAspectFill;
 
    _userImgView.clipsToBounds = YES;
    _userImgView.layer.masksToBounds = YES;
    [_userImgView setImageStr:self.viewModel.dataModel.avatar_thumb];
    [userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.height.equalTo(headerView.height);
        make.width.equalTo(headerView.width);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.font = BoldFont(16);
//    nameLabel.text = @"纳兰性德";
    nameLabel.textColor = Color(@"#FFFFFF");
    [headerView addSubview:nameLabel];
    _userNameLabel = nameLabel;
    _userNameLabel.text = self.viewModel.dataModel.user_nicename;
    UIImageView *sexImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    sexImgView.image = image(@"icon_sexFamale");
    _sexImgView = sexImgView;
    [headerView addSubview:_sexImgView];
    if([self.viewModel.dataModel.sex isEqualToString:@"1"]){
        _sexImgView.image = image(@"icon_sexFamale");
    }else{
        _sexImgView.image = image(@"icon_sexWomen");
    }
   
    UIImageView *levelBackImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    levelBackImgView.image = image(@"icon_rankLevelBackImg");
   
    [headerView addSubview:levelBackImgView];
    
    
    UIImageView *levelImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    levelImgView.image = image(@"icon_rankLevelImg1");
   
    [levelBackImgView addSubview:levelImgView];
   
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    levelLabel.font = MediumFont(10);
    levelLabel.textColor = Color(@"#FFFFFF");
    levelLabel.textAlignment = NSTextAlignmentCenter;
    [levelBackImgView addSubview:levelLabel];
    _levelLabel = levelLabel;
    _levelLabel.text = self.viewModel.dataModel.level;
    UIButton *accessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessBtn setImage:image(@"icon_mineUserInfoAcess") forState:UIControlStateNormal];
    [headerView addSubview:accessBtn];
    accessBtn.hidden = ![self.userId isEqualToString:[LCUserInfoManager shareManager].userInfo.ID];
    WS(weakSelf)
    [[accessBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        LCUpdatePersonalInfoViewController *con = [LCUpdatePersonalInfoViewController new];
        [weakSelf pushToViewController:con];
    }];
    UIImageView *gifImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:gifImgView];
    gifImgView.hidden = ![self.viewModel.dataModel.islive boolValue];
    
    gifImgView.contentMode = UIViewContentModeScaleAspectFill;
    gifImgView.userInteractionEnabled = YES;
  
    gifImgView.animationImages = @[image(@"icon_userHomeOnLiveImg1"),image(@"icon_userHomeOnLiveImg2"),image(@"icon_userHomeOnLiveImg3"),image(@"icon_userHomeOnLiveImg4")];
    gifImgView.animationDuration = 0.8;                //设置帧动画时长
    gifImgView.animationRepeatCount = 0;
//        [_gifImgView startAnimating];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
       //进直播间
        LCLiveViewController *con = [LCLiveViewController new];
        NSMutableArray *temp = [NSMutableArray array];
        if(!weakSelf.viewModel.dataModel.live.user_nicename.length){
            weakSelf.viewModel.dataModel.live.user_nicename = weakSelf.viewModel.dataModel.user_nicename;
        }
        [temp addObject:weakSelf.viewModel.dataModel.live];

        con.dataArray = temp;
        con.index = 0;

        [weakSelf pushToViewController:con];
    }];
    [gifImgView addGestureRecognizer:tap];
    if(self.viewModel.dataModel.islive){
        [gifImgView startAnimating];
    }
    [sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(kUI_Width(14));
        make.left.equalTo(kUI_Width(12));
        make.bottom.equalTo(-kUI_Width(13));
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(12));
        make.bottom.mas_equalTo(sexImgView.mas_top).offset(-kUI_Width(13));
        make.height.equalTo(kUI_Width(16));
        make.right.equalTo(-kUI_Width(12));
    }];
    [levelBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kUI_Width(34));
        make.height.equalTo(kUI_Width(16));
        make.left.mas_equalTo(sexImgView.mas_right).offset(kUI_Width(6));
        make.centerY.mas_equalTo(sexImgView.mas_centerY);
    }];
    [levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.width.height.equalTo(kUI_Width(12));
        make.left.equalTo(kUI_Width(4));
    }];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(levelImgView.mas_right).offset(kUI_Width(3));
        make.right.equalTo(-kUI_Width(3));
        make.top.bottom.equalTo(0);
    }];
    [gifImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-kUI_Width(8));
        make.right.equalTo(-kUI_Width(12));
        make.width.equalTo(kUI_Width(56));
        make.height.equalTo(kUI_Width(20));
    }];
    [accessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(kUI_Width(14));
        make.right.mas_equalTo(gifImgView.mas_left).offset(-kUI_Width(kViewMargin));
        make.centerY.mas_equalTo(gifImgView.mas_centerY);
    }];
    self.mainTableView.tableHeaderView = headerView;
 
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat Offset_y = scrollView.contentOffset.y;
        // 下拉 纵向偏移量变小 变成负的
        if ( Offset_y < 0) {
            // 拉伸后图片的高度
            CGFloat totalOffset = kNavBarHeight+kUI_Width(95)+kUI_Width(16) - Offset_y;
            // 图片放大比例
            CGFloat scale = totalOffset / (kNavBarHeight+kUI_Width(95)+kUI_Width(16));
           
            // 拉伸后图片位置
            self.userImgView.transform = CGAffineTransformMakeScale(scale, scale);
            
        }else{
            self.userImgView.transform = CGAffineTransformIdentity;
        }
 
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kUI_Width(28) * 2+kUI_Width(38);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"LCUserHomeTableViewCell" configuration:^(LCUserHomeTableViewCell * cell) {
        cell.dataModel = self.viewModel.dataModel;
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(28) * 2+kUI_Width(38))];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image(@"icon_userHomeFollowNormal") forState:UIControlStateNormal];
    [btn setBackgroundImage:image(@"icon_userHomeFollowSelected") forState:UIControlStateSelected];
    [btn setTitle:KLanguage(@"关注") forState:UIControlStateNormal];
    [btn setTitle:KLanguage(@"取消关注") forState:UIControlStateSelected];
    btn.titleLabel.font = MediumFont(14);
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(kUI_Width(118));
        make.height.equalTo(kUI_Width(38));
        make.top.equalTo(kUI_Width(28));
    }];
    btn.selected = [self.viewModel.dataModel.isattention boolValue];
    WS(weakSelf)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.viewModel.followCommand execute:weakSelf.viewModel.dataModel];
    }];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserHomeTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataModel = self.viewModel.dataModel;
    WS(weakSelf)
    [[cell.followClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        LCFollowListViewController *con = [LCFollowListViewController new];
        con.userId = weakSelf.viewModel.dataModel.modelId;
        [weakSelf pushToViewController:con];
    }];
    [[cell.fansClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        LCFansListViewController *con = [LCFansListViewController new];
        con.userId = weakSelf.viewModel.dataModel.modelId;
        [weakSelf pushToViewController:con];
    }];
    [[cell.contributeClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        LCPersonalContributeRankViewController *con = [LCPersonalContributeRankViewController new];
        con.userId = weakSelf.viewModel.dataModel.modelId;
        [weakSelf pushToViewController:con];
    }];
    return cell;
}

#pragma mark---- 懒加载 ----
- (LCUserHomeViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [LCUserHomeViewModel new];
        _viewModel.userId = self.userId;
    }
    return _viewModel;
}




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
        [_mainTableView registerClass:[LCUserHomeTableViewCell class] forCellReuseIdentifier:@"LCUserHomeTableViewCell"];
        
        
    }
    return _mainTableView;
}

@end
