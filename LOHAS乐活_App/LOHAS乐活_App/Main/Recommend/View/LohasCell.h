//
//  LohasCell.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/13/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LohasCell : UITableViewCell

@property(nonatomic,strong) LohasModel *lmModel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
