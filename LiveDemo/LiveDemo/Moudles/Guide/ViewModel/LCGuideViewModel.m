//
//  LCGuideViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/3.
//

#import "LCGuideViewModel.h"
#import "LCGuideApi.h"
@implementation LCGuideViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
}
- (LCBaseApi *)getLoadApi{
    LCGuideApi *api = [LCGuideApi new];
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSDictionary *dic = result;
        NSArray *info = dic[@"info"];
        NSDictionary *tempDic = [info firstObject];
        
    }
    return result;
}
@end
