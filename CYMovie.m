//
//  CYMovie.m
//  Top250
//
//  Created by lcy on 15/9/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYMovie.h"

@implementation CYMovie

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.image = dic[@"images"][@"small"];
    }
    return self;
}

@end
