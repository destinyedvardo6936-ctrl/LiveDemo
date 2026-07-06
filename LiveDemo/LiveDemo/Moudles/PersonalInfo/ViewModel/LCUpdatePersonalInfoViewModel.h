//
//  LCUpdatePersonalInfoViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUpdatePersonalInfoViewModel : LCBaseViewModel
@property (nonatomic , strong) LCUserInfoModel *dataModel;
@property (nonatomic , copy) NSString *nickname;
@property (nonatomic , strong) UIImage *avater;
@property (nonatomic , copy) NSString *profile;
@property (nonatomic , copy) NSString *birthday;
@property (nonatomic , copy) NSString *sex;
@property (nonatomic , copy) NSString *province;
@property (nonatomic , copy) NSString *city;
@property (nonatomic , copy) NSString *avaterStr;
@property (nonatomic , strong) RACCommand *uploadCommand;
@property (nonatomic , strong) RACSubject *uploadSubject;
@end

NS_ASSUME_NONNULL_END
