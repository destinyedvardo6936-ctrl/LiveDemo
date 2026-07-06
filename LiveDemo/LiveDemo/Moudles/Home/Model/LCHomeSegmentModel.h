//
//  LCHomeSegmentModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeSegmentModel : LCBaseModel
@property (nonatomic , copy) NSString              * channelId;
@property (nonatomic , copy) NSString              * thumb;
@property (nonatomic , copy) NSString              * list_order;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * des;
@end

NS_ASSUME_NONNULL_END
