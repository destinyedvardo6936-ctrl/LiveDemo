//
//  LCBaseApi.h
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LCBaseApiProtocol <NSObject>

/// 请求方法
- (NSString *)requestMethod;

/// 请求参数
- (NSDictionary *)requestParams;

/// 请求地址
- (NSString *)requestUrl;

@optional


/// 翻页请求参数（重写用）
- (NSDictionary *)requestListParams;

@end
@interface LCBaseApi : NSObject<LCBaseApiProtocol>

@property (nonatomic,weak)NSURLSessionDataTask *task;//记录当前任务
@end

NS_ASSUME_NONNULL_END
