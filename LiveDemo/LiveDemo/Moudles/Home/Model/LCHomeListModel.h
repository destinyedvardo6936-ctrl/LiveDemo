//
//  LCHomeListModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/12/31.
//

#import "LCBaseModel.h"
#import "LCGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeListModel : LCBaseModel

@property (nonatomic , copy) NSString              * title;//直播标题
@property (nonatomic , copy) NSString              * avatar_thumb;//头像缩略图
@property (nonatomic , copy) NSString              * sex;//1男2女
@property (nonatomic , copy) NSString              * starttime;
@property (nonatomic , strong) LCGameListModel              * caipiao;
@property (nonatomic , copy) NSString              * city;//主播位置
@property (nonatomic , copy) NSString              * stream;//流名
@property (nonatomic , copy) NSString              * type;//直播类型
@property (nonatomic , copy) NSString              * level_anchor;//主播等级
@property (nonatomic , copy) NSString              * anyway;//
@property (nonatomic , copy) NSString              * user_nicename;//直播昵称
@property (nonatomic , copy) NSString              * uid;//主播id
@property (nonatomic , copy) NSString              * thumb;//直播封面
@property (nonatomic , copy) NSString              * nums;//人数
@property (nonatomic , copy) NSString              * level;//主播等级
@property (nonatomic , copy) NSString              * hotvotes;
@property (nonatomic , copy) NSString              * avatar;//主播头像

@property (nonatomic , copy) NSString              * pull;//播流地址
@property (nonatomic , copy) NSString              * type_val;//收费房间价格，默认0
@end

NS_ASSUME_NONNULL_END
