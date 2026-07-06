//
//  LCSendGiftApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/14.
//

#import "LCSendGiftApi.h"

@implementation LCSendGiftApi
- (NSString *)requestUrl{
    return @"Live.SendGift";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.liveuid.length){
        dic[@"liveuid"] = self.liveuid;
    }
    if(self.stream.length){
        dic[@"stream"] = self.stream;
    }
    if(self.giftid.length){
        dic[@"giftid"] = self.giftid;
    }
    if(self.giftcount.length){
        dic[@"giftcount"] = self.giftcount;
    }
    if(self.touids.length){
        dic[@"touids"] = self.touids;
    }
    dic[@"ispack"] = self.ispack ? @(1):@(0);
    return dic;
}
@end
