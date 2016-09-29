//
//  SendWBViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/24/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "SendWBViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo+SendWeibo.h"
@interface SendWBViewController ()<SinaWeiboRequestDelegate>{
    
    UITextView *_textView;
    UIImageView *_img;

}
@end

@implementation SendWBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"图文分享";
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self createUI];
    [self createBarItem];
}
-(void)createBarItem {
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 40, 30);
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button1.tag = 0;
    [button1 addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = item1;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 40, 30);
    [button2 setTitleColor:fenxiangColor forState:UIControlStateNormal];
    [button2 setTitle:@"分享" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button2.tag = 1;
    [button2 addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = item2;
    
}
-(void)createUI{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont boldSystemFontOfSize:20];
    _textView.text = _text;
    [self.view addSubview:_textView];
    
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220, 120, 120)];
    _img.image = [UIImage imageNamed:@"btnaddpic@3x.png"];
    _img.userInteractionEnabled = YES;
    _img.layer.borderWidth = 1;
    _img.layer.borderColor = [UIColor grayColor].CGColor;
    [_img sd_setImageWithURL:_imgUrl];
    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(_img.width -20, 0, 20, 20)];
    [delete setBackgroundImage:[UIImage imageNamed:@"ico_cha.png"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    delete.backgroundColor = [UIColor blackColor];
    [_img addSubview:delete];
    [self.view addSubview:_img];
    
}
-(void)deleteAction{
    _img.image =nil;
    _img.hidden = YES;
}
-(void)barItemAction:(UIButton *)sender{
    if (sender.tag == 0) {
    [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag == 1){
        //去除文本中的空白字符
        NSString *text = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //判断输入框是否有文字
        if (text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"没有输入微博正文" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        //发微博之前显示HUD
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view.window];
        //添加hud到window中(发微博时正在跳转，只有window一直在，所以显示到window上)
        [self.view.window addSubview:hud];
        //显示文本内容
        hud.labelText = @"正在分享";
        //设置背景颜色 变暗效果
        hud.dimBackground = YES;
        //显示HUD
        [hud show:YES];
        
        //获取微博对象
        SinaWeibo *wb = kSinaWeiboObject;
        NSMutableDictionary *params = [@{@"status": text } mutableCopy];
        
        UIImage *image = nil;
        if (_img.image) {
            image = _img.image;
        }
        [wb sendWeiboWithText:text image:image params:params success:^(id result) {
            [_textView resignFirstResponder];//放弃第一响应者
            [self.navigationController popViewControllerAnimated:YES];
            hud.labelText = @"分享成功";
            //隐藏hud
            [hud hide:YES afterDelay:1.5];
        } fail:^(NSError *error) {
            NSLog(@"失败");
            hud.labelText = @"分享失败";
            //隐藏hud
            [hud hide:YES afterDelay:2];
        }];
  }
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
