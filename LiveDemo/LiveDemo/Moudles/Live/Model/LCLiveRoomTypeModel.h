//
//  LCLiveRoomTypeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/25.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveRoomTypeModel : LCBaseModel
@property (nonatomic , copy) NSString              * type_val;
@property (nonatomic , copy) NSString              * type_msg;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * live_sdk;
@property (nonatomic , copy) NSString              * live_type;
@end

NS_ASSUME_NONNULL_END
