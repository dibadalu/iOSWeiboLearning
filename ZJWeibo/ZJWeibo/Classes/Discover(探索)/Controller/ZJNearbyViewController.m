//
//  ZJNearbyViewController.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/11/27.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJNearbyViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZJHttpTool.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"
//#import <MapKit/MapKit.h>

@interface ZJNearbyViewController ()<CLLocationManagerDelegate>

@property(nonatomic,strong) CLLocationManager *clMgr;//定位管理者对象
//@property(nonatomic,strong) MKMapView *mapView;//地图控件对象
//@property(nonatomic,strong) CLGeocoder *gecoder;//地理编码对象

@end

@implementation ZJNearbyViewController
//- (CLGeocoder *)gecoder
//{
//    if (!_gecoder) {
//        _gecoder = [[CLGeocoder alloc] init];
//    }
//    return _gecoder;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"周边";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //iOS8之后，需要主动获取用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        self.clMgr = [[CLLocationManager alloc] init];
        [self.clMgr requestWhenInUseAuthorization];
    }
    //设置CLLocationManager的代理
    self.clMgr.delegate = self;
    //设置其他属性
    self.clMgr.desiredAccuracy = kCLLocationAccuracyBest;//精度
    CLLocationDistance distance = 10.0;
    self.clMgr.distanceFilter = distance;//频率
    //开始定位跟踪
    [self.clMgr startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate
/**
 *  位置发生改变后执行（第一次定位到某个位置也会执行）
 *
 *  @param manager   CLLocationManager
 *  @param locations 获取到位置数组
 */
-  (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations");
    
    CLLocation *firstLocation = [locations firstObject];
    CLLocationCoordinate2D coodinate = firstLocation.coordinate;//坐标
    NSLog(@"经度：%f 纬度：%f",coodinate.longitude,coodinate.latitude);
    
    /*
     https://api.weibo.com/2/place/nearby_timeline.json
     
     get
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     lat	true	float	纬度。有效范围：-90.0到+90.0，+表示北纬。
     long	true	float	经度。有效范围：-180.0到+180.0，+表示东经。
     */
    //发送请求——获取某个位置周边的动态
    ZJAccount *account = [ZJAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"lat"] = @(coodinate.latitude);
    params[@"long"] = @(coodinate.longitude);
    
    
    [ZJHttpTool get:@"https://api.weibo.com/2/place/nearby_timeline.json" params:params success:^(id json) {
        ZJLog(@"%@",json);
    } failure:^(NSError *error) {
        ZJLog(@"%@",error);
    }];
    
    //停止定位跟踪
    [self.clMgr stopUpdatingLocation];
}

@end
