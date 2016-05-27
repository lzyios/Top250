//
//  CYJSONMovieModel.m
//  Top250
//
//  Created by lcy on 15/9/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYJSONMovieModel.h"

/*
    person 
    dog
 */

@implementation CYJSONMovieModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"images.small":@"image",@"title":@"abc"}];
}

@end
