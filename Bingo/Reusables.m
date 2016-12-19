//
//  Reusables.m
//  Bingo
//
//  Created by feialoh on 21/01/13.
//  Copyright (c) 2013 feialoh. All rights reserved.
//

#import "Reusables.h"


@implementation Reusables


+(NSString*)getCurrentDateWithTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *result = [[dateFormatter stringFromDate:date] stringByReplacingOccurrencesOfString:@" " withString:@"_"] ;
    return result;
}


#pragma method to get authentication token
/*
+(NSString *)getAuthToken
{
    NSString *authToken=[[NSUserDefaults standardUserDefaults] valueForKey:AUTHENTICATION_KEY];
    NSLog(@"%@",authToken);
    return authToken;
    
}

+(NSString *)getUserID
{
    NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:USER_ID_KEY];
    return userId;
    
}

+(void)SetUserIdNil
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:USER_ID_KEY];
    [defaults synchronize];
}

*/

+(NSObject *)getDefaultValue:(NSString *)key
{
    NSObject *value=[[NSUserDefaults standardUserDefaults] valueForKey:key];
    return value;
    
}
+(void)storeDataToDefaults :(NSString *)keyName objectToAdd:(id)data

{
    if (![data isKindOfClass:[NSNull class]]) {
        //if((data.length>=0)&&(![data isEqualToString:@"null"])){
        
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:data forKey:keyName];
        
        [defaults synchronize];
        //        }
        //
        //    }else{
        //        NSLog(@"*** in uderDefaults, storedatatoDefaults is a nul object %@",data);
    }
    
}
+(NSString *)getDefaultStringValueForKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [NSString stringWithFormat:@"%@",[defaults valueForKey:key]];
}
+(void)removeDataFromDefaultsWithKey:(NSString *)keyName
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:keyName])
        [defaults removeObjectForKey:keyName];
    [defaults synchronize];
}
#pragma mark- AlertView
+(void)showAlertWithText:(NSString *)alertText
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


#pragma mark-get Device UUID
+(NSString *)getDeviceId
{
    NSString *deviceToken=[[NSUserDefaults standardUserDefaults] valueForKey:@"UniqueId"];
    if(deviceToken.length>1)
        return deviceToken;
    else
    {
        NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"UniqueId"];
        if (!identifier)
        {
            CFUUIDRef uuidRef = CFUUIDCreate(NULL);
            CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
            CFRelease(uuidRef);
            identifier = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
            CFRelease(uuidStringRef);
            [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"UniqueId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return identifier;
    }
}


+(NSString*)getDateFromDateTimeString:(NSString*)date
{
    NSArray *components = [date componentsSeparatedByString:@" "];
    if([components count])
    {
        NSString *newDate = components[0];
        return newDate;
    }
    
    return @"";
}






+(NSString*)trimString:(NSString*)string
{
    NSString *userNameTrimmed=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return userNameTrimmed;
}
// Resize Images
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize
{
    /*
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    */
    float oldWidth = sourceImage.size.width;
    float scaleFactor = newSize.width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//Method to filter the lastName of a person
+(NSString*)fetchLastName:(NSString*)lastName
{
    //NSLog(@"%@",lastName);
    lastName=[lastName stringByReplacingOccurrencesOfString:@"." withString:@" "];
    NSRange range=[lastName rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet] options:NSBackwardsSearch];
    range.length=range.location;
    range.location=0;
    lastName= ([lastName rangeOfString:@" " options:NSBackwardsSearch range:range].location==NSNotFound)? [NSString stringWithFormat:@" %@",lastName]:[lastName substringFromIndex:[lastName rangeOfString:@" " options:NSBackwardsSearch range:range].location];
    
    return lastName;
    
}

//Method to pop to particular view
+ (void)popToView:(Class)aClass navigationViewController:(id)delegate
{
    NSArray *viewControllers = [delegate viewControllers];
    NSLog(@"View Controllers:%@,popToView:%@",viewControllers,aClass);
    for( int i=(int)[viewControllers count]-1;i>=0;i--)
    {
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:aClass])
        {
            [delegate popToViewController:obj animated:YES];
            return;
        }
    }

}

+(NSString *)getResourcePath:(NSString *)forString {
    NSString *path=@"";
    if(forString) {
        NSArray *arr=[forString componentsSeparatedByString:@"."];
        if([arr count]==2) {
            path=[[NSBundle mainBundle] pathForResource:[arr objectAtIndex:0] ofType:[arr objectAtIndex:1]];
        }
    }
    NSLog(@"%@",path);
    return path;
    
}


+(void)getSectionIndexList:(NSArray*)names Key:(NSString*)key :(void (^)(NSMutableDictionary *, NSException *))completionBlock
{
    BOOL found;
    
    @try {
        // Try something
        
        NSMutableDictionary *listSection=[[NSMutableDictionary alloc]init];
        // Loop through the names and create our keys for section Index
        for (NSDictionary *book in names)
        {
            NSString *lastName=[self fetchLastName:[book objectForKey:key]];
//            NSString *lastName=[book objectForKey:key];
            NSString *c = [[[lastName substringToIndex:2] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
//             NSString *c = [[[lastName substringToIndex:1] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            found = NO;
            
            for (NSString *str in [listSection allKeys])
            {
                if ([str caseInsensitiveCompare:c] == NSOrderedSame)
                {
                    found = YES;
                }
            }
            
            if (!found)
            {
                [listSection setValue:[[NSMutableArray alloc] init] forKey:c];
                
            }
        }
        for (NSDictionary *book in names)
        {
            NSString *lastName=[self fetchLastName:[book objectForKey:key]];
//             NSString *lastName=[book objectForKey:key];
            NSString *c = [[[lastName substringToIndex:2] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//             NSString *c = [[[lastName substringToIndex:1] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [[listSection objectForKey:c] addObject:book];
        }
        
        completionBlock(listSection,nil);
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
        completionBlock(nil,e);
    }
    
}

//AlertView Background
+ (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UIGraphicsBeginImageContext(demoView.frame.size);
    [[UIImage imageNamed:[Reusables getDefaultValue:MAIN_BACKGROUND]] drawInRect:demoView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    demoView.backgroundColor = [UIColor colorWithPatternImage:image];

    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
//    [imageView setImage:[UIImage imageNamed:@"demo"]];
//    [demoView addSubview:imageView];
    
    return demoView;
}





@end
