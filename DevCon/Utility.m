//
//  Utility.m
//  PropertyGuru
//
//  Created by Tonytoons on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#define NUMBERS	@"0123456789"
#define NUMBERSPERIOD @"0123456789."
#import <QuartzCore/QuartzCore.h>

@implementation Utility
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
+ (BOOL) isNumber:(NSString *)input{
   NSCharacterSet *cs;
   NSString *filtered;
   
   // Check for period
   if ([input rangeOfString:@"."].location == NSNotFound)
   {
      cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
      filtered = [[input componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
      return [input isEqualToString:filtered];
   }
   
   // Period is in use
   cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD] invertedSet];
   filtered = [[input componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
   NSLog(@"filter: %@", filtered);
   return [input isEqualToString:filtered];   
}

+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect{
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created context
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(rect.origin.x * -1,
								 rect.origin.y * -1,
								 imageToCrop.size.width,
								 imageToCrop.size.height);
	
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	NSLog(@"rect width: %0.0f, cropped width: %0.0f", rect.size.width, cropped.size.width);
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	//Note: this is autoreleased
	return cropped;
}

+ (UIImage *)forceImageResize:(UIImage *) sourceImage newsize:(CGSize) targetSize{
	UIImage *newImage = nil;
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;   
	thumbnailRect.origin = CGPointMake(0.0,0.0);
	
	thumbnailRect.size.width  = targetSize.width;
	thumbnailRect.size.height = targetSize.height;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");   
	
	return newImage;
}

+ (UIImage *) imageByScalingProportionallyToSize:(UIImage *) sourceImage newsize:(CGSize)targetSize resizeFrame:(BOOL) resize{
   UIImage *newImage = nil;
   
   CGSize imageSize = sourceImage.size;
   CGFloat width = imageSize.width;
   CGFloat height = imageSize.height;
   
   CGFloat targetWidth = targetSize.width;
   CGFloat targetHeight = targetSize.height;
   
   CGFloat scaleFactor = 0.0;
   CGFloat scaledWidth = targetWidth;
   CGFloat scaledHeight = targetHeight;
   
   CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
   
   if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
      
      CGFloat widthFactor = targetWidth / width;
      CGFloat heightFactor = targetHeight / height;
      
      if (widthFactor < heightFactor) 
         scaleFactor = widthFactor;
      else
         scaleFactor = heightFactor;
      
      scaledWidth  = width * scaleFactor;
      scaledHeight = height * scaleFactor;
      
      // center the image
      
      if (widthFactor < heightFactor) {
         thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
      } else if (widthFactor > heightFactor) {
         thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
      }
   }   
   
   // this is actually the interesting part:
   
   if( resize ){
      CGSize newSize = CGSizeMake(scaledWidth,scaledHeight);
      UIGraphicsBeginImageContext(newSize);
   }
   else UIGraphicsBeginImageContext(targetSize);
   
   CGRect thumbnailRect = CGRectZero;   
   if(!resize) thumbnailRect.origin = thumbnailPoint;
   
   thumbnailRect.size.width  = scaledWidth;
   thumbnailRect.size.height = scaledHeight;
   
   [sourceImage drawInRect:thumbnailRect];
   
   newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   
   if(newImage == nil){
	   NSLog(@"could not scale image");
   }
   
   return newImage;
}

+ (UIImage *) resizedImage:(UIImage *) inImage newsize:(CGRect) thumbRect{
	CGImageRef			imageRef = [inImage CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	// There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
	// see Supported Pixel Formats in the Quartz 2D Programming Guide
	// Creating a Bitmap Graphics Context section
	// only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
	// and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
	// The images on input here are likely to be png or jpeg files
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
		
	// Build a bitmap context that's the size of the thumbRect
	CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												thumbRect.size.width,		// width
												thumbRect.size.height,		// height
												CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
												4 * thumbRect.size.width,	// rowbytes
												CGImageGetColorSpace(imageRef),
												alphaInfo
												);
	
	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}

+ (NSString *) transformHTML:(NSString *) input{   
	input = [input stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
   input = [input stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
   input = [input stringByReplacingOccurrencesOfString:@"<br><br/>" withString:@"\n"];
   input = [input stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
   input = [input stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
   input = [input stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
   input = [input stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
   input = [input stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
   input = [input stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
   input = [input stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
   input = [input stringByReplacingOccurrencesOfString:@"&lquo;" withString:@"'"];
   input = [input stringByReplacingOccurrencesOfString:@"&rquo;" withString:@"'"];
   input = [input stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
   
   return input;
}

+ (UIImage*)imageWithBorderFromImage:(UIImage*)source{
   CGSize size = [source size];
   UIGraphicsBeginImageContext(size);
   CGRect rect = CGRectMake(0, 0, size.width, size.height);
   [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); 
   CGContextStrokeRect(context, rect);
   
   UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
   
   UIGraphicsEndImageContext();   
   //[source release];
   //CGContextRelease(context);
   
   return testImg;
}

/*+(NSString *) getDatabasePath
{
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    
    return databasePath;
}*/

+(void) showAlert:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alert show];
}

+(void)makeCornerRadius:(UIView*)theView andRadius:(float)radius{
    theView.layer.cornerRadius = radius;
    theView.layer.masksToBounds = YES;
}

+(void)makeBorder:(UIView*)theView andWidth:(float)width andColor:(UIColor *)color{
    theView.layer.borderColor = color.CGColor;
    theView.layer.borderWidth = width;
}

+(BOOL ) stringIsEmpty:(NSString *) aString shouldCleanWhiteSpace:(BOOL)cleanWhileSpace {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    }
    
    if (cleanWhileSpace) {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (UIImage*)drawImageWithColor:(UIColor*)color{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imagePath;
    imagePath = [[paths lastObject] stringByAppendingPathComponent:@"NavImage.png"];
    if([fileManager fileExistsAtPath:imagePath]){
        return  [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    }
    UIGraphicsBeginImageContext(CGSizeMake(320, 40));
    [color setFill];
    UIRectFill(CGRectMake(0, 0, 320, 40));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:imagePath atomically:YES];
    return image;
}

+ (NSString *)uniqueFileName
{
    CFUUIDRef theUniqueString = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUniqueString);
    CFRelease(theUniqueString);
    return (__bridge NSString *)string;
}

+ (BOOL)validateSigaporeNRCWithString:(NSString*)email
{
    NSString *nrcRegex = @"[A-Z]{1}+[0-9.-]{7}+[A-Z]{1}";
    NSPredicate *nrcTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nrcRegex];
    return [nrcTest evaluateWithObject:email];
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateNumberOnlyString:(NSString*)str
{
    NSString *emailRegex = @"[0-9.-]+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

+ (NSDate *)dateSubtractionSinceTodayByTimetick:(int)timetick{
    
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:-timetick
                                                  sinceDate:[NSDate date]];
    return newDate;
}

+ (NSString *)truncateTheString:(NSString *)str andLength:(int)lenght{
    NSRange stringRange = {0, MIN([str length], lenght)};
    //NSString *shortString = ([str length]>lenght ? [str substringToIndex:lenght] : str);
    NSString *shortString = @"";
    if (lenght > [str length])
        // throw exception, ignore error, or set shortString to myString
    {
        return str;
    }
    else
    {
        shortString = [str substringWithRange:stringRange];
        shortString = [shortString stringByAppendingString:@" "];
    }
    
    return shortString;
    
}

+ (float) getPercentageAmount:(float)percentage andTotal:(float)total{
    if (percentage == 0.0 || total == 0.0) {
        return 0.0;
    }
    
    float result = (percentage/100 * total);
    return result;
}

+ (BOOL) isEqualOSVersion:(NSString *)v{
    
    if (SYSTEM_VERSION_EQUAL_TO(v)) {
        return TRUE;
    }
    return FALSE;
}

+ (BOOL) isGreaterOSVersion:(NSString *)v{
    
    if (SYSTEM_VERSION_GREATER_THAN(v)) {
        return TRUE;
    }
    return FALSE;
}

+ (BOOL) isGreaterOREqualOSVersion:(NSString *)v{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)) {
        return TRUE;
    }
    return FALSE;
}

+ (BOOL) isLessOSVersion:(NSString *)v{
    
    if (SYSTEM_VERSION_LESS_THAN(v)) {
        return TRUE;
    }
    return FALSE;
}

+ (BOOL) SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO:(NSString *)v{
    
    if (SYSTEM_VERSION_LESS_THAN(v)) {
        return TRUE;
    }
    return FALSE;
}

@end
