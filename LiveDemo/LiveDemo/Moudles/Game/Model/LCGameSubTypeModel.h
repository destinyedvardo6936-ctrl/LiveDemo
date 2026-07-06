//
//  LCGameSubTypeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/6/4.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCGameSubTypeModel : LCBaseModel
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * ismy;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * topclass_id;
@end

NS_ASSUME_NONNULL_END
