//
//  LCGameTypeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseModel.h"
#import "LCGameListModel.h"
#import "LCGameSubTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCGameTypeModel : LCBaseModel
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * biaoshi;
@property (nonatomic , copy) NSString              * istry;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * icon;


@property (nonatomic , assign) BOOL isSelected;
@property (nonatomic , strong) LCGameSubTypeModel *selectTypeModel;
@property (nonatomic , strong) NSMutableArray <LCGameSubTypeModel *>*typeArray;
@property (nonatomic , strong) NSMutableArray <LCGameListModel *>*dataArray;
@end

NS_ASSUME_NONNULL_END
