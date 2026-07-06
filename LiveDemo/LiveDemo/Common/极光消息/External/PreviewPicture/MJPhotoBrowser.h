//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^saveImgEvent)(UIImage *selImg);

@protocol MJPhotoBrowserDelegate;

@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSMutableArray * photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic, strong) JMSGConversation * conversation;

@property (nonatomic, copy) saveImgEvent saveEvent;
// 显示
- (void)show;
//撤回消息移除 browser
-(void)retractMsgDismissBrowser;

@end

@protocol MJPhotoBrowserDelegate <NSObject>

- (void)CellPhotoImageReload;

- (void)NewPostImageReload:(NSInteger)ImageIndex;

@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end
