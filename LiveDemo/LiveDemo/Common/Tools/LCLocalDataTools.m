//
//  LCLocalDataTools.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCLocalDataTools.h"
#import "UIApplication+LCExtension.h"
static NSString *appendPath = @"LCPath";
@implementation LCLocalDataTools
/// 保存本地数据
/// @param key 存取key
/// @param obj 保存对象
/// @param type 存储类型
+ (void)saveLoacalDataWithKey:(NSString *)key
                   object:(id)obj
                    catheType:(LCLocalDataToolsSaveType)type{
    NSString *path;
    if (type == LCLocalDataToolsSaveType_Document) {
        path = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:appendPath];
    }else if (type == LCLocalDataToolsSaveType_Library){
        path = [[UIApplication sharedApplication].libraryPath stringByAppendingPathComponent:appendPath];
    }else{
        path = [[UIApplication sharedApplication].tempPath stringByAppendingPathComponent:appendPath];
    }
    path = [path stringByAppendingPathComponent:key];
    if (obj != nil) {
       
          [NSKeyedArchiver archiveRootObject:obj toFile:path];
       
    }
}

/// 加载本地数据
/// @param key 存取key
/// @param type 存储类型
+ (id)loadLocalWithKey:(NSString *)key
            catcheType:(LCLocalDataToolsSaveType)type{
    NSString *path;
    NSString *foler;

    if (type == LCLocalDataToolsSaveType_Document) {
       
        foler = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:appendPath];
        path = [foler stringByAppendingPathComponent:key];
    } else if (type == LCLocalDataToolsSaveType_Library) {
       foler = [[UIApplication sharedApplication].libraryPath stringByAppendingPathComponent:appendPath];
        path = [foler stringByAppendingPathComponent:key];
    } else {
        foler = [[UIApplication sharedApplication].tempPath stringByAppendingPathComponent:appendPath];
        path = [foler stringByAppendingPathComponent:key];
    }


    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:foler isDirectory:&isDir] && isDir) {

    } else {
        [fileManager createDirectoryAtPath:foler withIntermediateDirectories:YES attributes:nil error:nil];
    }
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    return obj;
}

/// 删除本地存储数据
/// @param key 存取key
/// @param type 存储类型
+ (BOOL)deleteLoacalWithKey:(NSString *)key
                  catheType:(LCLocalDataToolsSaveType)type{
    
    NSString *path;

    if (type == LCLocalDataToolsSaveType_Document) {
    
        path = [NSString stringWithFormat:@"%@/%@", [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:appendPath], key];
    } else if (type == LCLocalDataToolsSaveType_Library) {
        path = [NSString stringWithFormat:@"%@/%@", [[UIApplication sharedApplication].libraryPath stringByAppendingPathComponent:appendPath], key];
    } else {
         path = [NSString stringWithFormat:@"%@/%@", [[UIApplication sharedApplication].tempPath stringByAppendingPathComponent:appendPath], key];
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] && [fileManager isDeletableFileAtPath:path]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:path error:&error];

        if (error) {
            return NO;
        }
        return YES;
    } else {
        return NO;
    }
}

/// 删除某一存储类型的所有数据
/// @param type 存储类型
+ (BOOL)deleteAllLoacalWithType:(LCLocalDataToolsSaveType)type{
    NSString *path;

    if (type == LCLocalDataToolsSaveType_Document) {
    
        path = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:appendPath];
    } else if (type == LCLocalDataToolsSaveType_Library) {
        path = [[UIApplication sharedApplication].libraryPath stringByAppendingPathComponent:appendPath];
    } else {
         path = [[UIApplication sharedApplication].tempPath stringByAppendingPathComponent:appendPath];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        NSError *error = nil;
               [fileManager removeItemAtPath:path error:&error];

               if (error) {
                   return NO;
               }
               return YES;
    }
    else {
        return NO;
    }
}
@end
