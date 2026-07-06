//
//  LCShortVideoListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/8.
//

#import "LCShortVideoListViewModel.h"
#import "LCShortVideoCategoryListApi.h"
@implementation LCShortVideoListViewModel
/**
 *  初始化
 */
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLoginNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf.loadDataCommend execute:@(YES)];
    }];
}

/// load api
- (LCBaseApi *)getLoadApi{
    
    LCShortVideoCategoryListApi *api = [LCShortVideoCategoryListApi new];
    api.channelId = self.channelId;
    self.listApi = api;
    return self.listApi;
    
}
/// 翻页api
- (LCBaseListApi *)getPageApi{
    return self.listApi;
}



- (id)dealWithLoadData:(id)result{
  
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *a  = result[@"info"];
        [self.dataArray removeAllObjects];
       
            NSArray *arr = [LCShortVideoListModel mj_objectArrayWithKeyValuesArray:a];
            
            [self.dataArray addObjectsFromArray:arr];
        
       
        
        
    }

      
    
    
    
    return result;
}

- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadMoreData:(id)result{
    
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *a  = result[@"info"];
            
           
                NSArray *arr = [LCShortVideoListModel mj_objectArrayWithKeyValuesArray:a];
                
                [self.dataArray addObjectsFromArray:arr];
            
           
            
            
        }
    
    
  
    
    return result;
    
}
- (void)dealWithLoadMoreError:(NSError *)error{
    
}
- (BOOL)dealWithNoPageWithData:(id)result{
    
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *a  = result[@"info"];
           
                return a.count ? NO : YES;
            
            
            
        }
    
   
    return NO;
}

#pragma mark---- 懒加载 ----


- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
