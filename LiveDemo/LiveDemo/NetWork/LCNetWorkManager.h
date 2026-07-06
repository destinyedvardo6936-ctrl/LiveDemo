//
//  LCNetWorkManager.h
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import <Foundation/Foundation.h>
#import "LCBaseApi.h"
typedef void (^LCRequestSuccessBlock)(id _Nullable result);

typedef void(^LCRequestFailureBlock)(NSError *_Nullable error);
NS_ASSUME_NONNULL_BEGIN

@interface LCNetWorkManager : NSObject
+ (instancetype)manager;

/// 请求api
/// @param api api接口
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)requestApi:(LCBaseApi *)api
           success:(LCRequestSuccessBlock)successBlock
           failure:(LCRequestFailureBlock)failureBlock;

- (void)requestUrl:(NSString *)url
            method:(NSString *)method
            params:(NSDictionary *)params
           success:(LCRequestSuccessBlock)successBlock
           failure:(LCRequestFailureBlock)failureBlock;

/// 取消请求api
/// @param api api接口
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)cancelApi:(LCBaseApi *)api
          success:(LCRequestSuccessBlock)successBlock
          failure:(LCRequestFailureBlock)failureBlock;
/// 上传a图片
/// @param img 图片
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)uploadImgs:(UIImage *)img
           success:(LCRequestSuccessBlock)successBlock
           failure:(LCRequestFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
