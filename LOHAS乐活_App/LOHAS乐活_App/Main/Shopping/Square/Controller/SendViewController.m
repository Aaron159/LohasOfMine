//
//  SendViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/21/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "SendViewController.h"
#import "LocationViewController.h"
@interface SendViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UITextView *_textView;
    NSDictionary *_ImageDic;
    UIImageView *img;
}
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    [self createBarItem];
    [self createUI];
}
-(void)createBarItem {
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 40, 30);
    [button1 setTitleColor:reddishBlueColor forState:UIControlStateNormal];
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button1.tag = 0;
    [button1 addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = item1;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 40, 30);
    [button2 setTitleColor:reddishBlueColor forState:UIControlStateNormal];
    [button2 setTitle:@"完成" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button2.tag = 1;
    [button2 addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = item2;
    
}
-(void)barItemAction:(UIButton *)button{
    if (button.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (button.tag == 1){
        if (_textView.text.length) {
            NSString *token = [[IsLoginManager shareManage]getTokenFromNSHomeDirectory];
            NSString *urlString = nil;
            if (_ImageDic) {
                NSString *image = _ImageDic[@"image"];
//                NSString *image1 = [[image stringByReplacingOccurrencesOfString:@":" withString:@"%3A"] stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
                NSString *thumb = _ImageDic[@"thumb"];
//                NSString *thumb1 = [[thumb stringByReplacingOccurrencesOfString:@":" withString:@"%3A"] stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
                urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/club/add_note?token=%@&content=%@&file_type=1&file_path=%@&file_image_thumb=%@",token,_textView.text,image,thumb];
            }else {
                urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/club/add_note?token=%@&content=%@",token,_textView.text];
            }
            urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
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
                     NSInteger status= [content[@"status"] integerValue];
                     if (status == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"请求失败");
                 }];
        }
    }
}
-(void)createUI {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:_textView];
    
    img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 320, 80, 80)];
    img.image = [UIImage imageNamed:@"btnaddpic@3x.png"];
    img.userInteractionEnabled = YES;
    img.layer.borderWidth = 1;
    img.layer.borderColor = [UIColor grayColor].CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [img addGestureRecognizer:tap];
    [self.view addSubview:img];
    
    UIView *img1 = [[UIView alloc] initWithFrame:CGRectMake(0, 410, kScreenWidth, 50)];
    img1.userInteractionEnabled = YES;
    img1.layer.borderWidth = 2;
    img1.layer.borderColor = [UIColor grayColor].CGColor;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)];
    [img1 addGestureRecognizer:tap1];
    UIImageView *location = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    location.image = [UIImage imageNamed:@"icop@3x.png"];
    location.userInteractionEnabled = YES;
    [img1 addSubview:location];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 100, 20)];
    l.textColor = [UIColor blackColor];
    l.font = [UIFont boldSystemFontOfSize:15];
    l.text = @"所在位置";
    [img1 addSubview:l];
    [self.view addSubview:img1];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 40,10, 18, 30)];
    icon.userInteractionEnabled = YES;
    icon.image = [UIImage imageNamed:@"icoass@3x.png"];
    [img1 addSubview:icon];


}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    if (kSystemVersion > 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                       
                                                             handler:^(UIAlertAction * action) {}];
        UIAlertAction *fromPhotoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {                                                                     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = NO;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        UIAlertAction *fromCameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = NO;
                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:fromCameraAction];
        [alertController addAction:fromPhotoAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    img.image = image;
    NSData *data = UIImageJPEGRepresentation(image, 1);
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *token = [[IsLoginManager shareManage] getTokenFromNSHomeDirectory];
    NSString *s =@"http://api.ilohas.com/v2/index.php?m=upload&a=upimg";
    //请求参数
    NSDictionary *parameters = @{@"token" : token,
                                 @"data" :result,
                                 @"postfix":@"jpg"};
    //请求序列化对象
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    //创建请求对象
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:s parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *data = UIImageJPEGRepresentation(image, 1);
//        
//        //图片数据拼接
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"12345.png" mimeType:@"image/jpeg"];
    } error:nil];
    
    //manager
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //创建任务
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //responseObject --NSDictionary
//        NSLog(@"%@",responseObject);
         NSDictionary *dic = responseObject[@"content"];
         _ImageDic = [dic copy];
         NSInteger status = [responseObject[@"status"] integerValue];
         if (status == 0) {
            [picker dismissViewControllerAnimated:YES completion:NULL];
//             NSLog(@"%@",_ImageDic);
         }
    }];
    //开始任务
    [task resume];

}
-(void)tapAction1:(UITapGestureRecognizer *)tap{
    LocationViewController *location = [[LocationViewController alloc] init];
    location.navigationItem.hidesBackButton = YES;
    location.title = @"选择地点";
    [self.navigationController pushViewController:location animated:YES];
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
