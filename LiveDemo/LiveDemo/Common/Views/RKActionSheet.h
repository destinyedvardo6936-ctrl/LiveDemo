//
//  RKActionSheet.h
//  iphoneLive
//
//  Created by YB007 on 2020/7/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RKSheetType) {
    RKSheet_Default,    //功能按钮
    RKSheet_Cancle,     //取消按钮
    RKSheet_FunPink,    //功能键-红色
};

typedef void (^RKSheetBlock)(void);

@interface RKActionSheet : UIView

- (instancetype)initWithTitle:(NSString *)titleStr;
-(void)addActionWithType:(RKSheetType)sheetType andTitle:(NSString *)titile complete:(RKSheetBlock)complete;
-(void)showSheet;


//调用示例 注意 type 区分
/**
 YBWeakSelf;
 RKActionSheet *sheet = [[RKActionSheet alloc]initWithTitle:@""];
 [sheet addActionWithType:RKSheet_Default andTitle:@"" complete:^{
     //...
 }];
 [sheet addActionWithType:RKSheet_Default andTitle:@"" complete:^{
     //...
 }];
 [sheet addActionWithType:RKSheet_Cancle andTitle:@"" complete:^{
 }];
 [sheet showSheet];
 */

@end


