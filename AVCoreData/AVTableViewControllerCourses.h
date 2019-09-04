//
//  AVTableViewControllerCourses.h
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

NS_ASSUME_NONNULL_BEGIN

@interface AVTableViewControllerCourses : UITableViewController<NSFetchedResultsControllerDelegate,UITabBarDelegate>

@property (strong, nonatomic,nullable) NSFetchedResultsController<AVCourses*>*fetchedResultsController;
@property (strong, nonatomic,nullable) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,nullable)AVDataManager*dataManager;
@property (nullable)NSIndexPath*indexPathForDel;
@property NSInteger numberSection;

@end

NS_ASSUME_NONNULL_END
