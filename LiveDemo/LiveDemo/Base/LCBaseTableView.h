//
//  ZNBaseTableView.h
//  zhunong
//
//  Created by mrgao on 2022/10/20.
//  Copyright © 2022 WY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCBaseTableView : UITableView
/**
 添加了预估行高的初始化 分组样式
 */
+ (LCBaseTableView *)addTableGrouped;

/**
 添加了预估行高的初始化 不分组样式
 */
+ (LCBaseTableView *)addTablePlain;
@end

NS_ASSUME_NONNULL_END
