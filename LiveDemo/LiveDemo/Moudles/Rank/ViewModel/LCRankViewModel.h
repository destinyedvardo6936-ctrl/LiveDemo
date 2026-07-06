//
//  LCRankViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCBaseViewModel.h"
#import "LCRankArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRankViewModel : LCBaseViewModel
@property (nonatomic , assign) BOOL isArchorList;
@property (nonatomic , copy) NSString *type;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@property (nonatomic , strong) RACCommand *followCommand;
@property (nonatomic , strong) RACSubject *followSubject;
@end

NS_ASSUME_NONNULL_END
