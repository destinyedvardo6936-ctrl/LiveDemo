//
//  LCWithDrawAccountModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawAccountModel : LCBaseModel
@property (nonatomic , copy) NSString              * account;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * addtime;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * account_bank;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * name;
@end

NS_ASSUME_NONNULL_END
