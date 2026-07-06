//
//  NSBundle+LCBundle.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "NSBundle+LCBundle.h"
#import <objc/runtime.h>
#import "LCLanguageManager.h"
@interface LCBundle : NSBundle

@end


@implementation LCBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    if ([LCBundle lc_mainBundle]) {
        return [[LCBundle lc_mainBundle] localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

+ (NSBundle *)lc_mainBundle {
    if ([[LCLanguageManager shareManager] getLanguageEncode].length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[[LCLanguageManager shareManager] getLanguageEncode] ofType:@"lproj"];
       
        if (path.length) {
            return [NSBundle bundleWithPath:path];
        }
    }
    return nil;
}

@end


@implementation NSBundle (LCBundle)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //动态继承、交换，方法类似KVO，通过修改[NSBundle mainBundle]对象的isa指针，使其指向它的子类CLBundle，这样便可以调用子类的方法；其实这里也可以使用method_swizzling来交换mainBundle的实现，来动态判断，可以同样实现。
        object_setClass([NSBundle mainBundle], [LCBundle class]);
    });
}

@end
