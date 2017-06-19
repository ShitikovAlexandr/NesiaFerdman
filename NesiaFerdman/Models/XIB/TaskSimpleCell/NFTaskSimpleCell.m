//
//  NFTaskSimpleCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTaskSimpleCell.h"
#import "NotifyList.h"
#import "NFStyleKit.h"

@interface NFTaskSimpleCell ()
@property (strong, nonatomic) UILongPressGestureRecognizer *lpgr;
@property (assign, nonatomic) CGRect standartLabelFrame;

@end

@implementation NFTaskSimpleCell


- (void)awakeFromNib {
    [super awakeFromNib];
  }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)addData:(NFEvent*)event {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (event) {
        self.event = event;
        self.textLabel.text = event.title;
        if (event.eventType == Event) {
            if (event.isDone) {
                [self.imageView setImage:[UIImage imageNamed:@"checked_enable.png"]];
            } else {
                [self.imageView setImage:[UIImage imageNamed:@"checked_disable.png"]];
            }
        } else {
            [self.imageView setImage:[UIImage imageNamed:@"point.png"]];
        }
    } else {
        self.textLabel.text = @"Добавить";
        [self.imageView setImage:[UIImage imageNamed:@"Add.png"]];
    }
}

- (void)prepareForReuse {
    self.textLabel.text = @"";
    [self.imageView setImage:nil];
    self.lpgr = nil;
    self.event = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageDiametr = 17.f;
    self.imageView.frame = CGRectMake(19, self.imageView.center.y - imageDiametr/2, imageDiametr , imageDiametr);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)addLongPressToCell {
    _lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    _lpgr.minimumPressDuration = 1.2; //seconds
    _lpgr.delegate = self;
    [self addGestureRecognizer:_lpgr];
}
- (void) handleLongPress {
    NSLog(@"press cell inside");
    NSNotification *notification = [NSNotification notificationWithName:LONG_CELL_PRESS object:self];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
}


    


@end
