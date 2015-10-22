//
//  ZJStatus.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/21.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  

#import "ZJStatus.h"
#import "ZJPhoto.h"
#import <MJExtension.h>

@implementation ZJStatus

/**
 *  告知系统数组pic_urls存放的是ZJPhoto模型
 */
+ (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [ZJPhoto class]};
    
}

/**
 *  重写created_at的get方法，更改时间格式
 *  注意：时间会不断改变，所以要用get方法多次获取时间
 */
- (NSString *)created_at
{

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //如果是真机调试，转换欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //设置日期格式（声明字符串里面每个数字和单词的含义）  @"Tue Sep 30 17:06:25 +0800 2014";
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    //微博的创建时间
    NSDate *createDate = [fmt dateFromString:_created_at];
    //当前时间
    NSDate *now = [NSDate date];
    
    //日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit =NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算2个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    //判断时间
    if ([createDate isThisYear]) {//今年
        if ([createDate isYesterday]) {//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }else if ([createDate isToday]){
            if (cmps.hour > 1) {//大于1小时
                return [NSString stringWithFormat:@"%d小时前",(int)cmps.hour];
            }else if (cmps.minute > 1){//大于1分钟
                return [NSString stringWithFormat:@"%d分钟前",(int)cmps.minute];
            }else{//1分钟内
                return @"刚刚";
            }
            
        }else{//今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{//非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }

    
}

/**
 *  重写source的set方法，更改来源格式
 */
- (void)setSource:(NSString *)source
{
    
    // 范例 <a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
    //截取字符串

    if (source.length != 0) {
        NSRange range = NSMakeRange(0, 0);
        range.location = [source rangeOfString:@">"].location + 1;
        //    range.length = [source rangeOfString:@"</"].location - range.location;
        range.length = [source rangeOfString:@"<" options:NSBackwardsSearch].location - range.location;
        
        _source = [NSString stringWithFormat:@"来自%@",[source substringWithRange:range]];
    }else{
        _source = @"来自ZJWeibo";
    }
    
}

@end
