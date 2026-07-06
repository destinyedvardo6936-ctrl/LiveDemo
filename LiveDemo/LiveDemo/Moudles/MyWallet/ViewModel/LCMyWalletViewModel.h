//
//  LCMyWalletViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import "LCBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCMyWalletViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , copy) NSString *sendZSStr;
@property (nonatomic , copy) NSString *leftZSStr;
@end

NS_ASSUME_NONNULL_END
