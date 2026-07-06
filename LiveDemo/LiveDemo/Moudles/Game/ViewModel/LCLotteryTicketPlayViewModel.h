//
//  LCLotteryTicketPlayViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCBaseViewModel.h"
#import "LCLotteryTicketPlayModel.h"
#import "LCGameListModel.h"
#import "LCLotteryTicketBeishuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketPlayViewModel : LCBaseViewModel
@property (nonatomic , strong) LCGameListModel *originModel;
@property (nonatomic , strong) NSMutableArray *wanfaSegArr;
@property (nonatomic , strong) LCLotteryTicketPlayModel *dataModel;
@property (nonatomic , strong) NSMutableArray *wanfaSelectArr;
@property (nonatomic , strong) RACCommand *changeWanfaSegCommand;
@property (nonatomic , assign) NSInteger xiazhuCount;
@property (nonatomic , strong) NSString *wanfaSelectTitle;
@property (nonatomic , strong) RACCommand *clearSelectCommand;
@property (nonatomic , strong) RACCommand *jixuanCommand;
@property (nonatomic , strong) RACCommand *selectCoinCommand;
@property (nonatomic , strong) LCLotteryTicketCoinModel *coinModel;
@property (nonatomic , copy) NSString *cutDownTimeStr;
@property (nonatomic , copy) NSString *nowQihaoStr;

@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , strong) RACCommand *balanceCommand;
@property (nonatomic , strong) RACSubject *balanceSubject;

@property (nonatomic , copy , nullable) NSString *customZhuMoneyStr;
@property (nonatomic , strong) RACCommand *customZhuMoneyCommand;//输入每注价格

@property (nonatomic , strong) LCLotteryTicketSQKJModel *sqkj;//上期开奖
@property (nonatomic , assign) BOOL isResultRequestSending;
@property (nonatomic , strong) RACCommand *kaijiangResultCommand;
@property (nonatomic , strong) RACSubject *kaijiangResultSubject;

@property (nonatomic , strong) RACCommand *socketInfoCommand;
@property (nonatomic , strong) RACSubject *socketInfoSubject;
@property (nonatomic , strong) RACCommand *closeSocketCommand;

- (NSMutableArray *)getWanfaArrWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
