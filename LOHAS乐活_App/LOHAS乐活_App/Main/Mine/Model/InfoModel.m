
//
//  InfoModel.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/21/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    NSString *uidMine = [[IsLoginManager shareManage]getUidFromNSHomeDirectory];
    NSString *uid = dic[@"uid"];
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/club/check_follow?uid=%@&follow_uid=%@",uidMine,uid];
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
             _follow_status = [dic[@"follow_status"] integerValue];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
    return YES;
}
@end
