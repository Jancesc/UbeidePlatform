//
//  NGGDarenGameResultTableViewCell.m
//  Sport
//
//  Created by Jan on 08/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameResultTableViewCell.h"
#import "JYCommonTool.h"
#import "UIImageView+WebCache.h"

@interface NGGDarenGameResultTableViewCell() {
    
    __weak IBOutlet UILabel *_leagueLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UIImageView *_homeLogo;
    __weak IBOutlet UILabel *_homeNameLabel;
    __weak IBOutlet UILabel *_homeScore;
    __weak IBOutlet UILabel *_awayScoreLabel;
    __weak IBOutlet UILabel *_awayNameLabel;
    __weak IBOutlet UIImageView *_awayLogo;
    __weak IBOutlet UIView *_tipsBGView;
    __weak IBOutlet UILabel *_tipsLabel;
    __weak IBOutlet UIButton *_darenButton;
    __weak IBOutlet UIButton *_registeryFeeButton;

}

@end

@implementation NGGDarenGameResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setup];
}

- (void)setup {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_darenButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0x02, 0x74, 0xe9)] forState:UIControlStateNormal];
    _darenButton.layer.cornerRadius = 2.f;
    _darenButton.layer.masksToBounds = YES;
    
    
    [_registeryFeeButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor]  forState:UIControlStateNormal];
    _registeryFeeButton.layer.cornerRadius = 2.f;
    _registeryFeeButton.layer.masksToBounds = YES;
    _tipsBGView.layer.cornerRadius = 8.f;
    _tipsBGView.layer.masksToBounds = YES;
    _tipsBGView.layer.borderColor = [NGGColor999 CGColor];
    _tipsBGView.layer.borderWidth = 1.f;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
    
    _leagueLabel.text = [cellInfo stringForKey:@"c_name"];
    _timeLabel.text = [JYCommonTool dateFormatWithInterval:[cellInfo intForKey:@"match_time"] format:@"yyyy-MM-dd hh:mm"];
    [_homeLogo sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"h_logo"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    [_awayLogo sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"a_logo"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    _homeNameLabel.text = [cellInfo stringForKey:@"h_name"];
    _awayNameLabel.text = [cellInfo stringForKey:@"a_name"];
    
    NSArray *scoreArray = [cellInfo arrayForKey:@"score"];
    _homeScore.text = [scoreArray firstObject];
    _awayScoreLabel.text = [scoreArray lastObject];
    
    NSString *tipsString = [NSString stringWithFormat:@"%@人参与  奖金 %@ 金豆",[cellInfo stringForKey:@"sign_up"], [cellInfo stringForKey:@"pool"]];
    _tipsLabel.text = tipsString;
    
    [_registeryFeeButton setTitle:[NSString stringWithFormat:@" %@金豆报名 ", [_cellInfo stringForKey:@"need_bean"]] forState:UIControlStateNormal];
}

@end
