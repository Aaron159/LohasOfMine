//
//  DetailViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/13/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "DetailViewController.h"
#import "LinkModel.h"
#import "LinkViewController.h"
#import "SendWBViewController.h"
#define dataAPI ([NSString stringWithFormat:@"http://api.ilohas.com/v2/daily/%li",_idStr])
@interface DetailViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>{

    UIScrollView *_scrollView;
    NSArray *_linkArr;
    LohasModel *_lohasModel;
    NSInteger _scrollHeight;
    UIWebView *_wbView;
    UIView *_view;
    BOOL isShow;

    UIView *_shareView;
    UIButton *_upButton;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isShow = NO;
    [self loadData];
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
    //获取管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发起GET请求
    [manager GET:dataAPI
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSData *data = (NSData *)responseObject;
             NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSDictionary *dic = content[@"content"];
             _lohasModel = [LohasModel yy_modelWithJSON:dic];
             NSMutableArray *mArray = [[NSMutableArray alloc] init];
             //遍历数组
             for (NSDictionary *dic in _lohasModel.link) {
                 //创建微博对象
                 LinkModel *linkModel = [LinkModel yy_modelWithJSON:dic];
                 
                 [mArray addObject:linkModel];
             }
             _linkArr  = [mArray copy];
             [self createUI];
             [self createTool];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];

}
-(void)createUI {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *gap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView addGestureRecognizer:gap];
    [self.view addSubview:_scrollView];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 300)];
    [image sd_setImageWithURL:_lohasModel.image];
    image.userInteractionEnabled = YES;
    _scrollHeight += 305;
    [_scrollView addSubview:image];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, _scrollHeight +5, kScreenWidth - 20, 50)];
    _scrollHeight += 55;
    label.userInteractionEnabled = YES;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.numberOfLines = 0;
    label.text = _lohasModel.title;
    [_scrollView addSubview:label];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, _scrollHeight, kScreenWidth - 20, 15)];
    _scrollHeight += 20;
    label1.textColor = [UIColor grayColor];
    label1.font = [UIFont boldSystemFontOfSize:12];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_lohasModel.dateline];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *s = [formatter stringFromDate:date];
    label1.text = s;
    [_scrollView addSubview:label1];
    for (int i = 0; i < 3; i++) {
        UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, _scrollHeight, 30, 30)];
        titleImg.userInteractionEnabled = YES;
        titleImg.image = [UIImage imageNamed:@"column_outline.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, _scrollHeight, kScreenWidth - 40 - 10, 30);
        LinkModel *link = _linkArr[i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:link.title forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(netAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        // button.titleLabel.textAlignment = NSTextAlignmentLeft; 这句无效
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _scrollHeight += 33;
        [_scrollView addSubview:button];
        [_scrollView addSubview:titleImg];
    }
    _scrollHeight += 20;
//    CGFloat height = [WXLabel getTextHeight:[UIFont systemFontOfSize:16].pointSize width:kScreenWidth - 20 text:_lohasModel.content linespace:2];
    _wbView  = [[UIWebView alloc] init];
    _wbView.frame = CGRectMake(10,_scrollHeight, kScreenWidth-20, 150);
    _wbView.delegate = self;
    _wbView.scrollView.scrollEnabled = NO;
//    _wbView.scrollView.bounces = YES;
//    _wbView.scalesPageToFit = YES;
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>",_lohasModel.content];
    [_wbView loadHTMLString:htmls baseURL:nil];
    _wbView.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_wbView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [_scrollView addSubview:_wbView];
    
}
-(void)netAction:(UIButton *)button {
    NSInteger i = button.tag;
    LinkModel *model = _linkArr[i];
    LinkViewController *link = [[LinkViewController alloc] init];
    link.url = model.url;
    [self.navigationController pushViewController:link animated:YES];
}
-(void)tapAction:(UITapGestureRecognizer *)gap{

    isShow = !isShow;
    if (isShow) {
        _view.hidden = NO;
    }else if(!isShow){
        _view.hidden = YES;
    }
}
-(void)createTool{

    _view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth,50)];
    _view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view];
    _view.hidden = YES;
    CGFloat itemWidth = kScreenWidth / 4;
    NSArray *imageArr = @[@"aico_return",@"aico_comment",@"aico_favorite",@"aico_share"];
    for (int i = 0; i < 4; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemWidth * i +(itemWidth-30)/2, 2, 30, 45);
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:button];
    }

    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 150, kScreenWidth, 150)];
    _shareView.alpha = 0;
    _shareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_shareView];
    UIButton *wbButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 60)/2, 10, 60, 60)];
    wbButton.layer.cornerRadius = wbButton.width/2.0f;
    [wbButton addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
    [wbButton setBackgroundImage:[UIImage imageNamed:@"shareWB.png"] forState:UIControlStateNormal];
    [_shareView addSubview:wbButton];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 60)/2, 75, 60, 20)];
    label.text = @"新浪微博";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    [_shareView addSubview:label];
    
    _upButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 150)];
    _upButton.backgroundColor = [UIColor blackColor];
    _upButton.alpha = 0;
    [_upButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_upButton];
    
    UIButton *bu = [[UIButton alloc] initWithFrame:CGRectMake(0, _shareView.height - 40, kScreenWidth, 40)];
    bu.backgroundColor = [UIColor whiteColor];
    bu.alpha = 0.9;
    bu.layer.borderWidth = 0.5;
    bu.layer.borderColor = [UIColor blackColor].CGColor;
    [bu setTitle:@"取消" forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:bu];
}
-(void)jumpAction{
    [UIView animateWithDuration:0.5 animations:^{
        _upButton.alpha = 0;
        _shareView.alpha = 0;
    }];
    if ([[IsLoginManager shareManage]judgeNeedsPush:self] == YES) {
        SendWBViewController *wb = [[SendWBViewController alloc] init];
        wb.text = [NSString stringWithFormat:@"%@ 阅读全文 分享来自@LOHAS乐活杂志",_lohasModel.title];
        wb.imgUrl = _lohasModel.image;
        wb.navigationItem.hidesBackButton = YES;
        wb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wb animated:YES];
    }

}
-(void)backAction{
   [UIView animateWithDuration:0.5 animations:^{
       _upButton.alpha = 0;
       _shareView.alpha = 0;
   }];
}
-(void)buttonAction:(UIButton *)button {
    if (button.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(button.tag == 3){
        [UIView animateWithDuration:0.5 animations:^{
            _upButton.alpha = 0.5;
            _shareView.alpha = 0.9;
        }];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat height = [[_wbView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    _wbView.frame = CGRectMake(10, _scrollHeight, kScreenWidth-20, height);
    _scrollView.contentSize =  CGSizeMake(_scrollView.bounds.size.width, _scrollHeight+height);

}
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
