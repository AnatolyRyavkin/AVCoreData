//
//  AVUnivers+CoreDataProperties.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVUnivers+CoreDataProperties.h"

@implementation AVUnivers (CoreDataProperties)

+ (NSFetchRequest<AVUnivers *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AVUnivers"];
}

@dynamic name;
@dynamic courses;
@dynamic users;

@end
