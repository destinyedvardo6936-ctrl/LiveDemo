//
//  LCBindPhoneViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCBindPhoneViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *code;
@property (nonatomic , copy) NSString *country_code;

@property (nonatomic , strong) RACCommand *codeCommand;
@property (nonatomic , strong) RACSubject *codeSubject;
@end

NS_ASSUME_NONNULL_END
