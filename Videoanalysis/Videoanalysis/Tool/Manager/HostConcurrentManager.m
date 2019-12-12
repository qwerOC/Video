//
//  HostConcurrentManager.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/12.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostConcurrentManager.h"
#import <AFNetworking.h>
@implementation HostConcurrentManager
/// 并发有序上传图片 如果有个别失败会原数据返回后手东点击重试
/// @param imageArry 图片数组
/// @param uploadSuccess 上传成功返回数组
/// @param uploadError 失败
/// @param progress 进度
+(void)uploadSortWithImageArry:(NSArray*)imageArry
                       success:(void(^)(NSArray *urlarry))uploadSuccess
                         error:(void(^)(void))uploadError
                uploadProgress:(void(^)(NSArray *progress))progress{
    if (imageArry.count==0) {
        return;
    }
    // 需要上传的数据
    NSArray* images = (NSArray*)imageArry;
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (UIImage* image in images) {
        [result addObject:[NSNull null]];
    }
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++)
    {
        
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[HostRequestManager shareRequestManager] getRequest:images[i]
                                                      withParams:@{} success:^(id  _Nonnull obj) {
                
                NSMutableString *strHtml=(NSMutableString*)obj;
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i]=strHtml;
                }
                dispatch_group_leave(group);
                
                    
                
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"err");
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i]=images[i];
                }
                dispatch_group_leave(group);
                
            }];
            
        });
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        uploadSuccess(result);
    });
    
}
@end
