//
//  NGGDateListView.h
//  sport
//
//  Created by Jan on 30/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGGGameDateModel.h"

@protocol NGGDateListViewDelegate<NSObject>

- (void)dateListViewDidSelectItem:(NGGGameDateModel *)model atIndex:(NSInteger)index;

@end

@interface NGGDateListView : UIScrollView

@property (nonatomic, assign) NSInteger dateSelectedIndex;

@property (nonatomic, strong) NSArray *arrayOfDate;

@property (nonatomic, weak) id <NGGDateListViewDelegate> listViewdelegate;

@end
