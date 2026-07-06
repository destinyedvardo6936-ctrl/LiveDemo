//
//  LCLotteryTicketConfirmViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCBaseViewModel.h"
#import "LCLotteryTicketPlayViewModel.h"
#import "LCLotteryTicketBeishuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketConfirmViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *zhuboId;
@property (nonatomic , copy) NSString *qihao;
@property (nonatomic , copy) NSString *countDownTime;
@property (nonatomic , strong) NSMutableArray *wanfaSelectArr;
@property (nonatomic , strong) NSMutableArray *beishuArr;
@property (nonatomic , strong) LCLotteryTicketBeishuModel *beishuModel;
@property (nonatomic , assign) NSInteger xiazhuCount;
@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , copy) NSString *totalMoney;
@property (nonatomic , strong) RACCommand *customMoneyCommand;
@property (nonatomic , strong) RACCommand *selectBeishuCommand;
@property (nonatomic , assign) BOOL isFP;//是否在封盘
@property (nonatomic , assign) BOOL isResultRequestSending;
@property (nonatomic , strong) LCLotteryTicketSQKJModel *sqkj;//上期开奖
@property (nonatomic , strong) RACCommand *kaijiangResultCommand;
@property (nonatomic , strong) RACSubject *kaijiangResultSubject;

@property (nonatomic , strong) RACCommand *xiazhuCommand;
@property (nonatomic , strong) RACSubject *xiazhuSubject;


@end

NS_ASSUME_NONNULL_END
