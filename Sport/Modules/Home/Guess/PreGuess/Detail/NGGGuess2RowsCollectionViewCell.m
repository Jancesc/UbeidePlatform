//
//  NGGGuess2RowsCollectionViewCell.m
//  Sport
//
//  Created by Jan on 08/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuess2RowsCollectionViewCell.h"

@interface NGGGuess2RowsCollectionViewCell() {
    
    __weak IBOutlet UILabel *_aboveLabel;
    __weak IBOutlet UILabel *_bottomLabel;
    __weak IBOutlet UIView *_disableView;
}
@end

@implementation NGGGuess2RowsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    _disableView.hidden = YES;
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    if (_model.isGuessed) return;

    if (selected) {
        
        [self updateUIForSelected];
    } else {
        
        [self updateUIForNormal];
    }
}

- (void)setModel:(NGGGuessItemModel *)model {
    
    _model = model;
    _aboveLabel.text = model.title;
    _bottomLabel.text = model.odds;
    
    if (_model.isGuessed) {
        
        [self updateUIForGuessed];
    } else {
        
        [self updateUIForNormal];
    }
}

- (void)updateUIForNormal {
    
    _aboveLabel.textColor = NGGColor333;
    _bottomLabel.textColor = NGGColor666;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)updateUIForGuessed {
    
    _aboveLabel.textColor = [UIColor whiteColor];
    _bottomLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = NGGViceColor;
}

- (void)updateUIForSelected {
    
    _aboveLabel.textColor = [UIColor whiteColor];
    _bottomLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = NGGThirdColor;
}

@end
