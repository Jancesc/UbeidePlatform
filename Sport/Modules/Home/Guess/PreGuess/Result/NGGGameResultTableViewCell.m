//
//  NGGGameResultTableViewCell.m
//  Sport
//
//  Created by Jan on 21/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGameResultTableViewCell.h"
#import "JYCommonTool.h"

@interface NGGGameResultTableViewCell () {
    
    __weak IBOutlet UILabel *_homeResultLabel;
    __weak IBOutlet UILabel *_homeNameLabel;
    __weak IBOutlet UILabel *_awayResultLabel;
    __weak IBOutlet UILabel *_awayNameLabel;
    __weak IBOutlet UILabel *_timeLabel;
}
@end

@implementation NGGGameResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
    
    NSArray *scoreArray = [cellInfo arrayForKey:@"score"];
    _homeNameLabel.text = [cellInfo stringForKey:@"h_name"];
    _awayNameLabel.text = [cellInfo stringForKey:@"a_name"];
    _homeResultLabel.text =  [@([scoreArray[0] integerValue]) stringValue];
    _awayResultLabel.text =   [@([scoreArray[1] integerValue]) stringValue];;
    _timeLabel.text = [JYCommonTool dateFormatWithInterval:[cellInfo intForKey:@"match_time"] format:@"yyyy-MM-dd"];
}

@end
