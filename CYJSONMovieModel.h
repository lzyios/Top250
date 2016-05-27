//
//  CYJSONMovieModel.h
//  Top250
//
//  Created by lcy on 15/9/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface CYJSONMovieModel : JSONModel

//Optional 允许该属性值为空
@property (nonatomic,strong) NSString <Optional> *abc;
@property (nonatomic,strong) NSString *original_title;

//如果不在一个层级中  实现一个 keyMapper
@property (nonatomic,strong) NSString *image; //images small

@end
