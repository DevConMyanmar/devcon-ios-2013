//
//  Utility.h
//  PropertyGuru
//
//  Created by Tonytoons on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface Utility : NSObject {

}

+ (NSData *)DESEncryptWithKey:(NSString *)key tokenData:(NSString *) token;

+ (BOOL) isNumber:(NSString *)input;
+ (UIImage *)imageByScalingProportionallyToSize:(UIImage *) sourceImage newsize:(CGSize)targetSize resizeFrame:(BOOL) resize;
+ (NSString *) transformHTML:(NSString *) input;
+ (NSString *) md5:(NSString *) str;
+ (UIImage*)imageWithBorderFromImage:(UIImage*)source;
+ (NSString *)flattenHTML:(NSString *)html;
+ (NSMutableArray *) parseHTMLBody:(NSString *)html relativePath:(NSString *) rPath rootLocation:(NSString *) rootPath;
+ (CGFloat) processPaging:(NSString *)content initY:(float)y width:(float)w height:(float)h ch:(NSMutableArray *) chapter fontSize:(CGFloat) fz;
+ (CGPoint) MTFrameGetLineOriginAtIndex:(CTFrameRef) frame pIndex:(CFIndex) index;
+ (UIImage *)forceImageResize:(UIImage *) sourceImage newsize:(CGSize) targetSize;
+ (UIImage *) resizedImage:(UIImage *) inImage newsize:(CGRect) thumbRect;
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;

+(NSString *) getDatabasePath;

+(void) showAlert:(NSString *) title message:(NSString *) msg;

+(void)makeCornerRadius:(UIView*)theView andRadius:(float)radius;
+(void)makeBorder:(UIView*)theView andWidth:(float)width andColor:(UIColor *)color;

+(BOOL) stringIsEmpty:(NSString *) aString shouldCleanWhiteSpace:(BOOL)cleanWhileSpace;
+ (NSString*)base64forData:(NSData*)theData ;
+ (UIImage*)drawImageWithColor:(UIColor*)color;
+ (NSString *)uniqueFileName;
+ (BOOL)validateSigaporeNRCWithString:(NSString*)email;
+ (BOOL)validateEmailWithString:(NSString*)email;
+ (BOOL)validateNumberOnlyString:(NSString*)str;
+ (NSDate *)dateSubtractionSinceTodayByTimetick:(int)timetick;
+ (NSString *)truncateTheString:(NSString *)str andLength:(int)lenght;
+ (float) getPercentageAmount:(float)percentage andTotal:(float)total;
@end
