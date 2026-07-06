//
//  LCLiveToolView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveToolView : UIView
@property (nonatomic , copy) void(^btnClickBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
