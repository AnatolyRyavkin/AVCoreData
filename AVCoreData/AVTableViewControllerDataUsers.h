//
//  AVTableViewControllerDataUsers.h
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 09/07/2019.
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

@interface AVTableViewControllerDataUsers : UITableViewController<NSFetchedResultsControllerDelegate,UITextFieldDelegate,UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController<AVCourses*>*fetchedResultsController;

@property (strong, nonatomic) NSFetchedResultsController<AVCourses*>*fetchedResultsController1;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property AVDataManager*dataManager;

@property (weak)AVUsers*user;

@property UITextField*textFieldFirstName;
@property UITextField*textFieldlastname;
@property UITextField*textFieldEmail;



- (void)configureCell:(UITableViewCell *)cell withEvent:(AVCourses *)event withIndexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
