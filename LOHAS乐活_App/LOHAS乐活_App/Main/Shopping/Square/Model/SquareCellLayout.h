//
//  SquareCellLayout.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/18/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#define CellTopViewHeight 50
#define SpaceWidth 10
#define ImageViewWidth 200

#define ImageViewSpace 5

#define ArticleHeight 70

#define BottomViewHeight 15
#define ZanBottomHeight 20

#define LineSpace 2

#import <Foundation/Foundation.h>
#import "SquareModel.h"
@interface SquareCellLayout : NSObject

+ (instancetype)layoutWithSquareModel:(SquareModel *)square;
//------------------------数据输入------------------------
@property (nonatomic, strong) SquareModel *square;

//------------------------布局输出------------------------
@property (nonatomic, assign, readonly) CGRect squareTextFrame;  //正文frmae
@property (nonatomic, assign, readonly) CGRect sqImageFrame; //正文图片frmae

//九个图片
@property (nonatomic,strong,readonly) NSArray *imageFrameArray;

//总高度获取
- (CGFloat)cellHeight;
@end
