//
//  LCShortVideoCategoryListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/8.
//

#import "LCShortVideoCategoryListApi.h"

@implementation LCShortVideoCategoryListApi
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
