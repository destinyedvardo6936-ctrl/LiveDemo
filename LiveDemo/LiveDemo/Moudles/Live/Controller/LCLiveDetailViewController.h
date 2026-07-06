//
//  LCLiveDetailViewController.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/26.
//

#import "LCBaseViewController.h"
#import "LCHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveDetailViewController : LCBaseViewController
@property (nonatomic , strong) LCHomeListModel *dataModel;
- (void)startRequest;
- (void)pausePlayAndSocket;
- (void)resumePlayAndSocket;
- (void)releasePlayer;
@end

NS_ASSUME_NONNULL_END
