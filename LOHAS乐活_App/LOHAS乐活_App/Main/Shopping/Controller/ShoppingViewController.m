//
//  ShoppingViewController.m
//  仿LOHAS生活App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "ShoppingViewController.h"

@interface ShoppingViewController (){
    UIWebView *_wbView;
}
@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _wbView  = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49)];
    [self.view addSubview:_wbView];
}

-(void)viewWillAppear:(BOOL)animated {
    [_wbView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://shop110272191.taobao.com/?spm=a230r.7195193.1997079397.2.3a17ZM"]]];
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
