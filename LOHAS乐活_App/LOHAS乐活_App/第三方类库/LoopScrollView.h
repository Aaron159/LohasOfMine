//
//  LoopScrollView.h
//  LoopScrollView
//
//  Created by JayWon on 15/8/27.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopScrollView : UIView <UIScrollViewDelegate>

@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic ,strong)NSArray *urlArr;
@end
