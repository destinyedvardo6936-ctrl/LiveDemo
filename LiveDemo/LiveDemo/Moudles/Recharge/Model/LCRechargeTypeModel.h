//
//  LCRechargeTypeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeTypeModel : LCBaseModel
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * addtime;
@property (nonatomic , copy) NSString              * payid;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * usdtretio;

@property (nonatomic , assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
