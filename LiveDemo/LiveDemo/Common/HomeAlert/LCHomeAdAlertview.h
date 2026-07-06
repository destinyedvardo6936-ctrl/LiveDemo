//
//  LCHomeAdAlertview.h
//  LiveDemo
//
//  Created by mrgao on 2024/7/27.
//

#import <UIKit/UIKit.h>
#import "LCHomeAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeAdAlertview : UIView
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , copy)void (^clickBlock)(LCHomeAlertModel *selectModel);
@property (nonatomic,copy)void (^closeBlock)(void);
@end

NS_ASSUME_NONNULL_END
