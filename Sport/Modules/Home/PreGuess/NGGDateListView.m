//
//  NGGDateListView.m
//  sport
//
//  Created by Jan on 30/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGDateListView.h"
#import "NGGDateListItemView.h"

@interface NGGDateListItemView ()

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation NGGDateListView


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.pagingEnabled = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)setDateInfo:(NSDictionary *)dateInfo {
    
    _dateInfo = dateInfo;
    
    [self refreshData:dateInfo];
}

- (void)refreshData:(NSDictionary *)dateInfo {
    
    for (UIView *subview in self.subviews) {
        
        [subview removeFromSuperview];
    }
    
    NSInteger itemCount = 10;
    CGFloat lastViewLeftX = 0;
    for (NSInteger index = 0; index < itemCount; index++) {
        
        NGGDateListItemView *listView = [[NGGDateListItemView alloc] initWithFrame:CGRectMake(lastViewLeftX, 0, 70, VIEW_H(self))];
        [listView addTarget:self action:@selector(dateItemClicked:) forControlEvents:UIControlEventTouchUpInside];
//        listView.backgroundColor = NGGRandomColor;
        [self addSubview:listView];
        lastViewLeftX += VIEW_W(listView);
        
    }
    self.contentSize = CGSizeMake(lastViewLeftX, VIEW_H(self));

}


- (void)dateItemClicked:(NGGDateListItemView *)itemView {
    
    itemView.selected = YES;
}
@end
