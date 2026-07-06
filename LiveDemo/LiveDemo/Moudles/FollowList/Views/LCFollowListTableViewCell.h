//
//  LCFollowListTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseTableViewCell.h"
#import "LCRankArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCFollowListTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCRankArchorModel *dataModel;
@property (nonatomic , strong) RACSubject *followSubject;
@end

NS_ASSUME_NONNULL_END
