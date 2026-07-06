//
//  LCBindPhoneApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCBindPhoneApi : LCBaseApi
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *code;
@property (nonatomic , copy) NSString *country_code;
@end

NS_ASSUME_NONNULL_END
