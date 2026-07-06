//
//  PlatGiftView.m
//  yunbaolive
//
//  Created by ybRRR on 2019/12/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "PlatGiftView.h"

@implementation PlatGiftView

-(instancetype)initWithIsPlat:(BOOL)isPlat{
    self = [super init];
    if (self) {
        _haohuaCount = 0;
        _expensiveGiftCount = [NSMutableArray array];
        _isplatBool = isPlat;
    }
    return self;
}
-(void)sethaohuacount{
    if (_haohuaCount == 0) {
        _haohuaCount =1;
    }
    else{
        _haohuaCount = 0;
    }
}
-(void)addArrayCount:(NSDictionary *)dic{
    [_expensiveGiftCount addObject:dic];
}
-(void)stopHaoHUaLiwu{
    [expensiveGiftTime invalidate];
    expensiveGiftTime = nil;
    _expensiveGiftCount = nil;
}
-(void)enGiftEspensive:(BOOL)isplat{
    if (_expensiveGiftCount.count == 0 || _expensiveGiftCount == nil) {//判断队列中有item且不是满屏
        [expensiveGiftTime invalidate];
        expensiveGiftTime = nil;
        return;
    }
    _isplatBool = isplat;

    NSDictionary *Dic = [_expensiveGiftCount firstObject];
    [_expensiveGiftCount removeObjectAtIndex:0];
    [self expensiveGiftPopView:Dic];
}
-(void)expensiveGiftPopView:(NSDictionary *)giftData{
    CGFloat seconds;
    if (_isplatBool) {
        seconds = 8.0;
    }else{
        seconds = [[giftData valueForKey:@"swftime"] floatValue];

    }
    [self sethaohuacount];

        gifView = [[exoensiveGifGiftV alloc]initWithGiftData:giftData andVideoitem:nil andIsplat:YES];
        [self addSubview:gifView];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [gifView removeFromSuperview];
            [self sethaohuacount];
            if (_expensiveGiftCount.count >0) {
                [self.delegate platGiftdelegate:nil];
            }
        });
}
#pragma mark === 永久闪烁的动画 ======

-(CABasicAnimation *)opacityForever_Animation:(float)time

{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:0.5f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
     animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

@end
