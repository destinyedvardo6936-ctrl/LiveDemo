//
//  NSString+LCTime.m
//  LCHeadlines
//
//  Created by mrgao on 2019/11/28.
//  Copyright © 2019 personal. All rights reserved.
//

#import "NSString+LCTime.h"

@implementation NSString (LCTime)
+ (NSString *)currentTimeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)changeTimeIntreval:(NSTimeInterval)time {

    NSInteger secondTime = (NSInteger) ceil(time) % 60;
    NSInteger tenSecond = secondTime / 10;
    NSInteger lastSecond = secondTime % 10;
    NSInteger minuteTime = (NSInteger) ceil(time) / 60;
    NSInteger tenMinute = minuteTime / 10;
    NSInteger lastMinute = minuteTime % 10;

    return [NSString stringWithFormat:@"%LC%LC:%LC%LC", tenMinute, lastMinute, tenSecond, lastSecond];
}
@end
