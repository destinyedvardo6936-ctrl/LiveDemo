//
//  LCWithDrawTextFieldTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseTableViewCell.h"
#import "LCWithDrawProfitModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawTextFieldTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCWithDrawProfitModel *dataModel;
@property (nonatomic , strong) RACSubject *textSubject;
@end

NS_ASSUME_NONNULL_END
