//
//  LCLiveCheckRoomTypeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/25.
//

#import "LCLiveCheckRoomTypeApi.h"

@implementation LCLiveCheckRoomTypeApi
- (NSString *)requestUrl{
    return @"Live.CheckLive";
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
    return dic;
}
@end
