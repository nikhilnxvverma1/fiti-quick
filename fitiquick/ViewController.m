//
//  ViewController.m
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import "ViewController.h"
#import "Util.h"
#import "AppDelegate.h"
#import "Exercise.h"
#import "ExerciseCircle.h"
#import "WorkoutCard.h"
#import "ExerciseView.h"
#import "Day.h"
#import "Set.h"

@interface ViewController ()
@property BOOL readyForAnimation;
@property int level;
@property NSArray *exerciseArray;
@property Workout *currentWorkout;
@property Day *today;
@property NSDate *dateSelected;
@end

@implementation ViewController
@synthesize readyForAnimation;
@synthesize level;
@synthesize exerciseArray;
@synthesize currentWorkout;
@synthesize today;
@synthesize dateSelected;

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
    
    self.goDown=[[UIButton alloc] initWithFrame:CGRectMake(w/2-w/10, -h/10, w/5, h/10)];
    [self.goDown setTitle:@"Down" forState:UIControlStateNormal];
    [self.goDown addTarget:self action:@selector(moveItemsUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goDown];
    
    
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
    
    [self initExercises];

}

-(void)initExercises{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    exerciseArray = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to fetch exercises.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        CGRect frameSize=[[UIScreen mainScreen] bounds];
        float h=frameSize.size.height;
        float w=frameSize.size.width;
        
        Exercise *first=[exerciseArray objectAtIndex:0];
        NSLog(@"Exercise : %@, %@",first.name,first.bodypart);
        _selectedExercise=[[ExerciseView alloc] initWithFrame:CGRectMake(w/2-w/8, h/4+3*h, w/4, w/4)];
        [self.view addSubview:_selectedExercise];
        [self.selectedExercise setExercise:first];
        
        WorkoutCard *workoutCard=[[WorkoutCard alloc] initWithFrame:CGRectMake(25, 200, 275, 150) workout:nil];
//        [self.view addSubview:workoutCard];
        
        
        //setup a flow layout for the exercise collection
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(w/4, w/4)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        self.exerciseCollection=[[UICollectionView alloc]  initWithFrame:CGRectMake(0, h/2+3*h, w, h/2)
                                                    collectionViewLayout:flowLayout];
        self.exerciseCollection.delegate=self;
        self.exerciseCollection.dataSource=self;
        self.exerciseCollection.backgroundView=nil;
        self.exerciseCollection.backgroundColor=[self.exerciseCollection.backgroundColor colorWithAlphaComponent:0];
        [self.exerciseCollection registerClass:[ExerciseCircle class] forCellWithReuseIdentifier:@"exerciseCircle"];
        [self.view addSubview:self.exerciseCollection];
    }
    
}

#pragma mark Exercises

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Exercise *data = [exerciseArray objectAtIndex:indexPath.item];
    
    static NSString *cellIdentifier = @"exerciseCircle";
    
    ExerciseCircle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.exercise=data;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath.row];
    Exercise* exercise=[exerciseArray objectAtIndex:indexPath.row];
    NSLog(@"selected %@",exercise.name);
    [self.selectedExercise setExercise:exercise];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.exerciseArray count];
}

#pragma mark calendar

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Test if the dayView is from another month than the page
    // Use only in month mode for indicate the day of the previous or next month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(dateSelected && [_calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    // Your method to test if a date have an event for example
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

-(BOOL)haveEventForDay:(NSDate*)date{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDate *startDate=[Util dateFloor:date];
    
    NSDate *endDate=[Util dateCeil:date];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Day" inManagedObjectContext:delegate.managedObjectContext]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    
    return results.count>0;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    // Use to indicate the selected date
    dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
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
        return [NSString stringWithFormat:@"%d",[self valueForRepIndex:(int)item]];
    }else if(pickerView==_weightValue){
        return [NSString stringWithFormat:@"%d",[self valueForWeightIndex:(int)item]];
    }
    return @"!";
}

-(int) valueForRepIndex:(int) item{
    return item+1;
}

-(int) valueForWeightIndex:(int) item{
    return item*2.5;
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    NSLog(@"selected %ld",item);
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

- (void)moveItemsUp {
    if(readyForAnimation){
        CGRect frameSize=[[UIScreen mainScreen] bounds];
        float h=frameSize.size.height;
        float w=frameSize.size.width;
        
        if(level<3){
            readyForAnimation=NO;
            
            //move primary things up first

            
            CGPoint calContentPt=self.calendarContentView.center;
            calContentPt.y-=h;
            
            CGPoint calMenuPt=self.calendarMenuView.center;
            calMenuPt.y-=h;
            
            CGPoint goDownPt=self.goDown.center;
            goDownPt.y-=h;
            
            CGPoint digitalClockPoint=self.digitalClock.center;
            digitalClockPoint.y-=h;
            
            CGPoint repsPoint=self.reps.center;
            repsPoint.y-=h;
            
            CGPoint weightsPoint=self.weights.center;
            weightsPoint.y-=h;
            
            CGPoint exercisePoint=self.exercise.center;
            exercisePoint.y-=h;
            
            CGPoint selectedExercisePoint=self.selectedExercise.center;
            selectedExercisePoint.y-=h;
            
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.calendarContentView.center=calContentPt;
                                 self.calendarMenuView.center=calMenuPt;
                                 self.goDown.center=goDownPt;
                                 self.digitalClock.center=digitalClockPoint;
                                 self.reps.center=repsPoint;
                                 self.weights.center=weightsPoint;
                                 self.exercise.center=exercisePoint;
                                 self.selectedExercise.center=selectedExercisePoint;
                             }
                             completion:^(BOOL finished){
                                 readyForAnimation=YES;
                             }];
            
            //move secondary things up after a delay
            
            CGPoint repVPoint=self.repValue.center;
            repVPoint.y-=h;
            
            CGPoint weightVPoint=self.weightValue.center;
            weightVPoint.y-=h;
            
            CGPoint exerciseColPoint=self.exerciseCollection.center;
            exerciseColPoint.y-=h;
            
            [UIView animateWithDuration:0.5
                                  delay:0.2
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.repValue.center=repVPoint;
                                 self.weightValue.center=weightVPoint;
                                 self.exerciseCollection.center=exerciseColPoint;
                                 
                             }
                             completion:^(BOOL finished){
                                 readyForAnimation=YES;
                                 level++;
                             }];
        }else{
            readyForAnimation=NO;
            
            [self insertEntry];
            //reset everything back to where it was
            self.calendarContentView.frame=CGRectMake(0, h/10-h, w, h/3);
            self.calendarMenuView.frame=CGRectMake(0, 0-h, w, h/10);
            self.goDown.frame=CGRectMake(w/2-w/10, -h/10, w/5, h/10);
            self.digitalClock.center=CGPointMake(self.digitalClock.center.x,h/2);
            self.reps.center=CGPointMake(self.reps.center.x,h/6+h);
            self.repValue.frame=CGRectMake(0,h/4+h,w,3*h/4);
            self.weights.center=CGPointMake(self.weights.center.x,h/6+2*h);
            self.weightValue.frame=CGRectMake(0,h/4+2*h,w,3*h/4);
            self.exercise.center=CGPointMake(self.exercise.center.x,h/6+3*h);
            self.exerciseCollection.frame=CGRectMake(0, h/2+3*h, w, h/2);
            self.selectedExercise.frame=CGRectMake(w/2-w/8, h/4+3*h, w/4, w/4);
            
            self.digitalClock.alpha=0;
            [UIView animateWithDuration:1.0
                                  delay:0.4
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.digitalClock.alpha=1;
                             }
                             completion:^(BOOL finished){
                                 readyForAnimation=YES;
                                 level=0;
                             }];
            
        }
    }
}

-(void)insertEntry{
    int reps=[self valueForRepIndex:(int)self.repValue.selectedItem];
    int weight=[self valueForRepIndex:(int)self.repValue.selectedItem];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(today==nil||![today.date isEqualToDate:[NSDate date]]){
        today = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                              inManagedObjectContext:delegate.managedObjectContext];
        [today setDate:[NSDate date]];
        
    }
    
    if(currentWorkout==nil||currentWorkout.exercise!=_selectedExercise.exercise){
        currentWorkout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout"
                                                                inManagedObjectContext:delegate.managedObjectContext];
        [currentWorkout setValue:_selectedExercise.exercise forKey:@"exercise"];
        [today addWorkoutsObject:currentWorkout];
    }
    
    Set *set = [NSEntityDescription insertNewObjectForEntityForName:@"Set"
                                                            inManagedObjectContext:delegate.managedObjectContext];
    [set setValue:[NSNumber numberWithInteger:reps] forKey:@"reps"];
    [set setValue:[NSNumber numberWithInteger:weight] forKey:@"weight"];
    [set setValue:currentWorkout forKey:@"workout"];
    
    [currentWorkout addSetsObject:set];
    
    NSError *error;
    if (![delegate.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}

- (IBAction)upSwipe:(id)sender {
    NSLog(@"Swiped up");
    [self moveItemsUp];
}

- (void)moveItemsDown {
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
        
        CGPoint goDownPt=self.goDown.center;
        goDownPt.y+=h;
        
        
        CGPoint digitalClockPoint=self.digitalClock.center;
        digitalClockPoint.y+=h;
        
        CGPoint repsPoint=self.reps.center;
        repsPoint.y+=h;
        
        CGPoint weightsPoint=self.weights.center;
        weightsPoint.y+=h;
        
        CGPoint exercisePoint=self.exercise.center;
        exercisePoint.y+=h;
        
        CGPoint exerciseColPoint=self.exerciseCollection.center;
        exerciseColPoint.y+=h;
        
        CGPoint selectedExercisePoint=self.selectedExercise.center;
        selectedExercisePoint.y+=h;
        
        [UIView animateWithDuration:0.5
                              delay:0.2
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.calendarContentView.center=calContentPt;
                             self.calendarMenuView.center=calMenuPt;
                             self.goDown.center=goDownPt;
                             self.digitalClock.center=digitalClockPoint;
                             self.reps.center=repsPoint;
                             self.weights.center=weightsPoint;
                             self.exercise.center=exercisePoint;
                             self.exerciseCollection.center=exerciseColPoint;
                             self.selectedExercise.center=selectedExercisePoint;
                         }
                         completion:^(BOOL finished){
                             readyForAnimation=YES;
                             level--;
                         }];
    }
}

- (IBAction)downSwipe:(id)sender {
    NSLog(@"Swiped down");
    [self moveItemsDown];
}


@end
