//
//  LCAccountDetailsModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCAccountDetailsModel : LCBaseModel
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * totalcoin;
@property (nonatomic , copy) NSString              * action;

@end

NS_ASSUME_NONNULL_END
