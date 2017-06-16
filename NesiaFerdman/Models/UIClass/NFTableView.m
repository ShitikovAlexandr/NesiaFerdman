//
//  NFTableView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTableView.h"

@implementation NFTableView


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setEditing:NO animated:YES];
}



@end
