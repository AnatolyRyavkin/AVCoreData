//
//  AVTableViewControllerDataCourses.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 11/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVTableViewControllerDataCourses.h"
#import "AVTableViewControllerDataUsers.h"
#import "AVTVCPopover.h"

@interface AVTableViewControllerDataCourses ()

@end

@implementation AVTableViewControllerDataCourses

#pragma mark - popover delegat


- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    _managedObjectContext=nil;
    [self.tableView reloadData];
}


@synthesize managedObjectContext=_managedObjectContext,fetchedResultsController=_fetchedResultsController;

-(NSIndexPath*)indexPathCorrectForUser:(NSIndexPath*)indexPath{
    return  [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-2];
}

-(NSIndexPath*)indexPathCorrectForTeaher:(NSIndexPath*)indexPath{
    return  [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
}

-(NSIndexPath*)indexPathForTableCorrectForTeaher:(NSIndexPath*)indexPath{
    NSIndexPath*ip =[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
    return ip ;
}

-(NSIndexPath*)indexPathForTableCorrectForLearn:(NSIndexPath*)indexPath{
    NSIndexPath*ip =[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+2];
    return ip ;
}

-(void)dealloc{
    NSLog(@"dealloc1");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSManagedObjectContext*)managedObjectContext{
    if(_managedObjectContext==nil){
        self.dataManager = [AVDataManager sharedManager];
        _managedObjectContext = self.dataManager.persistentContainer.viewContext;
    }
    return _managedObjectContext;
}

- (IBAction)saveExit:(UIBarButtonItem *)sender {
    self.courses.name=self.textFieldName.text;
    self.courses.spechial=self.textFieldSpecialty.text;
    self.courses.facultet=self.textFieldFacultet.text;
    [_managedObjectContext save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addUsersLearn:(UIBarButtonItem *)sender {
    AVTVCPopover*tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"idPopoverUsers"];
    tvc.course=self.courses;
    tvc.sourse=SoursePopoverDataCoursesLearn;
    [tvc.tableView reloadData];
    UINavigationController*nc = [[UINavigationController alloc]initWithRootViewController:tvc];
    nc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController*pc = nc.popoverPresentationController;
    pc.delegate=self;
    nc.preferredContentSize = CGSizeMake(300,800);
    pc.barButtonItem=sender;
    pc.permittedArrowDirections =UIPopoverArrowDirectionUp;
    [self presentViewController:nc animated:YES completion:nil];
}

- (IBAction)buttonChangeTeaher:(UIButton *)sender {
        AVTVCPopover*tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"idPopoverUsers"];
        tvc.course=self.courses;
        tvc.sourse = SoursePopoverDataCoursesTeaher;
        UINavigationController*nc = [[UINavigationController alloc]initWithRootViewController:tvc];
        nc.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController*pc = nc.popoverPresentationController;
        pc.delegate=self;
        nc.preferredContentSize = CGSizeMake(300,800);
        pc.sourceRect = CGRectMake(600, 130, 100, 100);
        pc.sourceView = self.view;
        pc.permittedArrowDirections =UIPopoverArrowDirectionUp;
        [self presentViewController:nc animated:YES completion:nil];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath.section==1){
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][[self indexPathCorrectForTeaher:indexPath].section];
        if(([sectionInfo numberOfObjects])==0)
            return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"idSegueUserFromCourse"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.indexPathEdit=indexPath;
        if(indexPath.section==1){
            AVUsers *object = [self.fetchedResultsController objectAtIndexPath:[self indexPathCorrectForTeaher:indexPath]];
            AVTableViewControllerDataUsers*controller = (AVTableViewControllerDataUsers *)[[segue destinationViewController] topViewController];
            [controller setUser:object];
        }else if(indexPath.section==2){
            AVUsers *object = [self.fetchedResultsController1 objectAtIndexPath:[self indexPathCorrectForUser:indexPath]];
            AVTableViewControllerDataUsers*controller = (AVTableViewControllerDataUsers *)[[segue destinationViewController] topViewController];
            [controller setUser:object];
        }
    }
}


#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][[self indexPathCorrectForTeaher:indexPath].section];
        if(([sectionInfo numberOfObjects])==0){
            AVTVCPopover*tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"idPopoverUsers"];
            tvc.sourse = SoursePopoverDataCoursesTeaher;
            tvc.course=self.courses;
            [tvc.tableView reloadData];
            UINavigationController*nc = [[UINavigationController alloc]initWithRootViewController:tvc];
            nc.modalPresentationStyle = UIModalPresentationPopover;
            UIPopoverPresentationController*pc = nc.popoverPresentationController;
            pc.delegate=self;
            nc.preferredContentSize = CGSizeMake(300,800);
            pc.sourceRect = CGRectMake(600, 130, 100, 100);
            pc.sourceView = self.view;
            pc.permittedArrowDirections =UIPopoverArrowDirectionUp;
            [self presentViewController:nc animated:YES completion:nil];
        }
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger i = [[self.fetchedResultsController sections] count]+1+[[self.fetchedResultsController1 sections] count];
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)
        return 3;
    if(section==1){
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section-1];
        NSUInteger count =  [sectionInfo numberOfObjects];
        return (count==0)?1:count;
    }
    if(section==2){
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController1 sections][section-2];
    NSUInteger count =  [sectionInfo numberOfObjects];
    return count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    AVUsers *event=nil;
    id <NSFetchedResultsSectionInfo> sectionInfo;
    NSIndexPath*indexPathCorrectUser = [self indexPathCorrectForUser:indexPath];
    NSIndexPath*indexPathCorrectTeaher = [self indexPathCorrectForTeaher:indexPath];

    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellCourseCart1"];
            [self configureCell:cell withEvent:event withIndexPath:indexPath];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellCourseCart3"];
            sectionInfo= [self.fetchedResultsController sections][indexPathCorrectTeaher.section];
            if(([sectionInfo numberOfObjects])!=0)
                event = [self.fetchedResultsController objectAtIndexPath:indexPathCorrectTeaher];
            [self configureCell:cell withEvent:event withIndexPath:indexPath];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellCourseCart2"];
            event = [self.fetchedResultsController1 objectAtIndexPath:indexPathCorrectUser];
            [self configureCell:cell withEvent:event withIndexPath:indexPath];
            break;
        default:
            break;
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withEvent:( AVUsers*)event withIndexPath:(NSIndexPath*)indexPath {

    if(indexPath.section==0){
        UITextField*textField = [[cell.contentView subviews] objectAtIndex:0];
        switch (indexPath.row) {
            case 0:
                textField.text = self.courses.name;
                self.textFieldName=textField;
                self.textFieldName.delegate = self;
                self.textFieldName.tag=1;
                break;
            case 1:
                textField.text = self.courses.spechial;
                self.textFieldSpecialty=textField;
                self.textFieldSpecialty.delegate = self;
                self.textFieldSpecialty.tag=2;

                break;
            case 2:
                textField.text = self.courses.facultet;
                self.textFieldFacultet=textField;
                self.textFieldFacultet.delegate = self;
                self.textFieldFacultet.tag=3;
                break;
            default:
                break;
        }
    }else if(indexPath.section==1){
        UILabel*lable = ([[cell.contentView.subviews objectAtIndex:0] isKindOfClass:[UILabel class]])?
                                            [cell.contentView.subviews objectAtIndex:0]:
                                            [cell.contentView.subviews objectAtIndex:1];
        [lable setText:(event==nil) ? @" - establish teaher - tap - " : [NSString stringWithFormat:@"%@ %@",event.firstName,event.lastname]];
    }else if(indexPath.section==2){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",event.firstName,event.lastname];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString*nameSection;
    switch (section) {
        case 0:
            nameSection = @"date course";
            break;
        case 1:
            nameSection = @"user teahers user "; ;
            break;
        case 2:
            nameSection = @"users learn user";
            break;

        default:
            break;
    }
    return nameSection;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController<AVUsers*> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest<AVUsers*> *fetchRequest =AVUsers.fetchRequest;
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"coursesTeahers contains %@",self.courses];
    fetchRequest.predicate = predicate;


    NSFetchedResultsController<AVUsers*> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
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

#pragma mark - Fetched results controller1

- (NSFetchedResultsController<AVUsers*> *)fetchedResultsController1{
    if (_fetchedResultsController1!= nil) {
        return _fetchedResultsController1;
    }
    NSFetchRequest<AVUsers*> *fetchRequest =AVUsers.fetchRequest;
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"coursesLearn contains %@",self.courses];
    fetchRequest.predicate = predicate;

    NSError* error = nil;

    NSFetchedResultsController<AVUsers*> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                          managedObjectContext:self.managedObjectContext
                                                                                                            sectionNameKeyPath:nil
                                                                                                                     cacheName:nil];
    aFetchedResultsController.delegate = self;

    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    _fetchedResultsController1 = aFetchedResultsController;
    return _fetchedResultsController1;
}

#pragma marc - delegat NSFethController

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            if(![controller isEqual:self.fetchedResultsController])
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            if(![controller isEqual:self.fetchedResultsController])
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

    if([controller isEqual:self.fetchedResultsController]){
        NSIndexPath*ip = [self indexPathForTableCorrectForTeaher:newIndexPath];
        [self configureCell:[self.tableView cellForRowAtIndexPath:ip] withEvent:anObject withIndexPath:ip];
    }else{
        NSIndexPath*ip = [self indexPathForTableCorrectForLearn:newIndexPath];
        switch(type) {
            case NSFetchedResultsChangeInsert:
                    [tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
                break;

            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
                break;

            case NSFetchedResultsChangeUpdate:
                    //[self configureCell:[self.tableView cellForRowAtIndexPath:ip] withEvent:anObject withIndexPath:ip];
                break;

            case NSFetchedResultsChangeMove:
                    //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
                    //[tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    }

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - textFieldDelegat

-(NSString*)stringOldEmail: (NSString*)textFieldString stringNewEmail:(NSString*)string rangeInput:(NSRange)range{

    int checCountDogInString = 0;
    for(int i = 0; i<string.length;i++){
        unichar h=[string characterAtIndex:i];
        if([[NSString stringWithFormat:@"%c",h] isEqualToString:@"@"])
            checCountDogInString++;
    }

    int checCountDogInText = 0;
    for(int i = 0; i<textFieldString.length;i++){
        unichar h=[textFieldString characterAtIndex:i];
        if([[NSString stringWithFormat:@"%c",h] isEqualToString:@"@"])
            checCountDogInText++;
    }

    if((checCountDogInText==0 && checCountDogInString<=1) || (checCountDogInText==1 && checCountDogInString==0 )){
        NSMutableString*stringTemp=[[NSMutableString alloc]initWithString:textFieldString];
        [stringTemp replaceCharactersInRange:range withString:string];
        return stringTemp;
    }else{
        return textFieldString;
    }
}


#pragma mark -inputName&NameFamily

-(NSString*)stringOldName: (NSString*)textFieldString stringNewName: (NSString*)string rangeInput: (NSRange)range{

    NSMutableString*stringTemp=[[NSMutableString alloc]initWithString:textFieldString];

    NSMutableCharacterSet *setControl = [NSMutableCharacterSet letterCharacterSet];
    [setControl invert];

    NSArray*arrayCheckAtNumber=[string componentsSeparatedByCharactersInSet:setControl];

    if(arrayCheckAtNumber.count==1){
        [stringTemp replaceCharactersInRange:range withString:string];
        return stringTemp;
    }else{
        return textFieldString;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag==6 && [textField.text isEqualToString:@"Too short number!!!"]){
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    switch (textField.tag) {
        case 1:
            if(textField.text.length+string.length<20 && ![string isEqualToString:@""]){
                textField.text = [self stringOldName:textField.text stringNewName:string rangeInput:range];
                //self.courses.name=textField.text;
                return NO;
            }else if([string isEqualToString:@""]){
                return YES;
            }
            break;
        case 2:
            if(textField.text.length+string.length<20 && ![string isEqualToString:@""]){
                textField.text = [self stringOldName:textField.text stringNewName:string rangeInput:range];
                //self.courses.spechial=textField.text;
                return NO;
            }else if([string isEqualToString:@""]){
                return YES;
            }
            break;
        case 3:
            if(textField.text.length+string.length<20 && ![string isEqualToString:@""]){
                textField.text = [self stringOldName:textField.text stringNewName:string rangeInput:range];
                //self.courses.facultet=textField.text;
                return NO;
            }else if([string isEqualToString:@""]){
                return YES;
            }
            break;
        default:
            return NO;
            break;
    }
    return NO;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSArray*array=[NSArray arrayWithObjects:self.textFieldName, self.textFieldSpecialty, self.textFieldFacultet,nil];
    if(textField.tag==3){
        [textField resignFirstResponder];
    }else{
        [[array objectAtIndex:textField.tag] becomeFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            self.courses.name=textField.text;
            break;
        case 2:
            self.courses.spechial=textField.text;
            break;
        case 3:
            self.courses.facultet=textField.text;
            break;
        default:
            break;
    }
}


 @end
