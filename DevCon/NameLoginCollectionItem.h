//
//  NameLoginCollectionItem.h
//  PoS
//
//  Created by Zayar on 10/4/13.
//  Copyright (c) 2013 nex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameLoginCollectionItem : UICollectionViewCell
{
    IBOutlet UILabel * lblName;
}
- (void) setName:(NSString *)str;
@end
