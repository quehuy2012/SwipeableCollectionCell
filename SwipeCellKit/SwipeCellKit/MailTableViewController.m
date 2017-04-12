//
//  MailTableViewController.m
//  SwipeCellKit
//
//  Created by CPU11713 on 4/11/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "MailTableViewController.h"
#import "ZASwipeCellKit.h"
#import "Email.h"
#import "MailViewCell.h"
#import "ActionDescriptor.h"

#import "MailTableViewCell.h"

@interface MailTableViewController () <ZASwipeViewCellDelegate>

@property (nonatomic, readwrite) NSMutableArray<Email *> *emails;
@property (nonatomic, readwrite) ZASwipeCellOptions *defaultOptions;
@property (nonatomic, readwrite) ButtonDisplayMode buttonDisplayMode;
@property (nonatomic, readwrite) ButtonStyle buttonStyle;

@property (nonatomic, readwrite) BOOL isSwipeRightEnable;

@end

@implementation MailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Test xib
    [self.tableView registerNib:[UINib nibWithNibName:@"MailTableViewCell" bundle:nil] forCellReuseIdentifier:@"testCell"];
    
    
    self.tableView.allowsSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 120;
    self.tableView.userInteractionEnabled = YES;
    
//    /self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.buttonDisplayMode = ButtonDisplayModeTitleAndImage;
    self.buttonStyle = ButtonStyleBackgroundColor;
    self.isSwipeRightEnable = YES;
    self.defaultOptions = [[ZASwipeCellOptions alloc] init];
    
    [self resetData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.emails count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //MailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.selectedBackgroundView = [self createSelectedBackgroundView];
    
    Email *email = self.emails[indexPath.row];
    cell.fromLabel.text = email.from;
    cell.dateLabel.text = [email relativeDateString];
    cell.subjectLabel.text = email.subject;
    cell.bodyLabel.text = email.body;
    cell.unread = email.unread;
    
    
    //    for (UIGestureRecognizer *gesture in cell.gestureRecognizers) {
    //        NSLog(@"Gesture: %@ enable: %d",gesture, gesture.isEnabled);
    //    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
        CGRect frame = cell.frame;
        NSLog(@"Cell at indexpath:%ld  frame: x(%.2f),y(%.2f),width(%.2f),height(%.2f)",(long)indexPath.row, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    //    CGRect rectOfCell = [tableView rectForRowAtIndexPath:indexPath];
    //    NSLog(@"Table cell frame: x(%.2f),y(%.2f),width(%.2f),height(%.2f)", rectOfCell.origin.x, rectOfCell.origin.y, rectOfCell.size.width, rectOfCell.size.height);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MailViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect frame = cell.frame;
    NSLog(@"Cell frame: x(%.2f),y(%.2f),width(%.2f),height(%.2f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

- (UIView *)createSelectedBackgroundView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    return view;
}

- (void)resetData {
    NSArray *mockEmails = @[
                            [[Email alloc] initWithSubject:@"Video: Operators and Strong Opinions with Erica Sadun" from:@"Realm" body:@"Swift operators are flexible and powerful. They’re symbols that behave like functions, adopting a natural mathematical syntax, for example 1 + 2 versus add(1, 2). So why is it so important that you treat them like potential Swift Kryptonite? Erica Sadun discusses why your operators should be few, well-chosen, and heavily used. There’s even a fun interactive quiz! Play along with “Name That Operator!” and learn about an essential Swift best practice." date:[NSDate date]],
                            [[Email alloc] initWithSubject:@"[Pragmatic Bookstore] Your eBook 'Swift Style' is ready for download" from:@"The Pragmatic Bookstore" body:@"Hello, The gerbils at the Pragmatic Bookstore have just finished hand-crafting your eBook of Swift Style. It's available for download at the following URL:" date:[NSDate date]],
                            [[Email alloc] initWithSubject:@"Video: Operators and Strong Opinions with Erica Sadun" from:@"Realm" body:@"Swift operators are flexible and powerful. They’re symbols that behave like functions, adopting a natural mathematical syntax, for example 1 + 2 versus add(1, 2). So why is it so important that you treat them like potential Swift Kryptonite? Erica Sadun discusses why your operators should be few, well-chosen, and heavily used. There’s even a fun interactive quiz! Play along with “Name That Operator!” and learn about an essential Swift best practice." date:[NSDate date]],
                            [[Email alloc] initWithSubject:@"[Pragmatic Bookstore] Your eBook 'Swift Style' is ready for download" from:@"The Pragmatic Bookstore" body:@"Hello, The gerbils at the Pragmatic Bookstore have just finished hand-crafting your eBook of Swift Style. It's available for download at the following URL:" date:[NSDate date]],
                            [[Email alloc] initWithSubject:@"Video: Operators and Strong Opinions with Erica Sadun" from:@"Realm" body:@"Swift operators are flexible and powerful. They’re symbols that behave like functions, adopting a natural mathematical syntax, for example 1 + 2 versus add(1, 2). So why is it so important that you treat them like potential Swift Kryptonite? Erica Sadun discusses why your operators should be few, well-chosen, and heavily used. There’s even a fun interactive quiz! Play along with “Name That Operator!” and learn about an essential Swift best practice." date:[NSDate date]],
                            [[Email alloc] initWithSubject:@"Video: Operators and Strong Opinions with Erica Sadun" from:@"Realm" body:@"Swift operators are flexible and powerful. They’re symbols that behave like functions, adopting a natural mathematical syntax, for example 1 + 2 versus add(1, 2). So why is it so important that you treat them like potential Swift Kryptonite? Erica Sadun discusses why your operators should be few, well-chosen, and heavily used. There’s even a fun interactive quiz! Play along with “Name That Operator!” and learn about an essential Swift best practice." date:[NSDate date]]
                            ];
    
    self.emails = [NSMutableArray arrayWithArray:mockEmails];
    for (Email *email in self.emails) {
        email.unread = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - ZASwipeTalbeViewCellDelegate

- (NSArray<ZASwipeAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation {
    Email *email = self.emails[indexPath.row];
    
    if (orientation == ZASwipeActionsOrientationLeft) {
        if (!self.isSwipeRightEnable) {
            return nil;
        }
        
        __weak typeof(self) weakSelf = self;
        ZASwipeAction *readAction = [[ZASwipeAction alloc] initWithStyle:ZASwipeActionStyleDefault title:nil handler:^(ZASwipeAction *action, NSIndexPath *indexPath) {
            BOOL updatedStatus = !email.unread;
            email.unread = updatedStatus;
            
            MailViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            cell.unread = updatedStatus;
        }];
        
        readAction.hideWhenSelected = YES;
        readAction.accessibilityLabel = email.unread ? @"Mask as Read" : @"Mask as Unread";
        
        ActionDescriptorType type = email.unread ? ActionDescriptorTypeRead : ActionDescriptorTypeUnread;
        ActionDescriptor *descriptor = [ActionDescriptor type:type];
        [self configureAction:readAction withDescriptor:descriptor];
        return @[readAction];
    }
    else {
        
        ZASwipeAction *flagAction = [[ZASwipeAction alloc] initWithStyle:ZASwipeActionStyleDefault title:nil handler:nil];
        
        flagAction.hideWhenSelected = YES;
        [self configureAction:flagAction withDescriptor:[ActionDescriptor type:ActionDescriptorTypeFlag]];
        
        __weak typeof(self) weakSelf = self;
        ZASwipeAction *deleteAction = [[ZASwipeAction alloc] initWithStyle:ZASwipeActionStyleDestructive title:nil handler:^(ZASwipeAction *action, NSIndexPath *indexPath) {
            [weakSelf.emails removeObjectAtIndex:indexPath.row];
        }];
        [self configureAction:deleteAction withDescriptor:[ActionDescriptor type:ActionDescriptorTypeTrash]];
        return @[deleteAction, flagAction];
    }
}

- (ZASwipeCellOptions *)tableView:(UITableView *)tableView editActionsOptionsForRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation {
    ZASwipeCellOptions *options = [[ZASwipeCellOptions alloc] init];
    options.expansionStyle = orientation == ZASwipeActionsOrientationLeft ? [ZASwipeExpansionStyle selection] : [ZASwipeExpansionStyle destructive];
    options.transitionStyle = self.defaultOptions.transitionStyle;
    
    options.buttonSpacing = 4;
    
    return options;
}

- (void)tableView:(UITableView *)tableView didEndEdittingRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation {
    NSLog(@"End editting row at index path %ld", (long)indexPath.row);
}

- (void)tableView:(UITableView *)tableView willBeginEdittingRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation {
    NSLog(@"Begin editting row at index path %ld", (long)indexPath.row);
}

- (void)configureAction:(ZASwipeAction *)action withDescriptor:(ActionDescriptor *)descriptor {
    action.title = [descriptor titleForDisplayMode:self.buttonDisplayMode];
    action.image = [descriptor imageForStyle:self.buttonStyle inDisplayMode:self.buttonDisplayMode];
    
    switch (self.buttonStyle) {
        case ButtonStyleBackgroundColor:
            action.backgroundColor = descriptor.color;
            break;
        case ButtonStyleCircular:
            action.backgroundColor = [UIColor clearColor];
            action.textColor = descriptor.color;
            action.font = [UIFont systemFontOfSize:13];
            action.transitionDelgate = [ZAScaleTransition defaultTransition];
        default:
            break;
    }
}


@end
