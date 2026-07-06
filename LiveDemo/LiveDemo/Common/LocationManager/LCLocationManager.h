//
//  LCLocationManager.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLocationManager : NSObject
+ (instancetype)shareManager;
- (BOOL)isShowLocalTips;

//开始定位
- (void)startLocation;
@end

NS_ASSUME_NONNULL_END
