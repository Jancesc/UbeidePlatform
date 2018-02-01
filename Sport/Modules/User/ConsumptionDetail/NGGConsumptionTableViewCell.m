//
//  NGGConsumptionTableViewCell.m
//  Sport
//
//  Created by Jan on 11/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGConsumptionTableViewCell.h"
#import "JYCommonTool.h"

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

- (void)setCellInfo:(NSDictionary *)cellInfo {
    
//    "bean": "1000",
//    "title": "金币兑换",
//    "explain": "金币兑换获得金豆10000000",
//    "ct": "1512165810"
    _cellInfo = cellInfo;
    _titleLabel.text = [cellInfo stringForKey:@"title"];
    _descriptionLabel.text = [cellInfo stringForKey:@"explain"];

    NSString *countString = nil;
    if ([[cellInfo allKeys] containsObject:@"coin"]) {
        
        countString = [cellInfo stringForKey:@"coin"];
    } else {
     
        countString = [cellInfo stringForKey:@"bean"];;
    }
    
    if ([countString containsString:@"-"]) {
       
        _countLabel.textColor = NGGPrimaryColor;
        _countLabel.text = countString;
    } else {
        
        _countLabel.textColor = NGGThirdColor;
        _countLabel.text = [NSString stringWithFormat:@"+%@", countString];
    }
    _timeLabel.text = [JYCommonTool dateFormatWithInterval:[cellInfo intForKey:@"ct"] format:@"HH:mm:ss"];
    _dateLabel.text = [JYCommonTool dateFormatWithInterval:[cellInfo intForKey:@"ct"] format:@"yyyy:MM:dd"];

}

@end
