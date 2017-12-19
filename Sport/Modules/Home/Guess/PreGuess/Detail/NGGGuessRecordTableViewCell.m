//
//  NGGGuessRecordTableViewCell.m
//  Sport
//
//  Created by Jan on 18/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessRecordTableViewCell.h"
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
    
    _timeLabel.text = _model.timeStamp;
    _typeLabel.text = _model.sectionName;
    _itemLabel.text = _model.itemName;
    _oddsLabel.text = _model.odds;
    _countLabel.text = _model.money;
    _profitLabel.text = _model.profit;
}

@end
