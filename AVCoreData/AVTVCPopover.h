//
//  AVTVCPopoverUsers.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 11/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AVDataManager.h"
#import "AVAbstractEntity+CoreDataClass.h"
#import "AVUsers+CoreDataClass.h"
#import "AVUnivers+CoreDataClass.h"
#import "AVCourses+CoreDataClass.h"
#import "AVTableViewControllerDataCourses.h"
#import "AVTableViewControllerDataUsers.h"

typedef enum{
    SoursePopoverDataCoursesLearn=1,
    SoursePopoverDataCoursesTeaher,
    SoursePopoverDataUsersLearn,
    SoursePopoverDataUsersTeaher
}SoursePopover;


NS_ASSUME_NONNULL_BEGIN

@interface AVTVCPopover : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController<AVUsers*>*fetchedResultsController;

@property (strong, nonatomic) NSFetchedResultsController<AVCourses*>*fetchedResultsController1;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property AVDataManager*dataManager;
@property NSIndexPath*indexPathForDel;
@property BOOL flagDelAll;
@property NSInteger numberSection;

@property AVCourses*course;

@property AVUsers*user;

@property SoursePopover sourse;

@end

NS_ASSUME_NONNULL_END
