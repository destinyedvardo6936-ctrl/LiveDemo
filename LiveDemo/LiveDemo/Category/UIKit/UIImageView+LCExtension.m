//
//  UIImageView+LCExtension.m
//  LCHeadlines
//
//  Created by mrgao on 2019/12/2.
//  Copyright © 2019 personal. All rights reserved.
//

#import "UIImageView+LCExtension.h"

@implementation UIImageView (LCExtension)
- (void)setImageStr:(NSString *)imageStr{
    if (imageStr.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }else{
        LCLog(@"图片地址为空:%@",imageStr);
    }
}
- (void)setImageStr:(NSString *)imageStr placeholder:(NSString *)placeHolder{
    if (imageStr.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:image(placeHolder)];
    }else{
         LCLog(@"图片地址为空:%@",imageStr);
        self.image = image(placeHolder);
    }
}
- (void)setImageStr:(NSString *)imageStr placeholderImage:(UIImage *)placeHolder{
    if (imageStr.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:placeHolder];
    }else{
         LCLog(@"图片地址为空:%@",imageStr);
        self.image = placeHolder;
    }
}
- (void)setImageStr:(NSString *)imageStr placeholder:(NSString *_Nullable)placeHolder complete:(UIImageViewCompleteBlock)completeBlock{
    if (imageStr.length) {
        [self sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:image(placeHolder) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(image,error);
            });
            
        }];
    }else{
         LCLog(@"图片地址为空:%@",imageStr);
        self.image = image(placeHolder);
    }
    
}
@end
