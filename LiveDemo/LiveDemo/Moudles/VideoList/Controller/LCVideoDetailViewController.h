//
//  LCVideoDetailViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCBaseViewController.h"
#import "LCVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVideoDetailViewController : LCBaseViewController
@property (nonatomic,strong)LCVideoListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
