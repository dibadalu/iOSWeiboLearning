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
#import <RegexKitLite.h>
#import "ZJUser.h"
#import "ZJTextPart.h"
#import "ZJSpecialText.h"
#import "ZJEmotion.h"
#import "ZJEmotionTool.h"

@implementation ZJStatus

/**
 *  告知系统数组pic_urls存放的是ZJPhoto模型
 */
+ (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [ZJPhoto class]};
    
}

#pragma mark - getter & setter method
/**
 *  created_at的getter方法，更改时间格式
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
 *  source的setter方法，更改来源格式
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

/**
 *  text的setter方法，将微博正文转为属性文字
 *
 *  @param text 微博正文
 */
- (void)setText:(NSString *)text
{
    _text = [text copy];
    //text -> attributedText
    self.attributedText = [self attributedTextWithText:text];
}

/**
 *  setRetweeted_status的setter方法，将转发微博的正文改为属性文字
 *
 *  @param retweeted_status 转发微博模型
 */
- (void)setRetweeted_status:(ZJStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    //拼接转发微博的昵称+正文
    NSString *retweetedContent = [NSString stringWithFormat:@"@%@ : %@",retweeted_status.user.name,retweeted_status.text];
    //text -> attributedText
    self.retweeted_attributedText = [self attributedTextWithText:retweetedContent];
    
}


#pragma mark -  custom method
/**
 *  重点：将普通文字转变为属性文字，利用正则表达式将特殊字符高亮显示
 *
 *  @param text 普通文字
 *
 *  @return 属性文字
 */
- (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    /*---------正则表达式处理-----------------*/
    
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    NSMutableArray *parts = [NSMutableArray array];
    // 遍历所有的特殊字符
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        //        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:*capturedRanges];
        if ((*capturedRanges).length == 0) return ;
        //新建模型ZJTextPart，存储相关信息
        ZJTextPart *part = [[ZJTextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        [parts addObject:part];
        
    }];
    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        //        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:*capturedRanges];
        if ((*capturedRanges).length == 0) return ;
        
        ZJTextPart *part = [[ZJTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
        
    }];
    
    //对之前的两个遍历所得到的模型数组parts进行排序(所得到结果是从小 ——> 大)
    [parts sortUsingComparator:^NSComparisonResult(ZJTextPart *part1, ZJTextPart *part2) {
        //NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        if (part1.range.location > part2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    /*----根据正则表达式处理过的parts数组，做特殊文字的高亮显示，将特殊文字存进模型等操作----*/
    UIFont *font = [UIFont systemFontOfSize:15];//字体
    
    //遍历parts数组，做高亮显示等操作，并按排序拼接每一段字符
    NSMutableArray *specials = [NSMutableArray array];
    for (ZJTextPart *part in parts) {
        NSAttributedString *subStr = nil;
        if (part.isEmotion) {//表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];//附件
            NSString *name = [ZJEmotionTool emotinWithChs:part.text].png;
            if (name) {//能找到对应的图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                //拼接表情
                subStr = [NSAttributedString attributedStringWithAttachment:attch];
            }else{//表情图片不存在
                subStr = [[NSAttributedString alloc] initWithString:part.text];
            }
            
        }else if (part.isSepcail){//非表情的特殊字符
            subStr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                                                                                       NSForegroundColorAttributeName:[UIColor blueColor]
                                                                                       }];
            
            //创建特殊对象，存储相关信息
            ZJSpecialText *s = [[ZJSpecialText alloc] init];
            s.text = part.text;
            NSUInteger loc = attributedText.length;
            NSUInteger len = part.text.length;
            s.range = NSMakeRange(loc, len);
            [specials addObject:s];
            
        }else{//非特殊字符
            subStr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributedText appendAttributedString:subStr];
    };
    
    //    HMLog(@"%@",specials);
    //attributedText通过key"specials"存储特殊文字数组
    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    //必须设置字体，保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    return attributedText;
}




@end
