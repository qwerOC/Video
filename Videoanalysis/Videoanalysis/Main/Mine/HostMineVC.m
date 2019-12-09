//
//  HostMineVC.m
//  Videoanalysis
//
//  Created by lvqiang on 2019/11/25.
//  Copyright © 2019 lvqiang. All rights reserved.
//

#import "HostMineVC.h"

@interface HostMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *mintable;
@end

@implementation HostMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"我的";
    _mintable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MuScreen_Width, MuScreen_Height-SafeAreaTopHeight-SafeAreaBottomHeight-NGTabBarHeight)
                                             style:UITableViewStyleGrouped];
    _mintable.delegate=self;
    _mintable.dataSource=self;
    _mintable.estimatedRowHeight=100;
    _mintable.estimatedSectionFooterHeight=10;
    _mintable.estimatedSectionHeaderHeight=0;
    _mintable.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_mintable];
    
    self.dataArray=[[NSMutableArray alloc] initWithArray:@[@{@"name":@"解析地址管理",@"path":@"HostanalysisVC"}]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mintable reloadData];
    });
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
      cell.textLabel.text=[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"name"]];
      return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HostBaseViewController *vc =  [[NSClassFromString(self.dataArray[indexPath.row][@"path"]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
