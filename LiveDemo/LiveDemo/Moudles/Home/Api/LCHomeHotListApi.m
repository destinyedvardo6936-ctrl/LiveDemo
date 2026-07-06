//
//  LCHomeHotListApi.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/31.
//

#import "LCHomeHotListApi.h"

@implementation LCHomeHotListApi
- (NSString *)requestMethod{
    return @"POST";
}
- (NSString *)requestUrl{
    return @"Home.GetHot";
}
- (NSDictionary *)requestListParams{
    if(self.channelId.length){
        return @{@"classid":self.channelId};
    }
    return nil;
    
    
}
@end
