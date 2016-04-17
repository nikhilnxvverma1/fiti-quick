//
//  ExerciseCircle.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@interface ExerciseCircle : UIView
-(id)initWithFrame:(CGRect)frame exercise:(Exercise*)exercise;
@property (weak,nonatomic) Exercise *exercise;
@end
