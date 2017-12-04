//
//  NGGTypeTableViewCell.m
//  sport
//
//  Created by Jan on 30/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGTypeTableViewCell.h"

@interface NGGTypeTableViewCell () {
    
    __weak IBOutlet UIImageView *_noticeView;
    __weak IBOutlet UIImageView *_logoView;
    __weak IBOutlet UILabel *_leagueName;
}

@end

@implementation NGGTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _noticeView.image = [UIImage imageWithColor:NGGViceColor];
    UIView *selectedBG = [[UIView alloc] initWithFrame:self.bounds];
    selectedBG.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = selectedBG;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    _noticeView.hidden = !selected;
}

- (void)setModel:(NGGLeagueModel *)model{
    
    _model = model;
    
    _leagueName.text = [NSString stringWithFormat:@"%@(%@)", _model.leagueName, _model.count];
}
@end
