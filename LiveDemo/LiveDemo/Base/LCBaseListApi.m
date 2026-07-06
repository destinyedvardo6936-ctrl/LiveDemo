//
//  LCBaseListApi.m
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import "LCBaseListApi.h"

@implementation LCBaseListApi
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}
- (NSDictionary *)requestParams {
    NSDictionary *dic = [self requestListParams];
    if (dic) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dic];
        [result setObject:@(_page) forKey:@"page"];
        [result setObject:@(_page) forKey:@"p"];
        [result setObject:@(20) forKey:@"pagesize"];
        return result.copy;
    }else{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setObject:@(_page) forKey:@"page"];
               [result setObject:@(_page) forKey:@"p"];
        [result setObject:@(20) forKey:@"pagesize"];
        return result.copy;
    }
}
- (NSDictionary *)requestListParams{
    return nil;
}
@end
