//
//  UIImage+LCGif.h
//  LDHeadlines
//
//  Created by mrgao on 2019/12/26.
//  Copyright © 2019 personal. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^GIFimageBlock)(UIImage *GIFImage);

@interface UIImage (LDGif)
/** 根据本地GIF图片名 获得GIF image对象 */
+ (UIImage *)imageWithGIFNamed:(NSString *)name;
 
/** 根据一个GIF图片的data数据 获得GIF image对象 */
+ (UIImage *)imageWithGIFData:(NSData *)data;
/** 根据一个GIF图片的name 获得 image数组对象 */
+ (NSArray *)imageWithWithGIFName:(NSString *)name;
 
/** 根据一个GIF图片的URL 获得GIF image对象 */
+ (void)imageWithGIFUrl:(NSString *)url and:(GIFimageBlock)gifImageBlock;

@end

NS_ASSUME_NONNULL_END
