//
//  AVAbstractEntity+CoreDataProperties.h
//  ProjectCoreData
//
//  Created by Anatoly Ryavkin on 06/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVAbstractEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AVAbstractEntity (CoreDataProperties)

+ (NSFetchRequest<AVAbstractEntity *> *)fetchRequest;


@end

NS_ASSUME_NONNULL_END
