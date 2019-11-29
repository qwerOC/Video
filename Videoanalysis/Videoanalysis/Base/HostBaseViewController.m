//
//  HostBaseViewController.m
//  ShopshopHosts
//
//  Created by 苏秋东 on 2018/12/12.
//  Copyright © 2018 苏秋东. All rights reserved.
//

#import "HostBaseViewController.h"
#import "NGApplyAnchorPaperViewController.h"
#import "AppDelegate.h"
#import "HostStoreVC.h"
#import "HostActionSettingVC.h"
@interface HostBaseViewController ()<UIAlertViewDelegate>

@end

@implementation HostBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popGestureEnable = YES;
    self.view.backgroundColor = MainBackGroundColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.page_num = 1;
    self.page_size = 20;
}

- (void)setPopGestureEnable:(BOOL)popGestureEnable{
    if (!popGestureEnable) {
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [self.view addGestureRecognizer:pan];
    }
}

- (void)gotoHomeVC{
    self.popGestureEnable = YES;
    self.navigationController.navigationBarHidden=NO;
    
    HostMuTabbarController * tabbar = [[HostMuTabbarController alloc]init];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tabbarVC = tabbar;
    
    [UIApplication sharedApplication].delegate.window.rootViewController =tabbar;
}

//推送需要的--传递推送参数
- (void)pushNoticficationParameters:(NSDictionary*)parameters{
    
}
- (BOOL)checkUserAuth{
    //        0.未认证 1已认证 2认证失败 3 认证中
//    if ([[HostUserModel getUserModel].is_china isEqualToString:@"1"]) {
    if (![[HostUserModel getUserModel].issetAttestation isEqualToString:@"1"]) {
        if ([[HostUserModel getUserModel].issetAttestation isEqualToString:@"0"]) {
                [self showVer:@"您还未认证，请前往我的页面完善认证信息"];
        }else if ([[HostUserModel getUserModel].issetAttestation isEqualToString:@"2"]){
                [self showVer:@"您未认证成功，请前往我的页面重新提交认证信息"];
        }else if ([[HostUserModel getUserModel].issetAttestation isEqualToString:@"3"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [HostMuHUDManager showBriefAlert:@"您的认证信息正在审核中，请审核通过后再试"];
            });
            }
            return  NO;
        }else{
            return YES;
        }
//    }else{
//        return YES;
//    }
//
}

- (void)showVer:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          NGApplyAnchorPaperViewController * verVC = [[NGApplyAnchorPaperViewController alloc]init];
          [self.navigationController pushViewController:verVC animated:YES];
      }];
    [alert addAction:action];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NGApplyAnchorPaperViewController * verVC = [[NGApplyAnchorPaperViewController alloc]init];
        [self.navigationController pushViewController:verVC animated:YES];
    }
}
- (void)loadConfigPlist:(NSString *)path{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"plist"];
    NSArray * array = [NSArray arrayWithContentsOfFile:filePath];
    self.configArray = [NSMutableArray array];
    for (NSInteger index = 0; index < array.count; index++) {
        if ([array[index] isKindOfClass:[NSArray class]]) {
            NSMutableArray * subArray = [NSMutableArray array];
            NSArray * arritem = array[index];
            for (NSInteger num = 0; num < arritem.count; num++) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:arritem[num]];
                [subArray addObject:dict];
            }
            [self.configArray addObject:subArray];
        }else{
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:array[index]];
            [self.configArray addObject:dict];
        }
    }
    
}


/**
 获取提交参数字典
 */
- (NSMutableDictionary *)getParameterDicWithCellArray:(NSMutableArray *)cellArray{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (cellArray && [cellArray isKindOfClass:[NSArray class]]) {
        for (id data in cellArray) {
            if ([data isKindOfClass:[HostSubmitModel class]]) {
                HostSubmitModel * model = (HostSubmitModel *)data;
                [dic setValuesForKeysWithDictionary:[self getSubmitModelToDic:model]];
            }else if ([data isKindOfClass:[NSArray class]]){
                NSMutableArray * array = (NSMutableArray *)data;
                [dic setValuesForKeysWithDictionary:[self getParameterDicWithCellArray:array]];
            }
        }
    }
    return dic;
}
- (NSMutableArray *)getParameterArrayWithCellArray:(NSMutableArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    if (dataArray && [dataArray isKindOfClass:[NSArray class]]) {
        for (HostSubmitModel *model in dataArray) {
            [array addObject:[self getSubmitModelToDic:model]];
        }
    }
    return array;
}

- (NSMutableDictionary *)getSubmitModelToDic:(HostSubmitModel *)model{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (!model.hidden) {
        if (model.paramType == ParameterString) {
            if ((![HostCommonTools isBlankString:model.paramString]) && (![HostCommonTools isBlankString:model.paramKey])) {
                [dic setObject:model.paramString forKey:model.paramKey];
            }else{
                if(model.required==YES){
                    [dic setValue:model.paramString forKey:model.paramKey];
                }
            }
        }else if (model.paramType == ParameterDic){
            if (model.paramDic && [model.paramDic isKindOfClass:[NSDictionary class]] && (![HostCommonTools isBlankString:model.paramKey])) {
                [dic setObject:model.paramDic forKey:model.paramKey];
            }
        }else if (model.paramType == ParameterArray){
            if (model.paramDic && [model.paramDic isKindOfClass:[NSDictionary class]] && (![HostCommonTools isBlankString:model.paramKey])) {
                [dic setObject:model.paramArray forKey:model.paramKey];
            }
        }else if (model.paramType == ParameterArraySingle){
            [dic setValuesForKeysWithDictionary:[self getParameterDicWithCellArray:model.paramArray]];
        }else if (model.paramType == ParameterArrayMergeDic){
            [dic setObject:[self getParameterDicWithCellArray:model.paramArray] forKey:model.paramKey];
        }else if (model.paramType == ParameterArrayMergeArray){
            [dic setObject:[self getParameterArrayWithCellArray:model.paramArray] forKey:model.paramKey];
        }
    }
    return dic;
}

/**
 判断表单是否完成
 */
- (BOOL)judgeSubmitDoneStatus:(NSMutableArray *)dataArray{
    BOOL isDone = YES;
    for (id data in dataArray) {
        if ([data isKindOfClass:[HostSubmitModel class]]) {
            HostSubmitModel * model = (HostSubmitModel *)data;
            if (model.required) {
                if (!model.isDone) {
                    isDone = NO;
                    return isDone;
                }
            }
        }else if ([data isKindOfClass:[NSArray class]]){
            NSMutableArray * array = (NSMutableArray *)data;
            isDone = [self judgeSubmitDoneStatus:array];
            if (!isDone) {
                return isDone;
            }
        }
    }
    return isDone;
}

/**
 判断表单还剩下几步
 */
- (NSInteger)judgeLastSubmitDoneSteps:(NSMutableArray *)dataArray Step:(NSInteger)step{
    NSInteger steps = step;
    for (id data in dataArray) {
        if ([data isKindOfClass:[HostSubmitModel class]]) {
            HostSubmitModel * model = (HostSubmitModel *)data;
            if (model.required) {
                if (!model.isDone) {
                    steps++;
                }
            }
        }else if ([data isKindOfClass:[NSArray class]]){
            NSMutableArray * array = (NSMutableArray *)data;
            steps = [self judgeLastSubmitDoneSteps:array Step:steps];
        }
    }
    return steps;
}
/**
 在指定view显示搜索遮罩
 */
- (void)showSearchShadeViewToView:(UIView *)view{
  
    UIView *viewold=[view viewWithTag:898989];
    if (viewold) {
        [viewold removeFromSuperview];
    }
      UIView *createview=[[UIView alloc]initWithFrame:CGRectMake(0,view.origin.y+SafeAreaTopHeight, view.frame.size.width, view.frame.size.height)];
    if ([self.navigationController.topViewController isKindOfClass:[HostStoreVC class]]) {
        createview=[[UIView alloc]initWithFrame:CGRectMake(0,100+SafeAreaTopHeight, view.frame.size.width, view.frame.size.height)];
    }
    createview.tag=898989;
    createview.backgroundColor = [UIColor blackColor];
    createview.alpha = 0.2;
    createview.userInteractionEnabled = YES;
    [self.navigationController.topViewController.navigationController.view addSubview:createview];
}
/**
 从指定view删除搜索遮罩
 */
- (void)hideSearchShadeViewToView:(UIView *)view{
    [self.view endEditing:YES];
    UIView *viewold=[self.navigationController.topViewController.navigationController.view viewWithTag:898989];
    if (viewold) {
        [viewold removeFromSuperview];
    }
}

-(void)showNoDataViewToView:(UIView *)superview withString:(NSString*)string {
    UIView *viewold=[superview viewWithTag:1234987];
    if (viewold) {
        [viewold removeFromSuperview];
    }
    UIView *createview=[[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(superview.frame), CGRectGetHeight(superview.frame))];
    createview.autoresizingMask = UIViewAutoresizingNone;
    createview.tag=1234987;
    createview.backgroundColor = [UIColor clearColor];
    createview.userInteractionEnabled = YES;
    [superview addSubview:createview];
    [createview endEditing:YES];
    [superview bringSubviewToFront:createview];
    
    UIImage* uiimg=[UIImage imageNamed:@"not found"];
    UIImageView* imgV=[[UIImageView alloc]initWithImage:uiimg];
    imgV.frame=CGRectMake((CGRectGetWidth(superview.frame)-uiimg.size.width)/2.0, 0, uiimg.size.width, uiimg.size.height);
    imgV.autoresizingMask = UIViewAutoresizingNone;
    
    imgV.userInteractionEnabled = YES;
    
    [createview addSubview:imgV];
    imgV.centerY = createview.height*3/8.0;
    
    
    CGFloat height = [string heightForFont:[UIFont systemFontOfSize:16] width:(CGRectGetWidth(superview.frame) - 40)];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(imgV.frame)+10,CGRectGetWidth(superview.frame) - 40, height + 20)];
    label.autoresizingMask = UIViewAutoresizingNone;
    label.text= string;
    label.textColor = [UIColor colorWithHexString:@"9B9B9B"];
    label.font=[UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [createview addSubview:label];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRefresh)];
    [createview addGestureRecognizer:tap];
    
}

- (void)tapRefresh{
    if (self.clikEmptyView) {
        self.clikEmptyView();
    }
}

-(void)hideNoDataViewFromView:(UIView *)superview {
    UIView *view=[superview viewWithTag:1234987];
    if (view) {
        [view removeFromSuperview];
    }
}

- (void)addRightStatus:(NSInteger)step{
    UIView * backV = [[UIView alloc]init];
    backV.frame = CGRectMake(0, 0, 90, 4);
    backV.backgroundColor = [UIColor colorWithHexString:@"EDEDED"];
    backV.layer.cornerRadius = backV.height * 0.5;
    backV.layer.masksToBounds = YES;
    UIView * subView = [[UIView alloc]init];
    subView.frame = CGRectMake(0, 0, 30 * step, backV.height);
    subView.backgroundColor = MainAppColor;
    subView.layer.cornerRadius = subView.height * 0.5;
    [backV addSubview:subView];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:backV];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)creatRightBtnOfUploadList{
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"上传列表" style:UIBarButtonItemStylePlain target:self action:@selector(uploadList)];
}

- (void)uploadList{
    
}

- (void)creatRightBtnOfFinish{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishClick)];
}
- (void)finishClick{
    
}

- (void)creatRightBtnOfNext{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick)];
}

- (void)nextClick{
    
}

- (void)creatLeftBtnOfReturn{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:MuGetImage(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
}
- (void)creatLeftBtnOfLoginReturn{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"login_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
}
- (void)returnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatLeftBtnOfCustomWithTitle:(NSString *)title{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClcik)];
}
- (void)leftBtnClcik{
    
}

- (void)creatRightBtnOfCustomWithTitle:(NSString *)title{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:MainAppColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(rightBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}


- (void)creatRightBtnOfCustomWithTitle:(NSString *)title textColor:(UIColor *)textColor{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(rightBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

}

- (void)rightBtnClcik{
    
}


- (void)creatLeftBtnOfCustomWithImage:(NSString *)imageName{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClcik)];
}

- (void)creatRightBtnOfCustomWithImage:(NSString *)imageName{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClcik)];
}
//设置导航栏左边按钮
- (UIBarButtonItem *)leftMenuBarButtonItem {
    return [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back" renderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backPopViewcontroller:)];
}

- (void)backPopViewcontroller:(id) sender
{
    NSLog(@"super backPopViewcontroller");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be needed later.
            // 加一些代码保存可能会需要用到的数据。
            // Add code to clean up other strong references to the view in the view hierarchy.
            //清理view里所有的强引用对象。
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}

- (NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)cellArray{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}
/**
 用于照片相册的选择裁剪和视频的选择
 
 @param preview 是否展示预览图
 @param type video/image
 @param imageType 图片比例 1是1：1  2是16：9  4是不剪裁
 */
//-(void)chooseImageWithPreview:(BOOL)preview
//                         type:(NSString*)type
//                    imageType:(NSString*)imageType
//                   imageCount:(NSInteger)count
//  Success:(void (^)(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal))success{
//    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
//    ZLPhotoConfiguration *config=[ZLPhotoConfiguration defaultPhotoConfiguration];
//    BOOL allowEditImage = YES;
//    if ([type isEqualToString:@"image"]) {
//
//        if ([imageType isEqualToString:@"2"]) {
//            config.clipRatios = @[
//                                  GetClipRatio(16, 9)
//                                  ];
//        }else if ([imageType isEqualToString:@"1"]){
//            config.clipRatios = @[
//                                  GetClipRatio(1, 1),
//                                  ];
//        }else if ([imageType isEqualToString:@"4"]||[imageType isEqualToString:@"5"]){
//            //    编辑图片
//            allowEditImage = NO;
//
//        }else if ([imageType isEqualToString:@"7"]){
//            config.clipRatios = @[
//                                  GetClipRatio(4, 5),
//                                  ];
//            actionSheet.configuration.hideClipRatiosToolBar=YES;
//        }else if ([imageType isEqualToString:@"8"]){
//            config.clipRatios = @[
//                                          GetClipRatio(7, 5),
//                                          ];
//        }
//
//    }
//    actionSheet.configuration.sortAscending=NO;
//    actionSheet.configuration=config;
//    //设置允许选择的视频最大时长
//    actionSheet.previousStatusBarIsHidden = NO;
//    actionSheet.configuration.allowSelectImage =[type isEqualToString:@"video"]?NO:YES;
//    actionSheet.configuration.allowSelectGif =[type isEqualToString:@"video"]?NO:YES;
//    actionSheet.configuration.allowSelectVideo =[type isEqualToString:@"video"]?YES:NO;
//    actionSheet.configuration.allowSelectLivePhoto = [type isEqualToString:@"video"]?NO:YES;
//    //设置相册内部显示拍照按钮
//    actionSheet.configuration.allowTakePhotoInLibrary = [type isEqualToString:@"video"]?NO:YES;
//    actionSheet.configuration.allowTakePhotoInLibrary = [imageType isEqualToString:@"4"]?NO:YES;
//    actionSheet.configuration.maxVideoDuration = 60;
//    actionSheet.configuration.maxEditVideoTime=1;
//    //设置照片最大选择数
//    actionSheet.configuration.maxSelectCount = count==0?1:count;
//    //    编辑视频
//    actionSheet.configuration.allowEditVideo = [type isEqualToString:@"video"]?YES:NO;;
//    actionSheet.configuration.editAfterSelectThumbnailImage = [type isEqualToString:@"video"]?NO:YES;
////    编辑图片后直接保存新图片
//    actionSheet.configuration.saveNewImageAfterEdit = [type isEqualToString:@"video"]?NO:NO;
//    //    3dTouch
//    actionSheet.configuration.allowForceTouch = NO;
//    //    编辑图片
//    actionSheet.configuration.allowEditImage = [type isEqualToString:@"video"]?YES:allowEditImage;
//
//
//    //是否允许框架解析图片 图片多的时候为NO
//    actionSheet.configuration.shouldAnialysisAsset = YES;
//    actionSheet.configuration.timeout = 10;
//    actionSheet.configuration.useSystemCamera=YES;
//    //框架语言 0 系统 1 中文简 2中文繁 3 英文 4 日文
//    actionSheet.configuration.languageType = 0;
//    actionSheet.configuration.exportVideoType=ZLExportVideoTypeMp4;
//    actionSheet.sender = self;
//    __weak typeof(self) weakSelf = self;
//    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
//        [weakSelf showNavBar];
//        if (success) {
//            success(images,assets,isOriginal);
//        }
//    }];
//    actionSheet.cancleBlock = ^{
//        NSLog(@"取消选择图片");
//    };
//
//    if (preview) {
//        [actionSheet showPreviewAnimated:YES];
//    } else {
//        [actionSheet showPhotoLibrary];
//    }
//}

- (void)showNavBar{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}


/**
 预览网络图片
 */
//- (void)showPrviewPhotos:(NSArray *)photoArray index:(NSInteger)index hideToolBar:(BOOL)hideToolBar complete:(void (^)(NSArray * _Nonnull photos))success{
//
//    NSMutableArray * array = [NSMutableArray array];
//
//    for (NSString * str in photoArray) {
//        [array addObject:@{ZLPreviewPhotoObj: str, ZLPreviewPhotoTyp: @(ZLPreviewPhotoTypeURLImage)}];
//    }
//
//    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
//#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
//    //以下参数为自定义参数，均可不设置，有默认值
//#pragma mark - required
//    //如果调用的方法没有传sender，则该属性必须提前赋值
//    actionSheet.sender = self;
//    //预览网络图片
//    [actionSheet previewPhotos:array index:index hideToolBar:hideToolBar complete:^(NSArray * _Nonnull photos) {
//        if (success) {
//            success(photos);
//        }
//    }];
//}

-(void)dealloc{
    
}
@end
