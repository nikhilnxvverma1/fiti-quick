//
//  ExerciseCircle.m
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import "ExerciseCircle.h"
#import "Util.h"

@implementation ExerciseCircle

-(id)initWithFrame:(CGRect)frame exercise:(Exercise*)exercise{
    if(self=[super initWithFrame:frame]){
        self.exercise=exercise;
        
        // border radius
        [self.layer setCornerRadius:frame.size.width/2];
        
        [self.layer setBackgroundColor:[Util r:85 g:149 b:105].CGColor];
        
        // drop shadow
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.7];
        [self.layer setShadowRadius:frame.size.width/3];
        [self.layer setShadowOffset:CGSizeMake(frame.size.width/10, frame.size.width/10 )];
        
        [self addLabel:frame];
       
    }
    return self;
}

-(void)addLabel:(CGRect)frame{
    NSArray *array = [_exercise.name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];

    float dy=frame.size.height/5;
    //TODO for now we will hardcode the logic right in depending on how
    //many words we have
    float y;
    if(array.count==1){
        y=frame.size.height/2-0.5*dy;
    }else if(array.count==2){
        y=frame.size.height/2-1.0*dy;
    }else if(array.count==3){
        y=frame.size.height/2-1.5*dy;
    }else{
        y=frame.size.height/2-2*dy;
    }
    for(NSString *word in array){
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, y, frame.size.width, frame.size.height/5)];
        label.text=word;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        [self addSubview:label];
        y+=dy;
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
