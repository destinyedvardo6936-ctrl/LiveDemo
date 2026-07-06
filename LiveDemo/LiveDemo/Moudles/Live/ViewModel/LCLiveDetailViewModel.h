//
//  LCLiveDetailViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/12/2.
//

#import "LCBaseViewModel.h"
#import "LCHomeListModel.h"
#import "LCLiveModel.h"
#import "LCLiveArchorModel.h"
#import "LCLiveRoomTypeModel.h"
#import "LCChatMessageModel.h"
#import "LCLiveGiftModel.h"
#import "LCChatGiftMessageModel.h"
#import "LCLotteryTicketPlayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveDetailViewModel : LCBaseViewModel

@property (nonatomic , strong) LCHomeListModel *origalModel;
@property (nonatomic , strong) LCLiveModel *dataModel;
@property (nonatomic , strong) NSMutableArray *msgArray;//消息公屏
@property (nonatomic , strong) NSMutableArray *userAccessArray;
@property (nonatomic , strong) NSMutableArray *recommendRoomArray;
@property (nonatomic , strong) LCLiveArchorModel *archorModel;
@property (nonatomic , strong) LCLiveRoomTypeModel *roomTypeModel;
@property (nonatomic , copy) NSString *lotteryTicketCutDownTimeStr;

@property (nonatomic , strong) RACCommand *checkTypeCommand;
@property (nonatomic , strong) RACSubject *checkTypeSubject;
@property (nonatomic , strong) RACCommand *followCommand;
@property (nonatomic , strong) RACSubject *followSubject;

@property (nonatomic , strong) RACCommand *stopInfoCommand;
@property (nonatomic , strong) RACSubject *stopInfoSubject;

@property (nonatomic , strong) RACCommand *chargeCommand;
@property (nonatomic , strong) RACSubject *chargeSubject;
@property (nonatomic , strong) LCLotteryTicketSQKJModel *sqkj;//上期开奖


@property (nonatomic , strong) RACCommand *recommendLiveCommand;
@property (nonatomic , strong) RACSubject *recommendLiveSubject;
//socket相关
@property (nonatomic , strong) RACSubject *messageAddSubject;//公屏消息增加

@property (nonatomic , strong) RACSubject *disConnectSubject;//断开连接
@property (nonatomic , strong) RACSubject *roomCloseByAdminSubject;//直播间被管理员关闭
@property (nonatomic , strong) RACSubject *liveEndSubject;//直播结束
@property (nonatomic , strong) RACSubject *liveTypeChangeSubject;//直播间类型切换



@property (nonatomic , strong) RACSubject *audienceChangeSubject;//观众变化
@property (nonatomic , strong) RACSubject *userAccessSubject;//用户进入
@property (nonatomic , strong) RACSubject *userLeaveSubject;//用户离开



@property (nonatomic , strong) RACSubject *adminLevelSubject;//设置管理员
@property (nonatomic , strong) RACSubject *adminLevelCancelSubject;//取消设置管理员
@property (nonatomic , strong) RACSubject *shutUpSubject;//禁言
@property (nonatomic , strong) RACSubject *kickUserSubject;//踢人

@property (nonatomic , assign) BOOL isDanmu;//是否弹幕

@property (nonatomic , strong) RACSubject *danmuSubject;//弹幕
@property (nonatomic , strong) RACCommand *sendDanmuCommand;
@property (nonatomic , strong) RACSubject *sendDanmuSubject;

@property (nonatomic , strong) RACSubject *giftAllPlatformSubject;//全站礼物
@property (nonatomic , strong) RACSubject *sendGiftSubject;//送礼物

@property (nonatomic , strong) RACSubject *lightSubject;//点赞点亮

@property (nonatomic , strong) RACSubject *addCoinSubject;//增加映票



@property (nonatomic , strong) RACSubject *buyGuardSubject;//购买守护

@property (nonatomic , strong) RACSubject *gameXiaZhuSubject;//游戏下注
@property (nonatomic , strong) RACSubject *gameKaiJiangSubject;//游戏开奖
@property (nonatomic , strong) RACSubject *gameTimeSubject;//游戏倒计时
@property (nonatomic , strong) RACSubject *winningPrizeSubject;//中奖


@end

NS_ASSUME_NONNULL_END
