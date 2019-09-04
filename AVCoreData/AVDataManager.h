//
//  AVDataManager.h
//  ProjectCoreData
//
//  Created by Anatoly Ryavkin on 06/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVDataManager : NSObject


@property (strong,nonatomic,nullable) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSManagedObjectContext *viewContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property NSDateFormatter*formatter;

+(AVDataManager*)sharedManager;
-(void)removeBase;
-(void)saveContext;



@end

NS_ASSUME_NONNULL_END
