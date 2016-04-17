//
//  Util.m
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//

#import "Util.h"

@implementation Util

+(UIColor*)r:(int)r g:(int)g b:(int)b{
    return [UIColor colorWithRed:(float)r/256 green:(float)g/256 blue:(float)b/256 alpha:256];
}

+(BOOL) isToday:(NSDate *)date{
    return [[Util onlyDate:date] isEqualToDate:[self onlyDate:[NSDate date]]];
}

+(NSDate *)onlyDate:(NSDate*)date{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:date];
    
    return [calendar dateFromComponents:components];
    
}

+ (NSDate*) dateFloor:(NSDate*) date {
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* dateComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    
    return [gregorian dateFromComponents:dateComponents];
}

+ (NSDate*) dateCeil:(NSDate*) date {
        NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* dateComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
        
        [dateComponents setHour:23];
        [dateComponents setMinute:59];
        [dateComponents setSecond:59];
        
        return [gregorian dateFromComponents:dateComponents];
}

+ (float) heightForNumberOfLines:(int)lines{
    return lines*22.5;
}



@end
