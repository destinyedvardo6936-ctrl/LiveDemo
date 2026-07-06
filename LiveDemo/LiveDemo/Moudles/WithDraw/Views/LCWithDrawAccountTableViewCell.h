//
//  LCWithDrawAccountTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseTableViewCell.h"
#import "LCWithDrawAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawAccountTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCWithDrawAccountModel *dataModel;
@property (nonatomic , strong) RACSubject *clickSubject;
@end

NS_ASSUME_NONNULL_END
