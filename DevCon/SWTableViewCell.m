//
//  SWTableViewCell.m
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import "SWTableViewCell.h"
#import "UIColor+Expanded.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 90

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} SWCellState;

#pragma mark - SWUtilityButtonView

@interface SWUtilityButtonView : UIView

@property (nonatomic, strong) NSArray *utilityButtons;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, weak) SWTableViewCell *parentCell;
@property (nonatomic) SEL utilityButtonSelector;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@end

@implementation SWUtilityButtonView

#pragma mark - SWUtilityButonView initializers

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super init];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector; // eh.
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector; // eh.
    }
    
    return self;
}

#pragma mark Populating utility buttons

- (CGFloat)calculateUtilityButtonWidth {
    CGFloat buttonWidth = kUtilityButtonWidthDefault;
    if (buttonWidth * _utilityButtons.count > kUtilityButtonsWidthMax) {
        CGFloat buffer = (buttonWidth * _utilityButtons.count) - kUtilityButtonsWidthMax;
        buttonWidth -= (buffer / _utilityButtons.count);
    }
    return buttonWidth;
}

- (CGFloat)utilityButtonsWidth {
    return (_utilityButtons.count * _utilityButtonWidth);
}

- (void)populateUtilityButtons {
    NSUInteger utilityButtonsCounter = 0;
    for (UIButton *utilityButton in _utilityButtons) {
        CGFloat utilityButtonXCord = 0;
        if (utilityButtonsCounter >= 1) utilityButtonXCord = _utilityButtonWidth * utilityButtonsCounter;
        [utilityButton setFrame:CGRectMake(utilityButtonXCord, 0, _utilityButtonWidth, CGRectGetHeight(self.bounds))];
        [utilityButton setTag:utilityButtonsCounter];
        [utilityButton addTarget:self.parentCell action:self.utilityButtonSelector forControlEvents:UIControlEventTouchDown];
        [self addSubview: utilityButton];
        utilityButtonsCounter++;
    }
}

@end

@interface SWTableViewCell () <UIScrollViewDelegate> {
    SWCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
    UIScrollView *cellScrollView;
}

// Scroll view to be added to UITableViewCell
@property (nonatomic, weak) UIScrollView *cellScrollView;

// The cell's height
@property (nonatomic) CGFloat height;

// Views that live in the scroll view
@property (nonatomic, weak) UIView *scrollViewContentView;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewRight;




@end

@implementation SWTableViewCell
@synthesize objSchedule;
#pragma mark ScheduleCell class
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
    
    lblSpeaker.frame = CGRectMake(20, (lblTitle.frame.origin.y + lblTitle.frame.size.height) - 5, 206, 23);
    
    btnLocation.frame = CGRectMake(20, (lblSpeaker.frame.origin.y + lblSpeaker.frame.size.height), 150, 30);
    
    lblTitle.text = obj.strTitle;
    lblTime.text = [obj getSystemTimeOnlyByDate];
    [obj getScheduleSpeaker];
    [obj getSpeaker];
    lblSpeaker.text = obj.objSpeaker.strSpeakerName;
    
    ObjLocation * objLocation= [obj getLocationByStringID];
    NSLog(@"obj location id %@",objLocation.strServerId);
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

- (void) onLocation:(UIButton *)sendder{
    NSLog(@"location!!!");
}

#pragma mark Initializers

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
    height:(CGFloat)height
    leftUtilityButtons:(NSArray *)leftUtilityButtons
    rightUtilityButtons:(NSArray *)rightUtilityButtons {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightUtilityButtons = rightUtilityButtons;
        self.leftUtilityButtons = leftUtilityButtons;
        self.height = height;
        [self initializer];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (void)initializer {
    self.mainView.layer.cornerRadius = 10;
    self.mainView.layer.masksToBounds = YES;
    self.mainView = self;
    // Set up scroll view that will host our cell content
    if (cellScrollView == nil) {
        cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height)];
    }
    cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    cellScrollView.contentOffset = [self scrollViewContentOffset];
    cellScrollView.delegate = self;
    cellScrollView.showsHorizontalScrollIndicator = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [cellScrollView addGestureRecognizer:tapGesture];
    
    self.cellScrollView = cellScrollView;
    
    // Set up the views that will hold the utility buttons
    SWUtilityButtonView *scrollViewButtonViewLeft = [[SWUtilityButtonView alloc] initWithUtilityButtons:_leftUtilityButtons parentCell:self utilityButtonSelector:@selector(leftUtilityButtonHandler:)];
    [scrollViewButtonViewLeft setFrame:CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewLeft = scrollViewButtonViewLeft;
    [self.cellScrollView addSubview:scrollViewButtonViewLeft];
    
    SWUtilityButtonView *scrollViewButtonViewRight = [[SWUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];
    [scrollViewButtonViewRight setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewRight = scrollViewButtonViewRight;
    [self.cellScrollView addSubview:scrollViewButtonViewRight];
    
    // Populate the button views with utility buttons
    [scrollViewButtonViewLeft populateUtilityButtons];
    [scrollViewButtonViewRight populateUtilityButtons];
    
    
    
    /**** for Schedule cell ****/
    lblVerticalStrip = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 3, 137)];
    lblVerticalStrip.text = @"";
    
    [self addSubview:lblVerticalStrip];
    
    lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 206, 50)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Avenir Next Bold" size:16.0f];
    lblTitle.textColor = [UIColor colorWithRed:0/255.f green:91/255.f blue:113/255.f alpha:1];
    lblTitle.numberOfLines = 0;
    
    [self addSubview:lblTitle];
    
    lblTime = [[UILabel alloc]initWithFrame:CGRectMake(240, 87, 80, 54)];
    lblTime.backgroundColor = [UIColor clearColor];
    //lblTime.font = [UIFont boldSystemFontOfSize:15];
    lblTime.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:18.0f];
    lblTime.textColor = [UIColor colorWithRed:221/255.f green:126/255.f blue:55/255.f alpha:1];
    [self addSubview:lblTime];
    
    lblSpeaker = [[UILabel alloc]initWithFrame:CGRectMake(20, (lblTitle.frame.origin.y + lblTitle.frame.size.height) + 3, 206, 23)];
    lblSpeaker.backgroundColor = [UIColor clearColor];
    lblSpeaker.font = [UIFont fontWithName:@"Avenir Next Medium" size:15.0f];
    lblSpeaker.textColor = [UIColor colorWithRed:97/255.f green:87/255.f blue:87/255.f alpha:1];
    [self addSubview:lblSpeaker];
    
    btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocation.frame = CGRectMake(20, (lblSpeaker.frame.origin.y + lblSpeaker.frame.size.height) + 3, 150, 30);
    //btnLocation.titleLabel = lblSpeaker;
    btnLocation.titleLabel.font = [UIFont fontWithName:@"Avenir Next Medium" size:15.0f];
    btnLocation.titleLabel.textColor = [UIColor colorWithRed:221/255.f green:126/255.f blue:55/255.f alpha:1];
    [btnLocation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLocation addTarget:self action:@selector(onLocation:) forControlEvents:UIControlEventTouchUpInside];
    btnLocation.tag = self.tag;
    //btnLocation
    
    [self addSubview:btnLocation];
    /**** end for Schedule cell ****/
    
    // Create the content view that will live in our scroll view
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height)];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.cellScrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    // Add the cell scroll view to the cell
    UIView *contentViewParent = self;
    if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = [self.subviews objectAtIndex:0];
    }
    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:cellScrollView atIndex:0];
    for (UIView *subview in cellSubviews) {
        [self.scrollViewContentView addSubview:subview];
    }
}

-(void) scrollTapGesture:(UIGestureRecognizer *) sender {
    [_delegate didSelectedTheCell:self];
}

- (void) reloadTheScrollViewHeight:(float)cellHeight{
    if (cellScrollView != nil) {
        _height = cellHeight;
        cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height)];
        cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    }
}

#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(id)sender {
    
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if([utilityButton tag] == 0){
        AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
        [delegate clickFavSoundPlay];
    }
    [_delegate swippableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
}

- (void)leftUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    [_delegate swippableTableViewCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonTag];
}


#pragma mark - Overriden methods

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"row height %f",_height);
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    self.cellScrollView.contentOffset = CGPointMake([self leftUtilityButtonsWidth], 0);
    self.scrollViewButtonViewLeft.frame = CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height);
    self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height);
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height);
}

#pragma mark - Setup helpers

- (CGFloat)leftUtilityButtonsWidth {
    return [_scrollViewButtonViewLeft utilityButtonsWidth];
}

- (CGFloat)rightUtilityButtonsWidth {
    return [_scrollViewButtonViewRight utilityButtonsWidth];
}

- (CGFloat)utilityButtonsPadding {
    return ([_scrollViewButtonViewLeft utilityButtonsWidth] + [_scrollViewButtonViewRight utilityButtonsWidth]);
}

- (CGPoint)scrollViewContentOffset {
    return CGPointMake([_scrollViewButtonViewLeft utilityButtonsWidth], 0);
}

#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = [self leftUtilityButtonsWidth];
    _cellState = kCellStateCenter;
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kCellStateLeft;
}

- (void)wayToOriginalScrollView{
    [cellScrollView setContentOffset:CGPointMake(0, cellScrollView.frame.origin.y) animated:YES];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityButtonsWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x > [self leftUtilityButtonsWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x < ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [self leftUtilityButtonsWidth]) {
        // Expose the right button view
        self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth]), 0.0f, [self rightUtilityButtonsWidth], _height);
    } else {
        // Expose the left button view
        self.scrollViewButtonViewLeft.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityButtonsWidth], _height);
    }
}

@end

#pragma mark NSMutableArray class extension helper

@implementation NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addObject:button];
}

- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    button.tag = 10;
    [button setImage:icon forState:UIControlStateNormal];
    [self addObject:button];
}

- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon andTag:(int)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    button.tag = tag;
    [button setImage:icon forState:UIControlStateNormal];
    [self addObject:button];
}

@end

