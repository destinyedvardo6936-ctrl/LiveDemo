//
//  LCGameConfigManager.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCGameConfigManager : NSObject
@property (nonatomic , assign) BOOL gameStatus;
+ (instancetype)shareManager;
- (void)getGameCurrentStatus;
@end

NS_ASSUME_NONNULL_END
