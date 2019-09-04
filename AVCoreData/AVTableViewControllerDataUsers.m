//
//  AVTableViewControllerDataUsers.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 09/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVTableViewControllerDataUsers.h"
#import "AVTVCPopover.h"

@interface AVTableViewControllerDataUsers ()

@end

@implementation AVTableViewControllerDataUsers

@synthesize managedObjectContext=_managedObjectContext,fetchedResultsController=_fetchedResultsController;

-(NSIndexPath*)indexPathCorrectForUser:(NSIndexPath*)indexPath{
    return  [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
}

-(NSIndexPath*)indexPathCorrectForTeaher:(NSIndexPath*)indexPath{
    return  [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-2];
}

-(void)dealloc{
    NSLog(@"deallocDataUser");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _managedObjectContext=nil;
}

-(NSManagedObjectContext*)managedObjectContext{
    if(_managedObjectContext==nil){
        self.dataManager = [AVDataManager sharedManager];
        _managedObjectContext = self.dataManager.persistentContainer.viewContext;
    }
    return _managedObjectContext;
}

- (IBAction)saveExit:(UIBarButtonItem *)sender {
    NSError*error=nil;
    [_managedObjectContext save:&error];
    if(error!=nil)
        NSLog(@"error=%@",error);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)establCoursesLearn:(UIBarButtonItem *)sender{

    AVTVCPopover*tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"idPopoverUsers"];
    tvc.user=self.user;
    tvc.sourse=SoursePopoverDataUsersLearn;
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

-(IBAction)establCoursesTeaher:(UIBarButtonItem *)sender{
    AVTVCPopover*tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"idPopoverUsers"];
    tvc.user=self.user;
    tvc.sourse=SoursePopoverDataUsersTeaher;
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

#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
        return [sectionInfo numberOfObjects];
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController1 sections][section-2];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    AVCourses *event;
    NSIndexPath*indexPathCorrectUser = [self indexPathCorrectForUser:indexPath];
    NSIndexPath*indexPathCorrectTeaher = [self indexPathCorrectForTeaher:indexPath];

    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellUserCart1"];
            [self configureCell:cell withEvent:event withIndexPath:indexPath];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellUserCart2"];
            event = [self.fetchedResultsController objectAtIndexPath:indexPathCorrectUser];
            [self configureCell:cell withEvent:event withIndexPath:indexPath];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellUserCart2"];
            event = [self.fetchedResultsController1 objectAtIndexPath:indexPathCorrectTeaher];
            [self configureCell:cell withEvent:event withIndexPath:indexPath];
            break;

        default:
            break;
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withEvent:( AVCourses*)event withIndexPath:(NSIndexPath*)indexPath {
    
    if(indexPath.section==0){
        UITextField*textField = [[cell.contentView subviews] objectAtIndex:0];
        switch (indexPath.row) {
            case 0:
                 textField.text = self.user.firstName;
                self.textFieldFirstName=textField;
                self.textFieldFirstName.delegate = self;
                self.textFieldFirstName.tag=1;
                break;
            case 1:
                textField.text = self.user.lastname;
                self.textFieldlastname=textField;
                self.textFieldlastname.delegate=self;
                self.textFieldlastname.tag=2;
                break;
            case 2:
                textField.text = self.user.email;
                self.textFieldEmail = textField;
                self.textFieldEmail.delegate=self;
                self.textFieldEmail.tag=3;
                self.textFieldEmail.autocapitalizationType=UITextAutocapitalizationTypeNone;
                break;
            default:
                break;
        }
    }else
        cell.textLabel.text = event.name;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString*nameSection;
    switch (section) {
        case 0:
            nameSection = @"date users";
            break;
        case 1:
            nameSection = @"courses learn user";
            break;
        case 2:
            nameSection = @"courses teahers user";
            break;

        default:
            break;
    }
    return nameSection;
}


#pragma mark - Fetched results controller1

- (NSFetchedResultsController<AVCourses*> *)fetchedResultsController1{
    if (_fetchedResultsController1 != nil) {
        return _fetchedResultsController1;
    }
    NSFetchRequest<AVCourses*> *fetchRequest =AVCourses.fetchRequest;
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"teahers=%@",self.user];
    fetchRequest.predicate = predicate;

    NSError* error = nil;

    NSFetchedResultsController<AVCourses*> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
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

#pragma mark - Fetched results controller



- (NSFetchedResultsController<AVCourses*> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest<AVCourses*> *fetchRequest =AVCourses.fetchRequest;
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"users contains %@",self.user];
    fetchRequest.predicate = predicate;

    static int a = 0;
    a++;

        NSFetchedResultsController<AVCourses*> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
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

#pragma marc - delegat NSFethController

-(NSIndexPath*)indexPathForTableCorrectForTeaher:(NSIndexPath*)indexPath{
    NSIndexPath*ip =[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+2];
    return ip ;
}

-(NSIndexPath*)indexPathForTableCorrectForLearn:(NSIndexPath*)indexPath{
    NSIndexPath*ip =[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
    return ip ;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.tableView;

    if([controller isEqual:self.fetchedResultsController]){
        NSIndexPath*ip = [self indexPathForTableCorrectForLearn:newIndexPath];
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
                break;

            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
                break;
            default:
                break;
        }
    }else{
        NSIndexPath*ip = [self indexPathForTableCorrectForTeaher:newIndexPath];
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
                break;

            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
                break;

            default:
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
                self.user.firstName = textField.text;
                return NO;
            }else if([string isEqualToString:@""]){
                return YES;
            }
            break;
        case 2:
            if(textField.text.length+string.length<20 && ![string isEqualToString:@""]){
                textField.text = [self stringOldName:textField.text stringNewName:string rangeInput:range];
                self.user.lastname = textField.text;
                return NO;
            }else if([string isEqualToString:@""]){
                return YES;
            }
            break;
        case 3:
            if(textField.text.length+string.length<20 && ![string isEqualToString:@""]){
                textField.text = [self stringOldEmail:textField.text stringNewEmail:string rangeInput:range];
                self.user.email = textField.text;
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
    NSArray*array=[NSArray arrayWithObjects:self.textFieldFirstName, self.textFieldlastname, self.textFieldEmail,nil];
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
            self.user.firstName=textField.text;
            break;
        case 2:
            self.user.lastname=textField.text;
            break;
        case 3:
            self.user.email=textField.text;
            break;
        default:
            break;
    }
}

@end
