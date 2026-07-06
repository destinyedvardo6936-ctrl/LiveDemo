//
//  LCChatGiftMessageModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/15.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCChatGiftContentModel : LCBaseModel
@property (nonatomic , copy) NSString              * pktotal1;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * wincoin;
@property (nonatomic , copy) NSString              * isluck;
@property (nonatomic , copy) NSString              * gifticon;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * lucktimes;
@property (nonatomic , copy) NSString              * iswin;
@property (nonatomic , copy) NSString              * isplatgift;
@property (nonatomic , copy) NSString              * luckcoin;
@property (nonatomic , copy) NSString              * touid;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * votestotal;
@property (nonatomic , copy) NSString              * giftcount;
@property (nonatomic , copy) NSString              * coin;
@property (nonatomic , copy) NSString              * isluckall;
@property (nonatomic , copy) NSString              * mark;
@property (nonatomic , copy) NSString              * isup;
@property (nonatomic , copy) NSString              * pkuid2;
@property (nonatomic , copy) NSString              * giftid;
@property (nonatomic , copy) NSString              * swf;
@property (nonatomic , copy) NSString              * pkuid1;
@property (nonatomic , copy) NSString              * ispk;
@property (nonatomic , assign) NSInteger              totalcoin;
@property (nonatomic , copy) NSString              * pktotal2;
@property (nonatomic , copy) NSString              * swftime;
@property (nonatomic , copy) NSString              * uplevel;
@property (nonatomic , copy) NSString              * sticker_id;
@property (nonatomic , copy) NSString              * upcoin;
@property (nonatomic , copy) NSString              * giftname;
@property (nonatomic , copy) NSString              * swftype;
@property (nonatomic , assign) BOOL              pkuid;
@property (nonatomic , copy) NSString              * to_username;
@end

@interface LCChatGiftMessageModel : LCBaseModel
@property (nonatomic , copy) NSString              * evensend;
@property (nonatomic , copy) NSString              * msgtype;
@property (nonatomic , copy) NSString              * ifpk;
@property (nonatomic , copy) NSString              * roomnum;
@property (nonatomic , copy) NSString              * pktotal2;
@property (nonatomic , copy) NSString              * vip_type;
@property (nonatomic , copy) NSString              * uname;
//@property (nonatomic , copy) NSArray<PaintedPath *>              * paintedPath;
@property (nonatomic , copy) NSString              * action;
@property (nonatomic , copy) NSString              * livename;
//@property (nonatomic , copy) NSString              * paintedHeight;
@property (nonatomic , strong) LCChatGiftContentModel              * ct;
//@property (nonatomic , copy) NSString              * paintedWidth;
@property (nonatomic , copy) NSString              * pkuid2;
//@property (nonatomic , copy) NSString              * _method_;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * liangname;
@property (nonatomic , copy) NSString              * equipment;
@property (nonatomic , copy) NSString              * pktotal1;
@property (nonatomic , copy) NSString              * pkuid1;
@property (nonatomic , copy) NSString              * uhead;
@end

NS_ASSUME_NONNULL_END
