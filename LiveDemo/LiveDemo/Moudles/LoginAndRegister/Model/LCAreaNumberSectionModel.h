//
//  LCAreaNuberSectionModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import "LCBaseModel.h"
#import "LCAreaNumberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCAreaNumberSectionModel : LCBaseModel
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSArray<LCAreaNumberModel *>              * lists;

@end

NS_ASSUME_NONNULL_END
