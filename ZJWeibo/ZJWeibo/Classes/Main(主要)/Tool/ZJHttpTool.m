//
//  ZJHttpTool.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
// 

#import "ZJHttpTool.h"
#import "AFJSONResponseSerializer+ZJ.h"

@implementation ZJHttpTool
#pragma mark - get请求
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    //1.创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
#warning 由于新浪返回的数据content-Type是text/plain，所以在[AFJSONResponseSerializer serializer]加上text/plain类型，重写init方法
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //2.发送请求
    [mgr GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
#pragma mark - post请求
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    //1.创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //2.发送请求
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


@end
