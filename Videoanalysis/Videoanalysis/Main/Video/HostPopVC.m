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
@interface HostPopVC ()<UITableViewDelegate,UITableViewDataSource,HWPanModalPresentable>

@property(nonatomic, strong) UITableView *analysisTale;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self jsonAnalysis];
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
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=model.url;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HostDBModel *model=self.dataArray[indexPath.row];
    if (self.getUrl) {
        self.getUrl([NSString stringWithFormat:@"%@%@",model.url,self.htmlUrl],self.htmlUrl);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
