//
//  LCUpdatePersonalInfoViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCUpdatePersonalInfoViewController.h"
#import "LCUpdatePersonalInfoViewModel.h"
#import "LCUpdatePersonalAvaterCell.h"
#import "LCUpdatePersonalSexCell.h"
#import "LCUpdatePersonalNicknameCell.h"
#import "LCUpdatePersonalProfileCell.h"
#import "LCUpdatePersonalBirthdayCell.h"
#import "LCUpdatePersonalProvinceCell.h"
#import "LCUpdatePersonalCityCell.h"
#import <TZImagePickerController/TZImagePickerController.h>


@interface LCUpdatePersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , strong) LCUpdatePersonalInfoViewModel *viewModel;
@property (nonatomic , assign) CGFloat profileHeight;
@end

@implementation LCUpdatePersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)lc_addSubviews{
    self.profileHeight = (kUI_Width(140) -kUI_Width(15) * 2);
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"个人资料")];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.top.equalTo(kNavBarHeight );
        make.right.equalTo(0);

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
      
       
        [SVProgressHUD showNoMaskViewWithSuccess:KLanguage(@"保存成功") ];
        
    }];
    [[self.viewModel.uploadSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
     
        if ([x isKindOfClass:[NSError class]]) {
            NSError *error = x;
            [SVProgressHUD showMaskViewWithFailure:error.domain];
            
            return;
        }
        [self.viewModel.loadDataCommend execute:@(YES)];
       
    }];
    
    
   
    

}

#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return kUI_Width(10);
    }
    return kUI_Width(1);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 6){
        return kUI_Width(30) * 2 + kUI_Width(40);
    }
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [tableView fd_heightForCellWithIdentifier:@"LCUpdatePersonalAvaterCell" configuration:^(LCUpdatePersonalAvaterCell * cell) {
            
        }];
    }else if (indexPath.section == 1){
        return [tableView fd_heightForCellWithIdentifier:@"LCUpdatePersonalNicknameCell" configuration:^(LCUpdatePersonalNicknameCell * cell) {
            
        }];
    }else if (indexPath.section == 5){
        return [tableView fd_heightForCellWithIdentifier:@"LCUpdatePersonalSexCell" configuration:^(LCUpdatePersonalSexCell * cell) {
            
        }];
    }else if (indexPath.section == 2){
        return [tableView fd_heightForCellWithIdentifier:@"LCUpdatePersonalBirthdayCell" configuration:^(LCUpdatePersonalBirthdayCell * cell) {
            
        }];
    }else if (indexPath.section == 3){
        return [tableView fd_heightForCellWithIdentifier:@"LCUpdatePersonalProvinceCell" configuration:^(LCUpdatePersonalProvinceCell * cell) {
            
        }];
    }else if (indexPath.section == 4){
        return [tableView fd_heightForCellWithIdentifier:@"LCUpdatePersonalCityCell" configuration:^(LCUpdatePersonalCityCell * cell) {
            
        }];
    }
    
     return self.profileHeight > (kUI_Width(140) -kUI_Width(15) * 2)? self.profileHeight + kUI_Width(15) * 2 :kUI_Width(140);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 6){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(30) * 2 + kUI_Width(40))];
        view.backgroundColor = tableView.backgroundColor;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_personalUpdateSaveBg") forState:UIControlStateNormal];
        [btn setTitle:KLanguage(@"保存编辑") forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(18);
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(30));
            make.width.equalTo(kUI_Width(205));
            make.height.equalTo(kUI_Width(40));
            make.centerX.equalTo(0);
        }];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(!weakSelf.viewModel.nickname.length){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请填写昵称") ];
                return;
            }
            if(!weakSelf.viewModel.avaterStr.length && !weakSelf.viewModel.avater){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请上传头像")];
                return;
            }
            if(!weakSelf.viewModel.sex.length){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请选择性别")];
                return;
            }
            if(!weakSelf.viewModel.profile.length){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请填写个性签名")];
                return;
            }
            if(!weakSelf.viewModel.birthday.length){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请填写生日")];
                return;
            }
            if(!weakSelf.viewModel.city.length){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请填写城市")];
                return;
            }
            if(!weakSelf.viewModel.province.length){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"请填写省份")];
                return;
            }
            if(weakSelf.viewModel.avater){
                [SVProgressHUD showWithMaskView];
                [weakSelf.viewModel.uploadCommand execute:@(YES)];
            }else{
                [SVProgressHUD showWithMaskView];
                [weakSelf.viewModel.loadDataCommend execute:@(YES)];
            }
        }];
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        LCUpdatePersonalAvaterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUpdatePersonalAvaterCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.avatar = self.viewModel.avater ? self.viewModel.avater : self.viewModel.avaterStr;
        return cell;
    }else if (indexPath.section == 1){
        LCUpdatePersonalNicknameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUpdatePersonalNicknameCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nickName = self.viewModel.nickname;
        WS(weakSelf)
        cell.textChangeBlock = ^(NSString * _Nonnull text) {
            weakSelf.viewModel.nickname = text;
        };
        return cell;
    }else if (indexPath.section == 2){
        LCUpdatePersonalBirthdayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUpdatePersonalBirthdayCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.birthday = self.viewModel.birthday;
        WS(weakSelf)
        cell.textChangeBlock = ^(NSString * _Nonnull text) {
            weakSelf.viewModel.birthday = text;
        };
        return cell;
    }else if (indexPath.section == 3){
        LCUpdatePersonalProvinceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUpdatePersonalProvinceCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.province = self.viewModel.province;
        WS(weakSelf)
        cell.textChangeBlock = ^(NSString * _Nonnull text) {
            weakSelf.viewModel.province = text;
        };
        return cell;
    }else if (indexPath.section == 4){
        LCUpdatePersonalCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUpdatePersonalCityCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.city = self.viewModel.city;
        WS(weakSelf)
        cell.textChangeBlock = ^(NSString * _Nonnull text) {
            weakSelf.viewModel.city = text;
        };
        return cell;
    }else if (indexPath.section == 5){
        LCUpdatePersonalSexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUpdatePersonalSexCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sex = self.viewModel.sex;
        WS(weakSelf)
        [[cell.btnClickSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            weakSelf.viewModel.sex = [NSString stringWithFormat:@"%d",![weakSelf.viewModel.sex boolValue]];
            [weakSelf.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return cell;
    }
    LCUpdatePersonalProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUpdatePersonalProfileCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.profile = self.viewModel.profile;
    WS(weakSelf)
    cell.textChangeBlock = ^(NSString * _Nonnull text, CGFloat height) {
        weakSelf.profileHeight = height;
        weakSelf.viewModel.profile = text;
        [weakSelf.mainTableView beginUpdates];
        [weakSelf.mainTableView endUpdates];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [self determineAVAuthorizationStatusForAlbums];
    }
//    }else if (indexPath.section == 2){
//        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
//        //自定义位置
//        datePicker.frame = CGRectMake(0, self.view.height - kUI_Width(200), self.view.width, kUI_Width(200));
//        //设置背景颜色
//        datePicker.backgroundColor = Color(@"#FFFFFF");
//        //datePicker.center = self.center;
//        //设置本地化支持的语言（在此是中文)
//         datePicker.locale = [NSLocale localeWithLocaleIdentifier:[[LCLanguageManager shareManager]getLanguageEncode]];
//         //显示方式是只显示年月日
//         datePicker.datePickerMode = UIDatePickerModeDate;
//
//    NSDateFormatter *fMinDate = [[NSDateFormatter alloc] init];
//    [fMinDate setDateFormat:@"yyyy-MM-dd"];
//    NSDate *minDate = [fMinDate dateFromString:@"1930-09-09"];
//    datePicker.minimumDate = minDate;
//
//
//    NSDate *maxDate = [NSDate dateWithString:[NSString currentTimeString] format:@"yyyy-MM-dd"];
//        datePicker.maximumDate = maxDate;
//        //放在盖板上
//        [self.view addSubview:datePicker];
//        WS(weakSelf)
//        [[[datePicker rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIDatePicker * _Nullable x) {
//            NSDate *date = [x date];
//            weakSelf.viewModel.birthday = [date stringWithFormat:@"yyyy-MM-dd"];
//            [weakSelf.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
//        }];
//    }
}
#pragma mark----选取封面----
/**
 *  监测用户是否授权相册
 */
- (void)determineAVAuthorizationStatusForAlbums {
    if ([[TZImageManager manager] authorizationStatusAuthorized]) {
         [self openAlbums];
    }else{
        [[TZImageManager manager]requestAuthorizationWithCompletion:^{
            if (![[TZImageManager manager] authorizationStatusAuthorized]) {
                [UIAlertController showAlertInViewController:self withTitle:KLanguage(@"提示") message:KLanguage(@"没有权限访问您的照片，是否前往设置允许该应用使用照片？") cancelButtonTitle:KLanguage(@"取消") destructiveButtonTitle:KLanguage(@"确定") otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if(controller.destructiveButtonIndex == buttonIndex){
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
                
            }else{
                [self openAlbums];
            }
        }];
    }
    
    


}

/**
 *  打开相册
 */
- (void)openAlbums {
    TZImagePickerController *albumListVC = [[TZImagePickerController alloc]initWithMaxImagesCount:1  columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    albumListVC.allowTakeVideo = NO;
    albumListVC.allowTakePicture = NO;
    albumListVC.allowCrop = YES;
    albumListVC.allowPickingOriginalPhoto = NO;
    albumListVC.cropRect = CGRectMake(kUI_Width(40), (SCREEN_HEIGHT - (SCREEN_WIDTH - kUI_Width(80)))/2.0, SCREEN_WIDTH - kUI_Width(80), SCREEN_WIDTH - kUI_Width(80));
    WS(weakSelf)
    albumListVC.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakSelf.viewModel.avater = [photos firstObject];
        [weakSelf.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self presentViewController:albumListVC animated:YES completion:^{
        
    }];

}
#pragma mark---- 懒加载 ----
- (LCUpdatePersonalInfoViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [LCUpdatePersonalInfoViewModel new];
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
        _mainTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_mainTableView];
        [_mainTableView registerClass:[LCUpdatePersonalAvaterCell class] forCellReuseIdentifier:@"LCUpdatePersonalAvaterCell"];
        [_mainTableView registerClass:[LCUpdatePersonalProfileCell class] forCellReuseIdentifier:@"LCUpdatePersonalProfileCell"];
        [_mainTableView registerClass:[LCUpdatePersonalNicknameCell class] forCellReuseIdentifier:@"LCUpdatePersonalNicknameCell"];
        [_mainTableView registerClass:[LCUpdatePersonalSexCell class] forCellReuseIdentifier:@"LCUpdatePersonalSexCell"];
        [_mainTableView registerClass:[LCUpdatePersonalCityCell class] forCellReuseIdentifier:@"LCUpdatePersonalCityCell"];
        [_mainTableView registerClass:[LCUpdatePersonalProvinceCell class] forCellReuseIdentifier:@"LCUpdatePersonalProvinceCell"];
        [_mainTableView registerClass:[LCUpdatePersonalBirthdayCell class] forCellReuseIdentifier:@"LCUpdatePersonalBirthdayCell"];
       
        
    }
    return _mainTableView;
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
