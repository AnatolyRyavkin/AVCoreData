//
//  AVUnivers+CoreDataClass.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVUnivers+CoreDataClass.h"
#import "AVCourses+CoreDataClass.h"
#import "AVUsers+CoreDataProperties.h"


@implementation AVUnivers


-(id)initWithContext:(NSManagedObjectContext *)context{

    AVUnivers*univer = [NSEntityDescription insertNewObjectForEntityForName:@"AVUnivers" inManagedObjectContext:context];
    [univer setValue:@"TGU" forKey:@"name"];
    univer.name=@"TulGU";
    NSMutableSet*setCourses = [[NSMutableSet alloc]init];
    int countCourses=54;//arc4random_uniform(3);        MAX=54 !!!!!
    NSMutableSet*setNameCourseAlreadyUse=[[NSMutableSet alloc]init];
    for(int i=0;i<countCourses;i++){
        AVCourses*course=[[AVCourses alloc]initWithContext:context setNameCourseAlreadyUse:setNameCourseAlreadyUse];
        course.university = univer;
        [setNameCourseAlreadyUse addObject:course.name];
        int countStudentsAtCourse =arc4random_uniform(20);
        for(int j=0;j<countStudentsAtCourse;j++){
            AVUsers*user = [[AVUsers alloc]initWithContext:context];
            user.university = univer;
            [course addUsersObject:user];
        }
        [setCourses addObject:course];
    }

    [univer addCourses:(NSSet*)setCourses];



    NSArray*arrayUsers = [self getArrayAtNameEnyityString:@"AVUsers" withContext:context];
    NSArray*arrayCourses = [self getArrayAtNameEnyityString:@"AVCourses" withContext:context];
    for(int i = 0;i<54;i++){
        AVCourses*coursesForTeahe = [arrayCourses objectAtIndex:i];
        uint32_t num = (int)arrayUsers.count;
        int numUser = arc4random_uniform(num);
        AVUsers*user = [arrayUsers objectAtIndex:numUser];
        [user addCoursesTeahersObject:coursesForTeahe];
    }



    for(AVUsers*user in arrayUsers){
        NSMutableSet*set = [[NSMutableSet alloc]initWithArray:arrayCourses];
        int countCourse=arc4random_uniform(5)+5;
        while (user.coursesLearn.count<=countCourse){
            [set minusSet:user.coursesLearn];
            AVCourses*course = [set anyObject];
            [user addCoursesLearnObject:course];
            [set removeObject:course];
        }
    }
    [self saveContext:context];
    return self;
}

-(NSArray*)getArrayAtNameEnyityString:(NSString*)nameEntityString withContext:(NSManagedObjectContext*)context{
    NSEntityDescription*entity = [NSEntityDescription entityForName:nameEntityString inManagedObjectContext:context];
    NSFetchRequest*request = [[NSFetchRequest alloc]init];
    request.entity = entity;
    request.resultType =  NSManagedObjectResultType;
    NSError* error = nil;
    NSArray*array = [context executeFetchRequest:request error:&error];
    return array;
}

- (void)saveContext:(NSManagedObjectContext*)context {
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



@end
