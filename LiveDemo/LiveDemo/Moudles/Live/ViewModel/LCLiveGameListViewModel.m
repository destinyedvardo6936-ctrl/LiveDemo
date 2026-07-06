//
//  LCLiveGameListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCLiveGameListViewModel.h"
#import "LCGameListApi.h"
#import "LCGameThirdTypeApi.h"
#import "LCGameThirdListApi.h"
@implementation LCLiveGameListViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    @weakify(self)
    [[[self.thirdGameTypeCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.thirdGameTypeSubject sendNext:x];
    }];
    
    [[self.thirdGameTypeCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.thirdGameTypeSubject sendNext:x];
    }];
//
//    [[[self.balanceCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [self.balanceSubject sendNext:x];
//    }];
//
//    [[self.balanceCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
//        @strongify(self)
//        [self.balanceSubject sendNext:x];
//    }];
    
}
- (LCBaseApi *)getLoadApi{
    if([self.typeModel.modelId isEqualToString:@"0"]){
        LCGameListApi *api = [[LCGameListApi alloc]init];
        api.typeId = self.typeModel.modelId;

       
        return api;
    }else{
        if(self.typeModel.selectTypeModel){
            LCGameThirdListApi *api = [[LCGameThirdListApi alloc]init];
            api.pid = self.typeModel.selectTypeModel.topclass_id;
            api.oneClassId = self.typeModel.selectTypeModel.modelId;

            return api;
       
        }else{
            [self.typeModel.dataArray removeAllObjects];
            return nil;
        }
        
                        
                   
        
        

       
        
    }


    
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *a =result[@"info"];
        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        NSMutableArray *temp = [LCGameListModel mj_objectArrayWithKeyValuesArray:a];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:temp];
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (RACCommand *)thirdGameTypeCommand{
    if (_thirdGameTypeCommand == nil) {
        @weakify(self)
        _thirdGameTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                   
                        LCGameThirdTypeApi *api = [[LCGameThirdTypeApi alloc]init];
                        api.typeId = self.typeModel.modelId;
                        [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                           
                            if ([result isKindOfClass:[NSDictionary class]]){
                                NSArray *a =result[@"info"];
                                [LCGameSubTypeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                    return @{@"modelId":@"id"};
                                }];
                                NSMutableArray *temp = [LCGameSubTypeModel mj_objectArrayWithKeyValuesArray:a];
                                self.typeModel.typeArray = temp;
                                
                                self.typeModel.selectTypeModel = [temp firstObject];
                                [subscriber sendNext:result];
                                [subscriber sendCompleted];
                                
                            } else{
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
    return _thirdGameTypeCommand;
}
- (RACSubject *)thirdGameTypeSubject{
    if (_thirdGameTypeSubject == nil) {
        _thirdGameTypeSubject = [RACSubject subject];
    }
    return _thirdGameTypeSubject;
}
@end
