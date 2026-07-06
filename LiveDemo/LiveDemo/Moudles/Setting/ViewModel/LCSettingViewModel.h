//
//  LCSettingViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCBaseViewModel.h"
#import "LCSettingModel.h"
#import "LCVersionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCSettingViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCVersionModel *versionModel;
@property (nonatomic , strong) RACCommand *changeLanguageCommand;
@property (nonatomic , strong) RACCommand *logoutCommand;
@property (nonatomic , strong) RACSubject *logoutSubject;

@end

NS_ASSUME_NONNULL_END
