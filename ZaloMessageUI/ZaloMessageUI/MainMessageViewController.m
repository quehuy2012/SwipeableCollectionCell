//
//  IncomingMessageViewController.m
//  ZaloMessageUI
//
//  Created by CPU11713 on 3/20/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "MainMessageViewController.h"
#import <IGListKit/IGListKit.h>

// Helpers
#import "System.h"

// DataSources
#import "IGMainMessageDataSource.h"

// ViewModels
#import "FriendViewModel.h"
#import "MainMessageViewModel.h"
#import "IncomingMessageFactory.h"

// Models
#import "FriendEntity.h"
#import "GroupEntity.h"
#import "IncomingMessageEntity.h"


@interface MainMessageViewController ()

@property (nonatomic, readwrite) IGListCollectionView *collectionView;
@property (nonatomic, readwrite) IGListAdapter *adapter;
@property (nonatomic, readwrite) IGMainMessageDataSource *dataSource;

@property (nonatomic, readwrite) NSMutableArray<MainMessageViewModel *> *viewModels;

@end

@implementation MainMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
}

#pragma mark - Private
- (void)setUp {
    self.viewModels = [NSMutableArray array];
    
    [self setUpIncomingMessageSection];
    [self setUpSuggestFriendSection];
    
    [self setUpCollectionView];
    [self setUpAdapter];
}

- (void)setUpIncomingMessageSection {
    NSMutableArray<id<IncomingMessage>> *incomingMessageViewModel = [NSMutableArray array];
    
    FriendEntity *friendEntity1 = [[FriendEntity alloc] initWithUID:@"1" name:@"Friend1" profileURLString:@"User-50"];
    FriendEntity *friendEntity2 = [[FriendEntity alloc] initWithUID:@"2" name:@"Friend2" profileURLString:@"User-50"];
    GroupEntity *groupEntity2 = [[GroupEntity alloc] initWithMembers:@[friendEntity1,friendEntity2] name:@"Group 2"];
    GroupEntity *groupEntity3 = [[GroupEntity alloc] initWithMembers:@[friendEntity1,friendEntity2, friendEntity1] name:@"Group 3"];
    GroupEntity *groupEntity4 = [[GroupEntity alloc] initWithMembers:@[friendEntity1,friendEntity2,friendEntity1,friendEntity2] name:@"Group 4"];
    
    for (NSUInteger i=0; i < 50; i++) {
        NSString *content = [NSString stringWithFormat:@"Private messagse long text test %lu", (unsigned long)i];
        NSDate *date = [[NSDate alloc] init];
        
        IncomingMessageEntity *messageEntity;
        
        switch (i % 4) {
            case 0:
                messageEntity = [[IncomingMessageEntity alloc] initWithSender:friendEntity1 content:content date:date];
                break;
            case 1:
                messageEntity = [[IncomingMessageEntity alloc] initWithSender:groupEntity2 content:content date:date];
                break;
            case 2:
                messageEntity = [[IncomingMessageEntity alloc] initWithSender:groupEntity3 content:content date:date];
                break;
            default:
                messageEntity = [[IncomingMessageEntity alloc] initWithSender:groupEntity4 content:content date:date];
                break;
        }
        
        id<IncomingMessage> messageViewModel = [IncomingMessageFactory createMessageViewModel:messageEntity];
        
        [incomingMessageViewModel addObject:messageViewModel];
    }
    
    MainMessageViewModel *viewModel = [[MainMessageViewModel alloc] initWithSubViewModels:[incomingMessageViewModel copy] type:MainMessageViewModelTypeLastMessage];
    
    [self.viewModels addObject:viewModel];
}

- (void)setUpSuggestFriendSection {
    NSMutableArray<FriendViewModel *> *suggestFriends = [NSMutableArray array];
    
    for (NSUInteger i=0; i < 5; i++) {
        NSString *uid = [NSString stringWithFormat:@"%lu", (unsigned long)i];
        NSString *name = [NSString stringWithFormat:@"Recent %lu", (unsigned long)i];
        NSString *profileURLstring = @"User-50";

        FriendEntity * friendEntity = [[FriendEntity alloc] initWithUID:uid name:name profileURLString:profileURLstring];
        FriendViewModel *friendViewModel = [[FriendViewModel alloc] initWithFriend:friendEntity];
        
        [suggestFriends addObject:friendViewModel];
    }
    
    MainMessageViewModel *viewModel = [[MainMessageViewModel alloc] initWithSubViewModels:[suggestFriends copy] type:MainMessageViewModelTypeSuggestedFriends];
    
    [self.viewModels addObject:viewModel];
}

- (void)setUpCollectionView {
    // init collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[IGListCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    
    // configurate collectionView
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading, *trailing, *top, *bottom;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        leading = [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
        trailing = [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
        top = [self.collectionView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor];
        bottom = [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor];
    }
    
    [NSLayoutConstraint activateConstraints:@[leading, trailing, top, bottom]];
}

- (void)setUpAdapter {
    self.dataSource = [[IGMainMessageDataSource alloc] initWithViewModels:self.viewModels];
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self workingRangeSize:2];
    
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self.dataSource;
}

@end
