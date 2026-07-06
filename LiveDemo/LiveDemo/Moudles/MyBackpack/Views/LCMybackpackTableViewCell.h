//
//  LCMybackpackTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseTableViewCell.h"
#import "LCMyBackPackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCMybackpackTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCMyBackPackModel *dataModel;
@property (nonatomic , strong) RACSubject *clickSubject;
@end

NS_ASSUME_NONNULL_END
