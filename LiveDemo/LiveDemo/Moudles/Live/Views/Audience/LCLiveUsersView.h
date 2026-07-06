//
//  LCLiveUsersView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import <UIKit/UIKit.h>
#import "LCLiveUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveUsersView : UIView
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , copy) void(^clickBlock)(void) ;
@end

NS_ASSUME_NONNULL_END
