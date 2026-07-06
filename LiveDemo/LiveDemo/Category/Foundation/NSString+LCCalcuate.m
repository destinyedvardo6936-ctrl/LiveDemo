//
//  NSString+LCCalcuate.m
//  LCHeadlines
//
//  Created by mrgao on 2019/11/28.
//  Copyright © 2019 personal. All rights reserved.
//

#import "NSString+LCCalcuate.h"




@implementation NSString (LCCalcuate)
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

//计算长度
- (float)unicodeLengthOfString:(NSString *)text {
    float length = 0;
    for (int i = 0; i < [text length]; i++) {
        int a = [text characterAtIndex:i];
        //判断中文
        if (0x4E00 <= a && a <= 0x9FA5) {
            length += 1;//中文字符长度加一
        } else {
            length += 0.5;//其它字符长度加一
        }
    }

    return length;

}
- (NSString *)unicodeCutString:(NSString *)text length:(float)length {
    float strlength = 0;
    NSInteger index = 0;
    for (int i = 0; i < [text length]; i++) {
        //记录长度为length时的位置
//        if (strlength == length && index) {
//            index = i;
//        }
        //判断中文
        int a = [text characterAtIndex:i];
        if (0x4E00 <= a && a <= 0x9FA5) {

            strlength += 1;
            
        } else {
            strlength += 0.5;
        }
        //处理最后一个字符长度大于等于规定长度 并记录位置
        if (index == 0 && strlength == length) {
            index = i;
        } else if (index == 0 && strlength > length) {
            index = i - 1;
        }

    }

    return [text substringToIndex:index+ 1];

}
@end
