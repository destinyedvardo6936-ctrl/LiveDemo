//
//  LCProtocolView.h
//  LCHeadlines
//
//  Created by mrgao on 2020/2/24.
//  Copyright © 2020 WY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *protocolSavePath = @"LCProtocolSavePath";

@interface LCProtocolView : UIWindow
@property (nonatomic,copy)void(^protocolClicked)(NSInteger index);//index 1、用户服务协议  2、隐私政策
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
