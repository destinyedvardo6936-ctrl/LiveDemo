//
//  LCGameListModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCGameListModel : LCBaseModel
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * expects;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              ismy;

@property (nonatomic , copy) NSString              * minites;


@property (nonatomic , copy) NSString              * biaoshi;
@property (nonatomic , copy) NSString              * icon;

@property (nonatomic , copy) NSString              * name;

@property (nonatomic , copy) NSString              * pid;
@property (nonatomic , copy) NSString              * istry;
@property (nonatomic , copy) NSString              * tiojian;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * pailietype;

//@property (nonatomic , copy) NSString *modelId;
//@property (nonatomic , copy) NSString *thumb;
//@property (nonatomic , copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
