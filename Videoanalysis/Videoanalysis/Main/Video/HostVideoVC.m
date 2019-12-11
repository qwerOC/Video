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
#import "HostDBManager.h"
#import "HostDBModel.h"
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
//    self.dataArray=[[NSMutableArray alloc] initWithArray:@[@{@"name":@"腾讯",@"url":@"https://v.qq.com"},
//                                                           @{@"name":@"爱奇艺",@"url":@"https://www.iqiyi.com"}]];
    [self creatRightBtnOfCustomWithImage:@"add"];
         __weak typeof(self) weakSelf = self;
       self.clikEmptyView = ^{
           [weakSelf addData];
       };
    [self getData];
}
-(void)rigthBtnClcik{
    [self addData];
}
-(void)getData{
    self.dataArray=[NSMutableArray array];
    [[HostDBManager managerDB] createDBTable:@DBVideo];
    self.dataArray=[[HostDBManager managerDB] selectDBTable:@DBVideo];
    if (self.dataArray.count==0) {
        [self showNoDataViewToView:_listTable withString:@"暂无书签"];
    }
      __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.listTable reloadData];
    });
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HostVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HostVideoCell" forIndexPath:indexPath];
    HostDBModel *model=self.dataArray[indexPath.row];
    cell.titleLab.text= model.name;
    cell.detailLab.text= model.url;
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
    HostDBModel *model=self.dataArray[indexPath.row];
    detail.url=model.url;
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
-(void)addData{
      __weak typeof(self) weakSelf = self;
    UIAlertController *alc=[UIAlertController alertControllerWithTitle:@"添加解析地址"
                                                               message:nil
                                                        preferredStyle:UIAlertControllerStyleAlert];
    [alc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入书签名称";
    }];
    [alc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           textField.placeholder=@"请输入书签地址";
         textField.text=@"http://";
    }];
    UIAlertAction *cancaleBtn=[UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okBtn=[UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tfFirst=alc.textFields.firstObject;
        UITextField *tfLast=alc.textFields.lastObject;
        if ([HostsTools isBlankString:tfFirst.text]&&[HostsTools isBlankString:tfLast.text]) {
            
        }
        HostDBModel *model=[[HostDBModel alloc] init];
        model.name=tfFirst.text;
        model.url=tfLast.text
        [[HostDBManager managerDB] createDBTable:@DBVideo];
        [[HostDBManager managerDB] insertDBTable:@DBVideo withSearch:model];
         self.dataArray=[[HostDBManager managerDB] selectDBTable:@DBVideo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.listTable reloadData];
            if (weakSelf.dataArray.count>0) {
                      [weakSelf hideNoDataViewFromView:weakSelf.listTable];
                  }
        });
    }];
    [alc addAction:cancaleBtn];
    [alc addAction:okBtn];
    [self presentViewController:alc animated:YES completion:nil];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HostDBModel *model=self.dataArray[indexPath.row];
    [[HostDBManager managerDB] createDBTable:@DBVideo];
    [[HostDBManager managerDB] delDBTable:@DBVideo withSearch:model];
     self.dataArray=[[HostDBManager managerDB] selectDBTable:@DBVideo];
      __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        if (weakSelf.dataArray.count==0) {
             [weakSelf showNoDataViewToView:weakSelf.listTable withString:@"暂无书签"];
         }
    });
}
@end


