//
//  MagazineViewController.m
//  仿LOHAS生活App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#define kItemWidth (kScreenWidth - 40)/3
#define kItemHeight (kItemWidth *1.6)
#define kItemCount 3

#define kItemSpace 5

#import "MagazineViewController.h"
#import "MagazineModel.h"
#import "MagazineCell.h"
#import "WXRefresh.h"
#import "ScanViewController.h"
@interface MagazineViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>{
  
    UICollectionView *_collectView;
    NSMutableArray *_magazineArr;
    NSMutableArray *_mArray;
    NSInteger _page;
    NSString *_year;
    UIView *_view;
    NSString *_type;

}
@end

@implementation MagazineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _year = @"";
    _type = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self createCollectionView];
    [self reloadInfoData];
}
-(void)reloadInfoData {
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/magazine?platform=1&page=%li&pagesize=10&typeid=%@&year=%@",_page,_type,_year];
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
             NSMutableArray *dataArr = [NSMutableArray array];
             NSArray *array = content[@"content"];
             for (NSDictionary *dic in array) {
                 MagazineModel *model = [MagazineModel yy_modelWithDictionary:dic];
                 [dataArr addObject:model];
             }
             _magazineArr = [dataArr mutableCopy];
             [_collectView reloadData];
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
}
-(void)createUI{
  
    CGFloat widthButton = kScreenWidth / 4;
    NSArray *nameArr = @[@"所有",@"年份",@"别册",@"专题"];
    for (int i =0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(widthButton*i +3, 2, widthButton - 6, 30);
        button.layer.cornerRadius = 5.0;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button setTitleColor:kBlackColorItem forState:UIControlStateNormal];
        [button setTitleColor:kGreenColorItem forState:UIControlStateSelected];
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        button.tag = i;
        button.selected = NO;
        [button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        button.layer.borderColor = kBlackColorItem.CGColor;
        [self.view addSubview:button];
        if (i==0) {
            button.selected = YES;
            button.layer.borderColor = kGreenColorItem.CGColor;
        }
    }
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthButton, 20)];
    [self.view insertSubview:_view atIndex:0];
    NSString *urlString = @"http://api.ilohas.com/v2/index.php?m=magazine&a=get_year";
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
             _mArray = [[NSMutableArray alloc] init];
             //遍历数组
             for (NSDictionary *dic in array) {
                 //创建微博对象
                 NSString *year = dic[@"name"];
                 
                 [_mArray addObject:year];
             }
             CGFloat widthButton = kScreenWidth / _mArray.count;
             for (int i =0; i < _mArray.count; i++) {
                 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                 button.frame = CGRectMake(widthButton*i, 8, widthButton, 15);
                 button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                 [button setTitleColor:kBlackColorItem forState:UIControlStateNormal];
                 [button setTitleColor:kGreenColorItem forState:UIControlStateSelected];
                 [button setTitle:_mArray[i] forState:UIControlStateNormal];
                 button.tag = i;
                 button.selected = NO;
                 [button addTarget:self action:@selector(yearAction:) forControlEvents:UIControlEventTouchUpInside];
                 [_view addSubview:button];
                 _view.hidden =YES;
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];

    
    
}
-(void)yearAction:(UIButton *)button{
    for (UIView *b in _view.subviews) {
        Class buttonClass = NSClassFromString(@"UIButton");
        if ([b isKindOfClass:buttonClass]) {
            UIButton *btn = (UIButton *)b;
            btn.selected = NO;
            btn.layer.borderColor = kBlackColorItem.CGColor;
        }
    }
    //设置selected属性
    button.selected = YES;
    _year = _mArray[button.tag];
    [self reloadInfoData];
}
-(void)changeAction:(UIButton *)button {
    for (UIView *b in self.view.subviews) {
        Class buttonClass = NSClassFromString(@"UIButton");
        if ([b isKindOfClass:buttonClass]) {
            UIButton *btn = (UIButton *)b;
            btn.layer.borderColor = kBlackColorItem.CGColor;
            btn.selected = NO;
        }
    }
    //设置selected属性
    button.selected = YES;
    button.layer.borderColor = kGreenColorItem.CGColor;
    if (button.tag == 1) {
        [UIView animateWithDuration:0.1 animations:^{
            _collectView.frame =CGRectMake(0, 32+20, kScreenWidth, kScreenHeight -64-49-32-20);
            _view.frame = CGRectMake(0, 32, kScreenWidth, 20);
            _view.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            _view.hidden = YES;
            _collectView.frame =CGRectMake(0, 32, kScreenWidth, kScreenHeight -64-49-32);
            _view.frame = CGRectMake(0, 0, kScreenWidth, 20);
        }];
        _year = @"";
        if (button.tag == 2) {
            _type = @"1";
        }else if(button.tag == 3){
          _type = @"2";
        }else if (button.tag == 0){
        _type = @"";
        }
        [self reloadInfoData];
    }
    
}
-(void)createCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 10);
    layout.minimumLineSpacing = kItemSpace;
    layout.minimumInteritemSpacing = kItemSpace;
    layout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth, kScreenHeight -64-49-32) collectionViewLayout:layout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.showsHorizontalScrollIndicator = NO;
    _collectView.showsVerticalScrollIndicator = NO;
    _collectView.bounces = NO;
    _collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectView];
    //注册
    [_collectView registerNib:[UINib nibWithNibName:@"MagazineCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MagazineCellID"];
    
    //使用weak类型的指针,来解决Block中的循环引用
    __weak MagazineViewController *weakSelf = self;
    
    //上拉 加载更多
    [_collectView addInfiniteScrollingWithActionHandler:^{
        __strong MagazineViewController *strongSelf = weakSelf;
        //三者之间循环引用 不能用[self loadNewData];
        [strongSelf loadMoreData];
    }];
    
}
-(void)loadMoreData {
    _page += 1;
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/magazine?platform=1&page=%li&pagesize=10&typeid=&year=",_page];
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
                 MagazineModel *model = [MagazineModel yy_modelWithJSON:dic];
                 
                 [mArray addObject:model];
             }
             [_magazineArr addObjectsFromArray:mArray];
             [_collectView.infiniteScrollingView stopAnimating];
             [_collectView reloadData];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
    
    [_collectView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}
#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _magazineArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MagazineCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MagazineCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    MagazineModel *mgModel = _magazineArr[indexPath.row];
    cell.mgModel = mgModel;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    MagazineModel *model = _magazineArr[indexPath.row];
    NSString *idStr = model.idStr;
    ScanViewController *scan = [[ScanViewController alloc] init];
    scan.hidesBottomBarWhenPushed = YES;
    scan.idStr = idStr;
    [self.navigationController pushViewController:scan animated:YES];
    
    
    
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
