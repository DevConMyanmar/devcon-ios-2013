//
//  ScheduleCell.m
//  DevCon
//
//  Created by Zayar on 10/8/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import "ScheduleCell.h"
#import "UIColor+Expanded.h"
#import "ObjSchedule.h"
#import "ObjLocation.h"
@implementation ScheduleCell
@synthesize objSchedule;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        lblVerticalStrip = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 3, 137)];
        lblVerticalStrip.text = @"";
        
        [self addSubview:lblVerticalStrip];
        
        lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, 206, 50)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.font = [UIFont fontWithName:@"Avenir Next Medium" size:16.0f];
        lblTitle.textColor = [UIColor colorWithRed:0/255.f green:91/255.f blue:113/255.f alpha:1];
        lblTitle.numberOfLines = 0;
        
        [self addSubview:lblTitle];
        
        lblTime = [[UILabel alloc]initWithFrame:CGRectMake(230, 57, 80, 23)];
        lblTime.backgroundColor = [UIColor clearColor];
        //lblTime.font = [UIFont boldSystemFontOfSize:15];
        lblTime.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:15.0f];
        lblTime.textColor = [UIColor colorWithRed:221/255.f green:126/255.f blue:55/255.f alpha:1];
        [self addSubview:lblTime];
        
        lblSpeaker = [[UILabel alloc]initWithFrame:CGRectMake(17, (lblTitle.frame.origin.y + lblTitle.frame.size.height) + 3, 206, 23)];
        lblSpeaker.backgroundColor = [UIColor clearColor];
        lblSpeaker.font = [UIFont fontWithName:@"Avenir Next Medium" size:15.0f];
        lblSpeaker.textColor = [UIColor colorWithRed:97/255.f green:87/255.f blue:87/255.f alpha:1];
        [self addSubview:lblSpeaker];
        
        btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLocation.frame = CGRectMake(17, (lblSpeaker.frame.origin.y + lblSpeaker.frame.size.height) + 3, 150, 30);
        //btnLocation.titleLabel = lblSpeaker;
        btnLocation.titleLabel.font = [UIFont fontWithName:@"Avenir Next Medium" size:15.0f];
        btnLocation.titleLabel.textColor = [UIColor colorWithRed:221/255.f green:126/255.f blue:55/255.f alpha:1];
        [btnLocation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        //btnLocation
        
        [self addSubview:btnLocation];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //NSLog(@"cell layout setted!! x:%.2f,y:%.2f, height :%.2f and modefined height:%.2f, %f",lblTitle.frame.origin.x,lblTitle.frame.origin.y,[self heightForCellWithPureHeight:objSchedule],lblTitle.frame.size.height,lblTitle.frame.size.height + 81);
    //lblTitle.text = objSchedule.strTitle;
    
}

- (void)loadTheViewWith:(ObjSchedule *)obj{
    objSchedule = obj;
    CGRect detailTextLabelFrame = lblTitle.frame;
    detailTextLabelFrame.size.height = [self heightForCellWithPureHeight:objSchedule];
    lblTitle.frame = detailTextLabelFrame;
    NSLog(@"cell layout setted!! x:%.2f,y:%.2f, height :%.2f and modefined height:%.2f, %f",lblTitle.frame.origin.x,lblTitle.frame.origin.y,[self heightForCellWithPureHeight:objSchedule],lblTitle.frame.size.height,lblTitle.frame.size.height + 81);
    
    CGRect stripTextLabelFrame = lblVerticalStrip.frame;
    stripTextLabelFrame.size.height = [[self class] heightForCellWithPost:objSchedule]+ 81;
    lblVerticalStrip.frame = stripTextLabelFrame;
    
    CGRect timeTextLabelFrame = lblTime.frame;
    timeTextLabelFrame.origin.y = (([[self class] heightForCellWithPost:objSchedule]+ 81)/2)- timeTextLabelFrame.size.height;
    lblTime.frame = timeTextLabelFrame;
    
    lblSpeaker.frame = CGRectMake(17, (lblTitle.frame.origin.y + lblTitle.frame.size.height) + 3, 206, 23);
    
    btnLocation.frame = CGRectMake(17, (lblSpeaker.frame.origin.y + lblSpeaker.frame.size.height) + 3, 150, 30);
    
    lblTitle.text = obj.strTitle;
    lblTime.text = obj.strTime;
    lblSpeaker.text = obj.strSpeakerName;
    
    ObjLocation * objLocation= [obj getLocation];
    //NSLog(@"schedule str color hex %@ and location id %d",objLocation.strColorHex,obj.locationId);
    lblVerticalStrip.backgroundColor = [UIColor colorWithHexString:objLocation.strColorHex];
    //NSLog(@"loadTheView height:%.2f",lblTitle.frame.size.height);
    
    [btnLocation setTitle:objLocation.strName forState:normal];
    [btnLocation setTitleColor:[UIColor colorWithHexString:objLocation.strColorHex] forState:normal];
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(ObjSchedule *)obj {
    
    CGSize sizeToFit = [obj.strTitle sizeWithFont:[UIFont fontWithName:@"Avenir Next Medium" size:16.0f] constrainedToSize:CGSizeMake(206.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"size to fix %f",sizeToFit.height + 81.0f);
    return fmaxf(50.0f, sizeToFit.height+ 5);
}

- (CGFloat)heightForCellWithPureHeight:(ObjSchedule *)obj {
    CGSize sizeToFit = [obj.strTitle sizeWithFont:[UIFont fontWithName:@"Avenir Next Medium" size:16.0f] constrainedToSize:CGSizeMake(206.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return fmaxf(50.0f, sizeToFit.height+5);
}

@end
