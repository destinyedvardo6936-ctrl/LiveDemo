//
//  LCHomeChannelModel.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeChannelModel : LCBaseModel
@property (nonatomic , copy) NSString              * channelId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * upurl;
@end

NS_ASSUME_NONNULL_END
