//
//  LCHomeRecommendListApi.m
//  liveCommon
//
//  Created by mrgao on 2022/9/30.
//

#import "LCHomeRecommendListApi.h"

@implementation LCHomeRecommendListApi
- (NSString *)requestMethod{
    return @"POST";
}
- (NSString *)requestUrl{
    return @"Home.GetRecommendLive";
}
- (NSDictionary *)requestListParams{
    if(self.channelId.length){
        return @{@"classid":self.channelId};
    }
    return nil;
    
    
}
@end
