//
//  LCMineUserInfoCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/6.
//

#import "LCBaseTableViewCell.h"
#import "LCUserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCMineUserInfoCell : LCBaseTableViewCell
@property (nonatomic , strong) LCUserInfoModel *dataModel;
@property (nonatomic , strong) RACSubject *editSubject;
@property (nonatomic , strong) RACSubject *userIdCopySubject;
@property (nonatomic , strong) RACSubject *followClickSubject;
@property (nonatomic , strong) RACSubject *fansClickSubject;
@end

NS_ASSUME_NONNULL_END
