//
//  NGGConsumptionTableViewCell.m
//  Sport
//
//  Created by Jan on 11/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGConsumptionTableViewCell.h"
@interface NGGConsumptionTableViewCell (){
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_descriptionLabel;
    __weak IBOutlet UILabel *_countLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_dateLabel;
    
}

@end
@implementation NGGConsumptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
