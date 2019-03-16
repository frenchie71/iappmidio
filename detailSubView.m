//
//  UIDetailSubView.m
//  admidio
//
//  Created by Marc Ahlgrim on 27.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import "detailSubView.h"


@interface detailSubView ()

@end

@implementation detailSubView




// /////////////////////////////////////////////////////
// Little helper : getString
// /////////////////////////////////////////////////////





- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (NSInteger) numberOfRowsInSection:(NSInteger)section
{
    return _datenListe.count;
}


- (NSInteger) numberOfSections
{
    return 1;
}



- (UITableViewCell *) cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [self dequeueReusableCellWithIdentifier:@"detailCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"];
    }

    cell.textLabel.text       = [[_datenListe objectAtIndex:indexPath.row] objectForKey:@"usf_name"] ;
    cell.detailTextLabel.text = [[_datenListe objectAtIndex:indexPath.row] objectForKey:@"usd_value"];
        
    return cell;
}





@end
