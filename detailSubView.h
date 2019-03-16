//
//  UIDetailSubView.h
//  admidio
//
//  Created by Marc Ahlgrim on 27.12.13.
//  Copyright (c) 2013 ahlgrim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailSubView : UITableView

@property NSArray *datenListe;

- (UITableViewCell *) cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) numberOfRowsInSection:(NSInteger)section;
- (NSInteger) numberOfSections;
//- (id)initWithFrame:(CGRect)frame;

@end
