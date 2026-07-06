//
//  LCActivityModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCActivityModel : LCBaseModel
@property (nonatomic , copy) NSString *modelId;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *image;
@property (nonatomic , copy) NSString *aurl;
@property (nonatomic , copy) NSString *begintime;
@property (nonatomic , copy) NSString *endtime;
@end

NS_ASSUME_NONNULL_END
