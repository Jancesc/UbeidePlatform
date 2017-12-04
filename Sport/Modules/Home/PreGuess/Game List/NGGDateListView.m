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

@end

@implementation NGGDateListView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.pagingEnabled = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)setArrayOfDate:(NSArray *)arrayOfDate {
    
    _arrayOfDate = arrayOfDate;
    [self refreshData];
}

- (void)refreshData {
    
    for (UIView *subview in self.subviews) {
        
        [subview removeFromSuperview];
    }
    NSInteger itemCount = [_arrayOfDate count];
    CGFloat lastViewLeftX = 0;
    for (NSInteger index = 0; index < itemCount; index++) {
        
        NGGDateListItemView *itemView = [[NGGDateListItemView alloc] initWithFrame:CGRectMake(lastViewLeftX, 0, 85, VIEW_H(self))];
        itemView.tag = index;
        itemView.model = _arrayOfDate[index];
        [itemView addTarget:self action:@selector(dateItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemView];
        lastViewLeftX += VIEW_W(itemView);
    }
    
    self.contentSize = CGSizeMake(lastViewLeftX, VIEW_H(self));
}

- (void)dateItemClicked:(NGGDateListItemView *)itemView {
    
    itemView.selected = YES;
    if (_listViewdelegate && [_listViewdelegate respondsToSelector:@selector(dateListViewDidSelectItem:atIndex:)]) {
    
        [_listViewdelegate dateListViewDidSelectItem:_arrayOfDate[itemView.tag] atIndex:itemView.tag];
    }
}
@end
