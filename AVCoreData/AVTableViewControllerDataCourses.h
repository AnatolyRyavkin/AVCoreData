//
//  AVTableViewControllerDataCourses.h
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

@interface AVTableViewControllerDataCourses : UITableViewController<NSFetchedResultsControllerDelegate,UITextFieldDelegate,UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController<AVUsers*>*fetchedResultsController;

@property (strong, nonatomic) NSFetchedResultsController<AVUsers*>*fetchedResultsController1;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property AVDataManager*dataManager;

@property (weak)AVCourses*courses;

@property UITextField*textFieldFacultet;
@property UITextField*textFieldSpecialty;
@property UITextField*textFieldName;

@property NSIndexPath*indexPathEdit;


- (void)configureCell:(UITableViewCell *)cell withEvent:(AVUsers *)event withIndexPath:(NSIndexPath*)indexPath;

@end


NS_ASSUME_NONNULL_END
