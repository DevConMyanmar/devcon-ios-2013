//
//  NameLoginCollectionItem.m
//  PoS
//
//  Created by Zayar on 10/4/13.
//  Copyright (c) 2013 nex. All rights reserved.
//

#import "NameLoginCollectionItem.h"

@implementation NameLoginCollectionItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setName:(NSString *)str{
    lblName.text = str;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
