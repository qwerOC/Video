//
//  HostConcurrentManager.h
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/12.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HostConcurrentManager : NSObject
/// 并发有序上传图片 如果有个别失败会原数据返回后手东点击重试
/// @param imageArry 图片数组
/// @param uploadSuccess 上传成功返回数组
/// @param uploadError 失败
/// @param progress 进度
+(void)uploadSortWithImageArry:(NSArray*)imageArry
                       success:(void(^)(NSArray *urlarry))uploadSuccess
                         error:(void(^)(void))uploadError
                uploadProgress:(void(^)(NSArray *progress))progress;
@end

NS_ASSUME_NONNULL_END
