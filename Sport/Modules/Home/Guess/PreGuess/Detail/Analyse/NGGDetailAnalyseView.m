//
//  NGGDetailAnalyseView.m
//  Sport
//
//  Created by Jan on 09/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGDetailAnalyseView.h"
#import "NGGAnalyseHistoryView.h"
#import "NGGRecentRecordView.h"
#import "NGGFollowGameView.h"
#import "Masonry.h"

@interface NGGDetailAnalyseView () {
    
    __weak IBOutlet UISegmentedControl *_segmentControl;
    
    NGGAnalyseHistoryView *_historyView;
    NGGRecentRecordView *_recentRecordView;
    NGGFollowGameView *_followGameView;

}
@end

@implementation NGGDetailAnalyseView

#pragma mark - view life circle
- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self configueUIComponents];
}

#pragma mark - private methods

- (void)configueUIComponents {
    
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    _segmentControl.tintColor = NGGSeparatorColor;
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : NGGColor333, NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [_segmentControl setSelectedSegmentIndex:0];
    _segmentControl.layer.borderColor = [NGGSeparatorColor CGColor];
    _segmentControl.layer.cornerRadius = 5.f;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.layer.borderWidth = 1.f;
    
    _historyView = [[[NSBundle mainBundle] loadNibNamed:@"NGGAnalyseHistoryView" owner:nil options:nil] lastObject];
    [self addSubview:_historyView];
    [_historyView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_segmentControl.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    _historyView.hidden = YES;
    _recentRecordView = [[[NSBundle mainBundle] loadNibNamed:@"NGGRecentRecordView" owner:nil options:nil] lastObject];
    [self addSubview:_recentRecordView];
    [_recentRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_segmentControl.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    _recentRecordView.hidden = YES;
    
    _followGameView = [[NGGFollowGameView alloc] init];
    [self addSubview:_followGameView];
    [_followGameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_segmentControl.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}
@end
