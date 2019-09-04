//
//  AVTableViewControllerTeahers.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 13/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AVDataManager.h"
#import "AVAbstractEntity+CoreDataClass.h"
#import "AVUsers+CoreDataClass.h"
#import "AVUnivers+CoreDataClass.h"
#import "AVCourses+CoreDataClass.h"
#import "AVTableViewControllerDataUsers.h"
#import "AVTVCPopover.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVTableViewControllerTeahers : UITableViewController<NSFetchedResultsControllerDelegate,UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic,nullable) NSFetchedResultsController<AVCourses*>*fetchedResultsControllerForCourses;
@property (strong, nonatomic,nullable) NSFetchedResultsController<AVUsers*>*fetchedResultsControllerUsers;
@property(nonatomic,nullable)NSArray<NSFetchedResultsController*>*arrayFetchedControllersUsers;


@property (nonatomic,nullable)NSArray<NSString*>*arraySpechials;
@property(nonatomic,nullable)NSArray<AVCourses*>*arrayCourses;


@property (strong, nonatomic,nullable) NSManagedObjectContext *managedObjectContext;
@property AVDataManager*dataManager;
@property NSIndexPath*indexPathForDel;
@property BOOL flagDelAll;
@property NSInteger numberSection;
@property BOOL flagInsert;

@end

NS_ASSUME_NONNULL_END
