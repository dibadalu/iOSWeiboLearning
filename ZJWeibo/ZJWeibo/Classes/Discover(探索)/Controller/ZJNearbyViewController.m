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
#import <MapKit/MapKit.h>
#import "ZJStatusCell.h"
#import "ZJStatus.h"
#import "ZJStatusFrame.h"
#import <MJExtension.h>
#import "ZJStatusDetailViewController.h"

@interface ZJNearbyViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property(nonatomic,strong) CLLocationManager *clMgr;//定位管理者对象
//@property(nonatomic,strong) MKMapView *mapView;//地图控件对象
@property(nonatomic,strong) CLGeocoder *gecoder;//地理编码对象

@property(nonatomic,strong) NSMutableArray *statusFrames;

@end

@implementation ZJNearbyViewController
- (CLLocationManager *)clMgr
{
    if (!_clMgr) {
        _clMgr = [[CLLocationManager alloc] init];
        //设置CLLocationManager的代理
        _clMgr.delegate = self;
        //设置其他属性
        _clMgr.desiredAccuracy = kCLLocationAccuracyBest;//精度
        CLLocationDistance distance = 10.0;
        _clMgr.distanceFilter = distance;//频率

    }
    return _clMgr;
}
//- (MKMapView *)mapView
//{
//    if (!_mapView) {
//        _mapView = [[MKMapView alloc] init];
//        _mapView.frame = [UIScreen mainScreen].bounds;
//        //设置地图控件的属性
//        _mapView.mapType = MKMapTypeStandard;
//        _mapView.userTrackingMode = MKUserTrackingModeFollow;
//        _mapView.rotateEnabled = NO;
//        _mapView.delegate = self;
//    }
//    return _mapView;
//}
- (CLGeocoder *)gecoder
{
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc] init];
    }
    return _gecoder;
}
- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"周边";
//    self.view = self.mapView;
   
    //iOS8之后，需要主动获取用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
//        self.clMgr = [[CLLocationManager alloc] init];
        [self.clMgr requestWhenInUseAuthorization];
    }
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
    NSLog(@"CLLocationManagerDelegate--didUpdateLocations");
    
    CLLocation *firstLocation = [locations firstObject];//取得第一个位置
    CLLocationCoordinate2D firstCoodinate = firstLocation.coordinate;
//    NSLog(@"经度：%f 纬度：%f",coodinate.longitude,coodinate.latitude);
    
    //利用地理编码设置导航栏标题的内容
    [self.gecoder reverseGeocodeLocation:firstLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];//取得第一个地标
        self.title = placemark.thoroughfare;//街道
    }];
    
    //获取某个位置周边的动态
    ZJAccount *account = [ZJAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"lat"] = @(firstCoodinate.latitude);
    params[@"long"] = @(firstCoodinate.longitude);
    params[@"count"] = @20;
    //发送请求
    [ZJHttpTool get:@"https://api.weibo.com/2/place/nearby_timeline.json" params:params success:^(id json) {
//        ZJLog(@"%@",json[@"statuses"]);
        
        //字典转模型
        NSArray *newStatuses = [ZJStatus objectArrayWithKeyValuesArray:json[@"statuses"]];
        
        //将ZJStatus转化为ZJStatusFrame
        NSArray *frames = [self statusFramesWithStatuses:newStatuses];
        
        //将最新的微博数据，添加到总数组的最前面(插入)
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:frames atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        ZJLog(@"%@",error);
    }];
    
    //停止定位跟踪
    [self.clMgr stopUpdatingLocation];
}

/**
 * 将ZJStatus转化为ZJStatusFrame
 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    //遍历status数组
    NSMutableArray *frames = [NSMutableArray array];
    for (ZJStatus *status in statuses) {
        ZJStatusFrame *frame = [[ZJStatusFrame alloc] init];
        frame.status = status;
        [frames addObject:frame];
    }
    return frames;
}

#pragma mark - MKMapViewDelegate
/**
 *  用户位置发生改变时触发（第一次定位到用户位置也会触发该方法）
 *
 *  @param mapView      地图控件对象
 *  @param userLocation 用户位置
 */
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    NSLog(@"MKMapViewDelegate--didUpdateLocations");
//    
//    //利用地理编码设置大头针的内容
//    [self.gecoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark = [placemarks firstObject];//取得第一个地标
//        userLocation.title = placemark.name;
//        userLocation.subtitle = placemark.locality;
//    }];
//
//    CLLocationCoordinate2D coodinate = userLocation.coordinate;
//    //设置地图的中心位置
//    [self.mapView setCenterCoordinate:coodinate animated:YES];
//
//    //设置地图显示的区域
//    CLLocationCoordinate2D center = coodinate;
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
//    MKCoordinateRegion regin = MKCoordinateRegionMake(center, span);
//    [self.mapView setRegion:regin animated:YES];
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    ZJStatusCell *cell = [ZJStatusCell cellWithTableView:tableView];
    
    //2.给cell传模型
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
/**
 *  计算cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ZJLog(@"didSelectRowAtIndexPath---%ld",(long)indexPath.row);
    ZJStatusDetailViewController *detail = [[ZJStatusDetailViewController alloc] init];
    ZJStatusFrame *frame = self.statusFrames[indexPath.row];
    detail.status = frame.status;//传微博数据给ZJStatusDetailViewController
    [self.navigationController pushViewController:detail animated:YES];
}

@end
