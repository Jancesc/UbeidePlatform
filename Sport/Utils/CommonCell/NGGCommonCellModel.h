//
//  NGGCommonCellModel.h
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"

typedef NS_ENUM(NSUInteger, NGGCommonCellType) {
    
    NGGCommonCellTypeImage = 1,
    NGGCommonCellTypeText = 2,
    NGGCommonCellTypeSwitch = 3
};

@interface NGGCommonCellModel : NGGModel

@property (nonatomic, assign) NGGCommonCellType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *value;
@end
