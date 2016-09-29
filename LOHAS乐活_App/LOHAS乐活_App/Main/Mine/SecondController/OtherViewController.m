
//
//  OtherViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/21/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "OtherViewController.h"
#import "InfoModel.h"
#import "InfoCell.h"
@interface OtherViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_table;
    NSMutableArray *_otherArr;
}

@end
@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    [self createBarItem];
    [self loadNetData];
    [self createTableView];
    
}
#pragma mark - 界面构建
-(void)createBarItem {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"ico_return2"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}
-(void)barItemAction:(UIButton *)sender{
  [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 网络数据读取
-(void)loadNetData {
    //获取管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发起GET请求
    [manager GET:_webStr
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSData *data = (NSData *)responseObject;
             NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSArray *array = content[@"content"];
             NSMutableArray *mArray = [[NSMutableArray alloc] init];
             //遍历数组
             for (NSDictionary *dic in array) {
                 //创建微博对象
                 InfoModel *model = [InfoModel yy_modelWithJSON:dic];
                 [mArray addObject:model];
             }
             _otherArr  = [mArray mutableCopy];
             [_table reloadData];
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
}
#pragma mark - 创建Table
-(void)createTableView{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.showsVerticalScrollIndicator = NO;
    _table.bounces = NO;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    _table.rowHeight = 71;
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"InfoCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"InfoCell"];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _otherArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    InfoModel *sq = _otherArr[indexPath.row];
    [cell setIfModel:sq];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
