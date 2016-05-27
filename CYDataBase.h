//
//  CYDataBase.h
//  Top250
//
//  Created by lcy on 15/9/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYJSONMovieModel.h"
@interface CYDataBase : NSObject

+(CYDataBase *)sharedDataBase;

-(void)insertDataWithModel:(CYJSONMovieModel *)model;

-(NSMutableArray *)getAllMovies;

@end
