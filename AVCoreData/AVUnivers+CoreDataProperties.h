//
//  AVUnivers+CoreDataProperties.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//


#import "AVUnivers+CoreDataClass.h"
#import "AVUsers+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AVUnivers (CoreDataProperties)

+ (NSFetchRequest<AVUnivers *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<AVCourses *> *courses;
@property (nullable, nonatomic, retain) NSSet<AVCourses *> *users;

@end

@interface AVUnivers (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(AVCourses *)value;
- (void)removeCoursesObject:(AVCourses *)value;
- (void)addCourses:(NSSet<AVCourses *> *)values;
- (void)removeCourses:(NSSet<AVCourses *> *)values;

- (void)addUsersObject:(AVUsers *)value;
- (void)removeUsersObject:(AVUsers *)value;
- (void)addUsers:(NSSet<AVUsers *> *)values;
- (void)removeUsers:(NSSet<AVUsers *> *)values;

@end

NS_ASSUME_NONNULL_END
