//
//  WorkoutCard.m
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import "WorkoutCard.h"
#import "Util.h"

@implementation WorkoutCard

-(id)initWithFrame:(CGRect)frame workout:(Workout*)workout{
    if(self=[super initWithFrame:frame]){
        self.workout=workout;
        self.layer.backgroundColor=[Util r:75 g:76 b:108].CGColor;
        
        UIView *sideBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/25, frame.size.height)];
        sideBar.layer.backgroundColor=[Util r:85 g:148 b:106].CGColor;
        [self addSubview:sideBar];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
