//
//  LeftViewController.m
//  仿LOHAS生活App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//
#define kLeftScreenWidth 300

#import "LeftViewController.h"
#import "AboutViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "WebViewController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>{
  
    UITableView *_table;
    NSArray *_tableArr;
    NSArray *_webArr;

}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES
    ;
    UIImageView *image  =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kLeftScreenWidth, kScreenHeight)];
    image.image = [UIImage imageNamed:@"leftmencellbg@2x.png"];
    [self.view addSubview:image];
    
    _tableArr = @[@"每日推荐",@"节气令",@"好看视频",@"我的榨杂志",@"日子店",@"关于我们"];
    _webArr =@[@"http://web.ilohas.com/daily",@"http://web.ilohas.com/season",@"http://web.ilohas.com/video",@"http://web.ilohas.com/magazine",@"http://weibo.com/lohasday?is_all=1"];
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES
    ;
}
-(void)createUI {
   
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftScreenWidth, kScreenHeight *0.7) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.backgroundColor = [UIColor clearColor];
    _table.rowHeight = 50;
    [self.view addSubview:_table];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLeftScreenWidth, 150)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((kLeftScreenWidth - 150)/2, 40, 150, 70)];
    image.image = [UIImage imageNamed:@"logo3.png"];
    [view addSubview:image];
    _table.tableHeaderView = view;
    
    _table.separatorInset = UIEdgeInsetsMake(0, 20, 20, 0);
    
    CGFloat itemWidth = kLeftScreenWidth / 4;
    NSArray *nameArr = @[@"btn_leftweibo.png",
                         @"btn_leftweixin.png",
                         @"btn_leftpingjia.png",
                         @"btn_leftfanhui.png"];
    for (int i =0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemWidth *i, _table.bottom +30, itemWidth,itemWidth /1.17);
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth*0.2, itemWidth*0.2/1.17, itemWidth*0.6, itemWidth*0.6 /1.17)];
        image.image = [UIImage imageNamed:nameArr[i]];
        image.userInteractionEnabled = YES;
        [button addSubview:image];
        button.tag = i;
//        [button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [self.view addSubview:button];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, _table.bottom +100+itemWidth /1.17, 200, 30)];
    label.text = @"1.1.1.20160921_beta_by徐辉";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor =[UIColor grayColor];
    [self.view addSubview:label];
    
    
}

#pragma mark - TabelView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = _tableArr[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 5) {
        [self addCurrentPageScreenshot];
        [self settingDrawerWhenPush];
        AboutViewController *about = [[AboutViewController alloc] init];
        about.navigationItem.hidesBackButton = YES;
        about.title =_tableArr[indexPath.row];
        [self.navigationController pushViewController:about animated:YES];
    }else {
        [self addCurrentPageScreenshot];
        [self settingDrawerWhenPush];
        WebViewController *web = [[WebViewController alloc] init];
        web.navigationItem.hidesBackButton = YES;
        web.title =_tableArr[indexPath.row];
        web.url = [NSURL URLWithString:_webArr[indexPath.row]];
        [self.navigationController pushViewController:web animated:YES];
    }

}
/// 添加当前页面的截屏
- (void)addCurrentPageScreenshot {
    
    UIImage *screenImage = [UIImage screenshot];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:screenImage];
    imgView.image = screenImage;
    [self.view addSubview:imgView];
    self.coverImageView = imgView;
    
}
/// 设置抽屉视图pop后的状态
- (void)settingDrawerWhenPop {
    
    self.mm_drawerController.maximumLeftDrawerWidth =300;
    self.mm_drawerController.showsShadow = YES;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    [self.coverImageView removeFromSuperview];
    self.coverImageView = nil;
    
}
/// 设置抽屉视图push后的状态
- (void)settingDrawerWhenPush {
    
    [self.mm_drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width];
    self.mm_drawerController.showsShadow = NO;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self settingDrawerWhenPop];
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
