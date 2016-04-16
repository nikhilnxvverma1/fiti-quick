//
//  ViewController.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"


@interface ViewController : UIViewController<AKPickerViewDataSource,AKPickerViewDelegate>
- (IBAction)upSwipe:(id)sender;
- (IBAction)downSwipe:(id)sender;
- (IBAction)rightSwipe:(id)sender;
- (IBAction)leftSwipe:(id)sender;



@property (strong, nonatomic) UILabel *digitalClock;
@property (strong, nonatomic) UILabel *reps;
@property (strong, nonatomic) AKPickerView *repValue;
@property (strong, nonatomic) UILabel *weights;
@property (strong, nonatomic) AKPickerView *weightValue;
@property (strong, nonatomic) UILabel *exercise;

@end

