//
//  LCSexSelectView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSexSelectView : UIView
@property (nonatomic , copy) NSString *currentSex;
@property (nonatomic , copy)void(^selectBlock)(NSString *sex);
@end

NS_ASSUME_NONNULL_END
