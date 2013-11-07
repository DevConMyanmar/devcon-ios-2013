//
//  NavBarButton.m
//  PropertyGuru
//
//  Created by Tonytoons on 3/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NavFavBarButton.h"
#import "AppDelegate.h"

@implementation NavFavBarButton

-(id)init{
   if(self = [super init]) {
    //AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
      
      // The default size for the save button is 49x30 pixels
      self.frame = CGRectMake(0,0, 18, 18);//btn_back.png 57x36
      
      // Center the text vertically and horizontally
      self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
      
      UIImage *image = [UIImage imageNamed:@"Star_Unselect"];
      
      // Make a stretchable image from the original image
      //UIImage *stretchImage =
      //[image stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
      
      // Set the background to the stretchable image
      [self setBackgroundImage:image forState:UIControlStateNormal];
      
      // Make the background color clear
      self.backgroundColor = [UIColor clearColor];
      
      // Set the font properties
      [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
      self.titleShadowOffset = CGSizeMake(0, -1);
      self.font = [UIFont boldSystemFontOfSize:13];
   }
   
   return self;
}

- (void) setFavImage:(BOOL)isFav{
    
    if (!isFav) {
        UIImage *image = [UIImage imageNamed:@"Star_Unselect"];
        // Set the background to the stretchable image
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [UIImage imageNamed:@"Star"];
        // Set the background to the stretchable image
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
}

-(void)setLandscape:(BOOL)value {
   
   /*UIImage *image;
   CGRect frame = self.frame;
   
   if(value) {
      image = [UIImage imageNamed:@"blueButtonSmall.png"];
      frame.size.height = 24;
   }
   else {
      image = [UIImage imageNamed:@"blueButton.png"];
      frame.size.height = 30;
      frame.origin.y -= 3;
   }
   
   UIImage *stretchImage =
   [image stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
   self.frame = frame;
   [self setBackgroundImage:stretchImage forState:UIControlStateNormal];*/
}

@end
