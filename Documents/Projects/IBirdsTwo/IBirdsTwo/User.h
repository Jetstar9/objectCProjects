//
//  User.h
//  iBirds
//
//  Created by Samuel Westrich on 10/18/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bird;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarLocation;
@property (nonatomic, retain) NSString * cloudPassword;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * goldCoins;
@property (nonatomic, retain) NSDate * lastLogin;
@property (nonatomic, retain) NSDate * lastModificationDate;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * needsValidation;
@property (nonatomic, retain) NSDate * registrationDate;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * validated;
@property (nonatomic, retain) NSSet *birds;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addBirdsObject:(Bird *)value;
- (void)removeBirdsObject:(Bird *)value;
- (void)addBirds:(NSSet *)values;
- (void)removeBirds:(NSSet *)values;

@end
