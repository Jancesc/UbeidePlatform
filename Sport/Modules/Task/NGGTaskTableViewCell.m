//
//  NGGTaskTableViewCell.m
//  sport
//
//  Created by Jan on 01/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGTaskTableViewCell.h"

@interface NGGTaskTableViewCell () {
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_finishLabel;
    __weak IBOutlet UIButton *_statusButton;
    __weak IBOutlet UILabel *_coinLabel;
    __weak IBOutlet UILabel *_tipsLabel;
    
}

@end

@implementation NGGTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _statusButton.layer.cornerRadius = 0.5 * VIEW_H(_statusButton);
//    _statusButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
