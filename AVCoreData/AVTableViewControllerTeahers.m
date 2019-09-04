//
//  AVTableViewControllerTeahers.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 13/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVTableViewControllerTeahers.h"

@interface AVTableViewControllerTeahers ()

@end

@implementation AVTableViewControllerTeahers

@synthesize managedObjectContext=_managedObjectContext,fetchedResultsControllerUsers=_fetchedResultsControllerUsers;

-(NSManagedObjectContext*)managedObjectContext{
    if(_managedObjectContext==nil){
        self.dataManager = [AVDataManager sharedManager];
        _managedObjectContext = self.dataManager.persistentContainer.viewContext;
    }
    return _managedObjectContext;
}
-(void)dealloc{
    NSLog(@"deallocTeahers");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelectionDuringEditing=YES;
}

#pragma mark - init fetchedControllersAndArraySection

- (NSFetchedResultsController<AVCourses*> *)fetchedResultsControllerForCourses{
    if (_fetchedResultsControllerForCourses != nil) {
        return _fetchedResultsControllerForCourses;
    }
    NSFetchRequest<AVCourses*> *fetchRequest =AVCourses.fetchRequest;
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"spechial" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSError* error = nil;

    NSFetchedResultsController<AVCourses*> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                            managedObjectContext:self.managedObjectContext
                                                                                                              sectionNameKeyPath:@"spechial"
                                                                                                                       cacheName:nil];
    aFetchedResultsController.delegate = self;

    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    _fetchedResultsControllerForCourses = aFetchedResultsController;
    return _fetchedResultsControllerForCourses;
}

- (NSFetchedResultsController<AVUsers *> *)fetchedResultsControllerUsers{
    if (_fetchedResultsControllerUsers != nil) {
        return _fetchedResultsControllerUsers;
    }

    NSFetchRequest<AVUsers *> *fetchRequest = AVUsers.fetchRequest;
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSFetchedResultsController<AVUsers *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                           managedObjectContext:self.managedObjectContext
                                                                                                             sectionNameKeyPath:nil//@"university.name"
                                                                                                                      cacheName:nil];
    aFetchedResultsController.delegate = self;
    NSError* error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    _fetchedResultsControllerUsers = aFetchedResultsController;
    return _fetchedResultsControllerUsers;
}

-(NSArray<NSString*>*)arraySpechials{
    if(_arraySpechials!=nil)
        return _arraySpechials;
    NSArray<AVCourses*>*arrayResult = self.arrayCourses;
    NSArray*arraySort = [[arrayResult valueForKeyPath:@"@distinctUnionOfObjects.spechial"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    _arraySpechials=arraySort;
    return _arraySpechials;
}

-(NSArray<AVCourses*>*)arrayCourses{
    if(_arrayCourses!=nil)
        return _arrayCourses;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AVCourses"];
    request.resultType= NSManagedObjectResultType;
    NSSortDescriptor*sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors=@[sortDescriptor];
    NSError*error=nil;
    NSArray<AVCourses*>*arrayResult = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error!=nil)
        NSLog(@"error=%@",error);
    _arrayCourses=arrayResult;
    return _arrayCourses;
}

-(NSArray<NSFetchedResultsController*>*)arrayFetchedControllersUsers{
    if(_arrayFetchedControllersUsers!=nil)
        return _arrayFetchedControllersUsers;
    NSMutableArray*arrayTemp = [[NSMutableArray alloc]init];
    for(int i=0;i<[self.arraySpechials count];i++){
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AVUsers"];
        NSSortDescriptor*sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
        fetchRequest.sortDescriptors=@[sortDescriptor];
        NSString*spechial=[self.arraySpechials objectAtIndex:i];
        NSPredicate*pred=[NSPredicate predicateWithFormat:@"SUBQUERY(coursesTeahers, $course, $course.spechial == %@).@count > %d",spechial,0];
        [fetchRequest setPredicate:pred];
        NSFetchedResultsController<AVUsers*> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                              managedObjectContext:self.managedObjectContext
                                                                                                                sectionNameKeyPath:nil
                                                                                                                         cacheName:nil];

        aFetchedResultsController.delegate = self;
        NSError* error = nil;
        if (![aFetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
        [arrayTemp addObject:aFetchedResultsController];
    }
    _arrayFetchedControllersUsers = [[NSArray alloc]initWithArray:arrayTemp];
    return _arrayFetchedControllersUsers;
}


- (IBAction)edit:(UIBarButtonItem *)sender {
        self.tableView.editing= (self.tableView.editing)?NO:YES;
}


- (IBAction)insertUser:(UIBarButtonItem *)sender {
    self.flagInsert=YES;
    [self insertNewObject:sender];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"idSegueTeahers"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSFetchedResultsController*fethController = [self.arrayFetchedControllersUsers objectAtIndex:indexPath.section];
        NSIndexPath*indexPathCor = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        AVUsers *object = [fethController objectAtIndexPath:indexPathCor];
        AVTableViewControllerDataUsers*controller = (AVTableViewControllerDataUsers *)[[segue destinationViewController] topViewController];
        [controller setUser:object];
    }
}

#pragma mark - Table View

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"student leave as!";
}

#pragma mark - Change Cart Student

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.editing= (self.tableView.editing)?NO:NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(self.flagDelAll==NO)
            self.tableView.editing=NO;
        NSFetchedResultsController*fethController = [self.arrayFetchedControllersUsers objectAtIndex:indexPath.section];
        NSIndexPath*indexPathCor = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        AVUsers *user = [fethController objectAtIndexPath:indexPathCor];
        NSSet*coursesSet = user.coursesTeahers;
        UITableViewHeaderFooterView*head = [tableView headerViewForSection:indexPath.section];
        NSString*nameSection = head.textLabel.text;
        NSMutableSet*setCoursesDel = [[NSMutableSet alloc]init];
        for(AVCourses*course in coursesSet){
            if([course.spechial isEqualToString:nameSection]){
                [setCoursesDel addObject:course];
            }
        }
        [user removeCoursesTeahers:setCoursesDel];
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
           NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

#pragma mark - Table View form


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [self.arraySpechials count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.arrayFetchedControllersUsers objectAtIndex:section] sections][0];
    NSUInteger count =  [sectionInfo numberOfObjects];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellTeahers"];
    NSIndexPath*indexPathCorrect=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    AVUsers *event = [[self.arrayFetchedControllersUsers objectAtIndex:indexPath.section] objectAtIndexPath:indexPathCorrect];
    [self configureCell:cell withEvent:event];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withEvent:(AVUsers*)event {
    if([event isKindOfClass:[AVUsers class]]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",event.firstName,event.lastname];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",[[event valueForKeyPath:@"coursesTeahers.@count"] integerValue]];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsControllerForCourses sections][section];
    return sectionInfo.name;
}

- (void)insertNewObject:(id)sender {
    AVUsers *newEvent = [[AVUsers alloc] initWithContext:_managedObjectContext];
    newEvent.firstName = @"Anatoly";
    newEvent.lastname = @"Ryavkin";
    newEvent.email = @"toryav@gmail.com";
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    AVTableViewControllerDataUsers*uc=[self.storyboard instantiateViewControllerWithIdentifier:@"idUserContr"];
    uc.user=newEvent;
    UINavigationController*nc = [[UINavigationController alloc]initWithRootViewController:uc];
    nc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController*pc = nc.popoverPresentationController;
    pc.delegate=self;
    nc.preferredContentSize = CGSizeMake(600,800);
    pc.barButtonItem=sender;
    pc.permittedArrowDirections =UIPopoverArrowDirectionUp;
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - dismiss

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    _arrayCourses=nil;
    [self.tableView reloadData];

}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            _arrayCourses=nil;
            _arraySpechials=nil;
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        default:
            return;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    NSIndexPath*indexPathCor;
    int i = 0;
    for(NSFetchedResultsController*contr in self.arrayFetchedControllersUsers){
        if([contr isEqual:controller])
            indexPathCor = [NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section+i];
        i++;
    }

    switch(type) {
        case NSFetchedResultsChangeInsert:
            //[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[indexPathCor] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView deleteRowsAtIndexPaths:@[indexPathCor] withRowAnimation:UITableViewRowAnimationFade];

            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPathCor] withEvent:anObject];
            break;

        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
