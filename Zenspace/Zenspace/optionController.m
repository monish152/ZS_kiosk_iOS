//
//  optionController.m
//  MTSCRADemo
//
//  Created by Tam Nguyen on 9/17/15.
//  Copyright © 2015 MagTek. All rights reserved.
//

#import "optionController.h"

@implementation optionController
{
    NSArray* optionArray;
    NSArray* optionValue;
    NSMutableArray* selectedCardArray;
}

-(id)initWithData
{
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        optionArray = @[@"Transaction Type", @"Reporting Option", @"Acquire Response", @"Terminal Configuration Command", @"Bluetooth LE Demo", @"Card Type", @"Option", @"Misc. Commands"];
        optionValue = @[
                        @[@"Purchase", @"Cash Back with Purchase", @"Goods", @"Services", @"International Goods (Purchase)", @" International Cash Advance or Cash Back", @"Domestic Cash Advance or Cash Back"],
                        @[@"Termination Status Only ", @"Major Status Changes ", @"All Status Changes "],
                        @[@"Approve", @"Decline", @"None"],
                        @[@"0x0305 - Set Terminal Configuration", @"0x0306 - Get Terminal Configuration", @"0x030E - Commit Configuration"],
                        @[@"Initiate Pairing Demo"],
                        @[@"MSR", @"Contact", @"Contactless"],
                        @[@"Qwick Chip"],
                        @[@"Set Date Time"],
                        ];
        
        if(!selectedCardArray)
            selectedCardArray = [[NSMutableArray alloc]init];
        
        [selectedCardArray addObject:[NSIndexPath indexPathForRow:0 inSection:5]];
        [selectedCardArray addObject:[NSIndexPath indexPathForRow:1 inSection:5]];
    }
    return self;
}
- (void)viewDidLoad {
    self.title = @"Options";
    [super viewDidLoad];
    
    
    _optionDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:0] , @"ApproveSelection", [NSNumber numberWithInteger:0], @"PurchaseOption",[NSNumber numberWithInteger:0], @"ReportingOption", [NSNumber numberWithInteger:1],@"CardType", [NSNumber numberWithInt:0] ,@"QuickChip",  nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;[selectedCardArray addObject:indexPath];
    self.tableView.allowsMultipleSelection = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableCell"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return optionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (  (NSArray*)optionValue[section]).count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return optionArray[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    cell.textLabel.text = optionValue[indexPath.section][indexPath.row];
    if (indexPath.section == 2) {
        
        
        if([[_optionDict valueForKey:@"ApproveSelection"] intValue] == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == 1)
    {
        if([[_optionDict valueForKey:@"ReportingOption"] intValue] == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else if (indexPath.section == 5)
    {
        if([selectedCardArray containsObject:indexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == 0) {
        if([[_optionDict valueForKey:@"PurchaseOption"] intValue] == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else if (indexPath.section == 6)
    {
        if([[_optionDict valueForKey:@"QuickChip"] intValue] == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        [_optionDict setValue: [NSNumber numberWithInt:(int)indexPath.row] forKey:@"ApproveSelection"];
    }
    if(indexPath.section == 1)
    {
        [_optionDict setValue: [NSNumber numberWithInt:(int)indexPath.row] forKey:@"ReportingOption"];
    }
    if(indexPath.section == 0)
    {
        [_optionDict setValue: [NSNumber numberWithInt:(int)indexPath.row] forKey:@"PurchaseOption"];
    }
    if(indexPath.section == 3)
    {
        if([self.delegate respondsToSelector:@selector(didSelectConfigCommand:)])
        {
            if(indexPath.row == 0)
            {
                Byte tempByte[] = {0x03, 0x05} ;
                [self.delegate didSelectConfigCommand:[NSData dataWithBytes:tempByte length:2]];
            }
            else if(indexPath.row == 1)
            {
                Byte tempByte[] = {0x03, 0x06} ;
                [self.delegate didSelectConfigCommand:[NSData dataWithBytes:tempByte length:2]];
            }
            else
            {
                Byte tempByte[] = {0x03, 0x0e} ;
                [self.delegate didSelectConfigCommand:[NSData dataWithBytes:tempByte length:2]];
                
            }
        }
    }
    if(indexPath.section == 4)
    {
        blePairDemo* bleDemo = [blePairDemo new];
        [self.navigationController pushViewController:bleDemo animated:YES];
    }
    if(indexPath.section == 5)
    {
        
        if(![selectedCardArray containsObject:indexPath])
        {
            
            [selectedCardArray addObject:indexPath];
        }
        else
        {
            [selectedCardArray removeObject:indexPath];
        }
        //[self getCardType];
    }
    if(indexPath.section == 6)
    {
        if([_optionDict[@"QuickChip"] intValue] == 0)
            [_optionDict setValue: @"1" forKey:@"QuickChip"];
        else
            [_optionDict setValue: @"0" forKey:@"QuickChip"];
    }
    if(indexPath.section == 7)
    {
        if([self.delegate respondsToSelector:@selector(didSelectSetDateTime)])
        {
            if(indexPath.row == 0)
            {
              
                [self.delegate didSelectSetDateTime];
            }
        }
        
    }

    
    [self.tableView reloadData];
    
    if(indexPath.section != 5)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}
- (Byte)getCardType
{
    
    
    Byte selectedCard = 0;
    
    Byte cardValue = 0;
    for(int i = 0; i < selectedCardArray.count; i++)
    {
        NSIndexPath *indexPath = selectedCardArray[i];
        if(indexPath.row == 0)
        {
            cardValue = 0x01;
            
        }
        else if (indexPath.row == 1 )
        {
            cardValue = 0x02;
            
        }
        else if (indexPath.row == 2)
        {
            cardValue = 0x04;
            
        }
        
        selectedCard = selectedCard | cardValue;
        
    }
    
    
    
    
    //  [_optionDict setValue: [NSNumber numberWithInt:(int)selectedCard] forKey:@"CardType"];
    
    
    
    return selectedCard;
}
-(Byte)getReportingOption
{
    switch ([[_optionDict valueForKey:@"ReportingOption"] intValue]) {
        case 0:
            return 0x00;
        case 1:
            return 0x01;
        case 2:
            return 0x02;
        default:
            break;
    }
    return 0x00;
    
}

-(Byte) getPurchaseOption
{
    switch ([[_optionDict valueForKey:@"PurchaseOption"] intValue]) {
        case 0:
            return 0x00;
        case 1:
            return 0x02;
        case 2:
            return 0x04;
        case 3:
            return 0x08;
        case 4:
            return 0x10;
        case 5:
            return 0x40;
        case 6:
            return 0x80;
        default:
            break;
    }
    return 0x00;
}
-(BOOL)isQuickChip
{
    if([_optionDict[@"QuickChip"] intValue] == 0)
        return NO;
    else
        return YES;
    
}

-(BOOL)shouldSendApprove
{
    if([[_optionDict valueForKey:@"ApproveSelection"] intValue] == 1)
        return false;
    else
        return true;
    //NSLog(@"Option Value : %i", [[_optionDict valueForKey:@"ApproveSelection"] intValue]);
    // return [[_optionDict valueForKey:@"ApproveSelection"] intValue];
}
@end
