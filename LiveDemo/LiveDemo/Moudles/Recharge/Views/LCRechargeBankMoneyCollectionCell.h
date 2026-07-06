//
//  LCRechargeBankMoneyCollectionCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/23.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeBankMoneyCollectionCell : LCBaseTableViewCell
@property (nonatomic,copy)void (^inputBlock)(NSString * input);
@end

NS_ASSUME_NONNULL_END
