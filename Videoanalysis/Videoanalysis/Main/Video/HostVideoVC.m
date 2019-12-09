//
//  HostVideoVC.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/11/25.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostVideoVC.h"
#import "HostVideoCell.h"
#import "NGConsultingDetailViewController.h"
#import "HostPopVC.h"
#import "HostMineVC.h"
@interface HostVideoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)  UITableView *listTable;
@end

@implementation HostVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"首页";
    
    _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MuScreen_Width, MuScreen_Height-SafeAreaTopHeight-SafeAreaBottomHeight-NGTabBarHeight)
                                              style:UITableViewStyleGrouped];
    _listTable.delegate=self;
    _listTable.dataSource=self;
    _listTable.estimatedRowHeight=100;
    _listTable.estimatedSectionFooterHeight=10;
    _listTable.estimatedSectionHeaderHeight=0;
    _listTable.backgroundColor=[UIColor whiteColor];
    UIImageView *imgV=[[UIImageView alloc] init];
    imgV.backgroundColor=[UIColor whiteColor];
    _listTable.backgroundView=imgV;
    _listTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_listTable registerNib:[UINib nibWithNibName:@"HostVideoCell" bundle:nil] forCellReuseIdentifier:@"HostVideoCell"];
    [self.view addSubview:_listTable];
    self.dataArray=[[NSMutableArray alloc] initWithArray:@[@{@"name":@"腾讯",@"url":@"https://v.qq.com"},
                                                           @{@"name":@"爱奇艺",@"url":@"https://www.iqiyi.com"}]];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HostVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HostVideoCell" forIndexPath:indexPath];
    cell.titleLab.text= self.dataArray[indexPath.section][@"name"];
    cell.detailLab.text= self.dataArray[indexPath.section][@"url"];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NGConsultingDetailViewController *detail=[[NGConsultingDetailViewController alloc] init];
    detail.url=self.dataArray[indexPath.section][@"url"];
    [self.navigationController pushViewController:detail animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
@end


