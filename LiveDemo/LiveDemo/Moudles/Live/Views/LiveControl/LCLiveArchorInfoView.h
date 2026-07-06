//
//  LCLiveArchorInfoView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import <UIKit/UIKit.h>
#import "LCLiveArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveArchorInfoView : UIView
@property (nonatomic , strong) LCLiveArchorModel *dataModel;
@property (nonatomic , copy) void (^avaterClickBlock)(LCLiveArchorModel *selectModel);
@property (nonatomic , copy) void (^followBlock)(void);
@end

NS_ASSUME_NONNULL_END
