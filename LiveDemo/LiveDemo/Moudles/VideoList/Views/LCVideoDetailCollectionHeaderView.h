//
//  LCVideoDetailCollectionHeaderView.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import <UIKit/UIKit.h>
#import "LCVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVideoDetailCollectionHeaderView : UICollectionReusableView
@property (nonatomic , strong) LCVideoListModel *dataModel;
@property (nonatomic , copy) void (^vipClickedBlock)(void);
@property (nonatomic , copy) void (^gameCenterClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
