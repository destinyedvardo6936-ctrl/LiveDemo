//
//  LCLanguageManager.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LCLanguageType) {
    LCLanguageType_ChineseSimple,
    LCLanguageType_ChineseTraditional,
    LCLanguageType_English,
    LCLanguageType_Malay,//马来语
};

static NSString *userLanguageKey = @"userLanguageKey";

static NSString * language_ChineseSimple = @"zh_cn";
static NSString * language_Traditional = @"zh-Hant";
static NSString * language_English = @"en";
static NSString * language_Malay = @"ms";
NS_ASSUME_NONNULL_BEGIN

@interface LCLanguageManager : NSObject
+ (instancetype)shareManager;
- (void)setDefaultLanguage;
- (LCLanguageType )getCurrentLanguage;
- (void)changeCurrentLanguage:(LCLanguageType)language;
- (NSString *)getLanguageDescirbe;
- (NSString *)getCurrentLanguageEncode;
- (NSString *)getLanguageEncode;
- (NSArray *)getAllLanguageDescirbe;
- (void)changeToLanguageDescribe:(NSString *)lan;
@end

NS_ASSUME_NONNULL_END
