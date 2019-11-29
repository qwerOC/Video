//
//  HostBaseViewController.h
//  ShopshopHosts
//
//  Created by 苏秋东 on 2018/12/12.
//  Copyright © 2018 苏秋东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HostBaseViewController : UIViewController

/**
 * 是否支持右滑返回，默认YES
 */
@property (nonatomic, assign) BOOL popGestureEnable;
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;
//存储plist配置
@property (nonatomic,strong) NSMutableArray *configArray;

//分⻚页数量量
@property (nonatomic,assign) NSInteger page_num;
//分⻚页⼤大⼩小
@property (nonatomic,assign) NSInteger page_size;
//公共数组
@property (nonatomic,strong) NSMutableArray *dataArray;
//公共字典
@property (nonatomic,strong) NSMutableDictionary *dataDict;
//提交表单cell数组
@property (nonatomic,strong) NSMutableArray *cellArray;


//推送需要的--传递推送参数
- (void)pushNoticficationParameters:(NSDictionary*)parameters;

//获取plist配置
- (void)loadConfigPlist:(NSString *)path;

/**
 获取提交参数字典
 */
- (NSMutableDictionary *)getParameterDicWithCellArray:(NSMutableArray *)cellArray;

/**
 判断表单是否完成
 */
- (BOOL)judgeSubmitDoneStatus:(NSMutableArray *)dataArray;

/**
 判断表单还剩下几步
 */
- (NSInteger)judgeLastSubmitDoneSteps:(NSMutableArray *)dataArray Step:(NSInteger)step;

//左侧返回按钮
- (UIBarButtonItem*)leftMenuBarButtonItem;

/**
 在指定view显示搜索遮罩
 */
- (void)showSearchShadeViewToView:(UIView *)view;
/**
 从指定view删除搜索遮罩
 */
- (void)hideSearchShadeViewToView:(UIView *)view;


/**
 *  在指定view显示搜索没有数据的视图
 */
- (void)showNoDataViewToView:(UIView*)superview withString:(NSString*)string;

/**
 *  从指定view删除搜索没有数据的视图
 */
- (void)hideNoDataViewFromView:(UIView*)superview;

- (void)backPopViewcontroller:(id)sender;

- (void)addRightStatus:(NSInteger)step;

- (void)creatRightBtnOfUploadList;

- (void)creatRightBtnOfFinish;

- (void)creatRightBtnOfNext;

- (void)creatLeftBtnOfReturn;

- (void)creatLeftBtnOfLoginReturn;

- (void)creatLeftBtnOfCustomWithTitle:(NSString *)title;

- (void)creatRightBtnOfCustomWithTitle:(NSString *)title;

- (void)creatRightBtnOfCustomWithTitle:(NSString *)title textColor:(UIColor *)textColor;

- (void)creatLeftBtnOfCustomWithImage:(NSString *)imageName;

- (void)creatRightBtnOfCustomWithImage:(NSString *)imageName;

/**
 用于照片相册的选择裁剪和视频的选择

 @param preview 是否展示预览图
 @param type video/image
 @param imageType 图片比例 1是1：1  2是16：9 
 */
//-(void)chooseImageWithPreview:(BOOL)preview
//                         type:(NSString*)type
//                    imageType:(NSString*)imageType
//                    imageCount:(NSInteger)count
//                      Success:(void (^)(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal))success;


/**
 预览网络图片
 */
- (void)showPrviewPhotos:(NSArray *)photoArray index:(NSInteger)index hideToolBar:(BOOL)hideToolBar complete:(void (^)(NSArray * _Nonnull photos))success;

//返回首页
- (void)gotoHomeVC;

/**
 添加检测用户是否已经认证通过
                                                            
 @return yes：通过   no：不通过
 */
- (BOOL)checkUserAuth;

/// 点击空白视图
@property(nonatomic, copy) void (^clikEmptyView)(void);
@end

NS_ASSUME_NONNULL_END
