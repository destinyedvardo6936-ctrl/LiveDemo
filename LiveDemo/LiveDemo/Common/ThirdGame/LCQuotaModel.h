//
//  LCQuotaModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCQuotaModel : LCBaseModel
@property (nonatomic , copy) NSString              * pid;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * biaoshi;
@property (nonatomic , copy) NSString              * istry;
@property (nonatomic , copy) NSString              * tiojian;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * icon;

@property (nonatomic , copy) NSString *balance;
@end

NS_ASSUME_NONNULL_END
