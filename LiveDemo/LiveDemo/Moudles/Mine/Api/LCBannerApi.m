//
//  LCBannerApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBannerApi.h"

@implementation LCBannerApi
- (NSString *)requestUrl{
    return @"Home.GetSlide";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.type.length){
        dic[@"slide"] = self.type;
    }
    
    return dic;
}
@end
