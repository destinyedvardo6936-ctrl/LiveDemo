//
//  LCSettingLogoutBtnCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSettingLogoutBtnCell : LCBaseTableViewCell
@property (nonatomic , strong) RACSubject *clickSubject;
@end

NS_ASSUME_NONNULL_END
