//
//  BaseViewController.m
//  仿LOHAS生活App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "SquareViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackButton];
}
- (void)createBackButton {
    //判断导航控制器的栈中 是否有超过一个视图控制器
    if (self.navigationController.viewControllers.count >= 2) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 50, 40);
        //按钮的背景图片
        [backButton setBackgroundImage:[UIImage imageNamed:@"btn_return@2x"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = item;
    }else if (self.navigationController.viewControllers.count == 1){
        UIImageView *bgImage = [[UIImageView alloc]init];
        bgImage.image = [UIImage imageNamed:@"logo1.png"];
        bgImage.frame = CGRectMake(0, 0, 110, 44);
        self.navigationItem.titleView = bgImage;
        NSArray *arr = @[@"ico_btnleftnav",@"ico_found"];
        for (int i = 0; i < arr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 40, 40);
            //按钮的背景图片
            [button setBackgroundImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [button setBackgroundImage:[UIImage imageNamed:@"ico_btnleftnav2"] forState:UIControlStateHighlighted];
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = item;
            }else{
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
                self.navigationItem.rightBarButtonItem = item;
            }
        }
    }
    
    
}
-(void)action:(UIButton *)button{
    if (button.tag == 0) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }else if(button.tag == 1){
        SquareViewController *square = [[SquareViewController alloc] init];
        square.hidesBottomBarWhenPushed = YES;
        square.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:square animated:YES];
    }
}

- (void)backAction {
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
