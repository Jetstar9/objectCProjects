//
//  LoginParser.h
//  iBirds
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "JSONParser.h"
#import "User.h"

@interface UserInfoParser : JSONParser {
    User * user;
}

@property (nonatomic,retain) User * user;

@end
