//
//  NGGGuessCollectionViewCell.m
//  Sport
//
//  Created by Jan on 08/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessCollectionViewCell.h"

@interface NGGGuessCollectionViewCell() {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIView *_disableView;
    __weak IBOutlet UILabel *_oddsLabel;
}

@end

@implementation NGGGuessCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
    _titleLabel.text = model.title;
    _oddsLabel.text = model.odds;
    
    if (_model.isGuessed) {
        
        [self updateUIForGuessed];
    } else {
        
        [self updateUIForNormal];
    }
}

- (void)updateUIForNormal {
    
    _titleLabel.textColor = NGGColor333;
    _oddsLabel.textColor = NGGColor666;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)updateUIForGuessed {
    
    _titleLabel.textColor = [UIColor whiteColor];
    _oddsLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = NGGViceColor;
}

- (void)updateUIForSelected {
    
    _titleLabel.textColor = [UIColor whiteColor];
    _oddsLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = NGGThirdColor;
}

@end
