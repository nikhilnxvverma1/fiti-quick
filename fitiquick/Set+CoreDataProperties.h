//
//  Set+CoreDataProperties.h
//  fitiquick
//
//  Created by Nikhil Verma on 16/04/16.
//  Copyright © 2016 Nikhil Verma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Set.h"

NS_ASSUME_NONNULL_BEGIN

@interface Set (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *reps;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) NSManagedObject *workout;

@end

NS_ASSUME_NONNULL_END
