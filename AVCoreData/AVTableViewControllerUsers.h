//
//  AVTableViewControllerUsers.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
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

@interface AVTableViewControllerUsers : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic,nullable) NSFetchedResultsController<AVUsers*>*fetchedResultsController;
@property (strong, nonatomic,nullable) NSManagedObjectContext *managedObjectContext;
@property (nullable,nonatomic)AVDataManager*dataManager;
@property (nonatomic,nullable)NSIndexPath*indexPathForDel;
@property BOOL flagDelAll;
@property NSInteger numberSection;
@property BOOL clean;


@end

NS_ASSUME_NONNULL_END
