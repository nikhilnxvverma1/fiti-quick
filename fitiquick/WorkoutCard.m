//
//  WorkoutCard.m
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import "WorkoutCard.h"
#import "Util.h"
#import "Exercise.h"
#import "Set.h"

@interface WorkoutCard()


@end

@implementation WorkoutCard
@synthesize sideBar;

-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        
        self.layer.backgroundColor=[Util r:75 g:76 b:108].CGColor;
        
        sideBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/25, frame.size.height)];
        sideBar.layer.backgroundColor=[Util r:85 g:148 b:106].CGColor;
        [self addSubview:sideBar];
    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
//        self.layer.backgroundColor=[Util r:75 g:76 b:108].CGColor;
        self.backgroundColor=[Util r:75 g:76 b:108];
        
        sideBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/25,90)];
        sideBar.layer.backgroundColor=[Util r:85 g:148 b:106].CGColor;
        [self addSubview:sideBar];
    }
    return self;
}

-(void)setWorkout:(Workout *)workout{
    _workout=workout;
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(25, 3, self.frame.size.width, 20)];
    name.text=workout.exercise.name;
    name.textColor=[UIColor whiteColor];
    [self addSubview:name];
    float y=25;
    float dy=20;
    for(Set *set in workout.sets){
        UILabel *setInfo=[[UILabel alloc] initWithFrame:CGRectMake(25, y, self.frame.size.width, 20)];
        setInfo.text=[NSString stringWithFormat:@"%@ reps @ %@ kgs",set.reps,set.weight];
        [self addSubview:setInfo];
        setInfo.textColor=[UIColor whiteColor];
        y+=dy;
    }
    
    [self addSubview:sideBar];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
