//
//  AVUsers+CoreDataClass.m
//  AVCoreData
//
//  Created by Anatoly Ryavkin on 08/07/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//
//

#import "AVUsers+CoreDataClass.h"

@implementation AVUsers

-(id)initWithContext:(NSManagedObjectContext *)context{
    self = [super initWithContext:context];
    if(self){
            NSLog(@"init user");

        NSArray*arrayGlasChar = [[NSArray alloc]initWithObjects:@"y",@"u",@"a",@"o",@"i",@"a",@"u",@"o",@"i",@"j",nil];

        NSArray*arraySoglasChar = [[NSArray alloc]initWithObjects:     @"q",@"w",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"w",
                                   @"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",
                                   @"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",
                                   @"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"c",@"v",@"b",@"n",@"m",nil];

        NSMutableString*firstName = [[NSMutableString alloc]init];
        int lit = arc4random();
        for(int i=0;i<(arc4random()%6+4);i++){
            NSString*strChar = (lit%2==0) ? [arrayGlasChar objectAtIndex:arc4random()% (arrayGlasChar.count-1)] :
            [arraySoglasChar objectAtIndex:(arc4random()%
                                            (arraySoglasChar.count-1))];
            lit++;
            if(i==0)
                [firstName appendString:[strChar uppercaseString]];
            else
                [firstName appendString:strChar];
        }

        NSMutableString*lastName = [[NSMutableString alloc]init];
        for(int i=0;i<(arc4random()%6+4);i++){
            NSString*strChar = (arc4random()%2==0) ? [arrayGlasChar objectAtIndex:(arc4random()%(arrayGlasChar.count-1))] :  [arraySoglasChar objectAtIndex:(arc4random()%(arraySoglasChar.count-1))];
            if(i==0)
                [lastName appendString:[strChar uppercaseString]];
            else
                [lastName appendString:strChar];
        }
        if(arc4random()%2==0)
            [lastName appendString:@"in"];
        else
            [lastName appendString:@"of"];
        self.lastname = lastName;
        self.firstName = firstName;
        self.email = (arc4random()%2)?@"top@mal.bur":@"aaaaaaa@volo.myau"; //[NSString stringWithFormat:@"%@%@@gmail.com",self.firstName,self.lastname];
    }
    return self;
}


@end
