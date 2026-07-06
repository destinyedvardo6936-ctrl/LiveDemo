//
//  LCRankTopThreeCell.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCBaseTableViewCell.h"
#import "LCRankArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRankTopThreeCell : LCBaseTableViewCell
@property (nonatomic , assign) BOOL isArchorList;
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , strong) RACSubject *followSubject;
@property (nonatomic , strong) RACSubject *jumpToLiveSubject;
@property (nonatomic , strong) RACSubject *userHomeSubject;

@end

NS_ASSUME_NONNULL_END
