//
//  AVUsers+CoreDataClass.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "AVAbstractEntity+CoreDataClass.h"

@class AVCourses, AVUnivers;

NS_ASSUME_NONNULL_BEGIN

@interface AVUsers: AVAbstractEntity

-(id)initWithContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "AVUsers+CoreDataProperties.h"
