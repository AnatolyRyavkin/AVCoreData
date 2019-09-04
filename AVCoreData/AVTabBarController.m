//
//  AVTabBarController.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 16/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVTabBarController.h"
#import "AVTableViewControllerTeahers.h"
#import "AVTableViewControllerCourses.h"
#import "AVTableViewControllerUsers.h"

@implementation AVTabBarController

-(void)viewDidLoad{
    self.delegate=self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    for(UINavigationController*nc in self.viewControllers){
        if(!([viewController isEqual:nc]) && [nc.topViewController isKindOfClass:[AVTableViewControllerTeahers class]]){
            AVTableViewControllerTeahers*tc = (AVTableViewControllerTeahers*)(nc.topViewController);
            tc.tableView=nil;
            tc.managedObjectContext=nil;
            tc.fetchedResultsControllerForCourses=nil;
            tc.fetchedResultsControllerUsers=nil;
            tc.arrayFetchedControllersUsers=nil;
            tc.arraySpechials=nil;
            tc.arrayCourses=nil;
        }
        if(!([viewController isEqual:nc]) && [nc.topViewController isKindOfClass:[AVTableViewControllerCourses class]]){
            AVTableViewControllerCourses*tc = (AVTableViewControllerCourses*)(nc.topViewController);
            tc.tableView=nil;
            tc.fetchedResultsController=nil;
            tc.managedObjectContext=nil;
            tc.dataManager=nil;
            tc.indexPathForDel=0;
            tc.numberSection=0;
        }
    }
}


@end

