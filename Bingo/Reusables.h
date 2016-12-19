//
//  Reusables.h
//  Bingo
//
//  Created by feialoh on 21/01/13.
//  Copyright (c) 2013 feialoh. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Reusables : NSObject

+(NSString *)getDeviceId;
+(void)storeDataToDefaults :(NSString *)keyName objectToAdd:(id)data;
+(void)showAlertWithText:(NSString *)alertText;


+(NSString *)getDefaultValue:(NSString *)key;
+ (UIView *)createDemoView;

+(NSString*)getCurrentDateWithTime;
+(NSString*)getDateFromDateTimeString:(NSString*)date;
+(NSString *)getDefaultStringValueForKey:(NSString *)key;
+(NSString*)trimString:(NSString*)string;
+(void)removeDataFromDefaultsWithKey:(NSString *)keyName;
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+(NSString*)fetchLastName:(NSString*)lastName;
+ (void)popToView:(Class)aClass navigationViewController:(id)delegate;
+(NSString *)getResourcePath:(NSString *)forString;
+(void)getSectionIndexList:(NSArray*)names Key:(NSString*)key :(void (^)(NSMutableDictionary *, NSException *))completionBlock;
@end
