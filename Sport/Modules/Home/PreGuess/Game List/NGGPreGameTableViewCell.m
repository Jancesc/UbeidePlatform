//
//  NGGPreGameTableViewCell.m
//  sport
//
//  Created by Jan on 30/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGPreGameTableViewCell.h"
#import "JYCommonTool.h"

@interface NGGPreGameTableViewCell() {

    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_leagueLabel;
    __weak IBOutlet UIImageView *_homeImageVIew;
    __weak IBOutlet UIImageView *_awayImageView;
    __weak IBOutlet UILabel *_homeLabel;
    __weak IBOutlet UILabel *_awayLabel;
    __weak IBOutlet UIButton *_liveButton;
    __weak IBOutlet UIView *_countLabel;
}

@end

@implementation NGGPreGameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configueUIComponents];
}

- (void)configueUIComponents {
    
    [_liveButton setBackgroundImage: [UIImage imageWithColor:NGGColorCCC] forState:UIControlStateNormal];
    _liveButton.layer.cornerRadius = 2.f;
    _liveButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NGGGameListModel *)model {
    
    _model = model;
    _timeLabel.text = [JYCommonTool dateFormatWithInterval:_model.timeString.integerValue format:@"hh:mm"];
    _homeLabel.text = _model.homeName;
    _awayLabel.text = _model.awayName;
    _leagueLabel.text = _model.leagueName;
}

@end
