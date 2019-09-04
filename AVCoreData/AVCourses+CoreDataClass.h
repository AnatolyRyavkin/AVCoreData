//
//  AVCourses+CoreDataClass.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "AVAbstractEntity+CoreDataClass.h"

@class AVUnivers, AVCourses;

NS_ASSUME_NONNULL_BEGIN

@interface AVCourses : AVAbstractEntity

-(id)initWithContext:(NSManagedObjectContext *)context setNameCourseAlreadyUse:(NSSet*)setAlready;

@end

NS_ASSUME_NONNULL_END

#import "AVCourses+CoreDataProperties.h"
