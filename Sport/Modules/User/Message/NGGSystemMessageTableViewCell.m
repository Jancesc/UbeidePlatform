//
//  NGGSystemMessageTableViewCell.m
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGSystemMessageTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface NGGSystemMessageTableViewCell () {
    
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UIImageView *_headerImageView;
    __weak IBOutlet UIButton *_contentBGButton;
    __weak IBOutlet UILabel *_contentLabel;
}

@end

@implementation NGGSystemMessageTableViewCell

+(CGFloat)rowHeightWithCellInfo:(NSDictionary *)cellInfo {
    
    CGFloat contentHeight = 0;
    //分段样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = 6.f;;
    NSAttributedString *content = [[NSAttributedString alloc] initWithString:[cellInfo stringForKey:@"content"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : paragraphStyle}];
    
    contentHeight = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 48 - 89, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    if (contentHeight < 30) {//一行
        
        contentHeight = 40;
    }  if (contentHeight < 40) {//两行
        
        contentHeight = 50;
    }
    return contentHeight + 60;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}


- (void)setup {
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerImageView.layer.cornerRadius = 22.5f;
    _headerImageView.clipsToBounds = YES;
    self.contentView.backgroundColor = NGGGlobalBGColor;
    [_contentBGButton setBackgroundImage:[[UIImage imageNamed:@"message_bg"]  resizableImageWithCapInsets:UIEdgeInsetsMake(30, 14, 5, 4) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    _contentBGButton.userInteractionEnabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
    
    //分段样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = 6.f;;
    NSAttributedString *content = [[NSAttributedString alloc] initWithString:[cellInfo stringForKey:@"content"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : paragraphStyle}];
    _contentLabel.attributedText = content;
    
    _timeLabel.text = [self dateFormatter:@"1065434"];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"user_img"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
}

- (NSString *)dateFormatter:(NSString *)dateString {
    
    return @"2017/07/31 凌晨";
}

@end

