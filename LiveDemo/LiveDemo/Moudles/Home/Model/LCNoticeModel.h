//
//  LCNoticeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/21.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCNoticeModel : LCBaseModel
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * updatetime;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * createtime;
@end

NS_ASSUME_NONNULL_END
