//
//  WorkoutCard.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
@interface WorkoutCard : UIView
@property (weak,nonatomic) Workout *workout;

-(id)initWithFrame:(CGRect)frame workout:(Workout*)workout;

@end
