//
//  LCSendDanMuApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/30.
//

#import "LCSendDanMuApi.h"

@implementation LCSendDanMuApi
- (NSString *)requestUrl{
    return @"Live.SendBarrage";
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
    if(self.content.length){
        dic[@"content"] = self.content;
    }
    return dic;
}
@end
