//
//  LCQuatoBalanceTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCQuatoBalanceTableViewCell : LCBaseTableViewCell
@property (nonatomic,copy)NSString *balance;
@property (nonatomic , copy)void (^refreshBlock)(void);
@end

NS_ASSUME_NONNULL_END
