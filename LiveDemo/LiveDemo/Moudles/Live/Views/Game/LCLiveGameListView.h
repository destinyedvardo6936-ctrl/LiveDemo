//
//  LCLiveGameListView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
#import "LCGameTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveGameListView : UIView<JXPagerViewListViewDelegate>
@property (nonatomic , assign) BOOL isFromVideo;
@property (nonatomic , strong) LCGameTypeModel *dataModel;

@end

NS_ASSUME_NONNULL_END
