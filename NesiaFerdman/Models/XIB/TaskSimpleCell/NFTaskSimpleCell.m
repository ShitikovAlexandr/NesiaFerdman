//
//  NFTaskSimpleCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTaskSimpleCell.h"
#import "NotifyList.h"
#import "NFStyleKit.h"

@interface NFTaskSimpleCell ()
@property (strong, nonatomic) UILongPressGestureRecognizer *lpgr;
@property (assign, nonatomic) CGRect standartLabelFrame;
@property (strong, nonatomic) UIView *calendarColorView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation NFTaskSimpleCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
//    CGFloat calendarViewWidth = 6.0;
//    CGRect calFrame = CGRectMake(rect.size.width - calendarViewWidth, 0, calendarViewWidth, rect.size.height);
//    _calendarColorView = [[UIView alloc] initWithFrame:calFrame];
//    _calendarColorView.backgroundColor = [UIColor clearColor];
//    [self addSubview:_calendarColorView];
}


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

- (void)addData:(NFNEvent*)event {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (event) {
        self.event = event;
        self.calendarColorView.backgroundColor = [NFStyleKit colorFromHexString:event.calendarColor];
        self.textLabel.text = event.title;
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@", [self dateFormater:event.startDate],[self dateFormater:event.endDate]];

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
    self.calendarColorView.backgroundColor = [UIColor clearColor];
    self.timeLabel.text = @"";
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

- (NSString *)dateFormater:(NSString *)dateString {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:16]];
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    NSString* newDate = [dateFormatter1 stringFromDate:dateFromString];
    return newDate;
}



    


@end
