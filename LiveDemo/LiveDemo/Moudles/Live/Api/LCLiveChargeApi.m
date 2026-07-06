//
//  LCLiveChargeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/29.
//

#import "LCLiveChargeApi.h"

@implementation LCLiveChargeApi
- (NSString *)requestUrl{
    return @"Live.RoomCharge";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.roomId.length){
        dic[@"liveuid"] = self.roomId;
    }
    if(self.stream.length){
        dic[@"stream"] = self.stream;
    }
    return dic;
}
@end
