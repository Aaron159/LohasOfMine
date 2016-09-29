//
//  MagazineCell.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/20/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "MagazineCell.h"

@interface MagazineCell()
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MagazineCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setMgModel:(MagazineModel *)mgModel {

    _mgModel = mgModel;
    
    _timeLabel.text = _mgModel.pub_date;
    [_coverImage sd_setImageWithURL:_mgModel.cover];
    _titleLabel.text = _mgModel.title;


}

@end
