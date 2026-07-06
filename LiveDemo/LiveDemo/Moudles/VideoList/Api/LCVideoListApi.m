//
//  LCVideoListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCVideoListApi.h"

@implementation LCVideoListApi
- (NSString *)requestMethod{
    return @"POST";
}
- (NSString *)requestUrl{
    return @"Video.getClassVideo";
}
- (NSDictionary *)requestListParams{
    if(self.channelId.length){
        return @{@"videoclassid":self.channelId};
    }
    return nil;
    
    
}
@end
