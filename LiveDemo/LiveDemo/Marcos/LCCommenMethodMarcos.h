//
//  LCCommenMethodMarcos.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#ifndef LCCommenMethodMarcos_h
#define LCCommenMethodMarcos_h

//************************** 切换APP 语言 宏 ***********************
#define KLanguage(key)  [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
//[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]


#ifdef DEBUG
#define LXRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define LCLog(...) printf("%s: %s 第%d行: %s\n\n",[[NSString currentTimeString] UTF8String], [LXRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define LCLog(...)
#define NSLog(...)
#define LCLogFunc(...)

#endif


#define IOS11 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 11.0)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define ST(strongSelf) __strong __typeof(&*weakSelf)strongSelf = weakSelf;

#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif
//==================================//
/**
 *  定义UIImage对象（不带缓存的）
 */
#define imageNoCache(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]
/**
 *  定义UIImage对象（带缓存的）
 */
#define image(name) [UIImage imageNamed:name]


#define minstr(a)    [NSString stringWithFormat:@"%@",a]

#define fontMT(sizeThin)   [UIFont fontWithName:@"Arial-ItalicMT" size:(sizeThin)]
#endif /* LCCommenMethodMarcos_h */
