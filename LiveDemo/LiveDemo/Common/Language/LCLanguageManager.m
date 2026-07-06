//
//  LCLanguageManager.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCLanguageManager.h"
#import "AppDelegate.h"
#import "LCTabBarViewController.h"
@implementation LCLanguageManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static LCLanguageManager *manager;

    dispatch_once(&onceToken, ^{
        manager = [[LCLanguageManager alloc]init];
    });
    return manager;
}

- (void)setDefaultLanguage {
    [[NSUserDefaults standardUserDefaults] setValue:language_ChineseSimple forKey:userLanguageKey];
    [[NSUserDefaults standardUserDefaults] setObject:@[language_ChineseSimple] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)resetRootViewController {
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    
    
    app2.window.rootViewController = [LCTabBarViewController new];
//    [root changeLanguage];
    
}
- (LCLanguageType)getCurrentLanguage {
    //zh-Hant-HK,
//    zh-Hans-US,
//    en,
//    yue-Hant-US
    //ms-US
    NSString *lan = [[NSUserDefaults standardUserDefaults] valueForKey:userLanguageKey];
    if(lan.length){
        if ([lan isEqualToString:@"en"]) {
            return LCLanguageType_English;
        } else if ([lan containsString:@"zh-Hant"]) {
            return LCLanguageType_ChineseTraditional;
        } else if ([lan containsString:@"ms"]) {
            return LCLanguageType_Malay;
        }

        return LCLanguageType_ChineseSimple;
    }else{
        NSString *languages =   [[[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"] objectAtIndex:0];
        

        if ([languages isEqualToString:@"en"]) {
            return LCLanguageType_English;
        } else if ([languages containsString:@"zh-Hant"]) {
            return LCLanguageType_ChineseTraditional;
        } else if ([languages containsString:@"ms"]) {
            return LCLanguageType_Malay;
        }

        return LCLanguageType_ChineseSimple;
    }
   
}

- (void)changeCurrentLanguage:(LCLanguageType)language {
    NSString *lans = nil;

    switch (language) {
        case LCLanguageType_English:
            lans = language_English;
            break;

        case LCLanguageType_ChineseTraditional:
            lans = language_Traditional;
            break;

        case LCLanguageType_Malay:
            lans = language_Malay;
            break;

        default:
            lans = language_ChineseSimple;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setValue:lans forKey:userLanguageKey];
    [[NSUserDefaults standardUserDefaults] setObject:@[lans] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    exit(0);
    [self resetRootViewController];
}
- (NSString *)getCurrentLanguageEncode{
    NSString *lan = [[NSUserDefaults standardUserDefaults] valueForKey:userLanguageKey];
    if(!lan.length){
        lan =   [[[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"] objectAtIndex:0];
    }
    return lan;
}
- (NSString *)getLanguageDescirbe {
    NSString *lans = nil;
    LCLanguageType type = [self getCurrentLanguage];

    switch (type) {
        case LCLanguageType_English:
            lans = KLanguage(@"英语");
            break;

        case LCLanguageType_ChineseTraditional:
            lans = KLanguage(@"繁体中文");
            break;

        case LCLanguageType_Malay:
            lans = KLanguage(@"马来语");
            break;

        default:
            lans = KLanguage(@"简体中文");
            break;
    }
    return lans;
}
- (NSString *)getLanguageEncode {
    NSString *lans = nil;
    LCLanguageType type = [self getCurrentLanguage];

    switch (type) {
        case LCLanguageType_English:
            lans = @"en";
            break;

        case LCLanguageType_ChineseTraditional:
            lans = @"tw";
            break;

        case LCLanguageType_Malay:
            lans = @"ms";
            break;

        default:
            lans = @"zh";
            break;
    }
    return lans;
}
- (NSArray *)getAllLanguageDescirbe{
    return @[KLanguage(@"简体中文"),KLanguage(@"繁体中文"),KLanguage(@"英语"),KLanguage(@"马来语")];
}
- (void)changeToLanguageDescribe:(NSString *)lan{
    LCLanguageType type = [self getCurrentLanguage];
    if([lan isEqualToString:KLanguage(@"简体中文")]){
        type = LCLanguageType_ChineseSimple;
    }else if ([lan isEqualToString:KLanguage(@"繁体中文")]){
        type = LCLanguageType_ChineseTraditional;
    }else if ([lan isEqualToString:KLanguage(@"英语")]){
        type = LCLanguageType_English;
    }else if ([lan isEqualToString:KLanguage(@"马来语")]){
        type = LCLanguageType_Malay;
    }
    [self changeCurrentLanguage:type];
    
}
@end
