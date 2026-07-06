//
//  LCMineWalletAndMeaageCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCBaseTableViewCell.h"
#import "LCMessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCMineWalletAndMeaageCell : LCBaseTableViewCell
@property (nonatomic , strong) LCMessageListModel *dataModel;
@property (nonatomic , strong) RACSubject *clickSubject;
@end

NS_ASSUME_NONNULL_END
