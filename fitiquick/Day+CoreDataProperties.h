//
//  Day+CoreDataProperties.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Day.h"

NS_ASSUME_NONNULL_BEGIN

@interface Day (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *workouts;

@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addWorkoutsObject:(NSManagedObject *)value;
- (void)removeWorkoutsObject:(NSManagedObject *)value;
- (void)addWorkouts:(NSSet<NSManagedObject *> *)values;
- (void)removeWorkouts:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
