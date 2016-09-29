//
//  SquareCellLayout.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/18/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "SquareCellLayout.h"
#import "WXLabel.h"
@interface SquareCellLayout()
{
    CGFloat _cellHeight;
}
@end

@implementation SquareCellLayout

+ (instancetype)layoutWithSquareModel:(SquareModel *)square {
    SquareCellLayout *layout = [[SquareCellLayout alloc] init];
    if (layout) {
        layout.square = square;
    }
    
    return layout;
}



//在输入一个Model时，计算Frame
- (void)setSquare:(SquareModel *)square {
    if (_square == square) {
        return;
    }
    
    _square = square;
    
    //初始化总高度为0
    _cellHeight = 0;
    //顶部视图
    _cellHeight += CellTopViewHeight;
    //空隙
    _cellHeight += SpaceWidth;
    
    //pointSize 字体的实际大小
    CGFloat squareTextHeight = [WXLabel getTextHeight:kSquareTextFont.pointSize width:kScreenWidth - 2 * SpaceWidth text:_square.content.content linespace:LineSpace];
    squareTextHeight += 2;
    
    //文本frmae
    _squareTextFrame = CGRectMake(SpaceWidth, CellTopViewHeight + SpaceWidth, kScreenWidth - 2 * SpaceWidth, squareTextHeight);
    
    //累加总高度
    _cellHeight += squareTextHeight;
    //空隙
    _cellHeight += SpaceWidth;
    
    
    if (_square.content.file_image_thumb.count >0) {
    CGFloat imageHeight = [self layoutNineImageViewFrameWithImageCount:_square.content.file_image_thumb.count viewWidth:(kScreenWidth - 2*SpaceWidth) top:(CGRectGetMaxY(_squareTextFrame)+SpaceWidth)];
            //累加高度
            _cellHeight += imageHeight;
            _cellHeight += SpaceWidth;
        } else {
            _imageFrameArray = nil;
        }
    
    if (_square.article.count) {
        _cellHeight += 70;
        _cellHeight += SpaceWidth;
    }
    if (_square.zan) {
        if (_square.zan.count >0) {
            _cellHeight += ZanBottomHeight;
            _cellHeight += SpaceWidth;
        }
        _cellHeight += BottomViewHeight;
        _cellHeight += SpaceWidth;
    }
    
}

- (CGFloat)cellHeight {
    return _cellHeight;
}

#pragma mark - 九宫格布局
/**
 *  布局九个视图的frame
 *
 *  @param imageCount 图片数量
 *  @param viewWidth  整个视图的总宽度
 *  @param top        最顶部图片的y值
 *
 *  @return 视图的总高度，用于计算单元格高度
 */
- (CGFloat)layoutNineImageViewFrameWithImageCount:(NSInteger)imageCount viewWidth:(CGFloat)viewWidth
                                              top:(CGFloat)top {
    
    //判断图片数量是否合法
    if (imageCount > 9 || imageCount <= 0) {
        _imageFrameArray = nil;
        return 0;
    }
    
    //分情况讨论图片的布局条件 (行数，列数，每个图片的宽度)
    //所有图片的总高度/每一个图片的边长/列数
    CGFloat viewHeight;
    CGFloat imageWidth;
    NSInteger numberOfColumn = 2;   //列数/一行有几个
    
    if (imageCount == 1) {
        //一行一列
        numberOfColumn = 1;
        imageWidth = viewWidth;
        viewHeight = viewWidth;
    } else if (imageCount == 2) {
        //一行两列
        imageWidth = (viewWidth - ImageViewSpace) / 2;
        viewHeight = imageWidth;
    } else if (imageCount == 4) {
        //两行两列
        imageWidth = (viewWidth - ImageViewSpace) / 2;
        viewHeight = viewWidth;
    } else {
        //三列
        imageWidth = (viewWidth - 2 * ImageViewSpace) / 3;
        numberOfColumn = 3;
        if (imageCount == 3) {
            //一行
            viewHeight = imageWidth;
        } else if (imageCount <= 6) {
            //两行
            viewHeight = imageWidth * 2 + ImageViewSpace;
        } else {
            //三行
            viewHeight = viewWidth;
        }
    }
    
    
    //布局视图
    //1.初始化Array
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    
    //2.循环创建frame
    for (int i = 0; i < 9; i++) {
        
        //如果循环次数大于了图片数量
        if (i >= imageCount) {
            //添加一个空的frame 到数组中去，表示此视图不需要显示
            CGRect frame = CGRectZero;
            [mArray addObject:[NSValue valueWithCGRect:frame]];
        } else {
            //计算当前视图，是第几行第几列
            NSInteger row = i / numberOfColumn;
            NSInteger column = i % numberOfColumn;
            //计算视图的frame
            //x = 列号 * (图片宽度 ＋ 空隙宽度) + leftSpace
            //y = 行号 * (图片宽度 ＋ 空隙宽度) + top
            CGFloat width = imageWidth + ImageViewSpace;
            CGFloat left = (kScreenWidth - viewWidth) / 2;
            CGRect frame = CGRectMake(column * width + left, row * width + top, imageWidth, imageWidth);
            
            [mArray addObject:[NSValue valueWithCGRect:frame]];
        }
    }
    //3.包装成NSValue 添加到数组中
    _imageFrameArray = [mArray copy];
    
    return viewHeight;
}
@end
