//
//  RootViewController.m
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "Cell.h"

@implementation RootViewController{
    
    int objectNumber;
}


@synthesize table;

-(void)viewDidLoad{
    objectNumber = 20;
}

- (void)dealloc {
    [super dealloc];
}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
	return 160;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
	return 80;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
	return 2;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
	return objectNumber;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	Cell *cell = (Cell *)[grid dequeueReusableCell];
	
	if (cell == nil) {
		cell = [[Cell alloc] init];
	}
	
	cell.label.text = [NSString stringWithFormat:@"(%d,%d)", rowIndex, columnIndex];
	
	return cell;
}

-(void) gridView:(UIGridView *)grid didEditRowAt:(int)row AndColumnAt:(int)column InSection:(int)section{
    objectNumber --;
    [grid reloadData];
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex Section:(int)section
{
	NSLog(@"%d, %d clicked", rowIndex, colIndex);
}


@end
