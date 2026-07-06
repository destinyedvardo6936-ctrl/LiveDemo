//
//  LCBettingRecordModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCBettingRecordModel : LCBaseModel
@property (nonatomic , copy) NSString              * expect;
@property (nonatomic , copy) NSString              * beishu;
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * mode;
@property (nonatomic , copy) NSString              * is_show;
@property (nonatomic , copy) NSString              * cptitle;
@property (nonatomic , copy) NSString              * playtitle;
@end

NS_ASSUME_NONNULL_END
