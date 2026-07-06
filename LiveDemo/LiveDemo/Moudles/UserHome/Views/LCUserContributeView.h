//
//  LCUserContributeView.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import <UIKit/UIKit.h>
#import "LCUserContributeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCUserContributeView : UIView
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , copy) void(^clickBlock)(LCUserContributeModel *selectModel) ;
@end

NS_ASSUME_NONNULL_END
