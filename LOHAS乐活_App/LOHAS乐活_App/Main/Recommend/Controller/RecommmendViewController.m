
//
//  RecommmendViewController.m
//  仿LOHAS生活App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "RecommmendViewController.h"
#import "LohasCell.h"
#import "HeaderTabelView.h"
#import "WXRefresh.h"
#import "DetailViewController.h"
@interface RecommmendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSMutableArray *_dataArr;
    NSInteger s;
}

@end

@implementation RecommmendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    s = 1;
    
    [self loadNetData];
    
    [self createTableView];
    
}

#pragma mark - 网络数据读取
-(void)loadNetData {
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/daily?page=%li&pagesize=10",s];
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
                 LohasModel *lohasModel = [LohasModel yy_modelWithJSON:dic];
                 
                 [mArray addObject:lohasModel];
             }
             _dataArr  = [mArray mutableCopy];
             [_table reloadData];
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
}
#pragma mark - 创建Table
-(void)createTableView{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64- 49) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.showsVerticalScrollIndicator = NO;
    _table.separatorStyle = YES;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"LohasCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"LohasCell"];
    
    HeaderTabelView *header = [[HeaderTabelView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    _table.tableHeaderView = header;
    
    //使用weak类型的指针,来解决Block中的循环引用
    __weak RecommmendViewController *weakSelf = self;

    //添加下拉刷新
    [_table addPullDownRefreshBlock:^{
        __strong RecommmendViewController *strongSelf = weakSelf;
        //三者之间循环引用 不能用[self loadNewData];
        [strongSelf loadNewData];
    }];
//
    //上拉 加载更多
    [_table addInfiniteScrollingWithActionHandler:^{
        __strong RecommmendViewController *strongSelf = weakSelf;
        //三者之间循环引用 不能用[self loadNewData];
        [strongSelf loadMoreData];
    }];

}

-(void)loadMoreData {
    s += 1;
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/daily?page=%li&pagesize=10",s];
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
                 LohasModel *lohasModel = [LohasModel yy_modelWithJSON:dic];
                 
                 [mArray addObject:lohasModel];
             }
             [_dataArr addObjectsFromArray:mArray];
             [_table.infiniteScrollingView stopAnimating];
             [_table reloadData];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
    
  [_table.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}
-(void)loadNewData {
    s = 1;
    [self loadNetData];
    [_table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LohasCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LohasCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LohasModel *lm = _dataArr[indexPath.row];
    [cell setLmModel:lm];
    return cell;
}
//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 286;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LohasModel *lm = _dataArr[indexPath.row];
    NSInteger selectID =lm.idStr;
    
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.idStr = selectID;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

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
