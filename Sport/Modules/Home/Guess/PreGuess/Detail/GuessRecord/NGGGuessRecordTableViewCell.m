//
//  NGGGuessRecordTableViewCell.m
//  Sport
//
//  Created by Jan on 18/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessRecordTableViewCell.h"
#import "JYCommonTool.h"

@interface NGGGuessRecordTableViewCell () {
    
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_typeLabel;
    __weak IBOutlet UILabel *_itemLabel;
    __weak IBOutlet UILabel *_oddsLabel;
    __weak IBOutlet UILabel *_countLabel;
    __weak IBOutlet UILabel *_profitLabel;

}

@end
@implementation NGGGuessRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NGGGuessRecordModel *)model {
    
    _model = model;
    
    _timeLabel.text = [JYCommonTool dateFormatWithInterval:_model.timeStamp.integerValue format:@"HH:mm"];
    _typeLabel.text = _model.sectionName;
    _itemLabel.text = _model.itemName;
    _oddsLabel.text = [JYCommonTool stringDisposeWithFloat:_model.odds.floatValue];
    _countLabel.text = _model.money;
    _profitLabel.text = [JYCommonTool stringDisposeWithFloat:_model.profit.floatValue];
}

@end
