//
//  LCSinglePickView.h
//  LCHeadlines
//
//  Created by mrgao on 2020/10/23.
//  Copyright © 2020 WY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSinglePickView : UIView
@property (nonatomic,copy)NSArray *titleArr;
@property (nonatomic,copy)void (^selectBlock)(NSString *title,NSInteger index);
@end

NS_ASSUME_NONNULL_END
