//
//  LCNoNetworkView.h
//  LCHeadlines
//
//  Created by mrgao on 2020/1/6.
//  Copyright © 2020 mrgao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNoNetworkView : UIView
@property (nonatomic,copy)void(^reconnectBlock)(void);
@end

NS_ASSUME_NONNULL_END
