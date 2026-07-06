//
//  LCLiveDetailGuardModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/24.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveDetailGuardModel : LCBaseModel
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * endtime;
@property (nonatomic , copy) NSString              * votestotal;
@property (nonatomic , copy) NSString              * guard_nums;
@end

NS_ASSUME_NONNULL_END
