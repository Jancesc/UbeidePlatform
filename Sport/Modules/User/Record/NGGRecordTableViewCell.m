//
//  NGGRecordTableViewCell.m
//  Sport
//
//  Created by Jan on 28/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGRecordTableViewCell.h"
#import "JYCommonTool.h"

@interface NGGRecordTableViewCell (){
    
    __weak IBOutlet UIImageView *_homeImageView;
    __weak IBOutlet UILabel *_homeNameLabel;
    __weak IBOutlet UILabel *_homeScoreLabel;
    
    __weak IBOutlet UIImageView *_awayImageView;
    __weak IBOutlet UILabel *_awayNameLabel;
    __weak IBOutlet UILabel *_awayScoreLabel;
    
    __weak IBOutlet UILabel *_totalLabel;
    __weak IBOutlet UILabel *_dateLaebl;

}

@end

@implementation NGGRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code]
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//"match_id": "102334",
//"h_name": "莱万特",
//"a_name": "莱加内斯",
//"match_time": "1513715400",
//"score": [
//          "0",
//          "0"
//          ],
//"result": "竞猜中"
- (void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
    
    _homeNameLabel.text = [cellInfo stringForKey:@"h_name"];
    _awayNameLabel.text = [cellInfo stringForKey:@"a_name"];
    NSString *timeStamp =  [JYCommonTool dateFormatWithInterval:[cellInfo intForKey:@"match_time"] format:@"yyyy-MM-dd hh:mm"];
    _dateLaebl.text = [NSString stringWithFormat:@"比赛时间:%@", timeStamp];
    
    if ([cellInfo floatForKey:@"result"] > 0) {
        
        _totalLabel.textColor = NGGThirdColor;
    } else if ([cellInfo floatForKey:@"result"] < 0) {
        
        _totalLabel.textColor = NGGPrimaryColor;
    }
    
    _totalLabel.text = [cellInfo stringForKey:@"result"];
    
    NSArray *scoreArray = [cellInfo arrayForKey:@"score"];
    _homeScoreLabel.text = [scoreArray firstObject];
    _awayScoreLabel.text = [scoreArray lastObject];
}

@end
