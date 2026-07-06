//
//  LCVideoDetailViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCVideoDetailViewModel.h"
#import "LCVideoListApi.h"
@implementation LCVideoDetailViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
//    @weakify(self)
//    [[[self.bannerCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [self.bannerSubject sendNext:x];
//    }];
//    
//    [[self.bannerCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
//        @strongify(self)
//        [self.bannerSubject sendNext:x];
//    }];
}
- (LCBaseApi *)getLoadApi{
    LCVideoListApi *api = [LCVideoListApi new];
    api.channelId = self.currentVideoModel.channelId;
    self.listApi = api;
    return self.listApi;
}
- (LCBaseListApi *)getPageApi{
    return self.listApi;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [self.dataArray removeAllObjects];
        [LCVideoListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [self.dataArray addObjectsFromArray:[LCVideoListModel mj_objectArrayWithKeyValuesArray:arr]];
        LCVideoListModel *tempModel = nil;
        for (LCVideoListModel *model in self.dataArray) {
            model.channelId = self.currentVideoModel.channelId;
            if([model.modelId isEqualToString:self.currentVideoModel.modelId]){
                tempModel = model;
            }
        }
        if(tempModel){
            [self.dataArray removeObject:tempModel];
        }
           
        
    }
    return result;
   
}
- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadMoreData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [LCVideoListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        
            [self.dataArray addObjectsFromArray:[LCVideoListModel mj_objectArrayWithKeyValuesArray:arr]];
        for (LCVideoListModel *model in self.dataArray) {
            model.channelId = self.currentVideoModel.channelId;
            
        }
        
    }
    return result;
    
}
- (void)dealWithLoadMoreError:(NSError *)error{
    
}
- (BOOL)dealWithNoPageWithData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result ;
       
       
        if (dic[@"info"]){
            NSArray *arr = dic[@"info"];
            return arr.count ? NO : YES;
        }
        
        
    }
    return NO;
}
- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
