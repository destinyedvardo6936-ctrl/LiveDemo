//
//  LCChatMessageModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCChatMessageModel : LCBaseModel
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger               type;//1、系统通知 2、用户发送的消息 3、礼物 4、彩票跟投 5、守护主播 6、彩票中奖
@property (nonatomic , copy) NSAttributedString     *attContent;

@property (nonatomic , copy) NSString              * roomnum;
@property (nonatomic , copy) NSString              * vip_type;
@property (nonatomic , copy) NSString              * uname;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * action;
@property (nonatomic , copy) NSString              * tougood;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * guard_type;
@property (nonatomic , copy) NSString              * liangname;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * ugood;
@property (nonatomic , copy) NSString              * issuper;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * isAnchor;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * equipment;

@property (nonatomic , copy) NSString              * timestamp;
@property (nonatomic , copy) NSString              * touname;
@property (nonatomic , copy) NSString              * touid;
@property (nonatomic , copy) NSString              * usign;
@property (nonatomic , copy) NSString              * uhead;

@property (nonatomic , copy) NSDictionary *lotteryTicketDic;
//@property (nonatomic , strong) UIColor *backgroundColor;
//@property (nonatomic , copy) NSString              * msgtype;
//@property (nonatomic , copy) NSString              * _method_;

- (void )changeContentToAtttributeString;
@end

NS_ASSUME_NONNULL_END
