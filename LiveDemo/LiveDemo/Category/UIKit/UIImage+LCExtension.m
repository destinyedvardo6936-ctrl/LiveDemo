//
//  UIImage+LCExtension.m
//  LDHeadlines
//
//  Created by mrgao on 2019/12/5.
//  Copyright © 2019 personal. All rights reserved.
//

#import "UIImage+LCExtension.h"




@implementation UIImage (LCExtension)
+ (instancetype)imageWithColor:(UIColor *)color
                          size:(CGSize)size{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width,size.height);
    UIGraphicsBeginImageContext(size);//创建图片
    CGContextRef context = UIGraphicsGetCurrentContext();//创建图片上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);//设置当前填充颜色的图形上下文
    CGContextFillRect(context, rect);//填充颜色
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (NSData *)zipImageToMaxKBit:(NSInteger)kBit{
    CGFloat maxFileSize = kBit * 1024;
        CGFloat compression = 1.0f;
        CGFloat maxCompression = 0.0f;
        NSData *compressedData = UIImageJPEGRepresentation(self, compression);
    
        while ([compressedData length] > maxFileSize && compression > maxCompression) {
            compression -= 0.1;
            compressedData = UIImageJPEGRepresentation(self, compression);
        }
 
        
        return compressedData;
}
@end
