//
//  LCLiveStopInfoApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/30.
//

#import "LCLiveStopInfoApi.h"

@implementation LCLiveStopInfoApi
- (NSString *)requestUrl{
    return @"Live.StopInfo";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    if(self.stream.length){
        return @{@"stream":self.stream};
    }
    return nil;
}
@end
