//
//  LCLiveRoomGiftListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import "LCLiveRoomGiftListViewModel.h"
#import "LCLiveGiftListApi.h"
#import "LCLiveBackPackGiftListApi.h"
#import "LCLiveBalanceApi.h"
#import "LCSendGiftApi.h"
@implementation LCLiveRoomGiftListViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    @weakify(self)
    [[[self.balanceCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    [[self.balanceCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    [[[self.sendGiftCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.sendGiftSubject sendNext:x];
    }];
    [[self.sendGiftCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.sendGiftSubject sendNext:x];
    }];
}
- (LCBaseApi *)getLoadApi{

    return self.isBackPack?[LCLiveBackPackGiftListApi new]:[LCLiveGiftListApi new];
 
}


- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result ;
        NSArray *info = dic[@"info"];
        NSDictionary *subDic= [info firstObject];
        
        if (subDic[@"giftlist"]){
            
            [self.dataArray removeAllObjects];
            [LCLiveGiftModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCLiveGiftModel mj_objectArrayWithKeyValuesArray:subDic[@"giftlist"]];
          
            [self.dataArray addObjectsFromArray:arr];
        }else {
            [self.dataArray removeAllObjects];
            [LCLiveGiftModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCLiveGiftModel mj_objectArrayWithKeyValuesArray:info];
          
            [self.dataArray addObjectsFromArray:arr];
        }

        
        
    }
  
    
    return result;
}

- (void)dealWithLoadError:(NSError *)error{
    
}


#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArray{
    if (_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (RACCommand *)balanceCommand{
    if (_balanceCommand == nil) {
        @weakify(self)
        _balanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCLiveBalanceApi *api = [[LCLiveBalanceApi alloc] init];
               
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        NSArray *a =result[@"info"];
                        NSDictionary *dic = [a firstObject];
                        self.balanceStr = [NSString stringWithFormat:@"%ld",[dic[@"coin"]integerValue]];
                        LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
                        model.coin = self.balanceStr;
                        [[LCUserInfoManager shareManager] updateUserInfo:model];
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
    return _balanceCommand;
}
- (RACSubject *)balanceSubject{
    if (_balanceSubject == nil) {
        _balanceSubject = [RACSubject subject];
    }
    return _balanceSubject;
}
- (RACCommand *)selectGiftCommand{
    if (_selectGiftCommand == nil) {
        @weakify(self)
        _selectGiftCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(LCLiveGiftModel  *_Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                for (LCLiveGiftModel *model in self.dataArray) {
                    model.isSelected = [model isEqual:input];
                    if(model.isSelected){
                        self.selectGiftModel = model;
                    }
                }
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _selectGiftCommand;
}
- (RACCommand *)sendGiftCommand{
    if (_sendGiftCommand == nil) {
        @weakify(self)
        _sendGiftCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple *   _Nullable input) {
            @strongify(self)
            LCLiveGiftModel *model = input[0];
            NSString *count = input[1];
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCSendGiftApi *api = [[LCSendGiftApi alloc] init];
                api.liveuid = self.roomId;
                api.stream = self.stream;
                api.giftid = model.modelId;
                api.giftcount = count;
                api.touids = self.roomId;
                api.ispack = self.isBackPack;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        NSArray *a =result[@"info"];
                        NSDictionary *dic = [a firstObject];
                        LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
                        [model mj_setKeyValues:dic];
                        [[LCUserInfoManager shareManager] updateUserInfo:model];
                        self.balanceStr = [NSString stringWithFormat:@"%ld",[dic[@"coin"]integerValue]];
                        [subscriber sendNext:dic[@"gifttoken"]];
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
    return _sendGiftCommand;
}
- (RACSubject *)sendGiftSubject{
    if (_sendGiftSubject == nil) {
        _sendGiftSubject = [RACSubject subject];
    }
    return _sendGiftSubject;
}
@end
