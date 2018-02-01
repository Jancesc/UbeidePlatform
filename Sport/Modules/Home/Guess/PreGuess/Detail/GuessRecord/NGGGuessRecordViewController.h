//
//  NGGGuessRecordViewController.h
//  Sport
//
//  Created by Jan on 18/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGCommonViewController.h"
#import "NGGGameModel.h"
#import "NGGGuessRecordModel.h"

@interface NGGGuessRecordViewController : NGGCommonViewController

@property (nonatomic, strong) NSArray <NGGGuessRecordModel *> *arrayOfRecord;
@property (nonatomic, strong) NGGGameModel *gameModel;

//另一种方式
@property (nonatomic, strong) NSString *gameID;

@end
