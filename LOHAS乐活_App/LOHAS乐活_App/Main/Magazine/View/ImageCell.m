 //
//  ImageCell.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/22/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell()

@end

@implementation ImageCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setIgModel:(ImageModel *)igModel {
  
    _igModel = igModel;
    
//    [_everyImage sd_setImageWithURL:_igModel.path];
    [_everyImage loadRequest:[NSURLRequest requestWithURL:_igModel.path]];
    _everyImage.scalesPageToFit = YES;
    _everyImage.scrollView.showsVerticalScrollIndicator = NO;
    _everyImage.scrollView.bounces = NO;
//    _everyImage.userInteractionEnabled = YES;
    
    
}
@end
