//
//  AVDataManager.m
//  ProjectCoreData
//
//  Created by Anatoly Ryavkin on 06/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVDataManager.h"

@implementation AVDataManager

+(AVDataManager*)sharedManager{
    static AVDataManager*manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AVDataManager alloc]init];
    });
    return manager;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"AVCoreDat"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil){
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    [self removeBase];
                    self->_persistentContainer = [[NSPersistentContainer alloc] initWithName:@"AVCoreDat"];
                    [self->_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                        if (error != nil){
                            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                            [self removeBase];
                            abort();
                        }
                    }];
                }
            }];
        }
    }

    return _persistentContainer;
}

#pragma mark - Core Data Saving and remove support

-(void)removeBase{
    NSURL *documentsURL = [[[NSFileManager defaultManager]  URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"AVCoreDat.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    _persistentContainer=nil;
}

-(void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
