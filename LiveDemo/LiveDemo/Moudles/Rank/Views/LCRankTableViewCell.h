//
//  LCRankTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/26.
//

#import "LCBaseTableViewCell.h"
#import "LCRankArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRankTableViewCell : LCBaseTableViewCell
@property (nonatomic , assign) BOOL isArchorList;
@property (nonatomic , strong) LCRankArchorModel *dataModel;
@property (nonatomic , strong) RACSubject *followSubject;
@property (nonatomic , strong) RACSubject *jumpToLiveSubject;
@end

NS_ASSUME_NONNULL_END
