//
//  LCVersionModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/1.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCVersionModel : LCBaseModel
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * content;

@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * version;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * url;
@end

NS_ASSUME_NONNULL_END
