//
//  LCHomeGameLiveListApi.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/31.
//

#import "LCHomeGameLiveListApi.h"

@implementation LCHomeGameLiveListApi
- (NSString *)requestMethod{
    return @"POST";
}
- (NSString *)requestUrl{
    return @"Home.GetGameLiveList";
}
- (NSDictionary *)requestListParams{
    if(self.channelId.length){
        return @{@"classid":self.channelId};
    }
    return nil;
    
    
}
@end
