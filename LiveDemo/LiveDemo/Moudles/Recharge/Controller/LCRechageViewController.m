//
//  LCRechageViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCRechageViewController.h"
#import "LCTitleNoticeView.h"
#import <JXPagerListRefreshView.h>
#import "LCShelterGradientView.h"
#import "LCRechargeTypeCollectionViewCell.h"
#import "LCRechargeTypeViewModel.h"
#import "LCRechargeSubViewController.h"
#import "LCRechargeAgentViewController.h"
#import "LCRechargeVirtualCurrencyViewController.h"
#import "LCRechargeBankViewController.h"
#import "LCCommonWebViewController.h"
#import "LCBindPhoneViewController.h"
@interface LCRechageViewController ()< JXPagerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , weak) UIButton *kefuBtn;

@property (nonatomic , strong) LCBaseCollectionView *rechargeTypeCollectionView;
@property (nonatomic, weak) JXPagerListRefreshView *pagerView;
@property (nonatomic , strong) LCRechargeTypeViewModel *viewModel;
@end

@implementation LCRechageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)lc_addSubviews{
    [self.navView setLeftButtonType:self.needBack ? LCBaseNavigationViewLeftType_BlackBack: LCBaseNavigationViewLeftType_None];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"充值中心")];
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
        make.width.lessThanOrEqualTo(kUI_Width(40));
        make.left.mas_equalTo(rankImgView.mas_right).offset(kUI_Width(3));
        make.right.equalTo(-kUI_Width(9));
    }];
    _kefuBtn = rankBtn;
    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.top.equalTo(kStatusBarHeight + (kNavBarHeight - kStatusBarHeight - kUI_Width(30))/2.0);
        
//        make.width.equalTo(kUI_Width(80));
        make.height.equalTo(kUI_Width(30));
    }];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
    
   
    
    
   
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        
        [self.rechargeTypeCollectionView reloadData];
        [self.pagerView reloadData];
       
        

    }];
    [[self.viewModel.balanceSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        
        [self.rechargeTypeCollectionView reloadData];
        [self.pagerView reloadData];
       
        

    }];
    [[self.viewModel.noticeSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        
        [self.rechargeTypeCollectionView reloadData];
        [self.pagerView reloadData];
       
        

    }];
    [[RACObserve(self.viewModel, currentIndex) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *  _Nullable x) {
        CGFloat scrollViewWidth = self.pagerView.listContainerView.scrollView.bounds.size.width;
        [self.pagerView.listContainerView.scrollView setContentOffset:CGPointMake(scrollViewWidth *[x integerValue], 0) animated:YES];
        [self.pagerView.listContainerView didClickSelectedItemAtIndex:[x integerValue]];
    }];
//    [self.viewModel.loadDataCommend execute:@(YES)];
//    [self.viewModel.noticeCommand execute:@(YES)];
}
- (void)lc_updatePageNewData{
    [self.viewModel.loadDataCommend execute:@(YES)];
    [self.viewModel.noticeCommand execute:@(YES)];
    [self.viewModel.balanceCommand execute:@(YES)];
    if([[LCUserInfoManager shareManager].userInfo.isyouke boolValue]){
        [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"您目前处于游客浏览模式，请先绑定手机号") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if(buttonIndex == controller.destructiveButtonIndex){
                LCBindPhoneViewController *con = [LCBindPhoneViewController new];
                [self pushToViewController:con];
            }
        }];
        return;
    }
}
#pragma mark----UICollectionViewDataSource、UICollectionViewDelegateFlowLayout----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat width = (collectionView.width - collectionView.contentInset.left - collectionView.contentInset.right - kUI_Width(6) * 3)/
    return CGSizeMake(kUI_Width(212)/2.0, kUI_Width(113)/2.0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCRechargeTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCRechargeTypeCollectionViewCell" forIndexPath:indexPath];
    cell.dataModel = self.viewModel.dataArray[indexPath.item];
    cell.contentView.clipsToBounds = YES;
//    cell.layer.cornerRadius = kUI_Width(4);
//    cell.layer.shadowColor = Color(@"#FFD5E7").CGColor;// 阴影颜色
//    cell.layer.shadowOpacity = 1;// 阴影透明度，默认0
//    cell.layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
//    cell.layer.shadowRadius = 2;//阴影半径，默认3
    cell.backgroundColor = collectionView.backgroundColor;
    cell.contentView.backgroundColor = collectionView.backgroundColor;
   
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(indexPath.item == self.viewModel.currentIndex){
        return;
    }
    [self.viewModel.changeSelectIndexCommend execute:self.viewModel.dataArray[indexPath.item]];
}

#pragma mark----JXPagerViewDelegate---

/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView{
   
    return  kUI_Width(162) ;
}

/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView{
   
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, kUI_Width(162))];
    LCShelterGradientView *noticeBackView = [[LCShelterGradientView alloc] initWithFrame:CGRectZero];
    [view addSubview:noticeBackView];
    noticeBackView.clipsToBounds = YES;
    noticeBackView.gradientLayer.startPoint = CGPointMake(1, 0.5);
    noticeBackView.gradientLayer.endPoint = CGPointMake(0, 0.5);
    noticeBackView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:253/255.0 green:181/255.0 blue:209/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:249/255.0 green:126/255.0 blue:165/255.0 alpha:1.0].CGColor];
    noticeBackView.gradientLayer.locations = @[@(0), @(1.0f)];
    noticeBackView.layer.cornerRadius = kUI_Width(4);
    

    [view addSubview:noticeBackView];
    [noticeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(kViewMargin));
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(28));
        make.top.equalTo(kUI_Width(10));
    }];
    UIImageView *noticeImgView = [[UIImageView alloc]initWithImage:image(@"icon_homeNotice")];
    noticeImgView.contentMode = UIViewContentModeScaleAspectFill;
    [noticeBackView addSubview:noticeImgView];
    
    [noticeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(kUI_Width(22));
        make.left.equalTo(kUI_Width(kViewMargin));
        make.centerY.equalTo(0);
    }];
    LCTitleNoticeView *noticeView = [[LCTitleNoticeView alloc]initWithFrame:CGRectZero];
    [noticeBackView addSubview:noticeView];
    noticeView.dataArray = self.viewModel.noticeArray;
    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(noticeImgView.mas_right).offset(kUI_Width(kViewMargin));
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.top.bottom.equalTo(0);
    }];
    UIImageView *balanceBgView = [[UIImageView alloc]initWithImage:image(@"icon_rechargeBalanceBg")];
    [view addSubview:balanceBgView];
    balanceBgView.clipsToBounds = YES;
    balanceBgView.userInteractionEnabled = YES;
    [balanceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(kViewMargin));
        make.right.equalTo(-kUI_Width(kViewMargin));
        make.height.equalTo(kUI_Width(104));
        make.top.mas_equalTo(noticeBackView.mas_bottom).offset(kUI_Width(10));
        
    }];
    
    UILabel *balanceTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    balanceTipLabel.font = BoldFont(14);
    balanceTipLabel.textColor = Color(@"#FFFFFF");
    balanceTipLabel.text = KLanguage(@"余额(钻石)");
    [balanceBgView addSubview:balanceTipLabel];
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    balanceLabel.font = BoldFont(18);
    balanceLabel.textColor = Color(@"#FFEB3B");
    balanceLabel.text = self.viewModel.balanceStr ? self.viewModel.balanceStr : @"0";
    [balanceBgView addSubview:balanceLabel];
   
    
//    UILabel *zsTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    zsTipLabel.font = BoldFont(14);
//    zsTipLabel.textColor = Color(@"#FFFFFF");
//    zsTipLabel.text = KLanguage(@"钻石");
//    [balanceBgView addSubview:zsTipLabel];
//    UILabel *zsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    zsLabel.font = BoldFont(18);
//    zsLabel.textColor = Color(@"#FFEB3B");
//    zsLabel.text =@"0.0";
//    [balanceBgView addSubview:zsLabel];
   
//    LCShelterGradientView *dhzsBgView = [[LCShelterGradientView alloc]initWithFrame:CGRectZero];
//    dhzsBgView.gradientLayer.startPoint = CGPointMake(0.5, 0);
//    dhzsBgView.gradientLayer.endPoint = CGPointMake(0.5, 1);
//    dhzsBgView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:210/255.0 blue:118/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:161/255.0 blue:21/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:224/255.0 blue:81/255.0 alpha:1.0].CGColor];
//    dhzsBgView.gradientLayer.locations = @[@(0), @(0.5f), @(1.0f)];
//    dhzsBgView.layer.cornerRadius = kUI_Width(28)/2.0;
//    dhzsBgView.layer.shadowColor = [UIColor colorWithRed:226/255.0 green:70/255.0 blue:115/255.0 alpha:1.0].CGColor;
//    dhzsBgView.layer.shadowOffset = CGSizeMake(0,-1);
//    dhzsBgView.layer.shadowOpacity = 1;
//    dhzsBgView.layer.shadowRadius = 0;
//    dhzsBgView.clipsToBounds = YES;
//    [balanceBgView addSubview:dhzsBgView];
//    UIButton *dhzsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [dhzsBtn setTitle:KLanguage(@"兑换钻石") forState:UIControlStateNormal];
//    [dhzsBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
//    dhzsBtn.titleLabel.font = RegularFont(14);
//    [dhzsBgView addSubview:dhzsBtn];
    
    [balanceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(kUI_Width(32));
        make.height.equalTo(kUI_Width(14));
        
    }];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.mas_equalTo(balanceTipLabel.mas_bottom).offset(kUI_Width(8));
        make.height.equalTo(kUI_Width(18));
//        make.right.mas_lessThanOrEqualTo(zsLabel.mas_left).offset(-kUI_Width(10));
    }];
//    [zsTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(balanceTipLabel.mas_right).offset(kUI_Width(73));
//        make.top.equalTo(kUI_Width(32));
//        make.height.equalTo(kUI_Width(14));
//
//    }];
//    [zsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(zsTipLabel.mas_left);
//        make.top.mas_equalTo(balanceTipLabel.mas_bottom).offset(kUI_Width(8));
//        make.height.equalTo(kUI_Width(18));
//        make.right.lessThanOrEqualTo(-kUI_Width(12));
//    }];
//    [dhzsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-kUI_Width(11));
//        make.centerY.equalTo(0);
//        make.height.equalTo(kUI_Width(28));
//        make.width.equalTo(kUI_Width(80));
//
//    }];
//    [dhzsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(0);
//    }];
    return view;
}

/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    NSInteger col = self.viewModel.dataArray.count / 3 + (self.viewModel.dataArray.count % 3 > 0 ? 1:0);
    return kUI_Width(113)/2.0 * col + (col > 0?(col - 1)*kUI_Width(10) : 0) + kUI_Width(10) * 2 + kUI_Width(16);
//    return kUI_Width(22) ;
}

/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView{
    NSInteger col = self.viewModel.dataArray.count / 3 + (self.viewModel.dataArray.count % 3 > 0 ? 1:0);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pagerView.width, kUI_Width(113)/2.0 * col + (col > 0?(col - 1)*kUI_Width(10) : 0) + kUI_Width(10) * 2 + kUI_Width(16))];
    view.backgroundColor = Color(@"#FFFFFF");
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_rechargeTipAcessImg")];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(12));
        make.width.equalTo(kUI_Width(4));
        make.height.equalTo(kUI_Width(16));
        make.top.equalTo(0);
    }];
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tipLabel.text = KLanguage(@"选择支付方式");
    tipLabel.textColor = Color(@"#333333");
    tipLabel.font = BoldFont(16);
    [view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(4));
        make.height.equalTo(kUI_Width(16));
        make.top.equalTo(0);
        make.right.equalTo(-kUI_Width(16));
    }];
    [view addSubview:self.rechargeTypeCollectionView];
  
    [self.rechargeTypeCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
       
            
            make.height.equalTo(kUI_Width(113)/2.0 * col + (col > 0?(col - 1)*kUI_Width(10) : 0) + kUI_Width(10) * 2);
        
        
        make.top.mas_equalTo(tipLabel.mas_bottom);
    }];
    return  view;
    
  
}

/**
 返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView{
    
    return self.viewModel.dataArray.count;
}

/**
 根据index初始化一个对应列表实例，需要是遵从`JXPagerViewListViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
 注意：一定要是新生成的实例！！！

 @param pagerView pagerView description
 @param index index description
 @return 新生成的列表实例
 */
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index{
    LCRechargeTypeModel *model = self.viewModel.dataArray[index];
    if([model.modelId isEqual:@"1"]){
        LCRechargeAgentViewController *con = [LCRechargeAgentViewController new];
        con.dataModel = model;
        return con;
    }else if ([model.modelId isEqual:@"2"]){
        LCRechargeBankViewController *con = [LCRechargeBankViewController new];
        con.dataModel = model;
        return con;
    }else if ([model.modelId isEqual:@"3"]){
        LCRechargeVirtualCurrencyViewController *con = [LCRechargeVirtualCurrencyViewController new];
        con.dataModel = model;
        return con;
    }else if ([model.modelId isEqual:@"4"]){
        LCRechargeSubViewController *con = [LCRechargeSubViewController new];
        con.dataModel = model;
        return con;
    }
    
    

    return nil;
}
#pragma mark - JXCategoryViewDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
//    if (otherGestureRecognizer == self.segmentControl.collectionView.panGestureRecognizer) {
//        return NO;
//    }

//    if ([otherGestureRecognizer.view.findViewController isKindOfClass:[UIPageViewController class]]) {
//        return NO;
//    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
#pragma mark---- 懒加载 ----



- (LCBaseCollectionView *)rechargeTypeCollectionView{
    if(_rechargeTypeCollectionView == nil){
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionLayout.minimumInteritemSpacing = (SCREEN_WIDTH - kUI_Width(212)/2.0 * 3 - kUI_Width(12) * 2)/2.0;
        collectionLayout.minimumLineSpacing = kUI_Width(10);
        collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
       
        
        LCBaseCollectionView *collectionView = [[LCBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _rechargeTypeCollectionView = collectionView;
        _rechargeTypeCollectionView.contentInset = UIEdgeInsetsMake(kUI_Width(10), kUI_Width(kViewMargin), kUI_Width(10), kUI_Width(kViewMargin));
        _rechargeTypeCollectionView.dataSource = self;
        _rechargeTypeCollectionView.delegate = self;
        _rechargeTypeCollectionView.backgroundColor = Color(@"#FFFFFF");
        _rechargeTypeCollectionView.scrollEnabled = NO;
        _rechargeTypeCollectionView.showsVerticalScrollIndicator = NO;
        _rechargeTypeCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_rechargeTypeCollectionView registerClass:[LCRechargeTypeCollectionViewCell class] forCellWithReuseIdentifier:@"LCRechargeTypeCollectionViewCell"];
       
    }
    return _rechargeTypeCollectionView;
}
- (JXPagerListRefreshView *)pagerView {
    if (_pagerView == nil) {
        JXPagerListRefreshView *view = [[JXPagerListRefreshView alloc]initWithDelegate:self listContainerType:JXPagerListContainerType_CollectionView];
        _pagerView = view;
        
        _pagerView.automaticallyDisplayListVerticalScrollIndicator = NO;
        _pagerView.isListHorizontalScrollEnabled = NO;
      
        [self.view addSubview:_pagerView];
    }

    return _pagerView;
}
- (LCRechargeTypeViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LCRechargeTypeViewModel new];
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
