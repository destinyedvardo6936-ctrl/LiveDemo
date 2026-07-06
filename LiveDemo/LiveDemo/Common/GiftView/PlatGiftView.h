//
//  PlatGiftView.h
//  yunbaolive
//
//  Created by ybRRR on 2019/12/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exoensiveGifGiftV.h"
#import <SVGAPlayer/SVGA.h>

@protocol platDelgate <NSObject>

-(void)platGiftdelegate:(NSDictionary *)giftData;

@end

@interface PlatGiftView : UIView
{
    NSTimer *expensiveGiftTime;//豪华礼物定时器
    exoensiveGifGiftV *gifView;
    SVGAPlayer *player;

}
@property(nonatomic,assign)id<platDelgate>delegate;

@property(nonatomic,strong)NSMutableArray *expensiveGiftCount;
@property(nonatomic,assign)int haohuaCount;
@property(nonatomic, assign)BOOL isplatBool;
-(void)sethaohuacount;
-(void)addArrayCount:(NSDictionary *)dic;
-(void)enGiftEspensive:(BOOL)isplat;
-(void)stopHaoHUaLiwu;
-(instancetype)initWithIsPlat:(BOOL)isPlat;
@end


