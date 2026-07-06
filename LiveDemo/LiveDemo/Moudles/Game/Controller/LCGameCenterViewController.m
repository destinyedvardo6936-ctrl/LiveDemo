//
//  LCGameCenterViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCGameCenterViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LCTitleNoticeView.h"
#import "LCShelterGradientView.h"
#import "LCGameTypeTableViewCell.h"
#import "LCGameCenterViewModel.h"
#import "LCGameCollectionListCell.h"
#import "LCCommonWebViewController.h"
#import "LCLotteryTicketPlayViewController.h"
#import "LCRechageViewController.h"
#import "LCWithDrawPaymentViewController.h"
#import "LCActivitysViewController.h"
#import "ChessCardWebVC.h"
#import "QuotaConversionVC.h"
#import "LCBindPhoneViewController.h"
#import "LCGameCenterHeaderView.h"
#import "LCBettingRecordPageViewController.h"


@interface LCGameCenterViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) SDCycleScrollView *bannerView;
@property (nonatomic , weak) LCShelterGradientView *noticeBackView;
@property (nonatomic, weak) LCTitleNoticeView *noticeView;
@property (nonatomic , weak) UIView *balanceBackView;
@property (nonatomic , weak) UILabel *nameLabel;
@property (nonatomic , weak) UILabel *balanceLabel;
@property (nonatomic , weak) LCBaseTableView *leftTableView;
@property (nonatomic , weak) LCBaseCollectionView *rightCollectionView;

@property (nonatomic , strong) LCGameCenterViewModel *viewModel;
@end

@implementation LCGameCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    
    [self.navView setLeftButtonType: self.needBack? LCBaseNavigationViewLeftType_BlackBack: LCBaseNavigationViewLeftType_None];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"游戏中心")];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    UIButton *rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankBtn setBackgroundColor:Color(@"#F7F6FA")];
    rankBtn.layer.cornerRadius = kUI_Width(30)/2.0;
  WS(weakSelf)
    [[rankBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        LCCommonWebViewController *con = [LCCommonWebViewController new];
        
        con.titleStr = KLanguage(@"客服");
        con.url = [LCConfigManager shareManager].kefuUrl;
        [weakSelf pushToViewController:con];
    }];
    [self.navView addSubview:rankBtn];
    UIImageView *rankImgView = [[UIImageView  alloc]initWithImage:image(@"icon_navKeFuImg")];
    [rankBtn addSubview:rankImgView];
    UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    rankLabel.font = BoldFont(16);
    rankLabel.textColor = Color(@"#AF93FD");
    rankLabel.text = KLanguage(@"客服");
    [rankBtn addSubview:rankLabel];
    [rankImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(kUI_Width(28));
        make.left.equalTo(kUI_Width(10));
        make.centerY.equalTo(0);
    }];
    [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kUI_Width(16));
        make.centerY.equalTo(0);
        make.left.mas_equalTo(rankImgView.mas_right).offset(kUI_Width(3));
        make.width.lessThanOrEqualTo(kUI_Width(40));
        make.right.equalTo(-kUI_Width(9));
    }];

    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - kUI_Width(30))/2.0);
//        make.width.equalTo(kUI_Width(80));
        make.height.equalTo(kUI_Width(30));
    }];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(12));
        make.right.equalTo(-kUI_Width(12));
        make.top.mas_equalTo(self.navView.mas_bottom).offset(kUI_Width(10));
        make.height.equalTo(kUI_Width(134));
    }];
    [self.noticeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kUI_Width(28));
        make.left.equalTo(kUI_Width(12));
        make.right.equalTo(-kUI_Width(12));
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(kUI_Width(10));
    }];
    [self.balanceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kUI_Width(63));
        make.left.equalTo(kUI_Width(12));
        make.right.equalTo(-kUI_Width(12));
        make.top.mas_equalTo(self.noticeBackView.mas_bottom).offset(kUI_Width(10));
    }];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(8));
        make.width.equalTo(kUI_Width(60));
        make.top.mas_equalTo(self.balanceBackView.mas_bottom).offset(kUI_Width(6));
        make.bottom.equalTo(0);
    }];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTableView.mas_right).offset(kUI_Width(6));
        make.right.equalTo(-kUI_Width(11));
        make.top.mas_equalTo(self.balanceBackView.mas_bottom).offset(kUI_Width(10));
        make.bottom.equalTo(0);
    }];
    // 注册截屏监听器
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        LCLog(@"x:%@",x);
    }];
}
- (void)lc_bindViewModel{
    @weakify(self)
//    [[[self.viewModel rac_valuesAndChangesForKeyPath:@"currentIndex" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew observer:self ] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
//        @strongify(self)
//
//
//
//        [self.segmentControl selectItemAtIndex:self.viewModel.currentIndex];
//
//
//    }];
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        [self.leftTableView reloadData];
        
        
        
    }];
    [[self.viewModel.gameListSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        [self.rightCollectionView reloadData];
        
        
    }];
    [[self.viewModel.noticeSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.noticeView.dataArray = self.viewModel.noticeArray;
        
    }];
    [[self.viewModel.thirdGameTypeSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        [self.viewModel.gameListCommand execute:@(YES)];

      
     
        
    }];
    [[self.viewModel.bannerSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
//        self.loadingView.hidden = YES;
//        if ([x isKindOfClass:[NSError class]]) {
//            NSError *er = x;
//            [SVProgressHUD showErrorWithStatus:er.domain];
//            return;
//        }
        NSMutableArray *imageArr = [NSMutableArray array];
        for (LCBannerModel *model in self.viewModel.bannerArray) {
            [imageArr addObject:model.slide_pic];
        }
        self.bannerView.imageURLStringsGroup = imageArr;
        
    }];
    [[self.viewModel.enterThirdGameSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        [SVProgressHUD dismiss];
        if([x isKindOfClass:NSDictionary.class]){
            NSDictionary *dic = x[@"info"];
            ChessCardWebVC *webVC = [[ChessCardWebVC alloc]init];
            webVC.url=dic[@"purl"];
            webVC.biaoshi = dic[@"biaoshi"];
            webVC.titleStr=minstr(dic[@"name"]) ;
            webVC.push=minstr(dic[@"balance"]) ;
            webVC.coin = minstr(dic[@"coin"]);
            [self pushToViewController:webVC];
        }
       
        
        
    }];
    [[self.viewModel.balanceSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        

        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        if([SVProgressHUD isVisible]){
            [SVProgressHUD showNoMaskViewWithSuccess:KLanguage(@"已更新")];
        }
       
        
    }];
    [[self.viewModel.huishouSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        

        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        NSDictionary *dic = x;
        
            [SVProgressHUD showNoMaskViewWithSuccess:dic[@"msg"]];
//        [self.viewModel.balanceCommand execute:@(YES)];
        
       
        
    }];
    RAC(self.balanceLabel,text) = [RACObserve(self.viewModel, balanceStr) takeUntil:self.rac_willDeallocSignal];
   
    
}
- (void)lc_updatePageNewData{
    [self.viewModel.loadDataCommend execute:@(YES)];
    [self.viewModel.noticeCommand execute:@(YES)];
    [self.viewModel.balanceCommand execute:@(YES)];
    [self.viewModel.bannerCommand execute:@(YES)];
}
- (UIButton *)createBtnWithTitle:(NSString *)title image:(NSString *)imgaeName{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image(@"icon_gameOpitionBgImg") forState:UIControlStateNormal];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image(imgaeName)];
    [btn addSubview:imgView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = RegularFont(12);
    label.textColor = Color(@"#6F5AA2");
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:label];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kUI_Width(3));
        make.width.height.equalTo(kUI_Width(30));
        make.centerX.equalTo(0);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(kUI_Width(12));
        make.top.mas_equalTo(imgView.mas_bottom);
//        make.bottom.equalTo(0);
    }];
    return btn;
}

#pragma mark---- SDCycleScrollViewDelegate ----
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    LCCommonWebViewController *con = [LCCommonWebViewController new];
    LCBannerModel *banner = [self.viewModel.bannerArray objectAtIndex:index];
//            con.titleStr = banner.
    con.url = banner.slide_url;
    [self pushToViewController:con];
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kUI_Width(4);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_Width(60);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCGameTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCGameTypeTableViewCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.dataModel = self.viewModel.dataArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.viewModel.selectTypeModel.isSelected = NO;
    self.viewModel.selectTypeModel = self.viewModel.dataArray[indexPath.section];
    self.viewModel.selectTypeModel.isSelected = YES;
    if([self.viewModel.selectTypeModel.modelId isEqualToString:@"0"]){
        if(self.viewModel.selectTypeModel.dataArray.count){
            [self.rightCollectionView reloadData];
        }else{
            [self.viewModel.gameListCommand execute:@(YES)];
        }
    }else{
        if(self.viewModel.selectTypeModel.typeArray.count){
            
            [self.viewModel.gameListCommand execute:@(YES)];
            
            
        }else{
            [self.viewModel.thirdGameTypeCommand execute:@(YES)];
        }
    }
    
}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.selectTypeModel.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([self.viewModel.selectTypeModel.modelId isEqualToString:@"0"] && section == 0){
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.width, kUI_Width(28) + kUI_Width(10) * 2);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCGameListModel *model = self.viewModel.selectTypeModel.dataArray[indexPath.item];
    if(model.pailietype.intValue == 1){
        return CGSizeMake(kUI_Width(140) * 2, kUI_Width(100));
    }
    return CGSizeMake(kUI_Width(140), kUI_Width(140));
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([self.viewModel.selectTypeModel.modelId isEqualToString:@"0"] && indexPath.section == 0){
        return nil;
    }
    LCGameCenterHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCGameCenterHeaderView" forIndexPath:indexPath];
    view.dataArray = self.viewModel.selectTypeModel.typeArray;
    view.selectTypeModel = self.viewModel.selectTypeModel.selectTypeModel;
    WS(weakSelf)
    view.subTypeClickBlock = ^(LCGameSubTypeModel * _Nonnull selectModel) {
        weakSelf.viewModel.selectTypeModel.selectTypeModel = selectModel;
        [weakSelf.viewModel.gameListCommand execute:@(YES)];
    };
    
    return view;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kUI_Width(9);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
  
    return (collectionView.width - kUI_Width(140) * 2);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCGameCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCGameCollectionListCell" forIndexPath:indexPath];
    cell.backgroundColor = collectionView.backgroundColor;
    cell.contentView.backgroundColor = collectionView.backgroundColor;
    cell.dataModel = self.viewModel.selectTypeModel.dataArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LCGameListModel *model = self.viewModel.selectTypeModel.dataArray[indexPath.item];
    if(model.ismy == 1){
        LCLotteryTicketPlayViewController *con = [LCLotteryTicketPlayViewController new];
        con.dataModel = model;
        [self pushToViewController:con];
    }else{
//        if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
//            [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//                if(buttonIndex == controller.destructiveButtonIndex){
//                    LCBindPhoneViewController *con = [LCBindPhoneViewController new];
//                    [self pushToViewController:con];
//                }
//            }];
//            return;
//        }
        [SVProgressHUD showWithMaskView];
        [self.viewModel.enterThirdGameCommand execute:model];
    }
    
}
#pragma mark---- 懒加载 ----
- (SDCycleScrollView *)bannerView{
    if (_bannerView == nil){
        SDCycleScrollView *bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectZero];
        bannerView.delegate = self;
        bannerView.backgroundColor = [UIColor clearColor];
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        [self.view addSubview:bannerView];
        bannerView.hidesForSinglePage = YES;
        bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        bannerView.autoScrollTimeInterval = 3.0;//轮播时间间隔，默认1.0秒，可自定义
        bannerView.currentPageDotColor = Color(@"#E5407B");
        bannerView.pageDotColor = Color(@"#FFFFFF");
        bannerView.pageControlDotSize = CGSizeMake(kUI_Width(3), kUI_Width(3));
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _bannerView = bannerView;
    }
    return _bannerView;
}
- (LCShelterGradientView *)noticeBackView{
    if(!_noticeBackView){
        LCShelterGradientView *noticeBackView = [[LCShelterGradientView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:noticeBackView];
        noticeBackView.clipsToBounds = YES;
        noticeBackView.gradientLayer.startPoint = CGPointMake(1, 0.5);
        noticeBackView.gradientLayer.endPoint = CGPointMake(0, 0.5);
        noticeBackView.gradientLayer.colors = @[(__bridge id)Color(@"#FFFFFF").CGColor, (__bridge id)Color(@"#EBE3FB").CGColor];
        noticeBackView.gradientLayer.locations = @[@(0), @(1.0f)];
        noticeBackView.layer.cornerRadius = kUI_Width(4);
        

        _noticeBackView = noticeBackView;
        
        UIImageView *noticeImgView = [[UIImageView alloc]initWithImage:image(@"icon_gameNoticeImg")];
        noticeImgView.contentMode = UIViewContentModeScaleAspectFill;
        [noticeBackView addSubview:noticeImgView];
        
        
        LCTitleNoticeView *noticeView = [[LCTitleNoticeView alloc]initWithFrame:CGRectZero];
        noticeView.cusTextColor = Color(@"#333333");
        [noticeBackView addSubview:noticeView];
        _noticeView = noticeView;
        
        UIButton *rechageRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechageRecordBtn setBackgroundImage:image(@"icon_gameRecordBgImg") forState:UIControlStateNormal];
        [noticeBackView addSubview:rechageRecordBtn];
        UILabel *rechargeLabel = [[UILabel alloc ]initWithFrame:CGRectZero];
        rechargeLabel.font = RegularFont(10);
        rechargeLabel.textColor = Color(@"#FFFFFF");
        rechargeLabel.text = KLanguage(@"投注记录");
//        rechargeLabel.textAlignment =
        [rechageRecordBtn addSubview:rechargeLabel];
        WS(weakSelf)
        [[rechageRecordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
//                [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//                    if(buttonIndex == controller.destructiveButtonIndex){
//                        LCBindPhoneViewController *con = [LCBindPhoneViewController new];
//                        [weakSelf pushToViewController:con];
//                    }
//                }];
//                return;
//            }
            //投注记录
            LCBettingRecordPageViewController *con = [LCBettingRecordPageViewController new];
            [weakSelf pushToViewController:con];
        }];
//        noticeView.dataArray = self.viewModel.noticeArray;
        [noticeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(22));
            make.left.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
        }];
        [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(noticeImgView.mas_right).offset(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(12));
            make.top.bottom.equalTo(0);
        }];
        [rechageRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(4));
            make.width.equalTo(kUI_Width(66));
            make.height.equalTo(kUI_Width(20));
            make.centerY.equalTo(0);
        }];
        [rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(20));
            make.top.bottom.equalTo(0);
            make.right.equalTo(0);
        }];
    }
    return _noticeBackView;
}
- (UIView *)balanceBackView{
    if(!_balanceBackView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#F4F1FF");
        view.layer.cornerRadius = kUI_Width(4);
        view.layer.shadowColor = Color(@"#E7DCFD").CGColor;
        view.layer.shadowOffset = CGSizeMake(0,-1);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 1;
        [self.view addSubview:view];
        _balanceBackView = view;
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameLabel.font = MediumFont(12);
        nameLabel.textColor = Color(@"#333333");
        nameLabel.text = [LCUserInfoManager shareManager].userInfo.user_nicename;
        [_balanceBackView addSubview:nameLabel];
        _nameLabel = nameLabel;
        UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        balanceLabel.font = BoldFont(14);
        balanceLabel.textColor = Color(@"#333333");
        [balanceLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [balanceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_balanceBackView addSubview:balanceLabel];
        _balanceLabel = balanceLabel;
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshBtn setImage:image(@"icon_gameRefreshBalanceImg") forState:UIControlStateNormal];
        [_balanceBackView addSubview:refreshBtn];
        WS(weakSelf)
        [[refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [SVProgressHUD show];
            [weakSelf.viewModel.balanceCommand execute:@(YES)];
        }];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = Color(@"#D8D8D8");
        [_balanceBackView addSubview:lineView];
        UIButton *walletBtn = [self createBtnWithTitle:KLanguage(@"存款") image:@"icon_gameOptionBalanceImg"];
        
        [_balanceBackView addSubview:walletBtn];
        
        [[walletBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            LCRechageViewController *con = [LCRechageViewController new];
            con.needBack = YES;
            [weakSelf pushToViewController:con];
        }];
        UIButton *withdrawalBtn = [self createBtnWithTitle:KLanguage(@"提现") image:@"icon_gameOptionWithDrawImg"];
        [_balanceBackView addSubview:withdrawalBtn];
        [[withdrawalBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            LCWithDrawPaymentViewController *con = [LCWithDrawPaymentViewController new];
            [weakSelf pushToViewController:con];
        }];
        UIButton *nobleBtn = [self createBtnWithTitle:KLanguage(@"优惠") image:@"icon_gameOptionDiscountImg"];
        [_balanceBackView addSubview:nobleBtn];
        [[nobleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            LCActivitysViewController *con = [LCActivitysViewController new];
            con.needBack = YES;
            [weakSelf pushToViewController:con];
        }];
        UIButton *activityBtn = [self createBtnWithTitle:KLanguage(@"一键归集") image:@"icon_gameOptionRecordImg"];
        [_balanceBackView addSubview:activityBtn];
        [[activityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [SVProgressHUD show];
            [weakSelf.viewModel.huishouCommand execute:@(YES)];
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(100));
            make.width.equalTo(1);
            make.top.equalTo(kUI_Width(9));
            make.bottom.equalTo(-kUI_Width(9));
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(10));
            make.right.mas_equalTo(lineView.mas_left).offset(-kUI_Width(6));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(13));
        }];
        [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(10));
            make.right.mas_lessThanOrEqualTo(lineView.mas_left).offset(-kUI_Width(6)-kUI_Width(20));
            make.height.equalTo(kUI_Width(14));
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(kUI_Width(11));
        }];
        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(balanceLabel.mas_right).offset(kUI_Width(6));
            make.width.height.equalTo(kUI_Width(16));
            make.centerY.mas_equalTo(balanceLabel.mas_centerY);
        }];
        
        [walletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(53));
            make.centerY.equalTo(0);
            make.left.mas_equalTo(lineView.mas_right).offset(kUI_Width(7));
            
        }];
        [withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(53));
            make.centerY.equalTo(0);
            make.left.mas_equalTo(walletBtn.mas_right).offset(kUI_Width(7));
            
        }];
        [nobleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(53));
            make.centerY.equalTo(0);
            make.left.mas_equalTo(withdrawalBtn.mas_right).offset(kUI_Width(7));
            
        }];
        [activityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(53));
            make.centerY.equalTo(0);
            make.left.mas_equalTo(nobleBtn.mas_right).offset(kUI_Width(7));

        }];
        
    }
    return _balanceBackView;
}
- (LCBaseTableView *)leftTableView{
    if(!_leftTableView){
        LCBaseTableView *tableView = [LCBaseTableView addTableGrouped];
        _leftTableView = tableView;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_leftTableView];
        [_leftTableView registerClass:[LCGameTypeTableViewCell class] forCellReuseIdentifier:@"LCGameTypeTableViewCell"];

    }
    return _leftTableView;
}
- (LCBaseCollectionView *)rightCollectionView{
    if(!_rightCollectionView){
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        collectionLayout.itemSize = CGSizeMake(kUI_Width(140), kUI_Width(140));
//        collectionLayout.minimumLineSpacing = kUI_Width(9);
//        collectionLayout.minimumInteritemSpacing = kUI_Width(8);

        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _rightCollectionView = collectionView;
        
//        _rightCollectionView.contentInset = UIEdgeInsetsMake(kUI_Width(10), kUI_Width(12), kUI_Width(10), kUI_Width(12));
//
//        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, (SCREEN_WIDTH-60-btnWidth*3)/2, 15,  (SCREEN_WIDTH-60-btnWidth*3)/2);
//        _mainCollectionView.scrollEnabled = NO;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.delegate = self;
        _rightCollectionView.backgroundColor = [UIColor clearColor];
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_rightCollectionView];
        [_rightCollectionView registerClass:[LCGameCollectionListCell class] forCellWithReuseIdentifier:@"LCGameCollectionListCell"];
        [_rightCollectionView registerClass:[LCGameCenterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCGameCenterHeaderView"];
        
    }
    return _rightCollectionView;
}
- (LCGameCenterViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCGameCenterViewModel new];
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
