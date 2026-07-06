//
//  NSString+LCTime.h
//  LCHeadlines
//
//  Created by mrgao on 2019/11/28.
//  Copyright © 2019 personal. All rights reserved.
//




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LCTime)

/// 当前时间字符串 YYYY-MM-dd hh:mm:ss
+ (NSString *)currentTimeString;

/**
 时间转换成“00:00”的格式

 @param time 时间
 @return “00:00”格式的字符串
 */
+ (NSString *)changeTimeIntreval:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
