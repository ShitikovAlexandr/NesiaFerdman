//
//  NFChackBox.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/2/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFChackBox : UIButton

@property (assign, nonatomic) BOOL isSelect;
@property (strong, nonatomic) NSString *imgSelected;
@property (strong, nonatomic) NSString  *imgUnselected;

@end
