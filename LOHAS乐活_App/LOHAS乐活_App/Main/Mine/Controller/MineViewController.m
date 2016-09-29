//
//  MineViewController.m
//  仿LOHAS生活App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "SettingTableViewController.h"
#import "InfoViewController.h"
#import "SquareViewController.h"
#import "SheQuViewController.h"
#import "MyHomeViewController.h"
#import "MyDiaryViewController.h"
#import "OtherViewController.h"
@interface MineViewController (){

    UIView *_view;
    UIButton *_login;
    UILabel *_label;
    UIImageView *_image1;
    UILabel *_l1;
    UILabel *_l2;
    UILabel *_l3;
    NSString *_isLogin;
    UILabel *_showLabel;
}

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    [self createBarItem];
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated {
    _isLogin = [[IsLoginManager shareManage] getUseIDFromNSHomeDirectory];
    if (_isLogin) {
    [self loadDataLogin];
    } else{
        _view.hidden = YES;
        _login.hidden = NO;
    }
}
#pragma mark - 登录操作
-(void)loadDataLogin {
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/login_by_openid?app_openid=%@&third_name=weibo",_isLogin];
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
             NSDictionary *dic = content[@"content"];
             _label.text = dic[@"username"];
             _l1.text = dic[@"note_total"];
             _l2.text = dic[@"follows"];
             _l3.text = dic[@"fans"];
             NSURL *s = [NSURL URLWithString:dic[@"avatar"]];
             [_image1 sd_setImageWithURL:s];
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
    _view.hidden = NO;
    _login.hidden = YES;
}
-(void)createBarItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    //按钮的背景图片
    [button setBackgroundImage:[UIImage imageNamed:@"icoSetting"] forState:UIControlStateNormal];
     [button addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 30, 30);
    //按钮的背景图片
    NSString *s = [[IsLoginManager shareManage]getBgColorFromNSHomeDirectory];
    if ([s isEqualToString:@"black"]) {
        button1.selected = NO;
    }else{
       button1.selected = YES;
    }
    [button1 setBackgroundImage:[UIImage imageNamed:@"ico_heartred"] forState:UIControlStateSelected];
    [button1 setBackgroundImage:[UIImage imageNamed:@"ico_heart"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(getdark:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = item1;
    
}
-(void)getdark:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSDictionary *bgColor = @{@"bgColor" : @"white"};
        //将认证数据 保存到属性列表中
        [userDef setObject:bgColor forKey:kBgColor];
        [userDef synchronize];
    }else {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSDictionary *bgColor = @{@"bgColor" : @"black"};
        //将认证数据 保存到属性列表中
        [userDef setObject:bgColor forKey:kBgColor];
        [userDef synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifacationBgColor object:nil];
}
-(void)settingAction{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    SettingTableViewController *set = [sb instantiateViewControllerWithIdentifier:@"SettingID"];
    set.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:set animated:YES];
    
}
-(void)createUI {

    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, 20, 80, 80)];
    image.image = [UIImage imageNamed:@"img_noneuser"];
    [self.view addSubview:image];
    
    _login = [UIButton buttonWithType:UIButtonTypeCustom];
    _login.frame = CGRectMake((kScreenWidth-150)/2, 20+image.height +30, 150, 40);
    [_login setBackgroundImage:[UIImage imageNamed:@"btn_login"] forState:UIControlStateNormal];
    [_login addTarget:self action:@selector(_loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login];
    
    _view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,_login.bottom +100 )];
    _view.backgroundColor = [UIColor whiteColor];
    _view.alpha = 0.95;
    [self.view addSubview: _view];
    _image1 = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, 20, 80, 80)];
    _image1.image = [UIImage imageNamed:@"img_noneuser"];
    _image1.layer.masksToBounds=YES;
    _image1.layer.cornerRadius=88/2.0f; //设置为图片宽度的一半出来为圆形
    _image1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_image1 addGestureRecognizer:tap];
    [_view addSubview:_image1];
    _label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2,100, 200, 20)];
    _label.text= @"nil";
    _label.font =[UIFont systemFontOfSize:15];
    _label.textAlignment = NSTextAlignmentCenter;
    [_view addSubview:_label];
    _view.hidden = YES;
    
    CGFloat widthB = kScreenWidth /3;
    NSArray *imageName = @[@"logintag1",@"logintag2",@"logintag3"];
    for (int i = 0 ; i <3; i++) {
        UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
        b1.frame = CGRectMake(i*widthB +(widthB-80)/2, _login.bottom +100-30-10, 80, 30);
        if (i == 0) {
            _l1 =[[UILabel alloc] initWithFrame:CGRectMake(i*widthB +(widthB-80)/2, _login.bottom +100-10-30-20-10, 80, 20)];
            _l1.textAlignment = NSTextAlignmentCenter;
            _l1.text = @"0";
            _l1.font =[UIFont systemFontOfSize:20];
            [_view addSubview:_l1];
        }else if (i == 1){
          _l2 = [[UILabel alloc] initWithFrame:CGRectMake(i*widthB +(widthB-80)/2, _login.bottom +100-10-30-20-10, 80, 20)];
        _l2.textAlignment = NSTextAlignmentCenter;
        _l2.text = @"0";
        _l2.font =[UIFont systemFontOfSize:20];
        [_view addSubview:_l2];
        }else if (i == 2){
        _l3 = [[UILabel alloc] initWithFrame:CGRectMake(i*widthB +(widthB-80)/2, _login.bottom +100-10-30-20-10, 80, 20)];
        _l3.textAlignment = NSTextAlignmentCenter;
        _l3.text = @"0";
        _l3.font =[UIFont systemFontOfSize:20];
        [_view addSubview:_l3];
        }
        b1.tag = i;
        [b1 addTarget:self action:@selector(haveLoginedAction:) forControlEvents:UIControlEventTouchUpInside];
        [b1 setBackgroundImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
        [_view addSubview:b1];
    }
    
    NSArray *imageName1 = @[@"u_home",
                            @"u_found",
                            @"u_shequ"];
    NSArray *imageName2 = @[@"u_favorite",
                            @"u_huiyuan",
                            @"u_notice"];
    for (int i = 0 ; i <3; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(i*widthB +(widthB-80)/2, _login.bottom +100, 80, 70);
        b.tag = i;
        [b addTarget:self action:@selector(firstRowAction:) forControlEvents:UIControlEventTouchUpInside];
        [b setBackgroundImage:[UIImage imageNamed:imageName1[i]] forState:UIControlStateNormal];
        [self.view addSubview:b];
    }
    for (int i = 0 ; i <3; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(i*widthB +(widthB-80)/2, _login.bottom +100+80+30, 80, 70);
        b.tag = i;
        [b addTarget:self action:@selector(secondRowAction:) forControlEvents:UIControlEventTouchUpInside];
        [b setBackgroundImage:[UIImage imageNamed:imageName2[i]] forState:UIControlStateNormal];
        [self.view addSubview:b];
    }
    
    //文本显示Label
    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3,kScreenHeight -64-49- 50-30, kScreenWidth/3, 30)];
    _showLabel.textColor = [UIColor redColor];
    _showLabel.backgroundColor = [UIColor grayColor];
    _showLabel.text = @"暂未开通";
    _showLabel.textAlignment = NSTextAlignmentCenter;
//    //改变frame 不如改变 y值
//    _showLabel.transform = CGAffineTransformMakeTranslation(0, 130);
    _showLabel.alpha = 0.03;
    [self.view addSubview:_showLabel];
    
}
#pragma mark - UIControlAction
-(void)haveLoginedAction:(UIButton *)button{
    NSString *s = [[IsLoginManager shareManage]getUidFromNSHomeDirectory];
    NSArray *s1 = @[@"我的朋友",@"我的粉丝"];
    if (button.tag == 0) {
        if (s) {
            MyDiaryViewController *my = [[MyDiaryViewController alloc] init];
            my.uid = s;
            my.hidesBottomBarWhenPushed = YES;
            my.navigationItem.hidesBackButton = YES;
            [self.navigationController pushViewController:my animated:YES];
        }
    }
    else{
        OtherViewController *other = [[OtherViewController alloc]init];
        other.hidesBottomBarWhenPushed = YES;
        other.navigationItem.hidesBackButton = YES;
        if (button.tag == 1){
        NSString *str =[NSString stringWithFormat:@"http://api.ilohas.com/v2/club/follow_list?uid=%@&page=1&pagesize=10",s];
            other.titleStr = s1[0];
            other.webStr = str;
        }else if (button.tag == 2){
        NSString *str1 =[NSString stringWithFormat:@"http://api.ilohas.com/v2/club/fans_list?uid=%@&page=1&pagesize=10",s];
            other.titleStr = s1[1];
            other.webStr = str1;
       }
        [self.navigationController pushViewController:other animated:YES];
}
}
-(void)firstRowAction:(UIButton *)button{
    if (button.tag == 0) {
        BOOL isLg = [[IsLoginManager shareManage] judgeNeedsPush:self];
        if (isLg) {
        NSString *s = [[IsLoginManager shareManage]getTokenFromNSHomeDirectory];
            MyHomeViewController *myHome = [[MyHomeViewController alloc] init];
            myHome.hidesBottomBarWhenPushed = YES;
            myHome.navigationItem.hidesBackButton = YES;
            myHome.token = s;
            [self.navigationController pushViewController:myHome animated:YES];
        }
    }else if (button.tag == 1){
        SquareViewController *sq = [[SquareViewController alloc]init];
        sq.hidesBottomBarWhenPushed = YES;
        sq.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:sq animated:YES];
    }else if (button.tag == 2){
        NSString *s = [[IsLoginManager shareManage]getTokenFromNSHomeDirectory];
        NSString *url = [NSString stringWithFormat:@"http://club.ilohas.com/?token=%@",s];
        SheQuViewController *shequ = [[SheQuViewController alloc]init];
        shequ.url = [NSURL URLWithString:url];
        shequ.hidesBottomBarWhenPushed =YES;
        shequ.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:shequ animated:YES];
    }
}
-(void)secondRowAction:(UIButton *)button{
    [self showLabel];
}
-(void)showLabel {
    //播放动画效果
    [UIView animateWithDuration:0.25 animations:^{
        _showLabel.alpha = 1;
    }completion:^(BOOL finished) {
        //延迟两秒,再次动画
        [UIView animateWithDuration:0.25 delay:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
//            _showLabel.transform = CGAffineTransformMakeTranslation(0, 130);
            _showLabel.alpha = 0.03;
        } completion:nil];
    }];
}
-(void)tapAction:(UITapGestureRecognizer *)tap {
    InfoViewController *info = [[InfoViewController alloc]init];
    info.hidesBottomBarWhenPushed = YES;
    info.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:info
                                         animated:YES];
}
-(void)_loginAction{
 
    LoginViewController *login = [[LoginViewController alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    login.title = @"登录";
    login.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:login animated:YES];
    
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
