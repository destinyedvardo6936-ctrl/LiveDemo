//
//  LCGameCenterHeaderView.h
//  LiveDemo
//
//  Created by mrgao on 2023/6/4.
//

#import <UIKit/UIKit.h>
#import "LCGameSubTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCGameCenterHeaderView : UICollectionReusableView
@property (nonatomic , strong)NSMutableArray *dataArray;
@property (nonatomic , strong)LCGameSubTypeModel *selectTypeModel;
@property (nonatomic , copy)void (^subTypeClickBlock)(LCGameSubTypeModel *selectModel);
@end

NS_ASSUME_NONNULL_END
