//
//  LCUserContributeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUserContributeModel : LCBaseModel
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * total;
@property (nonatomic , copy) NSString              * avatar;
@end

NS_ASSUME_NONNULL_END
