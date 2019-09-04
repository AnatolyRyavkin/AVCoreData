//
//  AVTableViewControllerUsers.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVTableViewControllerUsers.h"
#import "AVTableViewControllerDataUsers.h"

@interface AVTableViewControllerUsers ()

@end

@implementation AVTableViewControllerUsers
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
- (IBAction)edit:(UIBarButtonItem *)sender {
    if(self.flagDelAll==YES){
        self.flagDelAll=NO;
        self.tableView.editing=NO;
    }else{
    self.flagDelAll=YES;
    self.tableView.editing=YES;
    }
}
- (IBAction)clearBase:(UIBarButtonItem *)sender {
    _fetchedResultsController=nil;
    [self.dataManager removeBase];
    _managedObjectContext=nil;
    self.clean=YES;
    [self.tableView reloadData];
}
- (IBAction)createBase:(UIBarButtonItem *)sender {
    self.clean=NO;
    _managedObjectContext=nil;
    [[AVUnivers alloc]initWithContext:self.managedObjectContext];
    [self.tableView reloadData];
}

- (IBAction)insertUser:(UIBarButtonItem *)sender {
    [self insertNewObject:sender];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"idSegueUser"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AVUsers *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

#pragma mark - Table View form


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.clean==YES)
        return 0;
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.clean==YES)
        return 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellUsers"];
    AVUsers *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withEvent:event];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(self.flagDelAll==NO)
            self.tableView.editing=NO;
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell withEvent:(AVUsers*)event {
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",event.firstName,event.lastname];
    cell.detailTextLabel.text = event.email;
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
                                                                                                             sectionNameKeyPath:nil//@"university.name"
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

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    AVUsers *newEvent = [[AVUsers alloc] initWithContext:context];
    newEvent.firstName = @"AaaNew";
    newEvent.lastname = @"AaaNew";
    newEvent.email = @"anew@gmail.com";
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
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

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
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


