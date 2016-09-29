//
//  LohasCell.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/13/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "LohasCell.h"

@implementation LohasCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setLmModel:(LohasModel *)lmModel {
 
    _lmModel = lmModel;
    
    [_coverImg sd_setImageWithURL:_lmModel.cover_small];
    _title.text = _lmModel.title;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_lmModel.dateline];
    //时间格式化
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置格式化的格式
    [formatter setDateFormat:@"yyyy.MM.dd"];
    //对时间对象进行格式化输出
    //格式化过程中  会根据设备的时区  自动的计算时差
    NSString *s = [formatter stringFromDate:date];
    _dateLabel.text = s;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
