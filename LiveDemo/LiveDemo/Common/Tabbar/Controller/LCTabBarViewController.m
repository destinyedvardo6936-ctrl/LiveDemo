//
//  LDTabBarViewController.m
//  LDHeadlines
//
//  Created by mrgao on 2019/12/3.
//  Copyright © 2019 personal. All rights reserved.
//

#import "LCTabBarViewController.h"
#import "LCTabbarButton.h"
#import "LCNavigationViewController.h"
#import "LCHomeViewController.h"
#import "LCGameCenterViewController.h"
#import "LCRechageViewController.h"
#import "LCMineViewController.h"
#import "LCGameConfigManager.h"
#import "LCUserInfoApi.h"
#import "LCUserInfoManager.h"
#import "LCNetWorkManager.h"
#import "LCBaseViewController.h"
#import "LCLiveStopInfoView.h"
#import "LCSocketManager.h"
#import "common.h"
#import "NSString+LCHash.h"
#import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <TZImagePickerController/TZImagePickerController.h>

static CGFloat LCTabBarContentHeight(void) {
    return kUI_Width(50);
}

static CGFloat LCTabBarTotalHeight(void) {
    return kUI_Width(52) + KSafeHeight;
}

static CGFloat LCTabBarCenterSlotWidth(void) {
    return kUI_Width(64);
}

static CGFloat LCTabBarIconSide(void) {
    return kUI_Width(26);
}

static NSString * const LCAnchorLiveStopSalt = @"76576076c1f5f657b634e966c8836a06";

static NSString *LCAnchorLiveStringValue(id value) {
    if (!value || value == [NSNull null]) {
        return @"";
    }
    if ([value isKindOfClass:NSString.class]) {
        return (NSString *)value;
    }
    if ([value isKindOfClass:NSNumber.class]) {
        return [(NSNumber *)value stringValue];
    }
    return [NSString stringWithFormat:@"%@", value];
}

static NSDictionary *LCAnchorLiveDictionaryValue(id value) {
    if ([value isKindOfClass:NSDictionary.class]) {
        return (NSDictionary *)value;
    }
    if ([value isKindOfClass:NSString.class]) {
        NSData *data = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length) {
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([jsonObject isKindOfClass:NSDictionary.class]) {
                return jsonObject;
            }
        }
    }
    return nil;
}

static NSArray *LCAnchorLiveArrayValue(id value) {
    if ([value isKindOfClass:NSArray.class]) {
        return (NSArray *)value;
    }
    if ([value isKindOfClass:NSString.class]) {
        NSData *data = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length) {
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([jsonObject isKindOfClass:NSArray.class]) {
                return jsonObject;
            }
        }
    }
    return nil;
}

@interface LCAnchorLiveViewController : LCBaseViewController<TZImagePickerControllerDelegate, UITextFieldDelegate, LCSocketManagerDelegate>
- (instancetype)initWithUserInfo:(NSDictionary *)userInfo;
@end

@interface LCAnchorLiveViewController ()
@property (nonatomic, copy) NSDictionary *anchorUserInfo;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIView *readyPanelView;
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UILabel *coverHintLabel;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UIButton *liveClassButton;
@property (nonatomic, strong) UILabel *cityValueLabel;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIView *liveOverlayView;
@property (nonatomic, strong) UILabel *liveStatusLabel;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSArray<NSDictionary *> *liveClassOptions;
@property (nonatomic, strong) NSDictionary *selectedLiveClass;
@property (nonatomic, copy) NSString *selectedLiveClassId;
@property (nonatomic, strong) id livePusher;
@property (nonatomic, assign) BOOL previewReady;
@property (nonatomic, assign) BOOL startingLive;
@property (nonatomic, assign) BOOL living;
@property (nonatomic, assign) BOOL stoppingLive;
@property (nonatomic, strong) NSDate *liveStartDate;
@property (nonatomic, strong) NSTimer *liveTimer;
@property (nonatomic, copy) NSString *stream;
@property (nonatomic, copy) NSString *chatServer;
@property (nonatomic, copy) NSString *pushUrl;
@property (nonatomic, copy) NSString *liveTitle;
@end

@implementation LCAnchorLiveViewController

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        _anchorUserInfo = [userInfo copy] ?: @{};
        self.needHiddenInteractivePopGestureRecognizer = YES;
    }
    return self;
}

- (void)lc_addSubviews {
    self.view.backgroundColor = UIColor.blackColor;

    UIView *previewView = [[UIView alloc] initWithFrame:CGRectZero];
    previewView.backgroundColor = Color(@"#111111");
    self.previewView = previewView;
    [self.view addSubview:previewView];
    [previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];

    UIView *shadeView = [[UIView alloc] initWithFrame:CGRectZero];
    shadeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.16];
    [previewView addSubview:shadeView];
    [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];

    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topBarView = topBarView;
    [self.view addSubview:topBarView];
    [topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.mas_equalTo(kStatusBarHeight + kUI_Width(56));
    }];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton = backButton;
    [backButton setImage:image(@"MainStartCloseIcon") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kUI_Width(12));
        make.bottom.mas_equalTo(-kUI_Width(10));
        make.size.mas_equalTo(CGSizeMake(kUI_Width(36), kUI_Width(36)));
    }];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = KLanguage(@"开始直播");
    titleLabel.font = BoldFont(18);
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topBarView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(backButton);
    }];

    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchCameraButton = switchCameraButton;
    [switchCameraButton setImage:image(@"MainStartLiveIcon") forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(handleSwitchCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:switchCameraButton];
    [switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kUI_Width(12));
        make.centerY.equalTo(backButton);
        make.size.mas_equalTo(CGSizeMake(kUI_Width(36), kUI_Width(36)));
    }];

    UIView *readyPanelView = [[UIView alloc] initWithFrame:CGRectZero];
    readyPanelView.backgroundColor = ColorAlpha(@"#101010", 0.78);
    readyPanelView.layer.cornerRadius = kUI_Width(24);
    readyPanelView.layer.masksToBounds = YES;
    self.readyPanelView = readyPanelView;
    [self.view addSubview:readyPanelView];
    [readyPanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kUI_Width(16));
        make.right.mas_equalTo(-kUI_Width(16));
        make.bottom.mas_equalTo(-(KSafeHeight + kUI_Width(18)));
    }];

    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverButton = coverButton;
    coverButton.backgroundColor = ColorAlpha(@"#FFFFFF", 0.12);
    coverButton.layer.cornerRadius = kUI_Width(16);
    coverButton.layer.masksToBounds = YES;
    coverButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [coverButton addTarget:self action:@selector(selectCoverAction) forControlEvents:UIControlEventTouchUpInside];
    [readyPanelView addSubview:coverButton];
    [coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kUI_Width(18));
        make.width.height.mas_equalTo(kUI_Width(92));
    }];

    UILabel *coverHintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.coverHintLabel = coverHintLabel;
    coverHintLabel.text = KLanguage(@"选择封面");
    coverHintLabel.textColor = UIColor.whiteColor;
    coverHintLabel.font = MediumFont(13);
    coverHintLabel.textAlignment = NSTextAlignmentCenter;
    coverHintLabel.numberOfLines = 2;
    [coverButton addSubview:coverHintLabel];
    [coverHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.left.right.equalTo(0);
    }];

    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.titleTextField = titleTextField;
    titleTextField.backgroundColor = ColorAlpha(@"#FFFFFF", 0.12);
    titleTextField.layer.cornerRadius = kUI_Width(14);
    titleTextField.layer.masksToBounds = YES;
    titleTextField.textColor = UIColor.whiteColor;
    titleTextField.font = MediumFont(15);
    titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:KLanguage(@"输入直播标题") attributes:@{NSForegroundColorAttributeName:ColorAlpha(@"#FFFFFF", 0.55)}];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUI_Width(12), 1)];
    titleTextField.leftView = paddingView;
    titleTextField.leftViewMode = UITextFieldViewModeAlways;
    titleTextField.returnKeyType = UIReturnKeyDone;
    titleTextField.delegate = self;
    titleTextField.text = [self defaultLiveTitle];
    [readyPanelView addSubview:titleTextField];
    [titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coverButton.mas_right).offset(kUI_Width(14));
        make.right.mas_equalTo(-kUI_Width(18));
        make.top.equalTo(coverButton);
        make.height.mas_equalTo(kUI_Width(42));
    }];

    UIButton *liveClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.liveClassButton = liveClassButton;
    liveClassButton.backgroundColor = ColorAlpha(@"#FFFFFF", 0.12);
    liveClassButton.layer.cornerRadius = kUI_Width(14);
    liveClassButton.layer.masksToBounds = YES;
    liveClassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    liveClassButton.contentEdgeInsets = UIEdgeInsetsMake(0, kUI_Width(12), 0, kUI_Width(12));
    liveClassButton.titleLabel.font = MediumFont(14);
    [liveClassButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [liveClassButton addTarget:self action:@selector(selectLiveClassAction) forControlEvents:UIControlEventTouchUpInside];
    [readyPanelView addSubview:liveClassButton];
    [liveClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleTextField);
        make.top.equalTo(titleTextField.mas_bottom).offset(kUI_Width(10));
        make.height.mas_equalTo(kUI_Width(40));
    }];

    UIView *cityContainer = [[UIView alloc] initWithFrame:CGRectZero];
    cityContainer.backgroundColor = ColorAlpha(@"#FFFFFF", 0.12);
    cityContainer.layer.cornerRadius = kUI_Width(14);
    cityContainer.layer.masksToBounds = YES;
    [readyPanelView addSubview:cityContainer];
    [cityContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleTextField);
        make.top.equalTo(liveClassButton.mas_bottom).offset(kUI_Width(10));
        make.height.mas_equalTo(kUI_Width(40));
    }];

    UILabel *cityTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    cityTitleLabel.text = KLanguage(@"开播地区");
    cityTitleLabel.font = RegularFont(13);
    cityTitleLabel.textColor = ColorAlpha(@"#FFFFFF", 0.7);
    [cityContainer addSubview:cityTitleLabel];
    [cityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kUI_Width(12));
        make.centerY.equalTo(0);
    }];

    UILabel *cityValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cityValueLabel = cityValueLabel;
    cityValueLabel.textAlignment = NSTextAlignmentRight;
    cityValueLabel.font = MediumFont(14);
    cityValueLabel.textColor = UIColor.whiteColor;
    cityValueLabel.text = [self currentCityText];
    [cityContainer addSubview:cityValueLabel];
    [cityValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityTitleLabel.mas_right).offset(kUI_Width(10));
        make.right.mas_equalTo(-kUI_Width(12));
        make.centerY.equalTo(0);
    }];

    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton = startButton;
    startButton.backgroundColor = Color(@"#FC6EA1");
    startButton.layer.cornerRadius = kUI_Width(23);
    startButton.layer.masksToBounds = YES;
    startButton.titleLabel.font = BoldFont(16);
    [startButton setTitle:KLanguage(@"开始直播") forState:UIControlStateNormal];
    [startButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startLiveAction) forControlEvents:UIControlEventTouchUpInside];
    [readyPanelView addSubview:startButton];
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kUI_Width(18));
        make.right.mas_equalTo(-kUI_Width(18));
        make.top.equalTo(coverButton.mas_bottom).offset(kUI_Width(18));
        make.height.mas_equalTo(kUI_Width(46));
        make.bottom.mas_equalTo(-kUI_Width(18));
    }];

    UIView *liveOverlayView = [[UIView alloc] initWithFrame:CGRectZero];
    self.liveOverlayView = liveOverlayView;
    liveOverlayView.hidden = YES;
    [self.view addSubview:liveOverlayView];
    [liveOverlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(topBarView.mas_bottom);
        make.bottom.equalTo(0);
    }];

    UILabel *liveStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.liveStatusLabel = liveStatusLabel;
    liveStatusLabel.backgroundColor = Color(@"#FC335E");
    liveStatusLabel.textColor = UIColor.whiteColor;
    liveStatusLabel.font = BoldFont(12);
    liveStatusLabel.textAlignment = NSTextAlignmentCenter;
    liveStatusLabel.text = KLanguage(@"直播中");
    liveStatusLabel.layer.cornerRadius = kUI_Width(12);
    liveStatusLabel.layer.masksToBounds = YES;
    [liveOverlayView addSubview:liveStatusLabel];
    [liveStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kUI_Width(16));
        make.top.mas_equalTo(kUI_Width(14));
        make.width.mas_equalTo(kUI_Width(62));
        make.height.mas_equalTo(kUI_Width(24));
    }];

    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timerLabel = timerLabel;
    timerLabel.backgroundColor = ColorAlpha(@"#000000", 0.45);
    timerLabel.textColor = UIColor.whiteColor;
    timerLabel.font = MediumFont(12);
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.layer.cornerRadius = kUI_Width(12);
    timerLabel.layer.masksToBounds = YES;
    timerLabel.text = @"00:00:00";
    [liveOverlayView addSubview:timerLabel];
    [timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(liveStatusLabel.mas_right).offset(kUI_Width(8));
        make.centerY.equalTo(liveStatusLabel);
        make.width.mas_equalTo(kUI_Width(88));
        make.height.mas_equalTo(kUI_Width(24));
    }];

    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stopButton = stopButton;
    stopButton.backgroundColor = ColorAlpha(@"#FC335E", 0.95);
    stopButton.layer.cornerRadius = kUI_Width(24);
    stopButton.layer.masksToBounds = YES;
    stopButton.titleLabel.font = BoldFont(16);
    [stopButton setTitle:KLanguage(@"结束直播") forState:UIControlStateNormal];
    [stopButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopLiveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [liveOverlayView addSubview:stopButton];
    [stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kUI_Width(36));
        make.right.mas_equalTo(-kUI_Width(36));
        make.bottom.mas_equalTo(-(KSafeHeight + kUI_Width(24)));
        make.height.mas_equalTo(kUI_Width(48));
    }];

    [self loadDefaultLiveClass];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.previewReady && !self.living) {
        [self requestLivePermissionsIfNeeded];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isMovingFromParentViewController && !self.living) {
        [self stopPreviewResources];
    }
}

- (void)dealloc {
    [self invalidateLiveTimer];
    [self disconnectSocket];
    [self stopPreviewResources];
}

- (NSString *)defaultLiveTitle {
    NSString *name = LCAnchorLiveStringValue([LCUserInfoManager shareManager].userInfo.user_nicename);
    if (!name.length) {
        name = LCAnchorLiveStringValue(self.anchorUserInfo[@"user_nicename"]);
    }
    if (name.length) {
        return [NSString stringWithFormat:@"%@%@", name, KLanguage(@"的直播间")];
    }
    return KLanguage(@"我的直播间");
}

- (NSString *)currentCityText {
    NSString *province = LCAnchorLiveStringValue(self.anchorUserInfo[@"province"]);
    if (!province.length) {
        province = LCAnchorLiveStringValue([LCUserInfoManager shareManager].userInfo.province);
    }
    NSString *city = LCAnchorLiveStringValue(self.anchorUserInfo[@"city"]);
    if (!city.length) {
        city = LCAnchorLiveStringValue([LCUserInfoManager shareManager].userInfo.city);
    }
    NSString *location = [NSString stringWithFormat:@"%@%@", province, city];
    return location.length ? location : KLanguage(@"暂未获取");
}

- (NSArray<NSDictionary *> *)normalizedLiveClassOptions {
    NSArray *rawClasses = [common liveclass];
    NSMutableArray<NSDictionary *> *options = [NSMutableArray array];
    for (id item in rawClasses) {
        NSDictionary *dic = LCAnchorLiveDictionaryValue(item);
        if (!dic.count) {
            continue;
        }
        NSString *classId = LCAnchorLiveStringValue(dic[@"id"]);
        if (!classId.length) {
            classId = LCAnchorLiveStringValue(dic[@"liveclassid"]);
        }
        if (!classId.length) {
            classId = LCAnchorLiveStringValue(dic[@"value"]);
        }
        NSString *name = LCAnchorLiveStringValue(dic[@"name"]);
        if (!name.length) {
            name = LCAnchorLiveStringValue(dic[@"title"]);
        }
        if (!name.length) {
            name = LCAnchorLiveStringValue(dic[@"des"]);
        }
        if (!classId.length || !name.length) {
            continue;
        }
        [options addObject:@{@"id": classId, @"name": name}];
    }
    return options;
}

- (void)loadDefaultLiveClass {
    self.liveClassOptions = [self normalizedLiveClassOptions];
    if (self.liveClassOptions.count > 0) {
        [self applyLiveClass:self.liveClassOptions.firstObject];
    } else {
        [self.liveClassButton setTitle:KLanguage(@"暂未配置直播频道") forState:UIControlStateNormal];
    }
}

- (void)applyLiveClass:(NSDictionary *)liveClass {
    self.selectedLiveClass = liveClass;
    self.selectedLiveClassId = LCAnchorLiveStringValue(liveClass[@"id"]);
    NSString *name = LCAnchorLiveStringValue(liveClass[@"name"]);
    [self.liveClassButton setTitle:name.length ? name : KLanguage(@"请选择直播频道") forState:UIControlStateNormal];
}

- (void)handleBackAction {
    if (self.living) {
        [self confirmStopLiveWithCompletion:^{
            [self stopLiveFlow];
        }];
        return;
    }
    [self stopPreviewResources];
    [self popBack];
}

- (void)handleSwitchCameraAction {
    if (!self.livePusher) {
        return;
    }
    [self invokeVoidSelector:NSSelectorFromString(@"switchCamera") target:self.livePusher];
}

- (void)selectCoverAction {
    [self determinePhotoAuthorizationStatus];
}

- (void)selectLiveClassAction {
    if (!self.liveClassOptions.count) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"暂未配置直播频道")];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLanguage(@"选择直播频道") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *item in self.liveClassOptions) {
        NSString *name = LCAnchorLiveStringValue(item[@"name"]);
        [alertController addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self applyLiveClass:item];
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
    if (popoverController) {
        popoverController.sourceView = self.liveClassButton;
        popoverController.sourceRect = self.liveClassButton.bounds;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)startLiveAction {
    [self.view endEditing:YES];
    if (self.startingLive) {
        return;
    }
    if (!self.previewReady) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"相机预览还没准备好，请稍后再试")];
        return;
    }
    if (!self.selectedLiveClassId.length) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"请先选择直播频道")];
        return;
    }
    self.startingLive = YES;
    [self refreshStartButtonState];
    if (self.coverImage) {
        WS(weakSelf)
        [[LCNetWorkManager manager] uploadImgs:self.coverImage success:^(id  _Nullable result) {
            NSString *thumb = LCAnchorLiveStringValue(result[@"info"]);
            if (!thumb.length) {
                NSArray *thumbArray = LCAnchorLiveArrayValue(result[@"info"]);
                thumb = LCAnchorLiveStringValue(thumbArray.firstObject);
            }
            [weakSelf createLiveRoomWithThumb:thumb];
        } failure:^(NSError * _Nullable error) {
            weakSelf.startingLive = NO;
            [weakSelf refreshStartButtonState];
            [SVProgressHUD showMaskViewWithFailure:error.domain.length ? error.domain : KLanguage(@"直播封面上传失败，请重试")];
        }];
        return;
    }
    [self createLiveRoomWithThumb:@""];
}

- (void)createLiveRoomWithThumb:(NSString *)thumb {
    LCUserInfoModel *currentUser = [LCUserInfoManager shareManager].userInfo;
    NSString *title = self.titleTextField.text.length ? self.titleTextField.text : [self defaultLiveTitle];
    self.liveTitle = title;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = LCAnchorLiveStringValue(currentUser.ID);
    params[@"token"] = LCAnchorLiveStringValue(currentUser.token);
    params[@"user_nicename"] = LCAnchorLiveStringValue(currentUser.user_nicename);
    params[@"avatar"] = LCAnchorLiveStringValue(currentUser.avatar);
    params[@"avatar_thumb"] = LCAnchorLiveStringValue(currentUser.avatar_thumb);
    params[@"city"] = LCAnchorLiveStringValue(currentUser.city);
    params[@"province"] = LCAnchorLiveStringValue(currentUser.province);
    params[@"lat"] = @"";
    params[@"lng"] = @"";
    params[@"title"] = title;
    params[@"liveclassid"] = self.selectedLiveClassId;
    params[@"type"] = @"0";
    params[@"type_val"] = @"0";
    params[@"isshop"] = @"0";
    params[@"thumb"] = thumb ?: @"";
    params[@"live_type"] = @"0";
    params[@"deviceinfo"] = [self currentDeviceInfoText];
    WS(weakSelf)
    [[LCNetWorkManager manager] requestUrl:@"Live.createRoom" method:@"POST" params:params success:^(id  _Nullable result) {
        id infoObject = result[@"info"];
        if ([infoObject isKindOfClass:NSArray.class]) {
            infoObject = [((NSArray *)infoObject) firstObject];
        }
        NSDictionary *roomInfo = LCAnchorLiveDictionaryValue(infoObject);
        if (!roomInfo.count) {
            weakSelf.startingLive = NO;
            [weakSelf refreshStartButtonState];
            [SVProgressHUD showMaskViewWithFailure:KLanguage(@"开播失败，服务器没有返回房间信息")];
            return;
        }
        [weakSelf startLiveWithRoomInfo:roomInfo];
    } failure:^(NSError * _Nullable error) {
        weakSelf.startingLive = NO;
        [weakSelf refreshStartButtonState];
        [SVProgressHUD showMaskViewWithFailure:error.domain.length ? error.domain : KLanguage(@"开播请求失败，请检查网络后重试")];
    }];
}

- (void)startLiveWithRoomInfo:(NSDictionary *)roomInfo {
    self.stream = LCAnchorLiveStringValue(roomInfo[@"stream"]);
    self.chatServer = LCAnchorLiveStringValue(roomInfo[@"chatserver"]);
    self.pushUrl = LCAnchorLiveStringValue(roomInfo[@"push"]);
    NSString *txAppId = LCAnchorLiveStringValue(roomInfo[@"tx_appid"]);
    if (txAppId.length) {
        [common saveTXSDKAppID:txAppId];
    }
    if (!self.stream.length || !self.pushUrl.length) {
        self.startingLive = NO;
        [self refreshStartButtonState];
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"开播失败，推流地址缺失")];
        return;
    }

    NSInteger pushResult = [self invokeIntegerSelector:NSSelectorFromString(@"startPush:") target:self.livePusher objectArgument:self.pushUrl];
    if (pushResult != 0) {
        self.startingLive = NO;
        [self refreshStartButtonState];
        [self stopLiveRoomSilently];
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"推流启动失败，请稍后重试")];
        return;
    }

    self.startingLive = NO;
    self.living = YES;
    self.liveStartDate = [NSDate date];
    [self refreshStartButtonState];
    self.readyPanelView.hidden = YES;
    self.liveOverlayView.hidden = NO;
    [self startLiveTimerIfNeeded];
    [self connectSocketIfNeeded];
    [self notifyLiveChanged];
    [SVProgressHUD showNoMaskViewWithSuccess:KLanguage(@"已开始直播")];
}

- (void)notifyLiveChanged {
    if (!self.stream.length) {
        return;
    }
    [[LCNetWorkManager manager] requestUrl:@"Live.changeLive" method:@"POST" params:@{@"stream": self.stream, @"status": @"1"} success:^(id  _Nullable result) {
        (void)result;
    } failure:^(NSError * _Nullable error) {
        (void)error;
    }];
}

- (void)stopLiveButtonAction {
    [self confirmStopLiveWithCompletion:^{
        [self stopLiveFlow];
    }];
}

- (void)confirmStopLiveWithCompletion:(dispatch_block_t)completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLanguage(@"结束直播") message:KLanguage(@"确认结束当前直播吗？") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)stopLiveFlow {
    if (self.stoppingLive) {
        return;
    }
    self.stoppingLive = YES;
    self.living = NO;
    NSString *stream = self.stream;
    [self invalidateLiveTimer];
    [self disconnectSocket];
    [self stopPreviewResources];
    self.liveOverlayView.hidden = YES;
    [SVProgressHUD showWithMaskView];
    WS(weakSelf)
    [self requestStopRoomForStream:stream completion:^(NSError *error) {
        [weakSelf requestStopInfoForStream:stream completion:^(NSDictionary *summaryInfo) {
            weakSelf.stoppingLive = NO;
            [SVProgressHUD dismiss];
            if (error && !summaryInfo.count) {
                [SVProgressHUD showMaskViewWithFailure:error.domain.length ? error.domain : KLanguage(@"直播已结束，结算信息同步失败")];
            }
            NSDictionary *summary = [weakSelf stopSummaryDisplayDataWithInfo:summaryInfo];
            [weakSelf showStopSummaryWithInfo:summary];
        }];
    }];
}

- (void)requestStopRoomForStream:(NSString *)stream completion:(void (^)(NSError *error))completion {
    if (!stream.length) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    LCUserInfoModel *currentUser = [LCUserInfoManager shareManager].userInfo;
    NSString *time = [NSString stringWithFormat:@"%ld", (NSInteger)[[NSDate date] timeIntervalSince1970]];
    NSString *signSource = [NSString stringWithFormat:@"stream=%@&time=%@&token=%@&uid=%@&%@", stream, time, LCAnchorLiveStringValue(currentUser.token), LCAnchorLiveStringValue(currentUser.ID), LCAnchorLiveStopSalt];
    NSDictionary *params = @{
        @"stream": stream,
        @"uid": LCAnchorLiveStringValue(currentUser.ID),
        @"token": LCAnchorLiveStringValue(currentUser.token),
        @"time": time,
        @"sign": [signSource md5String] ?: @""
    };
    [[LCNetWorkManager manager] requestUrl:@"Live.stopRoom" method:@"POST" params:params success:^(id  _Nullable result) {
        (void)result;
        if (completion) {
            completion(nil);
        }
    } failure:^(NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)requestStopInfoForStream:(NSString *)stream completion:(void (^)(NSDictionary *summaryInfo))completion {
    if (!stream.length) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    [[LCNetWorkManager manager] requestUrl:@"Live.StopInfo" method:@"POST" params:@{@"stream": stream} success:^(id  _Nullable result) {
        id infoObject = result[@"info"];
        if ([infoObject isKindOfClass:NSArray.class]) {
            infoObject = [((NSArray *)infoObject) firstObject];
        }
        NSDictionary *info = LCAnchorLiveDictionaryValue(infoObject);
        if (completion) {
            completion(info);
        }
    } failure:^(NSError * _Nullable error) {
        (void)error;
        if (completion) {
            completion(nil);
        }
    }];
}

- (NSDictionary *)stopSummaryDisplayDataWithInfo:(NSDictionary *)summaryInfo {
    NSMutableDictionary *summary = [NSMutableDictionary dictionaryWithDictionary:summaryInfo ?: @{}];
    LCUserInfoModel *currentUser = [LCUserInfoManager shareManager].userInfo;
    if (!LCAnchorLiveStringValue(summary[@"avatar"]).length) {
        summary[@"avatar"] = LCAnchorLiveStringValue(currentUser.avatar);
    }
    if (!LCAnchorLiveStringValue(summary[@"user_nicename"]).length) {
        summary[@"user_nicename"] = LCAnchorLiveStringValue(currentUser.user_nicename);
    }
    if (!LCAnchorLiveStringValue(summary[@"length"]).length) {
        summary[@"length"] = [self currentLiveDurationText];
    }
    if (!LCAnchorLiveStringValue(summary[@"votes"]).length) {
        summary[@"votes"] = @"0";
    }
    if (!LCAnchorLiveStringValue(summary[@"nums"]).length) {
        summary[@"nums"] = @"0";
    }
    return summary;
}

- (void)showStopSummaryWithInfo:(NSDictionary *)summaryInfo {
    LCLiveStopInfoView *summaryView = [[LCLiveStopInfoView alloc] initWithFrame:self.view.bounds dataDic:summaryInfo ?: @{}];
    WS(weakSelf)
    summaryView.backBlock = ^{
        [weakSelf popBack];
    };
    [self.view addSubview:summaryView];
}

- (void)requestLivePermissionsIfNeeded {
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus micStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (cameraStatus == AVAuthorizationStatusDenied || cameraStatus == AVAuthorizationStatusRestricted) {
        [self showPermissionSettingsAlertWithMessage:KLanguage(@"请先在系统设置中允许访问相机，才能开始直播")];
        return;
    }
    if (micStatus == AVAuthorizationStatusDenied || micStatus == AVAuthorizationStatusRestricted) {
        [self showPermissionSettingsAlertWithMessage:KLanguage(@"请先在系统设置中允许访问麦克风，才能开始直播")];
        return;
    }

    __block BOOL cameraGranted = cameraStatus == AVAuthorizationStatusAuthorized;
    __block BOOL micGranted = micStatus == AVAuthorizationStatusAuthorized;
    dispatch_group_t permissionGroup = dispatch_group_create();
    if (cameraStatus == AVAuthorizationStatusNotDetermined) {
        dispatch_group_enter(permissionGroup);
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            cameraGranted = granted;
            dispatch_group_leave(permissionGroup);
        }];
    }
    if (micStatus == AVAuthorizationStatusNotDetermined) {
        dispatch_group_enter(permissionGroup);
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            micGranted = granted;
            dispatch_group_leave(permissionGroup);
        }];
    }
    dispatch_group_notify(permissionGroup, dispatch_get_main_queue(), ^{
        if (!cameraGranted) {
            [self showPermissionSettingsAlertWithMessage:KLanguage(@"请先在系统设置中允许访问相机，才能开始直播")];
            return;
        }
        if (!micGranted) {
            [self showPermissionSettingsAlertWithMessage:KLanguage(@"请先在系统设置中允许访问麦克风，才能开始直播")];
            return;
        }
        [self startPreviewIfNeeded];
    });
    if (cameraStatus == AVAuthorizationStatusAuthorized && micStatus == AVAuthorizationStatusAuthorized) {
        [self startPreviewIfNeeded];
    }
}

- (void)showPermissionSettingsAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLanguage(@"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"去设置") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)startPreviewIfNeeded {
    if (self.previewReady) {
        return;
    }
    if (!self.livePusher) {
        self.livePusher = [self createLivePusherInstance];
    }
    if (!self.livePusher) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"当前 iOS 客户端未正确接入推流能力")];
        return;
    }
    [self invokeVoidSelector:NSSelectorFromString(@"setRenderView:") target:self.livePusher objectArgument:self.previewView];
    NSInteger cameraResult = [self invokeIntegerSelector:NSSelectorFromString(@"startCamera:") target:self.livePusher boolArgument:YES];
    NSInteger micResult = [self invokeIntegerSelector:NSSelectorFromString(@"startMicrophone") target:self.livePusher];
    self.previewReady = cameraResult == 0 && micResult == 0;
    if (!self.previewReady) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"相机预览启动失败，请检查权限后重试")];
    }
}
- (id)createLivePusherInstance {
    Class pusherClass = NSClassFromString(@"V2TXLivePusher");
    if (!pusherClass) {
        return nil;
    }
    id instance = [pusherClass alloc];
    SEL selector = NSSelectorFromString(@"initWithLiveMode:");
    if (![instance respondsToSelector:selector]) {
        return [instance init];
    }
    NSMethodSignature *signature = [instance methodSignatureForSelector:selector];
    if (!signature) {
        return [instance init];
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = instance;
    invocation.selector = selector;
    NSInteger mode = 0;
    [invocation setArgument:&mode atIndex:2];
    [invocation invoke];
    __unsafe_unretained id returnValue = nil;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

- (void)stopPreviewResources {
    if (!self.livePusher) {
        self.previewReady = NO;
        return;
    }
    [self invokeVoidSelector:NSSelectorFromString(@"stopPush") target:self.livePusher];
    [self invokeVoidSelector:NSSelectorFromString(@"stopMicrophone") target:self.livePusher];
    [self invokeVoidSelector:NSSelectorFromString(@"stopCamera") target:self.livePusher];
    self.livePusher = nil;
    self.previewReady = NO;
}

- (void)stopLiveRoomSilently {
    NSString *stream = self.stream;
    if (!stream.length) {
        return;
    }
    [self requestStopRoomForStream:stream completion:^(NSError *error) {
        (void)error;
    }];
}

- (void)startLiveTimerIfNeeded {
    [self invalidateLiveTimer];
    self.timerLabel.text = @"00:00:00";
    self.liveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLiveTimerTick) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.liveTimer forMode:NSRunLoopCommonModes];
}

- (void)invalidateLiveTimer {
    [self.liveTimer invalidate];
    self.liveTimer = nil;
}

- (void)handleLiveTimerTick {
    self.timerLabel.text = [self currentLiveDurationText];
}

- (NSString *)currentLiveDurationText {
    if (!self.liveStartDate) {
        return @"00:00:00";
    }
    NSInteger totalSeconds = MAX((NSInteger)[[NSDate date] timeIntervalSinceDate:self.liveStartDate], 0);
    NSInteger hour = totalSeconds / 3600;
    NSInteger minute = (totalSeconds % 3600) / 60;
    NSInteger second = totalSeconds % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];
}

- (NSString *)currentDeviceInfoText {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@ %@ %@", LCAnchorLiveStringValue(device.model), LCAnchorLiveStringValue(device.systemName), LCAnchorLiveStringValue(device.systemVersion)];
}

- (void)connectSocketIfNeeded {
    if (!self.chatServer.length || !self.stream.length) {
        return;
    }
    [[LCSocketManager shareManager] connetToSever:self.chatServer delegate:self roomId:[LCUserInfoManager shareManager].userInfo.ID stream:self.stream];
}

- (void)disconnectSocket {
    [[LCSocketManager shareManager] disconnect];
}

- (void)refreshStartButtonState {
    self.startButton.enabled = !self.startingLive;
    self.startButton.alpha = self.startingLive ? 0.72 : 1.0;
    NSString *title = self.startingLive ? KLanguage(@"正在创建直播间...") : KLanguage(@"开始直播");
    [self.startButton setTitle:title forState:UIControlStateNormal];
}

- (void)determinePhotoAuthorizationStatus {
    if ([[TZImageManager manager] authorizationStatusAuthorized]) {
        [self openAlbums];
        return;
    }
    [[TZImageManager manager] requestAuthorizationWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![[TZImageManager manager] authorizationStatusAuthorized]) {
                [self showPermissionSettingsAlertWithMessage:KLanguage(@"没有权限访问您的照片，是否前往设置允许该应用使用照片？")];
            } else {
                [self openAlbums];
            }
        });
    }];
}

- (void)openAlbums {
    TZImagePickerController *albumListVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    albumListVC.allowTakeVideo = NO;
    albumListVC.allowTakePicture = NO;
    albumListVC.allowCrop = YES;
    albumListVC.allowPickingOriginalPhoto = NO;
    albumListVC.cropRect = CGRectMake(kUI_Width(40), (SCREEN_HEIGHT - (SCREEN_WIDTH - kUI_Width(80))) / 2.0, SCREEN_WIDTH - kUI_Width(80), SCREEN_WIDTH - kUI_Width(80));
    WS(weakSelf)
    albumListVC.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *selectedImage = photos.firstObject;
        if (!selectedImage) {
            return;
        }
        weakSelf.coverImage = selectedImage;
        [weakSelf.coverButton setImage:selectedImage forState:UIControlStateNormal];
        weakSelf.coverHintLabel.hidden = YES;
    };
    [self presentViewController:albumListVC animated:YES completion:nil];
}

- (NSInteger)invokeIntegerSelector:(SEL)selector target:(id)target {
    if (!target || ![target respondsToSelector:selector]) {
        return -1;
    }
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        return -1;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    [invocation invoke];
    NSInteger returnValue = 0;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

- (NSInteger)invokeIntegerSelector:(SEL)selector target:(id)target boolArgument:(BOOL)argument {
    if (!target || ![target respondsToSelector:selector]) {
        return -1;
    }
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        return -1;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    BOOL value = argument;
    [invocation setArgument:&value atIndex:2];
    [invocation invoke];
    NSInteger returnValue = 0;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

- (NSInteger)invokeIntegerSelector:(SEL)selector target:(id)target objectArgument:(id)argument {
    if (!target || ![target respondsToSelector:selector]) {
        return -1;
    }
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        return -1;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    id arg = argument;
    [invocation setArgument:&arg atIndex:2];
    [invocation invoke];
    NSInteger returnValue = 0;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

- (void)invokeVoidSelector:(SEL)selector target:(id)target {
    if (!target || ![target respondsToSelector:selector]) {
        return;
    }
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    [invocation invoke];
}

- (void)invokeVoidSelector:(SEL)selector target:(id)target objectArgument:(id)argument {
    if (!target || ![target respondsToSelector:selector]) {
        return;
    }
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    id arg = argument;
    [invocation setArgument:&arg atIndex:2];
    [invocation invoke];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)connectFailured:(NSError *)error {
    (void)error;
}

- (void)connectSuccess:(id)result {
    (void)result;
}

- (void)disConnect:(id)result {
    (void)result;
}

- (void)netWorkChanged {
}

- (void)receiveMessage:(id)message {
    (void)message;
}

@end

@interface LCMainStartSheetView : UIControl
@property (nonatomic, copy) dispatch_block_t liveActionBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;
- (void)showInView:(UIView *)view;
- (void)dismiss;
@end

@interface LCMainStartSheetView ()
@property (nonatomic, strong) UIView *panelView;
@end

@implementation LCMainStartSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = ColorAlpha(@"#000000", 0.0);
    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    UIView *panelView = [[UIView alloc] initWithFrame:CGRectZero];
    panelView.backgroundColor = UIColor.whiteColor;
    panelView.clipsToBounds = YES;
    if (@available(iOS 11.0, *)) {
        panelView.layer.cornerRadius = kUI_Width(20);
        panelView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    } else {
        panelView.layer.cornerRadius = kUI_Width(20);
    }
    self.panelView = panelView;
    [self addSubview:panelView];
    [panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
    }];

    UIControl *liveControl = [[UIControl alloc] initWithFrame:CGRectZero];
    [liveControl addTarget:self action:@selector(handleLiveAction) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:liveControl];
    [liveControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kUI_Width(15));
        make.centerX.equalTo(0);
        make.width.mas_equalTo(kUI_Width(120));
        make.height.mas_equalTo(kUI_Width(92));
    }];

    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.image = image(@"MainStartLiveIcon");
    [liveControl addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.centerX.equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kUI_Width(70), kUI_Width(70)));
    }];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = RegularFont(14);
    titleLabel.textColor = Color(@"#646464");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = KLanguage(@"开始直播");
    [liveControl addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.mas_equalTo(kUI_Width(20));
    }];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:image(@"MainStartCloseIcon") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveControl.mas_bottom).offset(kUI_Width(5));
        make.centerX.equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kUI_Width(50), kUI_Width(50)));
        make.bottom.mas_equalTo(-(KSafeHeight + kUI_Width(10)));
    }];
}

- (void)handleLiveAction {
    if (self.liveActionBlock) {
        self.liveActionBlock();
    }
}

- (void)showInView:(UIView *)view {
    self.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:self];
    [self layoutIfNeeded];
    self.panelView.transform = CGAffineTransformMakeTranslation(0, kUI_Width(240));
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = ColorAlpha(@"#000000", 0.3);
        self.panelView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = ColorAlpha(@"#000000", 0.0);
        self.panelView.transform = CGAffineTransformMakeTranslation(0, kUI_Width(240));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}

@end

@interface LCTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic, weak) CALayer *tabLayer;
@property (nonatomic, weak) UIView *tabBarView;
@property (nonatomic, strong) LCMainStartSheetView *startSheetView;
@end

@implementation LCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.delegate = self;
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameStatusNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf createUI];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tabBar.frame = CGRectMake(0, self.view.height - LCTabBarTotalHeight(), self.view.width, LCTabBarTotalHeight());
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tabBar.frame = CGRectMake(0, self.view.height - LCTabBarTotalHeight(), self.view.width, LCTabBarTotalHeight());
}

- (void)createUI {
    self.tabBar.frame = CGRectMake(0, self.view.height - LCTabBarTotalHeight(), self.view.width, LCTabBarTotalHeight());
    self.tabBar.hidden = YES;
    if (_tabBarView) {
        [self.tabBarView removeAllSubviews];
    }
    [self.tabBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(0);
        make.height.mas_equalTo(LCTabBarTotalHeight());
    }];

    NSString *title1 = KLanguage(@"首页");
    NSString *title2 = KLanguage(@"游戏");
    NSString *title4 = KLanguage(@"充值");
    NSString *title5 = KLanguage(@"我的");

    BOOL hasGameTab = [LCGameConfigManager shareManager].gameStatus;
    NSMutableArray<LCTabbarButton *> *tabButtons = [NSMutableArray array];
    WS(weakSelf)
    LCTabbarButton *(^makeTabButton)(NSString *, NSString *, NSString *, NSInteger) = ^LCTabbarButton *(NSString *normalImageName, NSString *selectedImageName, NSString *title, NSInteger tabTag) {
        LCTabbarButton *button = [[LCTabbarButton alloc] initWithFrame:CGRectZero normalImage:image(normalImageName) selectImage:image(selectedImageName) title:title imageSize:CGSizeMake(LCTabBarIconSide(), LCTabBarIconSide())];
        button.tag = tabTag;
        button.tabSelectedBlock = ^(LCTabbarButton * _Nonnull selectedView) {
            NSInteger index = selectedView.tag - 200;
            if (weakSelf.selectedIndex != index) {
                weakSelf.selectedIndex = index;
                [selectedView makeImgViewSelected:YES animated:NO];
                [weakSelf resetAnimation];
            }
        };
        button.refreshBlock = ^{
        };
        return button;
    };

    [tabButtons addObject:makeTabButton(@"Tabbar1", @"TabbarS1", title1, 200)];
    if (hasGameTab) {
        [tabButtons addObject:makeTabButton(@"Tabbar2", @"TabbarS2", title2, 201)];
    }
    [tabButtons addObject:makeTabButton(@"Tabbar4", @"TabbarS4", title4, hasGameTab ? 202 : 201)];
    [tabButtons addObject:makeTabButton(@"Tabbar5", @"TabbarS5", title5, hasGameTab ? 203 : 202)];

    for (LCTabbarButton *button in tabButtons) {
        [self.tabBarView addSubview:button];
    }

    UIControl *startLiveControl = [[UIControl alloc] initWithFrame:CGRectZero];
    [startLiveControl addTarget:self action:@selector(showStartDialog) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView addSubview:startLiveControl];
    [startLiveControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.mas_equalTo(-KSafeHeight);
        make.width.mas_equalTo(LCTabBarCenterSlotWidth());
        make.height.mas_equalTo(LCTabBarContentHeight());
    }];

    UIImageView *startLiveIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    startLiveIconView.contentMode = UIViewContentModeScaleAspectFit;
    startLiveIconView.image = image(@"TabbarLiveCenter");
    [startLiveControl addSubview:startLiveIconView];
    [startLiveIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kUI_Width(4));
        make.centerX.equalTo(0);
        make.size.mas_equalTo(CGSizeMake(LCTabBarIconSide(), LCTabBarIconSide()));
    }];

    UILabel *startLiveLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    startLiveLabel.font = RegularFont(11);
    startLiveLabel.textColor = Color(@"#646464");
    startLiveLabel.textAlignment = NSTextAlignmentCenter;
    startLiveLabel.text = KLanguage(@"直播");
    [startLiveControl addSubview:startLiveLabel];
    [startLiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startLiveIconView.mas_bottom).offset(kUI_Width(2));
        make.left.right.equalTo(0);
        make.height.mas_equalTo(kUI_Width(11));
    }];

    CGFloat sideButtonWidth = floor((SCREEN_WIDTH - LCTabBarCenterSlotWidth()) / MAX(tabButtons.count, 1));
    NSInteger leftButtonCount = hasGameTab ? 2 : 1;

    UIView *previousLeftButton = nil;
    for (NSInteger index = 0; index < MIN(leftButtonCount, tabButtons.count); index++) {
        LCTabbarButton *button = tabButtons[index];
        UIView *leftAnchor = previousLeftButton;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KSafeHeight);
            make.height.mas_equalTo(LCTabBarContentHeight());
            make.width.mas_equalTo(sideButtonWidth);
            if (leftAnchor) {
                make.left.equalTo(leftAnchor.mas_right);
            } else {
                make.left.equalTo(0);
            }
        }];
        previousLeftButton = button;
    }

    UIView *previousRightAnchor = startLiveControl;
    for (NSInteger index = leftButtonCount; index < tabButtons.count; index++) {
        LCTabbarButton *button = tabButtons[index];
        UIView *rightAnchor = previousRightAnchor;
        BOOL isLastButton = index == tabButtons.count - 1;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KSafeHeight);
            make.height.mas_equalTo(LCTabBarContentHeight());
            make.left.equalTo(rightAnchor.mas_right);
            if (isLastButton) {
                make.right.equalTo(0);
            } else {
                make.width.mas_equalTo(sideButtonWidth);
            }
        }];
        previousRightAnchor = button;
    }

    LCHomeViewController *homeViewController = [[LCHomeViewController alloc] init];
    LCGameCenterViewController *gameViewController = [[LCGameCenterViewController alloc] init];
    LCRechageViewController *rechargeViewController = [[LCRechageViewController alloc] init];
    LCMineViewController *mineViewController = [[LCMineViewController alloc] init];

    UINavigationController *homeNavigationController = [self createNaviwithRootVC:homeViewController];
    UINavigationController *gameNavigationController = [self createNaviwithRootVC:gameViewController];
    UINavigationController *rechargeNavigationController = [self createNaviwithRootVC:rechargeViewController];
    UINavigationController *mineNavigationController = [self createNaviwithRootVC:mineViewController];

    NSArray<UINavigationController *> *viewControllers = hasGameTab ? @[homeNavigationController, gameNavigationController, rechargeNavigationController, mineNavigationController] : @[homeNavigationController, rechargeNavigationController, mineNavigationController];
    NSInteger targetIndex = self.viewControllers.count ? MIN(self.selectedIndex, viewControllers.count - 1) : 0;
    self.viewControllers = viewControllers;
    self.selectedIndex = MAX(targetIndex, 0);

    [self resetAnimation];
}

- (UINavigationController *)createNaviwithRootVC:(UIViewController *)vc {
    LCNavigationViewController *navigationController = [[LCNavigationViewController alloc] initWithRootViewController:vc];
    return navigationController;
}

- (void)resetAnimation {
    NSInteger index = self.selectedIndex;
    for (NSInteger i = 0; i < self.viewControllers.count; i++) {
        LCTabbarButton *button = [self.tabBarView viewWithTag:i + 200];
        [button makeImgViewSelected:index == i];
    }
}

- (void)showStartDialog {
    if (self.startSheetView.superview) {
        return;
    }
    LCMainStartSheetView *sheetView = [[LCMainStartSheetView alloc] initWithFrame:CGRectZero];
    self.startSheetView = sheetView;
    WS(weakSelf)
    sheetView.liveActionBlock = ^{
        [weakSelf handleStartLiveAction];
    };
    sheetView.dismissBlock = ^{
        weakSelf.startSheetView = nil;
    };
    UIView *hostView = [UIApplication sharedApplication].delegate.window ?: self.view;
    [sheetView showInView:hostView];
}

- (void)handleStartLiveAction {
    [self.startSheetView dismiss];
    if (![LCUserInfoManager shareManager].userInfo.token.length || [[LCUserInfoManager shareManager].userInfo.isyouke boolValue]) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"请先登录后再开始直播")];
        return;
    }

    [self checkAnchorPermissionWithCompletion:^(BOOL canStart, NSDictionary *userInfo) {
        if (!canStart) {
            return;
        }
        [self forwardStartLiveWithUserInfo:userInfo];
    }];
}

- (void)checkAnchorPermissionWithCompletion:(void (^)(BOOL canStart, NSDictionary *userInfo))completion {
    LCUserInfoApi *api = [LCUserInfoApi new];
    api.userId = [LCUserInfoManager shareManager].userInfo.ID;
    api.userToken = [LCUserInfoManager shareManager].userInfo.token;
    [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
        if (![result isKindOfClass:NSDictionary.class]) {
            [SVProgressHUD showMaskViewWithFailure:KLanguage(@"网络错误")];
            if (completion) {
                completion(NO, nil);
            }
            return;
        }

        NSArray *infoArray = result[@"info"];
        NSDictionary *userInfo = [infoArray isKindOfClass:NSArray.class] ? infoArray.firstObject : nil;
        if (![userInfo isKindOfClass:NSDictionary.class]) {
            [SVProgressHUD showMaskViewWithFailure:KLanguage(@"网络错误")];
            if (completion) {
                completion(NO, nil);
            }
            return;
        }

        id isAnchorObject = userInfo[@"isanchor"] ?: userInfo[@"isAnchor"] ?: userInfo[@"is_anchor"];
        BOOL hasAnchorFlag = isAnchorObject != nil;
        NSString *isAnchorValue = hasAnchorFlag ? [NSString stringWithFormat:@"%@", isAnchorObject] : @"";
        if (hasAnchorFlag && isAnchorValue.integerValue != 1) {
            [SVProgressHUD showMaskViewWithFailure:KLanguage(@"请先联系客服开通主播")];
            if (completion) {
                completion(NO, userInfo);
            }
            return;
        }

        if (completion) {
            completion(YES, userInfo);
        }
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD showMaskViewWithFailure:error.domain.length ? error.domain : KLanguage(@"网络错误")];
        if (completion) {
            completion(NO, nil);
        }
    }];
}

- (void)forwardStartLiveWithUserInfo:(NSDictionary *)userInfo {
    UIViewController *selectedController = self.selectedViewController;
    UINavigationController *navigationController = [selectedController isKindOfClass:UINavigationController.class] ? (UINavigationController *)selectedController : selectedController.navigationController;
    if (!navigationController) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"当前页面无法打开开播页")];
        return;
    }
    LCAnchorLiveViewController *viewController = [[LCAnchorLiveViewController alloc] initWithUserInfo:userInfo];
    viewController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:viewController animated:YES];
}

- (void)makeTabbarViewHidden:(BOOL)hidden {
    self.tabBarView.hidden = hidden;
    self.tabBar.hidden = YES;
}

- (void)selectAtIndex:(NSInteger)index {
    self.selectedIndex = index;
    [self resetAnimation];
    self.tabBar.hidden = YES;
}

- (void)refreshView {
    UIViewController *currentVC = self.selectedViewController;
    if ([currentVC respondsToSelector:@selector(refreshVisibledView)]) {
        [currentVC performSelector:@selector(refreshVisibledView)];
    }
}

- (UIView *)tabBarView {
    if (_tabBarView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        _tabBarView = view;
        _tabBarView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tabBarView];
    }
    return _tabBarView;
}

@end


