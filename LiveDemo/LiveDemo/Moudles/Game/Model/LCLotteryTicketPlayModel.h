//
//  LCLotteryTicketPlayModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
//{"title":"用户 自然扯热狗在一分快三玩法中已成功下注1.00元","biaoshi":"f1k3","wanfaxiid":"22","zhushu":null,"trano":"2023032850102495","itemcount":"1","beishu":"1","money":"1.00","value":"单","peilv":"1.96"}
@interface LCLotteryTicketWanFaModel : LCBaseModel
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * wanfa_id;
@property (nonatomic , copy) NSString              * peilv;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * caipiao_id;
@property (nonatomic , copy) NSString              * wanfaname;
@property (nonatomic , copy) NSString              * gameid;

@property (nonatomic , copy) NSString              * biaoshi;
@property (nonatomic , copy) NSString *gameName;
@property (nonatomic , copy,nullable) NSString *coin;

@property (nonatomic , assign) BOOL isSelected;
@end

@interface LCLotteryTicketCoinModel : LCBaseModel
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * coin;
@property (nonatomic , copy) NSString              * img;
@property (nonatomic , assign) BOOL isSelected;
@end
@interface LCLotteryTicketSQKJModel : LCBaseModel
@property (nonatomic , copy) NSString              * opencode;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * expect;
@property (nonatomic , copy) NSString              * name;
@end

@interface LCLotteryTicketPlayModel : LCBaseModel
@property (nonatomic , copy) NSArray<LCLotteryTicketWanFaModel *>              * wanfa;
@property (nonatomic , copy) NSArray<LCLotteryTicketSQKJModel *>              * sqkj;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * nowexpect;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSArray<LCLotteryTicketCoinModel *>              * coinimg;
@property (nonatomic , assign) NSInteger              lefttime;
@end

NS_ASSUME_NONNULL_END
