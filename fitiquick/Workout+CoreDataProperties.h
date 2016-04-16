//
//  Workout+CoreDataProperties.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Workout.h"

NS_ASSUME_NONNULL_BEGIN

@interface Workout (CoreDataProperties)

@property (nullable, nonatomic, retain) NSManagedObject *exercise;
@property (nullable, nonatomic, retain) NSSet<Set *> *sets;
@property (nullable, nonatomic, retain) Day *day;

@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addSetsObject:(Set *)value;
- (void)removeSetsObject:(Set *)value;
- (void)addSets:(NSSet<Set *> *)values;
- (void)removeSets:(NSSet<Set *> *)values;

@end

NS_ASSUME_NONNULL_END
