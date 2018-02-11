//
//  NGGDarenGameDetailPrizeTableViewCell.m
//  Sport
//
//  Created by Jan on 11/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameDetailPrizeTableViewCell.h"

@interface NGGDarenGameDetailPrizeTableViewCell () {
    
    __weak IBOutlet UILabel *_rankLabel;
    __weak IBOutlet UIImageView *_rankImageView;
    __weak IBOutlet UILabel *_countLabel;
}

@end

@implementation NGGDarenGameDetailPrizeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCount:(NSString *)count {
    
    _count = count;
    
    _countLabel.text = [NSString stringWithFormat:@"%@个", count];
 
}

-(void)setIndex:(NSInteger)index {
    
    _index = index;
    
    if (index < 3) {
        
        _rankLabel.hidden = YES;
        _rankImageView.hidden = NO;
        NSString *imageStr = [NSString stringWithFormat:@"rank%ld", (long)index + 1];
        _rankImageView.image = [UIImage imageNamed:imageStr];
    } else {
        
        _rankLabel.hidden = NO;
        _rankImageView.hidden = YES;
        _rankLabel.text = @(index + 1).stringValue;
    }
}

@end
