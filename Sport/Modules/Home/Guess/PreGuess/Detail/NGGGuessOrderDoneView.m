//
//  NGGGuessOrderDoneView.m
//  Sport
//
//  Created by Jan on 13/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessOrderDoneView.h"
#import "JYCommonTool.h"

@interface NGGGuessOrderDoneView () {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_oddsLabel;
    __weak IBOutlet UILabel *_sectionLabel;
    __weak IBOutlet UILabel *_beanLabel;
    __weak IBOutlet UILabel *_profitLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_principleLabel;
    __weak IBOutlet UIButton *_additionButton;
    __weak IBOutlet UIButton *_closeButton;
    
}
@end

@implementation NGGGuessOrderDoneView

- (void)updateGuessOrderDoneViewWithInfo:(NSDictionary *)info {
    
//    @"itemName" : model.itemName,
//    @"odds" : model.odds,
//    @"bean" : currentUser.bean,
//    @"itemSection" : model.sectionName,
//    @"guessCount" : @(count).stringValue,
//    @"money" : moneyString,
//    @"profit" : profitString,
    
    _titleLabel.text = [info stringForKey:@"itemName"];
    _oddsLabel.text = [NSString stringWithFormat:@"@%@", [info stringForKey:@"odds"]];
    _sectionLabel.text = [NSString stringWithFormat:@"(%@)", [info stringForKey:@"itemSection"]];
    if ([info intForKey:@"isDaren"]) {
        
        _beanLabel.text = [NSString stringWithFormat:@"剩余：%@ 积分", [info stringForKey:@"bean"]];
    } else {
        
        _beanLabel.text = [NSString stringWithFormat:@"剩余：%@ 金豆", [info stringForKey:@"bean"]];
    }
    _timeLabel.text = [NSString stringWithFormat:@"已投%@次", [info stringForKey:@"guessCount"]];
    _principleLabel.text = [NSString stringWithFormat:@"本金%@", [info stringForKey:@"money"]];
      _profitLabel.text = [NSString stringWithFormat:@"猜中盈利%@", [JYCommonTool stringDisposeWithFloat:[info floatForKey:@"profit"]]];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [_additionButton addTarget:self action:@selector(handleAdditionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_additionButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
}
#pragma mark - button actions

- (void)handleAdditionButtonClicked:(UIButton *) button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(guessOrderDoneViewDidClickAdditionButton)]) {
        
        [_delegate guessOrderDoneViewDidClickAdditionButton];
    }
}

- (void)closeButtonClicked:(UIButton *) button {
    
    self.hidden = YES;
}

@end
