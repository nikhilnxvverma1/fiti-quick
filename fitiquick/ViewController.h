//
//  ViewController.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)upSwipe:(id)sender;
- (IBAction)downSwipe:(id)sender;
- (IBAction)rightSwipe:(id)sender;
- (IBAction)leftSwipe:(id)sender;



@property (weak, nonatomic) IBOutlet UILabel *digitalClock;

@end

