//
//  LCAPIMacros.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//
#ifndef LCAPIMacros_h
#define LCAPIMacros_h

#define kSuccessCode @"400"


#define DATAVERSION    @"1.0.0"
#define RequestTimeOut 10.0f

#pragma mark 域名地址
#if DEBUG
#define  kOpenLocalServers 1  // Debug 使用测试环境
#else
#define  kOpenLocalServers 2  // Release 使用生产环境，避免线上直播 licence 与拉流环境错配
#endif

#if kOpenLocalServers == 1

// 测试环境_稳定版本api
//打包更换下面两个域名
#define SERVER_LC_URL [NSString stringWithFormat:@"https://mt88.tv/appapi/?service="]
#define SERVER_HOST @"https://mt88.tv"
//腾讯云直播
#define TXPushLicenceURL @"https://license.vod2.myqcloud.com/license/v2/1327247574_1/v_cube.license"
#define TXPushLicenceKey @"48b0ba1e7353ebf6e45f919dc1cef19c"

#elif kOpenLocalServers == 2
//接口地址
#define SERVER_LC_URL [NSString stringWithFormat:@"https://mt88.tv/appapi/?service="]
#define SERVER_HOST @"https://mt88.tv"

#define TXPushLicenceURL @"https://license.vod2.myqcloud.com/license/v2/1326848147_1/v_cube.license"
#define TXPushLicenceKey @"11e08a27354e31a5ab24c9fb357b8b69"
#endif
#endif /* LCAPIMacros_h */
