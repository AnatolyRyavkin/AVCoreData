//
//  AVCourses+CoreDataProperties.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVCourses+CoreDataClass.h"
#import "AVUsers+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVCourses (CoreDataProperties)

+ (NSFetchRequest<AVCourses *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *facultet;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *spechial;
@property (nullable, nonatomic, retain) AVUsers *teahers;
@property (nullable, nonatomic, retain) AVUnivers *university;
@property (nullable, nonatomic, retain) NSSet<AVUsers*> *users;

@end

@interface AVCourses (CoreDataGeneratedAccessors)

- (void)addUsersObject:(AVUsers *)value;
- (void)removeUsersObject:(AVUsers *)value;
- (void)addUsers:(NSSet<AVUsers *> *)values;
- (void)removeUsers:(NSSet<AVUsers*> *)values;

@end

NS_ASSUME_NONNULL_END
