//
//  LCLocalDataTools.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, LCLocalDataToolsSaveType) {
    LCLocalDataToolsSaveType_Document,//会被备份
    LCLocalDataToolsSaveType_Library,//不会备份，不会退出应用清空
    LCLocalDataToolsSaveType_Temp,//临时
};
@interface LCLocalDataTools : NSObject
/// 保存本地数据
/// @param key 存取key
/// @param obj 保存对象
/// @param type 存储类型
+ (void)saveLoacalDataWithKey:(NSString *)key
                   object:(id)obj
                catheType:(LCLocalDataToolsSaveType)type;

/// 加载本地数据
/// @param key 存取key
/// @param type 存储类型
+ (id)loadLocalWithKey:(NSString *)key
            catcheType:(LCLocalDataToolsSaveType)type;

/// 删除本地存储数据
/// @param key 存取key
/// @param type 存储类型
+ (BOOL)deleteLoacalWithKey:(NSString *)key
                  catheType:(LCLocalDataToolsSaveType)type;

/// 删除某一存储类型的所有数据
/// @param type 存储类型
+ (BOOL)deleteAllLoacalWithType:(LCLocalDataToolsSaveType)type;
@end

NS_ASSUME_NONNULL_END
