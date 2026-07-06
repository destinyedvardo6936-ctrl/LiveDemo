//
//  LCSocketManager.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LCSocketManagerDelegate <NSObject>

- (void)connectFailured:(NSError *)error;
- (void)connectSuccess:(id)result;
- (void)disConnect:(id)result;
- (void)netWorkChanged;
//- (void)sendMessageSuccess:(id)result;
//- (void)sendMessageFailured:(NSError *)error;
- (void)receiveMessage:(id)message;


@end
@interface LCSocketManager : NSObject
@property (nonatomic , strong,readonly) id delegate;

+ (instancetype)shareManager;

- (void)connetToSever:(NSString *)urlStr
             delegate:(id<LCSocketManagerDelegate>)delegate
               roomId:(NSString *)roomId
               stream:(NSString *)stream;
- (void)sendMessage:(NSArray *)arr eventName:(NSString *)eventName;
- (void)disconnect;

@end

NS_ASSUME_NONNULL_END
