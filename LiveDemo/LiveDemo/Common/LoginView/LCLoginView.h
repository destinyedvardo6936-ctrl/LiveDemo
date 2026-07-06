//
//  LCLoginView.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLoginView : UIView
@property (nonatomic , copy) void(^loginClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
