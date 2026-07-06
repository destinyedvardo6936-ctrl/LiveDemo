//
//  LCLiveViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/26.
//

#import "LCBaseViewModel.h"
#import "LCLiveModel.h"
#import "LCHomeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveViewModel : LCBaseViewModel
@property (nonatomic , strong) NSArray *origalArr;//列表传进来的数组

@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCHomeListModel *currentModel;

@property (nonatomic , strong) RACCommand *nextLivePageCommand;
@property (nonatomic , strong) RACSubject *nextLivePageSubject;
@property (nonatomic , strong) RACCommand *lastLivePageCommand;
@property (nonatomic , strong) RACSubject *lastLivePageSubject;
@end

NS_ASSUME_NONNULL_END
