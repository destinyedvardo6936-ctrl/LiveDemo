//
//  LCVideoListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/6.
//

#import "LCVideoListViewModel.h"
#import "LCVideoListApi.h"
#import "LCBannerApi.h"

@implementation LCVideoListViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
    @weakify(self)
    [[[self.bannerCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.bannerSubject sendNext:x];
    }];
    
    [[self.bannerCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.bannerSubject sendNext:x];
    }];
}
- (LCBaseApi *)getLoadApi{
    LCVideoListApi *api = [LCVideoListApi new];
    api.channelId = self.channelId;
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
        for (LCVideoListModel *model in self.dataArray) {
            model.channelId = self.channelId;
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
            model.channelId = self.channelId;
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
- (NSMutableArray *)bannerArray{
    if (_bannerArray == nil) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (RACCommand *)bannerCommand{
    if (_bannerCommand == nil){
        @weakify(self)
        _bannerCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCBannerApi *api = [LCBannerApi new];
                api.type = @"8";
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if([result isKindOfClass:NSDictionary.class]){
                        NSArray *arr = result[@"info"];
                        [self.bannerArray removeAllObjects];
                        [self.bannerArray addObjectsFromArray:[LCBannerModel mj_objectArrayWithKeyValuesArray:arr]];
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                    }else{
                        
                            [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                        
                    }
                   
                } failure:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _bannerCommand;
}
- (RACSubject *)bannerSubject{
    if (_bannerSubject == nil){
        _bannerSubject = [RACSubject subject];
    }
    return _bannerSubject;
}
@end
