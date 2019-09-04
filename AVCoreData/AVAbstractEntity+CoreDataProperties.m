//
//  AVAbstractEntity+CoreDataProperties.m
//  ProjectCoreData
//
//  Created by Anatoly Ryavkin on 06/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVAbstractEntity+CoreDataProperties.h"

@implementation AVAbstractEntity (CoreDataProperties)

+ (NSFetchRequest<AVAbstractEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AVAbstractEntity"];
}


@end
