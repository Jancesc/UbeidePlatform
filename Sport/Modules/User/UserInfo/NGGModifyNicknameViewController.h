//
//  NGGModifyNicknameViewController.h
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGCommonViewController.h"
#import "NGGCommonCellModel.h"

@interface NGGModifyNicknameViewController : NGGCommonViewController

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) NGGCommonCellModel *model;
@property (nonatomic, copy) void(^completion)(NSString *text);

@end
