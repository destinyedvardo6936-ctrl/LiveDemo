//
//  LCLiveStopInfoView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveStopInfoView : UIView
- (instancetype)initWithFrame:(CGRect)frame dataDic:(NSDictionary *)dic;
@property (nonatomic , copy) void (^backBlock)(void);
@end

NS_ASSUME_NONNULL_END
