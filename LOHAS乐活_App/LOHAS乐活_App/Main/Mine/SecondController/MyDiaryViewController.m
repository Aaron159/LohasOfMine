//
//  MyDiaryViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/21/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "MyDiaryViewController.h"
#import "SquareModel.h"
#import "SquareCell.h"
#import "WXRefresh.h"
#import "SquareCellLayout.h"
#import "HeaderView.h"
@interface MyDiaryViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_table;
    NSMutableArray *_squareArr;
    NSInteger _squarePage;
}
@end

@implementation MyDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _squarePage = 1;
    self.title = @"我";
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
    button.tag = 0;
    [button addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 30, 30);
    [button1 setBackgroundImage:[UIImage imageNamed:@"ico_write"] forState:UIControlStateNormal];
    button1.tag = 1;
    [button1 addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = item1;
    
}
-(void)barItemAction:(UIButton *)sender{
    if (sender.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag == 1){
        BOOL isLogin = [[IsLoginManager shareManage] judgeNeedsPush:self];
        if (isLogin) {
            SendViewController *send = [[SendViewController alloc] init];
            send.hidesBottomBarWhenPushed = YES;
            send.navigationItem.hidesBackButton = YES;
            send.title = @"写笔记";
            [self.navigationController pushViewController:send animated:YES];
        }
    }
}
#pragma mark - 网络数据读取
-(void)loadNetData {
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/club/user_note_list?uid=%@&page=%li&pagesize=10",_uid,_squarePage];
    //获取管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发起GET请求
    [manager GET:urlString
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
                 SquareModel *model = [SquareModel yy_modelWithJSON:dic];
                 [mArray addObject:model];
             }
             _squareArr  = [mArray mutableCopy];
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
    //    _table.separatorStyle = YES;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"SquareCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"SquareCell"];
    
    HeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"Header" owner:nil options:nil] firstObject];
    view.frame = CGRectMake(0, 0, kScreenWidth, 150);
    _table.tableHeaderView = view;
    
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _squareArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SquareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SquareCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SquareModel *sq = _squareArr[indexPath.row];
    [cell setSqModel:sq];
    return cell;
}
//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SquareModel *sq = _squareArr[indexPath.row];
    //创建布局对象
    SquareCellLayout *layout = [SquareCellLayout layoutWithSquareModel:sq];
    //获取高度
    return [layout cellHeight];
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
