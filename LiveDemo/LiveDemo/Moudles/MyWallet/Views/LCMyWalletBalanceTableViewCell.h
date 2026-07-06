//
//  LCMyWalletBalanceTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCMyWalletBalanceTableViewCell : LCBaseTableViewCell
@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , strong) RACSubject *recordSubject;
@property (nonatomic , strong) RACSubject *rechargeSubject;
@property (nonatomic , strong) RACSubject *withdrawSubject;
@end

NS_ASSUME_NONNULL_END
