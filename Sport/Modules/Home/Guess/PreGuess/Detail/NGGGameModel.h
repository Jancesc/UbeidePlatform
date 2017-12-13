//
//  NGGGameModel.h
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"
#import "NGGGuessSectionModel.h"
@interface NGGGameModel : NGGModel

@property (nonatomic, assign) BOOL isForbid;
@property (nonatomic, strong) NSString *matchID;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, strong) NSArray *arrayOfSection;

@end
