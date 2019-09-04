//
//  AVUsers+CoreDataProperties.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVUsers+CoreDataProperties.h"

@implementation AVUsers (CoreDataProperties)

+ (NSFetchRequest<AVUsers *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AVUsers"];
}

@dynamic email;
@dynamic firstName;
@dynamic lastname;
@dynamic coursesLearn;
@dynamic coursesTeahers;
@dynamic university;

@end
