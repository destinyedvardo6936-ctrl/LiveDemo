//
//  LCUIMarcos.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#ifndef LCUIMarcos_h
#define LCUIMarcos_h

//#define KLanguage(key, comment) \
//     [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]

#pragma mark 布局
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kDevice_Is_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})



#define KSafeHeight (kDevice_Is_iPhoneX?34:0)
#define TabBarHeight (kUI_Width(60) + KSafeHeight)

#define kNavBarHeight (kDevice_Is_iPhoneX?88:64)
#define kStatusBarHeight (kDevice_Is_iPhoneX?44:20)



#define kUI_Width(a) (ceil((a/375.0) * SCREEN_WIDTH * 1) / 1)
#define kUI_WidthWithFloat(a) ((a/375.0) * SCREEN_WIDTH  )


#define kViewMargin 12
#pragma mark 字体宏

#define RegularFont(s) [UIFont fontWithName:@"PingFangSC-Regular" size:kUI_Width(s)]//常规体
#define MediumFont(s) [UIFont fontWithName:@"PingFangSC-Medium" size:kUI_Width(s)]//中黑体
#define BoldFont(s) [UIFont fontWithName:@"PingFangSC-Semibold" size:kUI_Width(s)]//中粗体
#define LightFont(s) [UIFont fontWithName:@"PingFangSC-Light" size: kUI_Width(s) ]//细体

#pragma mark 颜色
#define Color(b) [UIColor colorWithHexString:b]
#define ColorAlpha(b,c) [UIColor colorWithHexString:b alpha:c]
#define normalColors [UIColor colorWithRed:255/255.0 green:69/255.0 blue:0/255.0 alpha:1]
#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]
#endif /* LCUIMarcos_h */
