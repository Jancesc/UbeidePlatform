//
//  NGGDarenGameListTableViewCell.m
//  Sport
//
//  Created by Jan on 07/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameListTableViewCell.h"
#import "JYCommonTool.h"
#import "UIImageView+WebCache.h"

@interface NGGDarenGameListTableViewCell () {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_leagueLabel;
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UILabel *_homeNameLabel;
    __weak IBOutlet UILabel *_awayNameLabel;
    __weak IBOutlet UILabel *_numberlabel;
    __weak IBOutlet UIImageView *_homeLogo;
    __weak IBOutlet UIImageView *_awayLogo;
    __weak IBOutlet UIButton *_registeryFeeButton;
    __weak IBOutlet UIButton *_totalButton;
    
    NSInteger _closeTime;
}

@end

@implementation NGGDarenGameListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setup];
}

- (void)setup {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_registeryFeeButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0x02, 0x74, 0xe9)] forState:UIControlStateNormal];
    _registeryFeeButton.layer.cornerRadius = 2.f;
    _registeryFeeButton.layer.masksToBounds = YES;
    
    
    [_totalButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor]  forState:UIControlStateNormal];
    _totalButton.layer.cornerRadius = 2.f;
    _totalButton.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
    _titleLabel.text = [_cellInfo stringForKey:@"title"];
    _leagueLabel.text = [_cellInfo stringForKey:@"c_name"];
    
    [_homeLogo sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"h_logo"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    [_awayLogo sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"a_logo"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    _homeNameLabel.text = [_cellInfo stringForKey:@"h_name"];
    _awayNameLabel.text = [_cellInfo stringForKey:@"a_name"];
    
    _numberlabel.text = [NSString stringWithFormat:@"已报名:%@", [_cellInfo stringForKey:@"sign_up"]];
    
    [_registeryFeeButton setTitle:[NSString stringWithFormat:@" %@金豆报名 ", [_cellInfo stringForKey:@"need_bean"]] forState:UIControlStateNormal];
    [_totalButton setTitle:[NSString stringWithFormat:@" 当前奖池%@金豆 ", [_cellInfo stringForKey:@"pool"]] forState:UIControlStateNormal];
    
    _closeTime = [_cellInfo intForKey:@"shut_time"];
    [self countTime];
}

- (void)countTime {
    
    if (_cellInfo) {
        
        NSInteger currentInterval = [[NSDate date] timeIntervalSince1970];
        if (_closeTime > currentInterval) {
            
            NSInteger interval = _closeTime - currentInterval - 8* 3600;
            NSString *countString = [JYCommonTool dateFormatWithInterval:interval format:@"HH:mm:ss"];
            _dateLabel.text = [NSString stringWithFormat:@"截止时间:%@", countString];
        } else {
            
            if (_delegate && [_delegate respondsToSelector:@selector(gameListTableViewcellDidFinishCountDown:)]) {
                
                [_delegate gameListTableViewcellDidFinishCountDown:self];
            }
            
        }
    }
    
}

@end
