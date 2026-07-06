//
//  LCVersionView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import <UIKit/UIKit.h>
#import "LCVersionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVersionView : UIView
@property (nonatomic,strong)LCVersionModel *dataModel;
@property (nonatomic,copy)void (^updateClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
