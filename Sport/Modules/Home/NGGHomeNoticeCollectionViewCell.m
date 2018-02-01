//
//  NGGHomeNoticeCollectionViewCell.m
//  sport
//
//  Created by Jan on 26/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGHomeNoticeCollectionViewCell.h"

@interface NGGHomeNoticeCollectionViewCell () {
    
}
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (nonatomic, assign) NSInteger index;

@end

@implementation NGGHomeNoticeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)noticeAnimation{
    
    NSString *text = _arrayOfNotice[_index % [_arrayOfNotice count]];
    CGFloat textWidth =  [self calculateLabelWidth:text];

    _noticeLabel.text = text;
    _noticeLabel.frame = CGRectMake(SCREEN_WIDTH, 0, textWidth, self.bounds.size.height);
    _index++;
    
    NGGWeakSelf
    
    [UIView animateWithDuration:(SCREEN_WIDTH - 106 + textWidth) / 60.0 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
       
        _noticeLabel.frame = cgrX(_noticeLabel.frame, 106 - textWidth);
    } completion:^(BOOL finished) {

        [weakSelf noticeAnimation];
    }];
   
}

- (void)setArrayOfNotice:(NSArray *)arrayOfNotice {
    
    _arrayOfNotice = arrayOfNotice;
    
    if ([_arrayOfNotice count] > 0) {
       
        [self noticeAnimation];
    }
}

- (CGFloat)calculateLabelWidth:(NSString *)text {
    
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.width;
}
@end
