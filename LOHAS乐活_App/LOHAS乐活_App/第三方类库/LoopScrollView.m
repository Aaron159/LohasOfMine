//
//  LoopScrollView.m
//  LoopScrollView
//
//  Created by JayWon on 15/8/27.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import "LoopScrollView.h"
#import "LinkViewController.h"
#define kPageCtrlHeight 37  //UIPageControl的高度

@interface LoopScrollView()
{
    UIScrollView *scrollView;
    UIPageControl *pageCtrl;
}

@end

@implementation LoopScrollView

- (instancetype)init
{
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:frame];
    }
    return self;
}

-(void)createUI:(CGRect)frame
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenWidth - 150, frame.size.height - kPageCtrlHeight, 150, kPageCtrlHeight)];
    pageCtrl.backgroundColor = [UIColor clearColor];
    
    [self addSubview:scrollView];
    [self addSubview:pageCtrl];
}

-(void)createScrollContentView
{
    NSArray *subViews = [scrollView subviews];
    [subViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [_dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(idx*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
//        imgView.image = [UIImage imageNamed:obj];
        [imgView sd_setImageWithURL:obj];
        imgView.tag = idx;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =
        [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickImage:)];
        [imgView addGestureRecognizer:singleTap];
        [scrollView addSubview:imgView];
    }];
    
    pageCtrl.numberOfPages = _dataArr.count-2;
    scrollView.contentSize = CGSizeMake(_dataArr.count * scrollView.frame.size.width, scrollView.frame.size.height);
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
}
-(void)whenClickImage:(UITapGestureRecognizer *)gap{
    NSInteger i = gap.view.tag;
    LinkViewController *s =[[LinkViewController alloc] init];
    s.hidesBottomBarWhenPushed = YES;
    s.url = _urlArr[i];
    //使用响应者链 查找导航控制器
    UIResponder *nextResponder = self.nextResponder;
    while (nextResponder) {
        //判断对象是否是导航控制器
        if ([nextResponder isKindOfClass:[UINavigationController  class]]) {
            //PUSH跳转
            UINavigationController *navi = (UINavigationController *)nextResponder;
            [navi pushViewController:s animated:YES];
            break;
        }
        nextResponder = nextResponder.nextResponder;
    }
    
}
-(void)setDataArr:(NSArray *)dataArr
{
    if (![dataArr isKindOfClass:[NSArray class]] || dataArr.count == 0) {
        return;
    }
    
    NSMutableArray *accurateArr = [NSMutableArray arrayWithArray:dataArr];
    [accurateArr insertObject:[dataArr lastObject] atIndex:0];
    [accurateArr addObject:[dataArr firstObject]];
    
    _dataArr = accurateArr;
    
    [self createScrollContentView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
    int currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    pageCtrl.currentPage = currentPage - 1;
    if (currentPage == 0){
        
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width * (_dataArr.count - 2), 0)];
        pageCtrl.currentPage = _dataArr.count-2-1;
        
    }else if (currentPage == _dataArr.count-1){
        
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0)];
        pageCtrl.currentPage = 0;
    }
}

@end
