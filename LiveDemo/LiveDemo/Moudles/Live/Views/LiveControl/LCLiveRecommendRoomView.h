//
//  LCLiveRecommendRoomView.h
//  LiveDemo
//
//  Created by mrgao on 2022/12/3.
//

#import <UIKit/UIKit.h>
#import "LCHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveRecommendRoomView : UIView
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , copy) void (^selectOtherRoomBlock)(NSArray *arr, LCHomeListModel *model);
@property (nonatomic , copy) void (^dismissBlock)(void);
- (void)show;
@end

NS_ASSUME_NONNULL_END
