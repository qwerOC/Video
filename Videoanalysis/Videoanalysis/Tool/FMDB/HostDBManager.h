//
//  HostDBManager.h
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/10.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostDBModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HostDBManager : NSObject

+(instancetype)managerDB;

/// 创建数据库
/// @param dbName 数据库名称
-(void)createDBTable:(NSString*)dbName;

/// 查询数据库
/// @param dbName 数据库名称
-(NSMutableArray*)selectDBTable:(NSString*)dbName;

/// 删除单条数据
/// @param dbName 数据库名称
/// @param model  数据模型
-(void)delDBTable:(NSString*)dbName withSearch:(HostDBModel*)model;

/// 修改单条数据
/// @param dbName 数据库名称
/// @param model 数据模型
-(void)updateDBTable:(NSString*)dbName withSearch:(HostDBModel*)model;

/// 插入单条数据
/// @param dbName 数据库名称
/// @param model 数据模型
-(void)insertDBTable:(NSString*)dbName withSearch:(HostDBModel*)model;
@end

NS_ASSUME_NONNULL_END
