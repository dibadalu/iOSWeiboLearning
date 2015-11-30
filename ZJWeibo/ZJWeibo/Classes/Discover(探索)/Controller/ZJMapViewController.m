//
//  ZJMapViewController.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/11/30.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJMapViewController.h"
#import <MapKit/MapKit.h>

@interface ZJMapViewController ()<MKMapViewDelegate>

@property(nonatomic,strong) MKMapView *mapView;//地图控件对象
@property(nonatomic,strong) CLGeocoder *gecoder;//地理编码对象

@end

@implementation ZJMapViewController
- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.frame = [UIScreen mainScreen].bounds;
        //设置地图控件的属性
        _mapView.mapType = MKMapTypeStandard;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        _mapView.rotateEnabled = NO;
        _mapView.delegate = self;
    }
    return _mapView;
}
- (CLGeocoder *)gecoder
{
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc] init];
    }
    return _gecoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view = self.mapView;
}

#pragma mark - MKMapViewDelegate
/**
 *  用户位置发生改变时触发（第一次定位到用户位置也会触发该方法）
 *
 *  @param mapView      地图控件对象
 *  @param userLocation 用户位置
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"MKMapViewDelegate--didUpdateLocations");
    
    //利用地理编码设置大头针的内容
    [self.gecoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];//取得第一个地标
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
    }];
    
    CLLocationCoordinate2D coodinate = userLocation.coordinate;
    //设置地图的中心位置
    [self.mapView setCenterCoordinate:coodinate animated:YES];
    
    //设置地图显示的区域
    CLLocationCoordinate2D center = coodinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion regin = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:regin animated:YES];
}


@end
