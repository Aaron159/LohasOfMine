//
//  ScanViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/22/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "ScanViewController.h"
#import "ImageModel.h"
#import "ImageCell.h"
@interface ScanViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    UICollectionView *_ctView;
    NSMutableArray *_dataArr;
    UIView *_bottomView;
}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadData];
    [self createUI];
    [self createTool];
    
}
-(void)createTool{
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth,50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    _bottomView.hidden = YES;
    CGFloat itemWidth = kScreenWidth / 4;
    NSArray *imageArr = @[@"aico_return",@"aico_comment",@"aico_favorite",@"aico_share"];
    for (int i = 0; i < 4; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemWidth * i +(itemWidth-30)/2, 2, 30, 45);
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
    }
    
}
-(void)buttonAction:(UIButton *)button {
    if (button.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
   [super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)loadData {
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/magazine/%@",_idStr];
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
             NSDictionary *d = content[@"content"];
             NSDictionary *d1 = d[@"image"];
             NSMutableArray *mArray = [[NSMutableArray alloc] init];
             for (int i = 0; i < d1.count; i++) {
                 NSString *newStr = [NSString stringWithFormat:@"%i",i+1];
                 NSDictionary *dic = d1[newStr];
                ImageModel *model = [ImageModel yy_modelWithJSON:dic];
                 [mArray addObject:model];
             }
             _dataArr = [mArray mutableCopy];
             [_ctView reloadData];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
}
-(void)createUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    _ctView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _ctView.delegate = self;
    _ctView.dataSource = self;
    _ctView.showsHorizontalScrollIndicator = NO;
    _ctView.pagingEnabled = YES;
   
    _ctView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_ctView];
    
    //注册
    [_ctView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ImageCellID"];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCellID" forIndexPath:indexPath];
    ImageModel *model = _dataArr[indexPath.row];
    cell.igModel = model;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [cell.everyImage.scrollView addGestureRecognizer:singleTap];

    return cell;
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    _bottomView.hidden =!_bottomView.hidden;
}
//一定要写
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
