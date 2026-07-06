//
//  LCWithDrawPaymentModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawPaymentModel : LCBaseModel
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * cash_take;

@end

NS_ASSUME_NONNULL_END
