//
//  LCSettingButtonCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCBaseTableViewCell.h"
#import "LCSettingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCSettingButtonCell : LCBaseTableViewCell
@property (nonatomic , strong) LCSettingModel *dataModel;
@property (nonatomic , strong) RACSubject *clickSubject;
@end

NS_ASSUME_NONNULL_END
