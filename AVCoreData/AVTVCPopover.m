//
//  AVTVCPopoverUsers.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 11/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVTVCPopover.h"

@interface AVTVCPopover ()

@end

@implementation AVTVCPopover

@synthesize managedObjectContext=_managedObjectContext,fetchedResultsController=_fetchedResultsController;

-(NSManagedObjectContext*)managedObjectContext{
    if(_managedObjectContext==nil){
        self.dataManager = [AVDataManager sharedManager];
        _managedObjectContext = self.dataManager.persistentContainer.viewContext;
    }
    return _managedObjectContext;
}
-(void)dealloc{
    NSLog(@"dealloc0");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelectionDuringEditing=YES;
}


#pragma mark - Table View


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVUsers *user;
    AVCourses*course;
    switch (self.sourse){
        case SoursePopoverDataCoursesTeaher:
            user= [self.fetchedResultsController objectAtIndexPath:indexPath];
            [user addCoursesTeahersObject:self.course];
            break;

        case SoursePopoverDataCoursesLearn:
            user= [self.fetchedResultsController objectAtIndexPath:indexPath];
            if(![user.coursesLearn containsObject:self.course])
                [user addCoursesLearnObject:self.course];
            else
                [user removeCoursesLearnObject:self.course];
            break;

        case SoursePopoverDataUsersLearn:
            course = [self.fetchedResultsController1 objectAtIndexPath:indexPath];
            if(![course.users containsObject:self.user])
                [course addUsersObject:self.user];
            else
                [course removeUsersObject:self.user];
            break;

        case SoursePopoverDataUsersTeaher:
            course = [self.fetchedResultsController1 objectAtIndexPath:indexPath];
            if(![course.teahers isEqual: self.user])
                course.teahers=self.user;
            else
                [self.user removeCoursesTeahersObject:course];
            break;

        default:
            break;
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark - Table View form


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo;
    if(self.sourse==SoursePopoverDataCoursesLearn || self.sourse==SoursePopoverDataCoursesTeaher)
        sectionInfo = [self.fetchedResultsController sections][section];
    else
        sectionInfo = [self.fetchedResultsController1 sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(self.sourse==SoursePopoverDataCoursesLearn || self.sourse==SoursePopoverDataCoursesTeaher){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellPopUsers"];
        AVUsers *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self configureCellUsers:cell withEvent:event];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellPopUsers"];
        AVCourses *event = [self.fetchedResultsController1 objectAtIndexPath:indexPath];
        [self configureCellCourses:cell withEvent:event];
        return cell;
    }
}

- (void)configureCellUsers:(UITableViewCell *)cell withEvent:(AVUsers*)event {
    switch (self.sourse){
        case SoursePopoverDataCoursesLearn:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",event.firstName,event.lastname];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if([self.course.users containsObject:event])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case SoursePopoverDataCoursesTeaher:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",event.firstName,event.lastname];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if([self.course.teahers isEqual:event])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        default:
            break;
    }
}

- (void)configureCellCourses:(UITableViewCell *)cell withEvent:(AVCourses*)event {
    switch (self.sourse){
        case SoursePopoverDataUsersLearn:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",event.name];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if([self.user.coursesLearn containsObject:event])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case SoursePopoverDataUsersTeaher:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",event.name];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if([self.user.coursesTeahers containsObject:event])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        default:
            break;
    }
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController<AVUsers *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest<AVUsers *> *fetchRequest = AVUsers.fetchRequest;
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSFetchedResultsController<AVUsers *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                           managedObjectContext:self.managedObjectContext
                                                                                                             sectionNameKeyPath:nil
                                                                                                                      cacheName:nil];
    aFetchedResultsController.delegate = self;
    NSError* error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

#pragma mark - Fetched results controller1

- (NSFetchedResultsController<AVCourses *> *)fetchedResultsController1 {
    if (_fetchedResultsController1!= nil) {
        return _fetchedResultsController1;
    }

    NSFetchRequest<AVCourses *> *fetchRequest = AVCourses.fetchRequest;
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSFetchedResultsController<AVCourses *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                           managedObjectContext:self.managedObjectContext
                                                                                                             sectionNameKeyPath:nil
                                                                                                                      cacheName:nil];
    aFetchedResultsController.delegate = self;
    NSError* error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    _fetchedResultsController1 = aFetchedResultsController;
    return _fetchedResultsController1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString*string;
    switch (self.sourse){
        case SoursePopoverDataCoursesTeaher:
            string=@"user at teaher";
            break;

        case SoursePopoverDataCoursesLearn:
            string=@"user at learn";
            break;

        case SoursePopoverDataUsersLearn:
            string=@"course at learn";
            break;

        case SoursePopoverDataUsersTeaher:
            string=@"course at teaher";
            break;

        default:
            break;
    }

    return string;
}

@end
