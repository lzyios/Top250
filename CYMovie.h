//
//  CYMovie.h
//  Top250
//
//  Created by lcy on 15/9/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYMovie : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *or_title;

-(id)initWithDic:(NSDictionary *)dic;

@end
