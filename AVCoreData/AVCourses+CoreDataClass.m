//
//  AVCourses+CoreDataClass.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVCourses+CoreDataClass.h"

@implementation AVCourses

-(id)initWithContext:(NSManagedObjectContext *)context setNameCourseAlreadyUse:(NSSet*)setAlready{
    self = [super initWithContext:context];
    if(self){
            
            NSLog(@"init course");
        BOOL orig = YES;
        while (orig) {
            NSArray*arraySpechial = [[NSArray alloc]initWithObjects:@"SAULA",@"ASUVMC",@"PKM",@"POVS",@"MO",@"ECONOMIK",@"PHISIC",@"HISTORY",@"MARKCH",@"ELPRASU",nil];
            [self setValue:[arraySpechial objectAtIndex:arc4random_uniform(9)] forKey:@"spechial"];
            NSArray*arrayFacultet = [[NSArray alloc]initWithObjects:@"SAU",@"ASU",@"GF",@"MT",@"GUM",@"FPP",@"EN",nil];
            [self setValue:[arrayFacultet objectAtIndex:arc4random_uniform(6)] forKey:@"facultet"];
            self.name = [NSString stringWithFormat:@"COURSE for %@ spechial at %@ facultet",self.spechial,self.facultet];
            orig = [setAlready containsObject:self.name];
        }
    }
    return self;
}

@end
