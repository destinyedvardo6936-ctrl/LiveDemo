//
//  LCLiveGameRecommendView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveGameRecommendView : UIView
@property (nonatomic , copy) NSArray *dataArr;
@property (nonatomic , copy) void (^gameClickBlock)(id model);
@end

NS_ASSUME_NONNULL_END
