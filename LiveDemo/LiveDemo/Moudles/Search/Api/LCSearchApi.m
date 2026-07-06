//
//  LCSearchApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCSearchApi.h"

@implementation LCSearchApi
- (NSString *)requestUrl{
    return @"Home.Search";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    if(self.searchText.length){
        return @{@"key":self.searchText};
    }
    return nil;
}
@end
