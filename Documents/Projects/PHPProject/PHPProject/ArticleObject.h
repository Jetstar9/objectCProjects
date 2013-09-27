//
//  ArticleObject.h
//  PGA Magazine
//
//  Created by Derek Smith on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface ArticleObject : NSObject {

    
    // - Article ID.
    NSInteger *articleId;

    // - Author Photo
    UIImage *articleImage;

    // - Article Title
    NSString *articleTitle;

    // - Article Description
    NSString *articleDescription;
    
    // - Article Title with Description.
    NSString *articleTitleAndDescription;
    
    // - Author Bio
    NSString *articleBio;
    
    // - Article Date
    NSString *articleDate;
    
    // - Article Title 1
    NSString *articleTitle1;
    
    // - Article Content1
    NSString *articleContent1;
    
    // - Article Title 2
    NSString *articleTitle2;
    
    // - Article Content2
    NSString *articleContent2;


}

@property (nonatomic) NSInteger *articleId;
@property (nonatomic, retain) UIImage *articleImage;
@property (nonatomic, retain) NSString *articleTitle;
@property (nonatomic, retain) NSString *articleDescription;
@property (nonatomic, retain) NSString *articleTitleAndDescription;
@property (nonatomic, retain) NSString *articleBio;
@property (nonatomic, retain) NSString *articleDate;
@property (nonatomic, retain) NSString *articleTitle1;
@property (nonatomic, retain) NSString *articleContent1;
@property (nonatomic, retain) NSString *articleTitle2;
@property (nonatomic, retain) NSString *articleContent2;


// propose the following for the new database structure.
// 1. articleID
// 2. articleTitle
// 3. articleImage
// 4. articleDescription
// 5. articleBio
// 6. articleDate
// 7. articleTitle1
// 8. articleContent1
// 9. articleTitle2
// 10. articleContent2.





@end



