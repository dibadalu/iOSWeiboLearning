//
//  ZJProfileStatusTool.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/10.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJProfileStatusTool.h"
#import <FMDB.h>

@implementation ZJProfileStatusTool

static FMDatabase *_db;//全局静态常量
/**
 *  只调用一次
 */
+ (void)initialize
{
    //1.打开(连接)数据库,存在document文件
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"profileStatuses.sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];//创建数据库
    [_db open];
    if (![_db open]) {
        ZJLog(@"数据库打开失败");
    }
    
    //2.创表
    /*
     id      自增长的id属性
     status  从服务器获取的每条微博数据（以字典的形式存储）
     idstr   每条微博数据中对应的idstr
     */
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_status (id integer PRIMARY KEY,status blob NOT NULL,idstr text NOT NULL);"];
}

/**
 *  根据请求参数从沙盒中加载FMDB缓存的微博数据（微博字典数组）
 *
 *  @param params 请求参数
 *
 *  @return 返回之前FMDB缓存好的微博数据（微博字典数组）
 */
+ (NSArray *)statusesWithParams:(NSDictionary *)params
{
    //根据请求参数生成对应的sql查询语句
    NSString *sql = nil;
    if (params[@"since_id"]) {//最新微博
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;",params[@"since_id"]];
    }else if (params[@"max_id"]){//更多微博（旧的）
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;",params[@"max_id"]];
    }else{
        sql = @"SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;";
    }
    
    //执行sql语句,获得FMDB结果集
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *statuses = [NSMutableArray array];
    while (set.next) {//逐一取出每条数据
        //根据数据库的字段名取出二进制数据
        NSData *statusData = [set objectForColumnName:@"status"];
        //NSData -> NSDictionary (unicode -> utf-8)
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        [statuses addObject:status];
    }
    
    return statuses;
}

/**
 *  FMDB缓存从新浪获取的微博字典数组
 *
 *  @param statuses 从新浪获取的微博字典数组
 */
+ (void)saveStatuses:(NSArray *)statuses
{
    for (NSDictionary *status in statuses) {
        //NSDictionary -> NSData(要将一个对象存进数据库的blob字段，要转成NSData)
        NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:status];
        //        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_status(status,idstr) VALUES (%@,%@);",statusData,status[@"idstr"]];
        //执行sql语句
        [_db executeUpdateWithFormat:@"INSERT INTO t_status(status,idstr) VALUES (%@,%@);",statusData,status[@"idstr"]];
    }
}

@end
