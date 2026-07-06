//
//  LCBaseViewModelProtocol.h
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import <Foundation/Foundation.h>
//#import "LCBaseApi.h"
#import "LCBaseListApi.h"


NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, LCBaseViewModelApiStatus) {
    LCBaseViewModelListStatus_NoApi = 0,
    LCBaseViewModelListStatus_Loading,
    LCBaseViewModelListStatus_Finish,
    LCBaseViewModelListStatus_Error,
};


@protocol LCBaseViewModelProtocol <NSObject>
@optional
@property (nonatomic , strong) NSError *listApiError;
@property (nonatomic , assign) LCBaseViewModelApiStatus listApiStatus;
@property (nonatomic , assign) BOOL listNoMoreData;
@property (nonatomic,strong)RACSignal *loadDataSignal;//加载数据请求信号
@property (nonatomic,strong)RACCommand *loadDataCommend;//加载数据
@property (nonatomic,strong)RACSubject *loadDataLoadingSubject;//数据正在加载
@property (nonatomic,strong)RACSubject *loadDataFinishLoadSubject;//数据加载完毕
@property (nonatomic,strong)RACSignal *nextPageSignal;//加载更多请求信号
@property (nonatomic,strong)RACCommand *nextPageCommand;//加载更多
@property (nonatomic,strong)RACSubject *noMoreDataSubject;
@property (nonatomic,strong)RACCommand *cancelLoadCommand;//取消请求
//@property (nonatomic,strong)RACSubject *cancelLoadSubject;//取消请求完成
- (instancetype)initWithDataModel:(id)dataModel;
/**
 *  初始化
 */
- (void)lc_initialize;

/// 绑定请求commend和signal
- (void)lc_bindLoadSignal;

/// 绑定翻页commend和signal
- (void)lc_bindLoadMoreSignal;
/// 绑定取消signal
- (void)lc_bindCancelSignal;

/// load api
- (LCBaseApi *)getLoadApi;
/// 翻页api
- (LCBaseListApi *)getPageApi;

- (NSArray *)getCancelApiArray;


- (id)dealWithLoadData:(id)result;
- (void)dealWithLoadError:(NSError *)error;
- (id)dealWithLoadMoreData:(id)result;
- (void)dealWithLoadMoreError:(NSError *)error;
- (BOOL)dealWithNoPageWithData:(id)result;
@end

NS_ASSUME_NONNULL_END
