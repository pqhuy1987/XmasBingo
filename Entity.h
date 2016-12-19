//
//  Entity.h
//  Bingo
//
//  Created by feialoh on 29/08/14.
//  Copyright (c) 2014 feialoh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * playername;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * winstreaks;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSNumber * id;

@end
