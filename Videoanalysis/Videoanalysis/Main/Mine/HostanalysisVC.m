//
//  HostanalysisVC.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/12/9.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostanalysisVC.h"
#import "HostDBModel.h"
#import "HostDBManager.h"
@interface HostanalysisVC ()
<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *mintable;
@end

@implementation HostanalysisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"解析地址管理";
    _mintable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MuScreen_Width, MuScreen_Height-SafeAreaTopHeight-SafeAreaBottomHeight-NGTabBarHeight)
                                             style:UITableViewStyleGrouped];
    _mintable.delegate=self;
    _mintable.dataSource=self;
    _mintable.estimatedRowHeight=100;
    _mintable.estimatedSectionFooterHeight=10;
    _mintable.estimatedSectionHeaderHeight=0;
    _mintable.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_mintable];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mintable reloadData];
    });
    [self getData];
    [self creatRightBtnOfCustomWithImage:@"add"];
      __weak typeof(self) weakSelf = self;
    self.clikEmptyView = ^{
        [weakSelf addData];
    };
}
-(void)rigthBtnClcik{
        [self addData];
}
-(void)getData{
    self.dataArray=[NSMutableArray array];
    [[HostDBManager managerDB] createDBTable:@DBAnalysis];
    self.dataArray=[[HostDBManager managerDB] selectDBTable:@DBAnalysis];
    if (self.dataArray.count==0) {
        [self showNoDataViewToView:_mintable withString:@"暂无解析地址"];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellInderfiner=@"MinecellInderfiner";
      UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellInderfiner];
      if (!cell) {
          cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellInderfiner];
      }
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
      HostDBModel *model=self.dataArray[indexPath.row];
      cell.textLabel.text=[NSString stringWithFormat:@"%@",model.name];
      cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",model.url];
      return cell;
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HostDBModel *model=self.dataArray[indexPath.row];
    
    [self updateWith:model];
}
-(void)addData{
      __weak typeof(self) weakSelf = self;
    UIAlertController *alc=[UIAlertController alertControllerWithTitle:@"添加解析地址"
                                                               message:nil
                                                        preferredStyle:UIAlertControllerStyleAlert];
    [alc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入解析标记";
    }];
    [alc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           textField.placeholder=@"请输入解析地址";
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
        model.url=tfLast.text;
        [[HostDBManager managerDB] createDBTable:@DBAnalysis];
        [[HostDBManager managerDB] insertDBTable:@DBAnalysis withSearch:model];
         self.dataArray=[[HostDBManager managerDB] selectDBTable:@DBAnalysis];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mintable reloadData];
            if (weakSelf.dataArray.count>0) {
                      [weakSelf hideNoDataViewFromView:weakSelf.mintable];
                  }
        });
    }];
    [alc addAction:cancaleBtn];
    [alc addAction:okBtn];
    [self presentViewController:alc animated:YES completion:nil];
}
-(void)updateWith:(HostDBModel*)model{
    __weak typeof(self) weakSelf  = self;
     UIAlertController *alc=[UIAlertController alertControllerWithTitle:@"添加解析地址"
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleAlert];
     [alc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
         textField.placeholder=@"请输入解析标记";
         textField.placeholder=model.name;
     }];
     [alc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
         textField.placeholder=@"请输入解析地址";
         textField.placeholder=model.url;
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
         model.name=tfFirst.text;
         model.url=tfLast.text;
         [[HostDBManager managerDB] createDBTable:@DBAnalysis];
         [[HostDBManager managerDB] updateDBTable:@DBAnalysis withSearch:model];
          self.dataArray=[[HostDBManager managerDB] selectDBTable:@DBAnalysis];
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.mintable reloadData];
   
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
    [[HostDBManager managerDB] createDBTable:@DBAnalysis];
    [[HostDBManager managerDB] delDBTable:@DBAnalysis withSearch:model];
     self.dataArray=[[HostDBManager managerDB] selectDBTable:@DBAnalysis];
      __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        if (weakSelf.dataArray.count==0) {
             [weakSelf showNoDataViewToView:weakSelf.mintable withString:@"暂无解析地址"];
         }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
