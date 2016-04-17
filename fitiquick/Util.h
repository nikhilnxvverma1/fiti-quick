//
//  Util.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface Util : NSObject

+(UIColor*)r:(int)r g:(int)g b:(int)b;
+(BOOL) isToday:(NSDate *)date;
+(NSDate *)onlyDate:(NSDate*)date;
+ (NSDate*) dateFloor:(NSDate*) date;
+ (NSDate*) dateCeil:(NSDate*) date;
+ (float) heightForNumberOfLines:(int)lines;
@end
