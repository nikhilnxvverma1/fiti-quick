//
//  WorkoutCard.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
@interface WorkoutCard : UITableViewCell
@property (weak,nonatomic) Workout *workout;

@end
