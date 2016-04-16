//
//  ViewController.m
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import "ViewController.h"
#import "Util.h"



@interface ViewController ()
@property BOOL readyForAnimation;
@property int level;
@end

@implementation ViewController
@synthesize readyForAnimation;
@synthesize level;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self makeViews];
    [self updateTime];
    readyForAnimation=YES;
    level=0;
    
}

-(void)makeViews{
    CGRect frameSize=[[UIScreen mainScreen] bounds];
    float h=frameSize.size.height;
    float w=frameSize.size.width;
    
    //calendar
    _calendarContentView=[[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, h/10-h, w, h/3)];
    [self.view addSubview:_calendarContentView];
    _calendarMenuView=[[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0-h, w, h/10)];
    [self.view addSubview:_calendarMenuView];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    //digital clock
    _digitalClock=[[UILabel alloc] initWithFrame:CGRectMake(0, h/2, w, 30)];
    _digitalClock.textAlignment=NSTextAlignmentCenter;
    _digitalClock.textColor=[Util r:85 g:149 b:105];
    [self.view addSubview:_digitalClock];
    
    //reps
    _reps=[[UILabel alloc] initWithFrame:CGRectMake(0, h/6+h, w, 30)];
    _reps.text=@"Reps";
    _reps.textAlignment=NSTextAlignmentCenter;
    _reps.textColor=[Util r:85 g:149 b:105];
    [self.view addSubview:_reps];
    
    //rep value
    _repValue=[[AKPickerView alloc] initWithFrame:CGRectMake(0, h/4+h, w, 3*h/4)];
    _repValue.delegate=self;
    _repValue.dataSource=self;
    _repValue.interitemSpacing=20;
    [self.view addSubview:_repValue];
    [_repValue reloadData];
    
    //weight
    _weights=[[UILabel alloc] initWithFrame:CGRectMake(0, h/6+2*h, w, 30)];
    _weights.text=@"Weight";
    _weights.textAlignment=NSTextAlignmentCenter;
    _weights.textColor=[Util r:85 g:149 b:105];
    [self.view addSubview:_weights];
    
    _weightValue=[[AKPickerView alloc] initWithFrame:CGRectMake(0, h/4+2*h, w, 3*h/4)];
    _weightValue.delegate=self;
    _weightValue.dataSource=self;
    _weightValue.interitemSpacing=20;
    [self.view addSubview:_weightValue];
    [_weightValue reloadData];
    
    //exercise
    _exercise=[[UILabel alloc] initWithFrame:CGRectMake(0, h/6+3*h, w, 30)];
    _exercise.text=@"Exercise";
    _exercise.textAlignment=NSTextAlignmentCenter;
    _exercise.textColor=[Util r:85 g:149 b:105];
    [self.view addSubview:_exercise];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView{
    if(pickerView==_repValue){
        return 30;
    }else if(pickerView==_weightValue){
        return 30;
    }
    return 10;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item{
    if(pickerView==_repValue){
        return [NSString stringWithFormat:@"%d",item+1];
    }else if(pickerView==_weightValue){
        return [NSString stringWithFormat:@"%d",item*5];
    }
    return @"!";
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    NSLog(@"selected %d",item);
}

-(void)updateTime{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    self.digitalClock.text=[formatter stringFromDate:[NSDate date]];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}


- (IBAction)rightSwipe:(id)sender {
    NSLog(@"Swiped right");
}

- (IBAction)leftSwipe:(id)sender {
    NSLog(@"Swiped left");
}

- (IBAction)upSwipe:(id)sender {
    NSLog(@"Swiped up");
    if(readyForAnimation&&level<3){
        readyForAnimation=NO;
        
        //move primary things up first
        CGRect frameSize=[[UIScreen mainScreen] bounds];
        float h=frameSize.size.height;

        CGPoint calContentPt=self.calendarContentView.center;
        calContentPt.y-=h;
        
        CGPoint calMenuPt=self.calendarMenuView.center;
        calMenuPt.y-=h;
        
        CGPoint digitalClockPoint=self.digitalClock.center;
        digitalClockPoint.y-=h;
        
        CGPoint repsPoint=self.reps.center;
        repsPoint.y-=h;
        
        CGPoint weightsPoint=self.weights.center;
        weightsPoint.y-=h;
        
        CGPoint exercisePoint=self.exercise.center;
        exercisePoint.y-=h;

        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
             self.calendarContentView.center=calContentPt;
             self.calendarMenuView.center=calMenuPt;
             self.digitalClock.center=digitalClockPoint;
             self.reps.center=repsPoint;
             self.weights.center=weightsPoint;
             self.exercise.center=exercisePoint;
        }
                         completion:^(BOOL finished){
            readyForAnimation=YES;
        }];
        
        //move secondary things up after a delay

        CGPoint repVPoint=self.repValue.center;
        repVPoint.y-=h;
        
        CGPoint weightVPoint=self.weightValue.center;
        weightVPoint.y-=h;
        
        [UIView animateWithDuration:0.5
                              delay:0.2
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.repValue.center=repVPoint;
                             self.weightValue.center=weightVPoint;

                         }
                         completion:^(BOOL finished){
                             readyForAnimation=YES;
                             level++;
                         }];
    }
}

- (IBAction)downSwipe:(id)sender {
    NSLog(@"Swiped down");
    if(readyForAnimation&&level>=0){
        readyForAnimation=NO;
        CGRect frameSize=[[UIScreen mainScreen] bounds];
        float h=frameSize.size.height;
        
        //move secondary things down first
        CGPoint repVPoint=self.repValue.center;
        repVPoint.y+=h;
        
        CGPoint weightVPoint=self.weightValue.center;
        weightVPoint.y+=h;
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.repValue.center=repVPoint;
                             self.weightValue.center=weightVPoint;
                             
                         }
                         completion:^(BOOL finished){
                             readyForAnimation=YES;
                         }];
        
        
        //move primary items down after a delay
        CGPoint calContentPt=self.calendarContentView.center;
        calContentPt.y+=h;
        
        CGPoint calMenuPt=self.calendarMenuView.center;
        calMenuPt.y+=h;
        
        CGPoint digitalClockPoint=self.digitalClock.center;
        digitalClockPoint.y+=h;
        
        CGPoint repsPoint=self.reps.center;
        repsPoint.y+=h;
        
        CGPoint weightsPoint=self.weights.center;
        weightsPoint.y+=h;
        
        CGPoint exercisePoint=self.exercise.center;
        exercisePoint.y+=h;
        
        [UIView animateWithDuration:0.5
                              delay:0.2
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.calendarContentView.center=calContentPt;
                             self.calendarMenuView.center=calMenuPt;
                             self.digitalClock.center=digitalClockPoint;
                             self.reps.center=repsPoint;
                             self.weights.center=weightsPoint;
                             self.exercise.center=exercisePoint;
                         }
                         completion:^(BOOL finished){
                             readyForAnimation=YES;
                             level--;
                         }];
        
        
    }
    
    
    
}


@end
