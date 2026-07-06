//
//  LCNetWorkManager.m
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import "LCNetWorkManager.h"
#import <AFNetworking.h>
#import "LCAPIMacros.h"
#import "LCLanguageManager.h"

@interface LCNetWorkManager ()
@property(nonatomic,strong) AFNetworkReachabilityManager *netManager;
@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic,strong) NSMutableArray *failerTasks;
@end
@implementation LCNetWorkManager
+ (instancetype)manager {
    static LCNetWorkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LCNetWorkManager alloc] init];

        
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.failerTasks = [NSMutableArray array];
//        _netManager = [AFNetworkReachabilityManager sharedManager] ;
//        [_netManager startMonitoring];
        
        _netManager = [AFNetworkReachabilityManager manager];
        [_netManager startMonitoring];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];

        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;//去除空值
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        _sessionManager.responseSerializer = responseSerializer;


    }
    return self;
}
- (void)requestApi:(LCBaseApi *)api
           success:(LCRequestSuccessBlock)successBlock
           failure:(LCRequestFailureBlock)failureBlock{

   
//     WS(weakSelf)
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_LC_URL, [api requestUrl]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *apiDic = [api requestParams];
    if (apiDic) {
        [params addEntriesFromDictionary:apiDic];
    }
    //拼接公共参数
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [params setObject:app_Version forKey:@"appVersion"];
    [params setObject:DATAVERSION forKey:@"dataVersion"];
    if ([LCUserInfoManager shareManager].userInfo.ID.length){
        [params setObject:[LCUserInfoManager shareManager].userInfo.ID forKey:@"uid"];
    }
    LCLanguageManager *lanManager = [LCLanguageManager shareManager];
    [params setObject:[lanManager getLanguageEncode] forKey:@"lang"];
    if ([LCUserInfoManager shareManager].userInfo.token.length){
        [params setObject:[LCUserInfoManager shareManager].userInfo.token forKey:@"token"];
    }
    
    [params setObject:@"iOS" forKey:@"platform"];
//    NSString *deviceId = [NSString getUUIDInKeychain];
//    if (deviceId.length) {
//        [params setObject:deviceId forKey:@"deviceId"];
//    }
    NSString *time = [NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    if (time.length) {
        [params setObject:time forKey:@"time"];
    }


    NSError *error ;
    NSMutableURLRequest *request = nil;
    if([[api requestMethod] isEqualToString:@"GET"]){
        if(params[@"p"]){
            [params setObject:params[@"p"] forKey:@"page"];
        }
       
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:[api requestMethod] URLString:urlStr parameters:params error:&error];
    }else{
        
        request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:[api requestMethod] URLString:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                LCLog(@"序列化%@",formData);
        
            } error:&error];
    }

////
    if (error) {
        failureBlock(nil);
    }
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    request.timeoutInterval = RequestTimeOut;
    LCLog(@"请求url：%@", request.URL.absoluteString);
    LCLog(@"参数：%@", params);
   
    NSURLSessionDataTask *task = [_sessionManager dataTaskWithRequest:request.copy uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//        LCLog(@"上传进度：%@，线程：%@",uploadProgress.localizedDescription,[NSThread currentThread]);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//        LCLog(@"下载进度：%@,线程：%@",downloadProgress.localizedDescription,[NSThread currentThread]);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        LCLog(@"接口：%@  返回值：%@",response.URL.absoluteString, responseObject);
       
           
           if (error) {
               if (error.code == -1001) {
                   failureBlock([NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试")  code:error.code  userInfo:error.userInfo]);
                   return;
               }
               if (error.code == 3840) {
                   failureBlock([NSError errorWithDomain: KLanguage(@"数据加载失败，请稍后再试") code:999  userInfo:error.userInfo]);
                   return;
               }
               failureBlock(error);
           } else {
               if([[responseObject valueForKey:@"ret"] integerValue] == 200)
               {
                   if ([responseObject isKindOfClass:[NSDictionary class]]) {
                       NSDictionary *dic = [responseObject objectForKey:@"data"];
                       if ([[dic objectForKey:@"code"] integerValue] == 0) {
                           successBlock(dic);
                       }else if ([[dic objectForKey:@"code"] integerValue] == 700){
                           
//                           [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"msg"]];
                           
                          
                           [[NSNotificationCenter defaultCenter]postNotificationName:@"quitLogin" object:nil];
                           
                       }
                       else{
                           [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"msg"]];
                           failureBlock([NSError errorWithDomain:[dic objectForKey:@"msg"] ? [dic objectForKey:@"msg"] : KLanguage(@"数据加载失败，请稍后再试") code:[[dic objectForKey:@"code"] integerValue] userInfo:nil]);
                       }
                   }else{
                       failureBlock([NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]);
                   }
               }else{
                   failureBlock([NSError errorWithDomain:[responseObject valueForKey:@"msg"] code:[[responseObject valueForKey:@"ret"]integerValue] userInfo:nil]);
               }
               
               
           }
       
    }];
    api.task = task;

    [task resume];
}
- (void)requestUrl:(NSString *)url
            method:(NSString *)method
            params:(NSDictionary *)params
           success:(LCRequestSuccessBlock)successBlock
           failure:(LCRequestFailureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_LC_URL, url];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
   
    if (params) {
        [paramsDic addEntriesFromDictionary:params];
    }
    //拼接公共参数
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [paramsDic setObject:app_Version forKey:@"appVersion"];
    [paramsDic setObject:DATAVERSION forKey:@"dataVersion"];
    if ([LCUserInfoManager shareManager].userInfo.ID.length){
        [paramsDic setObject:[LCUserInfoManager shareManager].userInfo.ID forKey:@"uid"];
    }
    LCLanguageManager *lanManager = [LCLanguageManager shareManager];
    [paramsDic setObject:[lanManager getLanguageEncode] forKey:@"lang"];
    if ([LCUserInfoManager shareManager].userInfo.token.length){
        [paramsDic setObject:[LCUserInfoManager shareManager].userInfo.token forKey:@"token"];
    }
    
    [paramsDic setObject:@"iOS" forKey:@"platform"];
//    NSString *deviceId = [NSString getUUIDInKeychain];
//    if (deviceId.length) {
//        [params setObject:deviceId forKey:@"deviceId"];
//    }
    NSString *time = [NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    if (time.length) {
        [paramsDic setObject:time forKey:@"time"];
    }


    NSError *error ;
    NSMutableURLRequest *request = nil;
    if([method isEqualToString:@"GET"]){
        [paramsDic setObject:params[@"p"] forKey:@"page"];
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlStr parameters:paramsDic error:&error];
    }else{
        
        request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:method URLString:urlStr parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                LCLog(@"序列化%@",formData);
        
            } error:&error];
    }

////
    if (error) {
        failureBlock(nil);
    }
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    request.timeoutInterval = RequestTimeOut;
    LCLog(@"请求url：%@", request.URL.absoluteString);
    LCLog(@"参数：%@", params);
   
    NSURLSessionDataTask *task = [_sessionManager dataTaskWithRequest:request.copy uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//        LCLog(@"上传进度：%@，线程：%@",uploadProgress.localizedDescription,[NSThread currentThread]);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//        LCLog(@"下载进度：%@,线程：%@",downloadProgress.localizedDescription,[NSThread currentThread]);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        LCLog(@"接口：%@  返回值：%@",response.URL.absoluteString, responseObject);
       
           
           if (error) {
               if (error.code == -1001) {
                   failureBlock([NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试")  code:error.code  userInfo:error.userInfo]);
                   return;
               }
               if (error.code == 3840) {
                   failureBlock([NSError errorWithDomain: KLanguage(@"数据加载失败，请稍后再试") code:999  userInfo:error.userInfo]);
                   return;
               }
               failureBlock(error);
           } else {
               if([[responseObject valueForKey:@"ret"] integerValue] == 200)
               {
                   if ([responseObject isKindOfClass:[NSDictionary class]]) {
                       NSDictionary *dic = [responseObject objectForKey:@"data"];
                       if ([[dic objectForKey:@"code"] integerValue] == 0) {
                           successBlock(dic);
                       }else if ([[dic objectForKey:@"code"] integerValue] == 700){
                           
//                           [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"msg"]];
                           
                          
                           [[NSNotificationCenter defaultCenter]postNotificationName:@"quitLogin" object:nil];
                           
                       }
                       else{
                           [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"msg"]];
                           failureBlock([NSError errorWithDomain:[dic objectForKey:@"msg"] ? [dic objectForKey:@"msg"] : KLanguage(@"数据加载失败，请稍后再试") code:[[dic objectForKey:@"code"] integerValue] userInfo:nil]);
                       }
                   }else{
                       failureBlock([NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]);
                   }
               }else{
                   failureBlock([NSError errorWithDomain:[responseObject valueForKey:@"msg"] code:[[responseObject valueForKey:@"ret"]integerValue] userInfo:nil]);
               }
               
               
           }
       
    }];
   

    [task resume];
}
- (void)cancelApi:(LCBaseApi *)api
          success:(LCRequestSuccessBlock)successBlock
          failure:(LCRequestFailureBlock)failureBlock{
    if ([_sessionManager.dataTasks containsObject:api.task]) {
        [api.task cancel];
        dispatch_async(dispatch_get_main_queue(), ^{

            successBlock(nil);

        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{

            failureBlock(nil);

        });
    }
    
}
//- (void)requestTokenWithApi:(LCBaseApi *)api
//                    success:(LCRequestSuccessBlock)successBlock
//                    failure:(LCRequestFailureBlock)failureBlock{
//    WS(weakSelf)
//
//        [self requestApi:[[LCTokenApi alloc]initWithBuilder:[LCTokenBuilder new]] success:^(id  _Nullable result) {
//            if ([result isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = result;
//                LCAuthorModel *model = [LCUserInfoManager shareManager].userInfo;
//                model.authorId = [NSString stringWithFormat:@"%ld",(long)[[dic objectForKey:@"userId"] integerValue]] ;
//
//                [LCLocalDataTools saveLoacalDataWithKey:userInfoSavePath object:model catheType:LCLocalDataToolsSaveType_Library];
//                [LCLocalDataTools saveLoacalDataWithKey:userTokenSavePath object:[dic objectForKey:@"token"] catheType:LCLocalDataToolsSaveType_Library];
//                //更新用户信息和token
//                [[LCUserInfoManager shareManager]updateUserInfo];
//                if ([TTStatisticsManager manager].config) {
//                    [TTStatisticsManager manager].config.userId = model.authorId;
//                    [TTStatisticsManager manager].config.isSignIn = [[LCUserInfoManager shareManager] isLogin];
//                    [TTStatisticsManager manager].config.apiVersion = DATAVERSION;
//                    [TTStatisticsManager manager].config = [TTStatisticsManager manager].config;
//                } else {
//                    TTStaticsConfigModel *config = [TTStaticsConfigModel new];
//                    config.userId = model.authorId;
//                    config.isSignIn = [[LCUserInfoManager shareManager] isLogin];
//                    config.apiVersion = DATAVERSION;
//                    [TTStatisticsManager manager].config = config;
//
//                }
//
//                [weakSelf requestApi:api success:successBlock failure:failureBlock];
//            }
//
//        } failure:^(NSError * _Nullable error) {
//            if (error.code == 400) {
//                //用户失效，重新登录或需要登录后才可操作
//                [[LCUserInfoManager shareManager]clearUserInfo];
//                [[LCUserInfoManager shareManager]updateLoginoutStatus];
//                [weakSelf requestTokenWithApi:api success:successBlock failure:failureBlock];
//                return;
//            }
//            failureBlock(error);
//        }];
//
//
//}

/// 上传a图片
/// @param img 图片
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)uploadImgs:(UIImage *)img
           success:(LCRequestSuccessBlock)successBlock
           failure:(LCRequestFailureBlock)failureBlock{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionManager.requestSerializer = requestSerializer;
    [_sessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//     WS(weakSelf)
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_LC_URL, @"Upload.UploadFile"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
    //拼接公共参数
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [params setObject:app_Version forKey:@"appVersion"];
    [params setObject:DATAVERSION forKey:@"dataVersion"];
    if ([LCUserInfoManager shareManager].userInfo.ID.length){
        [params setObject:[LCUserInfoManager shareManager].userInfo.ID forKey:@"uid"];
    }
    LCLanguageManager *lanManager = [LCLanguageManager shareManager];
    [params setObject:[lanManager getLanguageEncode] forKey:@"lang"];
    if ([LCUserInfoManager shareManager].userInfo.token.length){
        [params setObject:[LCUserInfoManager shareManager].userInfo.token forKey:@"token"];
    }
    
    [params setObject:@"iOS" forKey:@"platform"];
//    NSString *deviceId = [NSString getUUIDInKeychain];
//    if (deviceId.length) {
//        [params setObject:deviceId forKey:@"deviceId"];
//    }
    NSString *time = [NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    if (time.length) {
        [params setObject:time forKey:@"time"];
    }

   

    NSError *error ;
    NSMutableURLRequest *request =[[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:params error:&error];
  
    
    
     request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSData* imageData = UIImageJPEGRepresentation(img, 1.0);

        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",time] mimeType:@"image/jpeg"];
       
       
    } error:&error];
    
    
    if (error) {
        failureBlock(nil);
    }
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    request.timeoutInterval = RequestTimeOut;
    LCLog(@"请求url：%@", request.URL.absoluteString);
    LCLog(@"请求头：%@", request.allHTTPHeaderFields);
    LCLog(@"参数：%@", params);
   
    NSURLSessionDataTask *task = [_sessionManager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        LCLog(@"接口：%@  返回值：%@",response.URL.absoluteString, responseObject);
        if (error) {
            if (error.code == -1001) {
                failureBlock([NSError errorWithDomain: KLanguage(@"数据加载失败，请稍后再试") code:error.code  userInfo:error.userInfo]);
                return;
            }
            if (error.code == 3840) {
                failureBlock([NSError errorWithDomain: KLanguage(@"数据加载失败，请稍后再试") code:999  userInfo:error.userInfo]);
                return;
            }
            failureBlock(error);
        } else {
            if([[responseObject valueForKey:@"ret"] integerValue] == 200)
            {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = [responseObject objectForKey:@"data"];
                    if ([[dic objectForKey:@"code"] integerValue] == 0) {
                        successBlock(dic);
                    }else if ([[dic objectForKey:@"code"] integerValue] == 700){
                        
//                           [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"msg"]];
                        
                       
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"quitLogin" object:nil];
                        
                    }
                    else{
                        [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"msg"]];
                        failureBlock([NSError errorWithDomain:[dic objectForKey:@"msg"] ? [dic objectForKey:@"msg"] : KLanguage(@"数据加载失败，请稍后再试" ) code:[[dic objectForKey:@"code"] integerValue] userInfo:nil]);
                    }
                }else{
                    failureBlock([NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]);
                }
            }else{
                failureBlock([NSError errorWithDomain:[responseObject valueForKey:@"msg"] code:[[responseObject valueForKey:@"ret"]integerValue] userInfo:nil]);
            }
            
            
        }
    }];
   

    [task resume];
}
@end
