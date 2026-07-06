//
//  LCLocationManager.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/2.
//

#import "LCLocationManager.h"

@interface LCLocationManager ()<CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;

@end
@implementation LCLocationManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static LCLocationManager *manager;

    dispatch_once(&onceToken, ^{
        manager = [[LCLocationManager alloc]init];
        
    });
    return manager;
}

- (BOOL)isShowLocalTips {
   

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (kCLAuthorizationStatusNotDetermined == status || kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {

        NSLog(@"请打开定位服务");
       
            

            return YES;
       
    } else {
        return NO;
    }
}


#pragma mark ----------------地图定位---------------------

- (void)startLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
 
    [self.locationManager requestAlwaysAuthorization];

    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    [self.locationManager startUpdatingLocation];

//    [self defaultCity];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self.locationManager startUpdatingLocation];
            break;

        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
        case kCLAuthorizationStatusDenied:
//            [Tools deleteLoacalWithKey:USER_LOCALCity catheType:CatcheType_NoRemove];
            
            break;

        default:
            break;
    }
}

//- (void)defaultCity {
//    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:USER_CITY_SELECTNUM];
//    [Tools saveLoacalWithKey:USER_LocalCityCopy object:@"北京" catheType:CatcheType_NoRemove];
//    [Tools saveLoacalWithKey:USER_LocalCityId object:@"52" catheType:CatcheType_NoRemove];
////    NSString *curentCityId = [Tools loadLocalWithKey:USER_CurrentCityID catcheType:(CatcheType_NoRemove)];
////    if ([Tools isEmptyOrNull:curentCityId] ) {
////        [Tools saveLoacalWithKey:USER_CurrentCity object:@"北京" catheType:CatcheType_NoRemove];
////        [Tools saveLoacalWithKey:USER_CurrentCityID object:@"52" catheType:CatcheType_NoRemove];
////        [[NSNotificationCenter defaultCenter] postNotificationName:USER_CurrentCity_Notification object:nil];
////
////    }
//    if (num == 0) {
//        NSString *curentCity = [Tools loadLocalWithKey:@"USER_CurrentCity" catcheType:(CatcheType_NoRemove)];
//
//        if ([Tools isEmptyOrNull:curentCity]) {
//            [Tools saveLoacalWithKey:USER_CurrentCity object:@"北京" catheType:CatcheType_NoRemove];
//            [Tools saveLoacalWithKey:USER_CurrentCityID object:@"52" catheType:CatcheType_NoRemove];
//            
//        } else {
//            NSString *curentCityId = [Tools loadLocalWithKey:USER_CurrentCityID catcheType:(CatcheType_NoRemove)];
//            if ([Tools isEmptyOrNull:curentCityId] && [curentCity isEqualToString:@"北京"]) {
//                [Tools saveLoacalWithKey:USER_CurrentCityID object:@"52" catheType:CatcheType_NoRemove];
//            }
//        }
//        
//        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:USER_CITY_SELECTNUM];
//
//    }else if(num==3){
//        [Tools saveLoacalWithKey:USER_CurrentCity object:@"北京" catheType:CatcheType_NoRemove];
//        [Tools saveLoacalWithKey:USER_CurrentCityID object:@"52" catheType:CatcheType_NoRemove];
//    }
//   
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"error: %@", error);
////
//    [Tools deleteLoacalWithKey:USER_LocalLoaction catheType:CatcheType_NoRemove];
//
////    [TTUserManager removeValueForKey:USER_LocalCityId];
//    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:USER_CITY_SELECTNUM];
//    if (num <= 0 && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined) {
//        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:USER_CITY_SELECTNUM];
//        //发送通知进行提示
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DefaultCitySetting" object:nil];
//        [self defaultCity];
//
//    }
//
//
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//
//    [self.locationManager stopUpdatingLocation];
//    CLLocation *newLocation = locations[0];
//
//    //统计设置经纬度
//    if ([TTStatisticsManager manager].config) {
//        
//        [TTStatisticsManager manager].config.h = [self getEncodeStrWith:newLocation.coordinate.latitude];
//        [TTStatisticsManager manager].config.s = [self getEncodeStrWith:newLocation.coordinate.longitude];
//        [TTStatisticsManager manager].config = [TTStatisticsManager manager].config;
//
//    } else {
//        TTStaticsConfigModel *config = [TTStaticsConfigModel new];
//        config.h = [self getEncodeStrWith:newLocation.coordinate.latitude];
//        config.s = [self getEncodeStrWith:newLocation.coordinate.longitude];
//        [TTStatisticsManager manager].config = config;
//    }
//
//
//    NSString *location = [NSString stringWithFormat:@"%@,%@", [self getEncodeStrWith:newLocation.coordinate.latitude], [self getEncodeStrWith:newLocation.coordinate.longitude]];
//    TTLog(@"%@", location);
//    [Tools saveLoacalWithKey:USER_LocalLoaction object:location catheType:CatcheType_NoRemove];
//    
//
//    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:USER_CITY_SELECTNUM];
//
//    //------------------位置反编码---5.0之后使用-----------------
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:newLocation
//                   completionHandler:^(NSArray *placemarks, NSError *error) {
//                       for (CLPlacemark *place in placemarks) {
//                           TTLog(@"name,%@", place.locality);
//                           __block NSString *cityName;
//                           if (place.locality) {
//                               cityName = place.locality;
//                           } else {
//                               //省
//                               if (place.administrativeArea) {
//                                   cityName = place.administrativeArea;
//                               } else {
//                                   cityName = @"";
//
//                               }
//                           }
//
//                           NSDictionary *param = @{@"localCity": cityName};
//                           [[BaseNetWork shareManager] postRequestWithBaseURLString:@"/Region/getRegionId" parameters:param forSucess:^(id result) {
//                               if ([[result objectForKey:@"statusCode"] integerValue] == 400) {
//                                   cityName = [[result objectForKey:@"data"] objectForKey:@"cityName"];
//                                   NSString *cityId = [[result objectForKey:@"data"] objectForKey:@"cityId"];
//                                   [Tools saveLoacalWithKey:USER_LOCALCity object:cityId catheType:CatcheType_NoRemove];
//                                   [Tools saveLoacalWithKey:USER_LocalCityCopy object:cityName catheType:CatcheType_NoRemove];
//                                   [Tools saveLoacalWithKey:USER_LocalCityId object:cityId catheType:CatcheType_NoRemove];
//                                   
//                                   //CLLocationDegrees latitude;
////                                   CLLocationDegrees longitude;
//
//
//                                   NSString *curentCity = [Tools loadLocalWithKey:USER_CurrentCity catcheType:(CatcheType_NoRemove)];
//                                   if ([curentCity isEqualToString:cityName]) {
//                                       [Tools saveLoacalWithKey:USER_CurrentCityID object:cityId catheType:CatcheType_NoRemove];
//                                   }
//                                   if ([Tools isEmptyOrNull:curentCity] || num == 2) {
//                                       [Tools saveLoacalWithKey:USER_CurrentCity object:cityName catheType:CatcheType_NoRemove];
//                                       [Tools saveLoacalWithKey:USER_CurrentCityID object:cityId catheType:CatcheType_NoRemove];
//                                       [[NSNotificationCenter defaultCenter] postNotificationName:USER_CurrentCity_Notification object:nil];
//                                   }
//
//                                   [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:USER_CITY_SELECTNUM];//自动定位成功标示
//                               }
//                           }                                                forFail:^(NSError *error) {
//
//                           }];
//                       }
//                   }];
//    [manager stopUpdatingLocation];
//}
//- (NSString *)getEncodeStrWith:(double)num{
//    NSString *afterLatitude = [[NSString stringWithFormat:@"%.f",num] base64EncodedString];
//    NSString *randString = [Tools getRandomStr:1];
//    NSString *beforeStr = [afterLatitude substringToIndex:2];
//    NSString *afterStr = [afterLatitude substringFromIndex:2 ];
//    NSString *afterTimeStr = [NSString stringWithFormat:@"%@%@%@",beforeStr,randString,afterStr];
//    return afterTimeStr;
//}
@end
