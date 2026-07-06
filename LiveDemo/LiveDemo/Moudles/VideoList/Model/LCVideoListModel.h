//
//  LCVideoListModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCVideoListModel : LCBaseModel
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * addtime;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * islike;
@property (nonatomic , copy) NSString              * steps;
@property (nonatomic , copy) NSString              * comments;
@property (nonatomic , copy) NSString              * thumb;
@property (nonatomic , copy) NSString              * isvip;
@property (nonatomic , copy) NSString              * music_id;
@property (nonatomic , copy) NSString              * isstep;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * isattent;
@property (nonatomic , copy) NSString              * href_w;
@property (nonatomic , copy) NSString              * shares;
@property (nonatomic , copy) NSString              * likes;
@property (nonatomic , copy) NSString              * thumb_s;
@property (nonatomic , copy) NSString              * views;
@property (nonatomic , copy) NSString              * goods_type;
@property (nonatomic , copy) NSString              * classid;

@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * lng;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * user_nicename;
@property (nonatomic , copy) NSString              * datetime;
@property (nonatomic , copy) NSString              * anyway;
@property (nonatomic , copy) NSString              * ad_url;
@property (nonatomic , copy) NSString              * goodsid;
@property (nonatomic , copy) NSString              * lat;
@property (nonatomic , copy) NSString              * href;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * is_ad;
@property (nonatomic , strong) LCUserInfoModel              * userinfo;
@property (nonatomic , copy) NSString *channelId;

@end

NS_ASSUME_NONNULL_END
