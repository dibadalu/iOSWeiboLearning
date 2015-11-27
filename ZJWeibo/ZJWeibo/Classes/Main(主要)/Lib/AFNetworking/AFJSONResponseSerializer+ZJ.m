//
//  AFJSONResponseSerializer+ZJ.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "AFJSONResponseSerializer+ZJ.h"

@implementation AFJSONResponseSerializer (ZJ)

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",nil];
    
    return self;
}


@end
