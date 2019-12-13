//
//  HostPopVC.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/6.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostPopVC.h"
#import "PlayViewController.h"
#import "HostDBManager.h"
#import "HostDBModel.h"
#import "HostanalysisVC.h"
#import "HostplayViewController.h"
@interface HostPopVC ()<UITableViewDelegate,UITableViewDataSource,HWPanModalPresentable>

@property(nonatomic, strong) UITableView *analysisTale;
@property(nonatomic, strong) NSMutableArray  *playArry;
@property(nonatomic, strong) NSMutableArray  *playUrlArry;
@end

@implementation HostPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
    [self jsonAnalysis];
    __weak typeof(self) weakSelf = self;
    self.clikEmptyView = ^{
        HostanalysisVC *analysisVC=[[HostanalysisVC alloc] init];
        [weakSelf.navigationController pushViewController:analysisVC animated:YES];
    };
}
-(void)jsonAnalysis{
    //    // 获取文件路径
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"analysis" ofType:@"json"];
    //    // 将文件数据化
    //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    //    // 对数据进行JSON格式化并返回字典形式
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //    self.dataArray=[[NSMutableArray  alloc] initWithArray:dic[@"data"]];
    self.dataArray=[NSMutableArray array];
    [[HostDBManager managerDB] createDBTable:@DBAnalysis];
    self.dataArray=[[HostDBManager managerDB] selectDBTable:@DBAnalysis];
    if (self.dataArray.count==0) {
        [self showNoDataViewToView:_analysisTale withString:@"暂无解析地址"];
    }else{
        [self hideNoDataViewFromView:_analysisTale];
    }
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.analysisTale reloadData];
    });
    
}

-(void)getVideoPlayer{
    
    self.playArry=[NSMutableArray array];
    for (int i=0; i<self.dataArray.count; i++) {
        HostDBModel *model=self.dataArray[i];
        [self.playArry addObject:[NSString stringWithFormat:@"%@%@",model.url,self.htmlUrl]];
    }
    __weak typeof(self) weakSelf = self;
    self.navigationItem.title=@"视频地址解析中...";
    [HostConcurrentManager uploadSortWithImageArry:self.playArry success:^(NSArray * _Nonnull urlarry) {
        weakSelf.playUrlArry=[NSMutableArray array];
         self.navigationItem.title=@"解析完成";
        for (int i=0; i<urlarry.count; i++) {
            if ([urlarry[i] containsString:@"http"]&&[urlarry[i] containsString:@"m3u8"]) {
                NSArray *arry = [urlarry[i] componentsSeparatedByString:@"="];
                
                for (int n=0; n<arry.count; n++) {
                    if ([arry[n] containsString:@"http"]&&[arry[n] containsString:@"m3u8"]) {
                        NSArray *plarArry= [arry[n] componentsSeparatedByString:@".m3u8"];
                        if (plarArry.count>0) {
                            [weakSelf.playUrlArry addObject:[NSString stringWithFormat:@"%@.m3u8",[plarArry firstObject]]];
                            
                        }else{
                            [weakSelf.playUrlArry addObject:[NSString stringWithFormat:@"12121"]];
                        }
                    }
                }
            }else{
                [weakSelf.playUrlArry addObject:[NSString stringWithFormat:@"12121"]];
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.navigationItem.title=@"解析完成";
            [weakSelf.analysisTale reloadData];
        });
    } error:^{
        
    } uploadProgress:^(NSArray * _Nonnull progress) {
        
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self jsonAnalysis];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getVideoPlayer];
}
-(void)loadUI{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title=@"视频解析地址";
    _analysisTale = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  MuScreen_Width,
                                                                  MuScreen_Height-SafeAreaBottomHeight-SafeAreaTopHeight-NGTabBarHeight+StatusBarHeight)
                                                 style:UITableViewStyleGrouped];
    _analysisTale.dataSource=self;
    _analysisTale.delegate=self;
    [self.view addSubview:_analysisTale];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellInderfiner=@"cellInderfiner";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellInderfiner];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellInderfiner];
    }
    HostDBModel *model=self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[NSString stringWithFormat:@"%@ 解析中",model.name];
    cell.detailTextLabel.text=model.url;
    
    if (self.playUrlArry.count>0&&[self.playUrlArry[indexPath.row] containsString:@"m3u8"]) {
        cell.textLabel.text=[NSString stringWithFormat:@"%@播放时长:%@",model.name,[HostsTools getVideoTimeByUrlString:self.playUrlArry[indexPath.row]]];
    }else if (self.playUrlArry.count>0&&![self.playUrlArry[indexPath.row] containsString:@"m3u8"]){
        cell.textLabel.text=[NSString stringWithFormat:@"%@解析失败",model.name];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    HostDBModel *model=self.dataArray[indexPath.row];
  
    //
    if (self.playUrlArry.count>0&&[self.playUrlArry[indexPath.row] containsString:@"m3u8"]) {
        if (self.getUrl) {
            self.getUrl(self.playUrlArry[indexPath.row],@"");
          }
        [self dismissViewControllerAnimated:YES completion:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            HostplayViewController *play=[[HostplayViewController alloc] init];
//            play.url=self.playUrlArry[indexPath.row];
//            [self presentViewController:play animated:YES completion:nil];
//        });
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 100);
}

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 200);
}

- (UIScrollView *)panScrollable {
    return self.analysisTale;
}

- (BOOL)anchorModalToLongForm {
    return YES;
}

@end
