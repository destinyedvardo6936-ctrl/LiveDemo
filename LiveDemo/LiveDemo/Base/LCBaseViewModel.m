//
//  LCBaseViewModel.m
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import "LCBaseViewModel.h"
#import "LCNetWorkManager.h"
@implementation LCBaseViewModel
@synthesize loadDataSignal = _loadDataSignal;
@synthesize nextPageSignal = _nextPageSignal;
@synthesize loadDataCommend = _loadDataCommend;
@synthesize loadDataLoadingSubject = _loadDataLoadingSubject;
@synthesize loadDataFinishLoadSubject = _loadDataFinishLoadSubject;
@synthesize nextPageCommand = _nextPageCommand;
@synthesize cancelLoadCommand = _cancelLoadCommand;
@synthesize noMoreDataSubject = _noMoreDataSubject;
//@synthesize cancelLoadSubject = _cancelLoadSubject;
@synthesize listApiStatus = _listApiStatus;
@synthesize listNoMoreData = _listNoMoreData;
@synthesize listApiError = _listApiError;


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    LCBaseViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        
        [viewModel lc_initialize];
    }
    return viewModel;
}

#pragma mark---- 子类实现 ----
- (instancetype)initWithDataModel:(id)dataModel {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    
//    LCLog(@"%@销毁",NSStringFromClass([self class]));
}
- (void)lc_initialize {
    
}
/// 绑定请求commend和signal
- (void)lc_bindLoadSignal{
    @weakify(self)
    [[[self.loadDataCommend.executing skip:1] takeUntil:self.rac_willDeallocSignal
      ] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            self.listApiStatus =  LCBaseViewModelListStatus_Loading;
        }
        [self.loadDataLoadingSubject sendNext:x];
        
    }];
    [[[self.loadDataCommend.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.listApiStatus =  LCBaseViewModelListStatus_Finish;
        [self.loadDataFinishLoadSubject sendNext:x];
        if ([[self getLoadApi] isKindOfClass:[LCBaseListApi class]]) {
           
                
            self.listNoMoreData = [self dealWithNoPageWithData:x];
            [self.noMoreDataSubject sendNext:[self dealWithNoPageWithData:x]? @(YES) : @(NO)];
        }
        
        
    }];
    [[self.loadDataCommend.errors takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSError * _Nullable error) {
        @strongify(self)
        self.listApiError = error;
        self.listApiStatus =  LCBaseViewModelListStatus_Error;
        [self.loadDataFinishLoadSubject sendNext:error];
    }];
}

/// 绑定翻页commend和signal
- (void)lc_bindLoadMoreSignal{
    @weakify(self)
    [[[self.nextPageCommand.executing skip:1]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            self.listApiStatus =  LCBaseViewModelListStatus_Loading;
        }
        
    }];
    [[[self.nextPageCommand.executionSignals switchToLatest]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.listApiStatus =  LCBaseViewModelListStatus_Finish;
        [self.loadDataFinishLoadSubject sendNext:x];
        
        if ([[self getPageApi] isKindOfClass:[LCBaseListApi class]]) {
           
                
            self.listNoMoreData = [self dealWithNoPageWithData:x];
            [self.noMoreDataSubject sendNext:[self dealWithNoPageWithData:x] ? @(YES) : @(NO)];
            
        }
    }];
    [[self.nextPageCommand.errors takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSError * _Nullable error) {
        @strongify(self)
        self.listApiError = error;
        self.listApiStatus =  LCBaseViewModelListStatus_Error;
        [self.loadDataFinishLoadSubject sendNext:error];
    }];
    
    
}
/// 绑定取消signal
- (void)lc_bindCancelSignal{
   
    [[self.cancelLoadCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
  
//        [self.cancelLoadSubject sendNext:x];
    }];
   
}
/// 请求数据
- (void)requestDataWithSubscriber:(id<RACSubscriber>)subscriber{
    LCBaseApi *api = [self getLoadApi];
//    [subscriber sendError:error];
    WS(weakSelf)
    [[LCNetWorkManager manager]requestApi:api success:^(id  _Nullable result) {
        
            id data = [weakSelf dealWithLoadData:result];
            [subscriber sendNext:data];
            [subscriber sendCompleted];
       
        } failure:^(NSError * _Nullable error) {
            [weakSelf dealWithLoadError:error];
            [subscriber sendError:error];
        }];
}
/// 请求更多数据
- (void)requestMoreDataWithSubscriber:(id<RACSubscriber>)subscriber{
    LCBaseListApi *api = [self getPageApi];
    api.page += 1;
    WS(weakSelf)
    [[LCNetWorkManager manager]requestApi:api success:^(id  _Nullable result) {
        
       
            
            id data = [weakSelf dealWithLoadMoreData:result];
            [subscriber sendNext:data];
            [subscriber sendCompleted];
        
        } failure:^(NSError * _Nullable error) {
            api.page -= 1;
            [weakSelf dealWithLoadMoreError:error];
            [subscriber sendError:error];
        }];
}

/// 取消请求
- (void)cancelLoadWithSubscriber:(id<RACSubscriber>)subscriber{
    //找到request 然后cancel
    
    NSArray *arr = [self getCancelApiArray];
    for (LCBaseApi *api in arr) {
        if (api.task) {
            [api.task cancel];
        }
    }
    [subscriber sendNext:arr];
    [subscriber sendCompleted];
}
/// load api
- (LCBaseApi *)getLoadApi{
    
    return nil;
}
/// 翻页api
- (LCBaseListApi *)getPageApi{
    
    return nil;
}
- (NSArray *)getCancelApiArray{
    return nil;
}
- (id)dealWithLoadData:(id)result{
    
    return  result;
}
- (void)dealWithLoadError:(NSError *)error{}
- (id)dealWithLoadMoreData:(id)result{
    
    return  result;
}
- (void)dealWithLoadMoreError:(NSError *)error{}
- (BOOL)dealWithNoPageWithData:(id)result{
    return NO;
}
#pragma mark---- 懒加载----


- (RACCommand *)loadDataCommend{
    if (_loadDataCommend == nil) {
        @weakify(self);
        RACCommand *commend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [self requestDataWithSubscriber:subscriber];
                return [RACDisposable disposableWithBlock:^{
                    LCLog(@"加载loadDataCommend销毁");
                }] ;
            }];
            self.loadDataSignal = signal;
            return signal;
        }];
        _loadDataCommend = commend;
    }
    return _loadDataCommend;
}

- (RACSubject *)loadDataLoadingSubject{
    if (_loadDataLoadingSubject == nil) {
        _loadDataLoadingSubject = [RACSubject subject];
    }
    return _loadDataLoadingSubject;
}
- (RACSubject *)loadDataFinishLoadSubject{
    if (_loadDataFinishLoadSubject == nil) {
        _loadDataFinishLoadSubject = [RACSubject subject];
    }
    return _loadDataFinishLoadSubject;
}
- (RACSubject *)noMoreDataSubject{
    if (_noMoreDataSubject == nil) {
        _noMoreDataSubject = [RACSubject subject];
    }
    return _noMoreDataSubject;
}
- (RACCommand *)nextPageCommand{
    if (_nextPageCommand == nil) {
        @weakify(self);
        RACCommand *commend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [self requestMoreDataWithSubscriber:subscriber];
                return [RACDisposable disposableWithBlock:^{
                    LCLog(@"加载更多nextPageCommand销毁");
                }] ;
            }];
            self.nextPageSignal =signal;
            return signal;
        }];
        _nextPageCommand = commend;
    }
    return _nextPageCommand;
}

- (RACCommand *)cancelLoadCommand{
    if (_cancelLoadCommand == nil) {
        @weakify(self);
        RACCommand *commend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [self cancelLoadWithSubscriber:subscriber];
                return [RACDisposable disposableWithBlock:^{
//                    LCLog(@"取消请求cancelLoadCommand销毁");
                }] ;
            }];
        }];
        _cancelLoadCommand = commend;
    }
    return _cancelLoadCommand;
}

@end
