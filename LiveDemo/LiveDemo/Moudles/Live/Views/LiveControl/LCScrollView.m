//
//  LCScrollView.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/21.
//

#import "LCScrollView.h"

@implementation LCScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delaysContentTouches = NO;
//        self.canCancelContentTouches = NO;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
       
                UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        
        CGPoint velocity = [pan velocityInView:self];
//        NSLog(@"滑动位置%@",NSStringFromCGPoint(trans));
//        NSLog(@"滑动速度%@",NSStringFromCGPoint(velocity));
        if([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
            UIPanGestureRecognizer *pan1 = (UIPanGestureRecognizer *)otherGestureRecognizer;
            
            CGPoint velocity1 = [pan1 velocityInView:otherGestureRecognizer.view];
//            NSLog(@"滑动位置1%@",NSStringFromCGPoint(trans1));
//            NSLog(@"滑动速度1%@",NSStringFromCGPoint(velocity1));
            if(pan.state == UIGestureRecognizerStateBegan && pan1.state == UIGestureRecognizerStateBegan){
                return  ABS(velocity1.y)>ABS(velocity.x);
            }
            return NO;
        }

                    return NO;

           
    }

    return YES;
}

@end
