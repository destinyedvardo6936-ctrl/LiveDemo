//
//  LCSettingModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSettingModel : LCBaseModel
@property (nonatomic , copy) NSString *leftTitle;
@property (nonatomic , copy) NSString *rightValue;
@property (nonatomic , assign) BOOL needAccess;
@property (nonatomic , assign) NSInteger type;//0 title 1 switch 2 button 
@end

NS_ASSUME_NONNULL_END
