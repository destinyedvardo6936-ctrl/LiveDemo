//
//  LCSearchResultTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/21.
//

#import "LCBaseTableViewCell.h"
#import "LCRankArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCSearchResultTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCRankArchorModel *dataModel;
@property (nonatomic , strong) RACSubject *jumpToLiveSubject;
@end

NS_ASSUME_NONNULL_END
