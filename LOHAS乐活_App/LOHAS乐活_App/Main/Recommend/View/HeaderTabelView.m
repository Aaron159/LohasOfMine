//
//  HeaderTabelView.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/13/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "HeaderTabelView.h"
#import "LoopScrollView.h"
@interface HeaderTabelView ()
{
    NSArray *_dataArr;
    NSArray *_urlArr;
}

@end

@implementation HeaderTabelView
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
    }
    
    return self;
}
-(void)loadData {
    NSString *urlString = @"http://api.ilohas.com/v2/banner_list?platform=1";
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
        NSMutableArray *mArray1 = [[NSMutableArray alloc] init];
         //遍历数组
         for (NSDictionary *dic in array) {
             //创建微博对象
             LohasModel *lohasModel = [LohasModel yy_modelWithJSON:dic];
             
             [mArray addObject:lohasModel.image];
             [mArray1 addObject:lohasModel.url];
         }
         _dataArr  = [mArray copy];
         _urlArr = [mArray1 copy];
         [self createScrollView];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
    

}
-(void)createScrollView {
    LoopScrollView *loopView = [[LoopScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.bounds.size.height - 2)];
    [self addSubview:loopView];
    loopView.dataArr =_dataArr;
    loopView.urlArr = _urlArr;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
