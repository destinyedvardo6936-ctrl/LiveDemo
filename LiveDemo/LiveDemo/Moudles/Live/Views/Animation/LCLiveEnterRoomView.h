//
//  LCLiveEnterRoomView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveEnterRoomView : UIView
//@property (nonatomic , copy) NSArray *dataArray;
- (void)addUsers:(NSArray *)arr;
- (void)stopAnim;
@end

NS_ASSUME_NONNULL_END
