//
//  LCHomeAlertModel.h
//  LiveDemo
//
//  Created by mrgao on 2024/7/27.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeAlertModel : LCBaseModel
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * list_order;
@property (nonatomic , copy) NSString              * target;
@property (nonatomic , copy) NSString              * alertId;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * more;
@property (nonatomic , copy) NSString              * slide_id;
@property (nonatomic , copy) NSString              * des;
@property (nonatomic , copy) NSString              * url;
@end

NS_ASSUME_NONNULL_END
