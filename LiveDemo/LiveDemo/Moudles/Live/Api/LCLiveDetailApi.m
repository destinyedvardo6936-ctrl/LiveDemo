//
//  LCLiveDetailApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCLiveDetailApi.h"

@implementation LCLiveDetailApi
- (NSString *)requestUrl{
    return @"Live.EnterRoom";
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
