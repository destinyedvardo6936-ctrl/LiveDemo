//
//  UIButton+LCDelayTimeClicked.m
//  LDHeadlines
//
//  Created by mrgao on 2020/2/20.
//  Copyright © 2020 personal. All rights reserved.
//

#import "UIButton+LCDelayTimeClicked.h"
#import <objc/runtime.h>

#define kRemoveHighlightEffect @"RemoveHighlightEffect"
static char * const eventIntervalKey = "eventIntervalKey";
static char * const eventUnavailableKey = "eventUnavailableKey";

@implementation UIControl (LDDelayTimeClicked)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method qi_method = class_getInstanceMethod(self, @selector(qi_sendAction:to:forEvent:));
        method_exchangeImplementations(method, qi_method);
        
        Class clazz = [self class];
               
               
               
               
               SEL originalSEL = @selector(setHighlighted:);
               SEL swizzledSEL = @selector(iw_setHighlighted:);
               
               
               Method originalMethod = class_getInstanceMethod(clazz, originalSEL);
               Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSEL);
               
               
               //添加方法
               
               BOOL result = class_addMethod(clazz, swizzledSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
               if (result) {
                   class_replaceMethod(clazz, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
               }else{
                   method_exchangeImplementations(originalMethod, swizzledMethod);
               }
    });
    
}


#pragma mark - Action functions

//- (void)qi_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
//    if (self.eventUnavailable == NO) {
//        self.eventUnavailable = YES;
//        [self qi_sendAction:action to:target forEvent:event];
//        [self performSelector:@selector(setEventUnavailable:) withObject:@(NO) afterDelay:self.qi_eventInterval];
//    }
//}

- (void)qi_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if([self isMemberOfClass:[UIButton class]]) {
        if (self.eventUnavailable == NO) {
              self.eventUnavailable = YES;
              [self qi_sendAction:action to:target forEvent:event];
              [self performSelector:@selector(setEventUnavailable:) withObject:0           afterDelay:self.eventInterval];
        }
   } else {
        [self qi_sendAction:action to:target forEvent:event];
    }
}

- (void)iw_setHighlighted:(BOOL)highlighted{
    if (!self.removeHighlightEffect) {
        //这句代码代码调用原来的方法
        [self iw_setHighlighted:highlighted];
    }
}



- (void)setRemoveHighlightEffect:(BOOL)removeHighlightEffect{
    objc_setAssociatedObject(self, kRemoveHighlightEffect, @(removeHighlightEffect), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)removeHighlightEffect{
    return objc_getAssociatedObject(self, kRemoveHighlightEffect);
}
#pragma mark - Setter & Getter functions


- (NSTimeInterval)eventInterval{
    return [objc_getAssociatedObject(self, eventIntervalKey) doubleValue] == 0 ? 1.2f:[objc_getAssociatedObject(self, eventIntervalKey) doubleValue];
}
- (void)setEventInterval:(NSTimeInterval)eventInterval{
     objc_setAssociatedObject(self, eventIntervalKey, @(eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)eventUnavailable {
    
    return [objc_getAssociatedObject(self, eventUnavailableKey) boolValue];
}

- (void)setEventUnavailable:(BOOL)eventUnavailable {
    
    objc_setAssociatedObject(self, eventUnavailableKey, @(eventUnavailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
