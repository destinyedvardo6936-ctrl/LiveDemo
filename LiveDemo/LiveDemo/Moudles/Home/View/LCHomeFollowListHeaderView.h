//
//  LCHomeFollowListHeaderView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeFollowListHeaderView : UICollectionReusableView
@property (nonatomic , copy) NSString *titleStr;
@property (nonatomic , strong) UIImage *image;
@property (nonatomic , assign) BOOL needReplace;
@property (nonatomic , copy) void(^replaceClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
