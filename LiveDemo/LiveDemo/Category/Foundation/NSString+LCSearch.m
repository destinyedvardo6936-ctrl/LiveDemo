//
//  NSString+Search.m
//  newsHD
//
//  Created by gx on 2017/5/17.
//  Copyright © 2017年 hyhd. All rights reserved.
//

#import "NSString+LCSearch.h"
#import "RegexKitLite.h"

@implementation NSString (LCSearch)
- (NSArray *)rangeOfSubString:(NSString *)subString {
    NSMutableArray *rangArr = [NSMutableArray array];
    for (NSInteger i = 0; i < subString.length; i++) {
        NSString *regex = [subString substringWithRange:NSMakeRange(i, 1)];
        //处理正则表达式.的情况
        if ([regex isEqualToString:@"."]) {
            regex = @"\\.";
        }
        [self enumerateStringsMatchedByRegex:regex options:RKLCaseless inRange:NSMakeRange(0, self.length) error:nil enumerationOptions:RKLRegexEnumerationNoOptions usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
            [rangArr addObject:[NSValue valueWithRange:*capturedRanges]];
        }];
    }
    return rangArr;
}
@end
