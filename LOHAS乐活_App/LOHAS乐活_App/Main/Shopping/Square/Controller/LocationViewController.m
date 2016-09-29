

//
//  LocationViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/23/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>//定位用到的类
#import "AppDelegate.h"
@class AFHTTPSessionManager;
@interface LocationViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>{
    CLLocationManager *_locationManager;
    NSMutableArray *_locationArray1;
    NSMutableArray *_locationArray2;

    UITableView *_tableView;
 
}
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    
    [self startLoaction];
    [self createTableView];
}
//开启定位服务
-(void)startLoaction {
    //获取位置管理器
    _locationManager = [[CLLocationManager alloc] init];
    
    //在IOS8之后 需要来设置定位的服务类型 始终/在程序运行时
    //NSLocationAlwaysUsageDescription或者NSLocationWhenInUseUsageDescription
    //将需要使用的类型,添加到Plist文件中，然后在后面字段中写上提示语
    
    //请求定位权限
    if (kSystemVersion >= 8.0) {
        //请求在程序使用期间的定位权限
        [_locationManager requestWhenInUseAuthorization];
    }
    //设定定位的精准度
    //精准度越高 耗电量越高  根据程序的需求情况，选择合适的精准度
    /*
     kCLLocationAccuracyBest;                //最高精准度
     kCLLocationAccuracyNearestTenMeters;    //10米
     kCLLocationAccuracyHundredMeters;       //100米
     kCLLocationAccuracyKilometer;           //1000米
     kCLLocationAccuracyThreeKilometers;     //3000米
     */
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    //设置代理获取结果
    _locationManager.delegate = self;
    
    //开启定位
    [_locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate
//在获取到最新的位置信息时 调用
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //    NSLog(@"%@", locations);
    //当获取到位置信息后，关闭定位
    [manager stopUpdatingLocation];
    
    //获取当前的位置经纬度
    CLLocation *location = [locations firstObject];
    //经度
    double lon = location.coordinate.longitude;
    //纬度
    double lat = location.coordinate.latitude;
    NSLog(@"经度%f,纬度%f",lon ,lat);
    if (lon > 0 && lat >0) {
        
        NSString *lonStr = [NSString stringWithFormat:@"%f",lon];
        NSString *latStr = [NSString stringWithFormat:@"%f",lat];
        NSString *urlString = [NSString stringWithFormat:@"http://restapi.amap.com/v3/place/around?output=json&location=%@,%@&radius=3000&sortrule=distance&city=%%E6%%9D%%AD%%E5%%B7%%9E%%E5%%B8%%82&keywords=&language=zh-CN&offset=20&page=1&types=%%E9%%A4%90%E9%%A5%%AE%%E6%%9C%%8D%%E5%%8A%%A1%%7C%%E5%95%86%%E5%%8A%%A1%%E4%%BD%%8F%%E5%%AE%85%7C%%E7%94%9F%%E6%%B4%%BB%%E6%%9C%%8D%%E5%%8A%%A1&extensions=all&key=a0c83e13533954b306b22798ab273c74&citylimit=false&children=0&ts=1474600610317&scode=70b60c5749b10dac650baae72661d6b1",lonStr,latStr];
        //获取管理对象
        //获取管理对象
        AFHTTPSessionManager *afManager = [AFHTTPSessionManager manager];
        afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //发起GET请求
        [afManager GET:urlString
            parameters:nil
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSData *data = (NSData *)responseObject;
                   NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                   NSArray *array = content[@"pois"];
                   NSMutableArray *mArray1 = [[NSMutableArray alloc] init];
                   NSMutableArray *mArray2 = [[NSMutableArray alloc] init];
                   //遍历数组
                   for (NSDictionary *dic in array) {
                       NSString *str1 = dic[@"name"];
                       NSString *str2 = dic[@"address"];
                       [mArray1 addObject:str1];
                       [mArray2 addObject:str2];
                   }
                   _locationArray1  = [mArray1 mutableCopy];
                   _locationArray2 = [mArray2 mutableCopy];
                   [_tableView reloadData];
                   
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSLog(@"请求失败");
               }];
    }else{
        _locationArray1 = [NSMutableArray array];
    }
    
}
#pragma mark - UITableView

-(void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight- 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"ico_return2"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 40, 30);
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitle:@"完成" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button2 addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = item2;
    
}
-(void)barItemAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _locationArray1.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    //地点名称
    cell.textLabel.text = _locationArray1[indexPath.row];
    cell.detailTextLabel.text = _locationArray2[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [self.navigationController popViewControllerAnimated:YES];
    
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
