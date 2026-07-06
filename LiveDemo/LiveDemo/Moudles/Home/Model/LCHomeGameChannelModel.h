//
//  LCHomeGameChannelModel.h
//  LiveDemo
//
//  Created by mrgao on 2024/7/30.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeGameChannelModel : LCBaseModel
@property (nonatomic , copy) NSString              * param;
@property (nonatomic , copy) NSString              * channelId;
@property (nonatomic , copy) NSString              * thumb;
@property (nonatomic , copy) NSString              * type;
@end

NS_ASSUME_NONNULL_END
