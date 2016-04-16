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
@end
