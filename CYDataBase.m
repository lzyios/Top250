//
//  CYDataBase.m
//  Top250
//
//  Created by lcy on 15/9/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYDataBase.h"
#import "FMDatabase.h"

@implementation CYDataBase
{
    FMDatabase *_fmDataBase;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        dataPath = [dataPath stringByAppendingPathComponent:@"movie.db"];
        NSLog(@"%@",dataPath);
        _fmDataBase = [FMDatabase databaseWithPath:dataPath];
        
        [_fmDataBase open];
        
        [_fmDataBase executeUpdate:@"create table if not exists Movie (movieTitle text primary key,movieOriginalTitle text,movieImageUrl text)"];
        
        [_fmDataBase close];
    }
    return self;
}

+(CYDataBase *)sharedDataBase
{
    static CYDataBase *dataBase = nil;
    if(dataBase == nil)
    {
        dataBase = [[CYDataBase alloc] init];
    }
    
    return dataBase;
}

-(void)insertDataWithModel:(CYJSONMovieModel *)model
{
    [_fmDataBase open];
    
    [_fmDataBase executeUpdate:@"insert into Movie (movieTitle,movieOriginalTitle,movieImageUrl) values (?,?,?)",model.abc,model.original_title,model.image];
    
    [_fmDataBase close];
}

-(NSMutableArray *)getAllMovies
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [_fmDataBase open];
    FMResultSet *result = [_fmDataBase executeQuery:@"select * from Movie"];
    while ([result next]) {
        CYJSONMovieModel *model = [[CYJSONMovieModel alloc] init];
        model.abc = [result stringForColumn:@"movieTitle"];
        model.image = [result stringForColumn:@"movieImageUrl"];
        model.original_title = [result stringForColumn:@"movieOriginalTitle"];
        [arr addObject:model];
    }
    [_fmDataBase close];
    
    return arr;
}

@end
