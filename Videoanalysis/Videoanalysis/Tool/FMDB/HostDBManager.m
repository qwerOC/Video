//
//  HostDBManager.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/10.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostDBManager.h"

#import <FMDB.h>
static HostDBManager *dbmanager;
@interface HostDBManager()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    FMDatabaseQueue *queue;
}
@end
@implementation HostDBManager
+(instancetype)managerDB{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbmanager=[[super alloc]init];
    });
    return dbmanager;
}
-(id)copyWithZone:(NSZone *)zone
{
    return dbmanager;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return dbmanager;
}
/// 创建数据库
/// @param dbName 数据库名称
-(void)createDBTable:(NSString*)dbName{
    //1.获得数据库文件的路径
    
    NSArray  * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES );
    NSString  * documentDirectory = [path    objectAtIndex :0 ];
    NSString *fileName =[dbName isEqualToString:@"DBVideo"]?[documentDirectory stringByAppendingPathComponent:@"DBVideo.sqlite"]:
    [documentDirectory stringByAppendingPathComponent:@"DBAnalysis.sqlite"];
    queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    [queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        //创建数据表
        BOOL flag;
        if ([dbName isEqualToString:@"DBVideo"]) {
            flag = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS DBVideo (ID integer PRIMARY KEY AUTOINCREMENT, name text, url text)"];
        }else{
            flag = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS DBAnalysis (ID integer PRIMARY KEY AUTOINCREMENT, name text, url text)"];
        }
        if (flag) {
            NSLog(@"创建%@==YES",dbName);
        } else {
            NSLog(@"创建%@==NO",dbName);
        }
    }];
}

/// 查询数据库
/// @param dbName 数据库名称
-(NSMutableArray*)selectDBTable:(NSString*)dbName{
    NSMutableArray*dataArray = [[NSMutableArray alloc]init];
    [queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",dbName];

        FMResultSet *result = [db executeQuery:sqlStr];
        while(result.next) {
            //创建对象赋值
            HostDBModel* model = [[HostDBModel alloc]init];
            model.name= [result stringForColumn:@"name"];
            model.url= [result stringForColumn:@"url"];
            model.ID=[[result stringForColumn:@"ID"] integerValue];
            [dataArray addObject:model];
        }
    }];
    return dataArray;
}

/// 删除单条数据
/// @param dbName 数据库名称
/// @param model  数据模型
-(void)delDBTable:(NSString*)dbName withSearch:(HostDBModel*)model{
    NSString*sqlStr = [NSString stringWithFormat:@"DELETE FROM %@  WHERE ID = '%ld' ",dbName,(long)model.ID];
    [queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        BOOL flag = [db executeUpdate:sqlStr];
        if (flag) {
            NSLog(@"数据删除成功%@",dbName);
        } else {
            NSLog(@"数据删除失败%@",dbName);
        }
        
    }];
}

/// 修改单条数据
/// @param dbName 数据库名称
/// @param model 数据模型
-(void)updateDBTable:(NSString*)dbName withSearch:(HostDBModel*)model{
    NSString*sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET name = '%@' url = '%@'  WHERE id = '%ld'",dbName,model.name,model.url,(long)model.ID];
    [queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        BOOL flag = [db executeUpdate:sqlStr];
        if (flag) {
            NSLog(@"数据更新成功%@",dbName);
        } else {
            NSLog(@"数据更新失败%@",dbName);
        }
        
    }];
}

/// 插入单条数据
/// @param dbName 数据库名称
/// @param model 数据模型
-(void)insertDBTable:(NSString*)dbName withSearch:(HostDBModel*)model{
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO  %@ ('name','url') VALUES ('%@', '%@')",dbName,model.name,model.url];
    [queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        BOOL flag = [db executeUpdate:sqlStr];
        if (flag) {
            NSLog(@"数据添加成功%@",dbName);
        } else {
            NSLog(@"数据添加失败%@",dbName);
        }
        
    }];
    
}
@end
