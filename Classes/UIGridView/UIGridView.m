//
//  UIGridViewView.m
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "UIGridViewCell.h"
#import "UIGridViewRow.h"

@interface UIGridView ()
{
  int _numCols;     // 列
	int _count;       // 总数
}

@end

@implementation UIGridView

@synthesize uiGridViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
		[self setUp];
  }
  return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setUp];
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  return self;
}

- (void)setUp
{
	self.delegate = self;
	self.dataSource = self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc
{
	self.delegate = nil;
	self.dataSource = nil;
	self.uiGridViewDelegate = nil;
  
  [super dealloc];
}

#pragma mark - public

- (void)reloadData
{
  _numCols = [uiGridViewDelegate numberOfColumnsOfGridView:self];
	_count = [uiGridViewDelegate numberOfCellsOfGridView:self];
  
  [super reloadData];
}

- (UIGridViewCell *)dequeueReusableCell
{
	UIGridViewCell* temp = tempCell;
	tempCell = nil;
	return temp;
}

// UITableViewController specifics
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int residue = _count % _numCols;
	
	if (residue > 0)
    residue = 1;
	
	return (_count / _numCols) + residue;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [uiGridViewDelegate gridView:self heightForRowAt:indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"UIGridViewRow";
	
  UIGridViewRow *row = (UIGridViewRow *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (row == nil) {
    row = [[[UIGridViewRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
	
	CGFloat x = 0.0;
	CGFloat height = [uiGridViewDelegate gridView:self heightForRowAt:indexPath.row];
	
	for (int i=0;i<_numCols;i++) {
		
		if ((i + indexPath.row * _numCols) >= _count) {
			
			if ([row.contentView.subviews count] > i) {
				((UIGridViewCell *)[row.contentView.subviews objectAtIndex:i]).hidden = YES;
			}
			
			continue;
		}
		
		if ([row.contentView.subviews count] > i) {
			tempCell = [row.contentView.subviews objectAtIndex:i];
		} else {
			tempCell = nil;
		}
		
		UIGridViewCell *cell = [uiGridViewDelegate gridView:self
                                           cellForRowAt:indexPath.row
                                            AndColumnAt:i];
		
		if (cell.superview != row.contentView) {
			[cell removeFromSuperview];
			[row.contentView addSubview:cell];
			
			[cell addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		cell.hidden = NO;
		cell.rowIndex = indexPath.row;
		cell.colIndex = i;
		
		CGFloat thisWidth = [uiGridViewDelegate gridView:self widthForColumnAt:i];
		cell.frame = CGRectMake(x, 0, thisWidth, height);
		x += thisWidth;
	}
	
	row.frame = CGRectMake(row.frame.origin.x,
                         row.frame.origin.y,
                         x,
                         height);
	
  return row;
}


- (void)cellPressed:(id)sender
{
	UIGridViewCell *cell = (UIGridViewCell *)sender;
  if ([uiGridViewDelegate respondsToSelector:@selector(gridView:didSelectRowAt:AndColumnAt:)])
    [uiGridViewDelegate gridView:self didSelectRowAt:cell.rowIndex AndColumnAt:cell.colIndex];
}


@end
