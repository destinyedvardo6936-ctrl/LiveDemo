//
//  LCConfigModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import "LCBaseModel.h"
#import "LCArchorLevelModel.h"
#import "LCUserLevelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCConfigModel : LCBaseModel
//@property (nonatomic , strong) Guide              * guide;
@property (nonatomic , copy) NSString              * login_alert_title;
@property (nonatomic , copy) NSString              * video_share_des;
@property (nonatomic , copy) NSString              * video_watermark;
@property (nonatomic , copy) NSString              * qiniu_domain;
@property (nonatomic , copy) NSString              * face_lift;
@property (nonatomic , copy) NSString              * shop_system_name;
@property (nonatomic , copy) NSString              * chin_lift;
@property (nonatomic , copy) NSString              * payment_time;
@property (nonatomic , copy) NSString              * brightness;
@property (nonatomic , copy) NSString              * name_coin;
@property (nonatomic , copy) NSString              * lengthen_noseLift;
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , copy) NSArray<NSString *>              * sensitive_words; //敏感词
@property (nonatomic , copy) NSString              * login_private_url;
@property (nonatomic , copy) NSString              * skin_tenderness;
@property (nonatomic , copy) NSString              * wxmini_shelves_version;
@property (nonatomic , copy) NSString              * company_desc;
@property (nonatomic , copy) NSString              * qiniu_sign;
@property (nonatomic , copy) NSString              * face_shave;
@property (nonatomic , copy) NSString              * ios_shelves;
@property (nonatomic , copy) NSString              * wechat_ewm;
@property (nonatomic , copy) NSString              * ipa_ewm;
@property (nonatomic , copy) NSString              * app_android;
@property (nonatomic , copy) NSString              * app_ios;
@property (nonatomic , copy) NSArray<NSString *>              * login_type;
@property (nonatomic , copy) NSString              * mouse_lift;
@property (nonatomic , copy) NSString              * name_votes;
@property (nonatomic , copy) NSString              * login_clause_title;
@property (nonatomic , copy) NSString              * apk_url;
@property (nonatomic , copy) NSString              * qiniu_region;
@property (nonatomic , copy) NSString              * big_eye;
@property (nonatomic , copy) NSString              * login_service_url;
@property (nonatomic , copy) NSString              * qiniu_uphost;
@property (nonatomic , copy) NSString              * apk_des;
@property (nonatomic , copy) NSString              * eye_brow;
@property (nonatomic , copy) NSString              * site;
@property (nonatomic , copy) NSString              * eye_length;
@property (nonatomic , copy) NSString              * ipa_ver;
@property (nonatomic , copy) NSString              * sprout_key;
@property (nonatomic , copy) NSString              * eye_corner;
@property (nonatomic , copy) NSString              * txvideofolder;
@property (nonatomic , copy) NSArray             * videoclass;//视频分类
@property (nonatomic , copy) NSString              * login_alert_content;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * video_audit_switch;
@property (nonatomic , copy) NSString              * letter_switch;
@property (nonatomic , copy) NSString              * socket_url;
@property (nonatomic , copy) NSString              * stricker_url;
@property (nonatomic , copy) NSString              * share_title;
@property (nonatomic , copy) NSString              * payment_percent;
@property (nonatomic , copy) NSString              * wxmini_version;
@property (nonatomic , copy) NSString              * eye_alat;
@property (nonatomic , copy) NSString              * txcloud_region;
@property (nonatomic , copy) NSString              * login_service_title;
@property (nonatomic , copy) NSString              * video_share_title;
@property (nonatomic , copy) NSArray<LCArchorLevelModel *>              * levelanchor; //主播等级信息
@property (nonatomic , copy) NSString              * apk_ewm;
@property (nonatomic , copy) NSString              * apigame_status;
@property (nonatomic , copy) NSArray<NSString *>              * live_time_coin;
@property (nonatomic , copy) NSString              * sprout_key_ios;
@property (nonatomic , copy) NSString              * shopexplain_url;
//@property (nonatomic , copy) NSArray<Live_type *>              * live_type;//房间类型
@property (nonatomic , copy) NSString              * game_status;
@property (nonatomic , copy) NSString              * wx_siteurl;
@property (nonatomic , copy) NSString              * skin_smooth;
@property (nonatomic , copy) NSString              * site_name;
@property (nonatomic , copy) NSString              * skin_whiting;
@property (nonatomic , copy) NSString              * isup;
@property (nonatomic , copy) NSArray<LCUserLevelModel *>              * level;//用户等级信息
@property (nonatomic , copy) NSString              * ipa_url;
@property (nonatomic , copy) NSString              * wxmini_des;
@property (nonatomic , copy) NSString              * apk_ver;
@property (nonatomic , copy) NSString              * cloudtype;
@property (nonatomic , copy) NSString              * name_score;
@property (nonatomic , copy) NSString              * forehead_lift;
@property (nonatomic , copy) NSString              * ipa_des;
@property (nonatomic , copy) NSArray<NSString *>              * share_type;
@property (nonatomic , copy) NSString              * txcloud_appid;
@property (nonatomic , copy) NSString              * txcloud_bucket;
@property (nonatomic , copy) NSString              * nose_lift;
@property (nonatomic , copy) NSString              * login_private_title;
@property (nonatomic , copy) NSString              * maintain_tips;
@property (nonatomic , copy) NSString              * share_des;
//@property (nonatomic , copy) NSArray<Liveclass *>              * liveclass;//直播分类
@property (nonatomic , copy) NSString              * company_name;
@property (nonatomic , copy) NSString              * maintain_switch;
@property (nonatomic , copy) NSString              * tximgfolder;
@end

NS_ASSUME_NONNULL_END
