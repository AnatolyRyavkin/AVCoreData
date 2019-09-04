//
//  AVUsers+CoreDataProperties.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVUsers+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AVUsers (CoreDataProperties)

+ (NSFetchRequest<AVUsers *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastname;
@property (nullable, nonatomic, retain) NSSet<AVCourses *> *coursesLearn;
@property (nullable, nonatomic, retain) NSSet<AVCourses *> *coursesTeahers;
@property (nullable, nonatomic, retain) AVUnivers *university;

@end

@interface AVUsers (CoreDataGeneratedAccessors)

- (void)addCoursesLearnObject:(AVCourses *)value;
- (void)removeCoursesLearnObject:(AVCourses *)value;
- (void)addCoursesLearn:(NSSet<AVCourses *> *)values;
- (void)removeCoursesLearn:(NSSet<AVCourses *> *)values;

- (void)addCoursesTeahersObject:(AVCourses *)value;
- (void)removeCoursesTeahersObject:(AVCourses *)value;
- (void)addCoursesTeahers:(NSSet<AVCourses *> *)values;
- (void)removeCoursesTeahers:(NSSet<AVCourses *> *)values;

@end

NS_ASSUME_NONNULL_END
