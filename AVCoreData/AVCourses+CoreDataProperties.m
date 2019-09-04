//
//  AVCourses+CoreDataProperties.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVCourses+CoreDataProperties.h"

@implementation AVCourses (CoreDataProperties)

+ (NSFetchRequest<AVCourses *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AVCourses"];
}

@dynamic facultet;
@dynamic name;
@dynamic spechial;
@dynamic teahers;
@dynamic university;
@dynamic users;

@end
