# SwipeableCollectionCell

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
![license MIT](https://img.shields.io/cocoapods/l/SwipeCellKit.svg)
![Platform](https://img.shields.io/cocoapods/p/SwipeCellKit.svg)

**`SwipeableCollectionCell` is port from https://github.com/jerkoch/SwipeCellKit to support IOS 9 and UICollectionViewCell**

*SwipeableCollectionCell based on the stock Mail.app, implemented in Objective-C.*

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Hero.gif" /></p>

## About

SwipeableCollectionCell with support for:

* Left and right swipe actions
* Action buttons with: *text only, text + image, image only*
* Haptic Feedback
* Customizable transitions: *Border, Drag, and Reveal*
* Customizable action button behavior during swipe
* Animated expansion when dragging past threshold
* Customizable expansion animations
* Accessibility

## Requirements

* Xcode 8
* iOS 9.0+

## Background

Check [blog post](https://jerkoch.com/2017/02/07/swiper-no-swiping.html) on how *SwipeCellKit* came to be.

## Demo

### Transition Styles

The transition style describes how the action buttons are exposed during the swipe.

#### Border 

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Transition-Border.gif" /></p>

#### Drag 

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Transition-Drag.gif" /></p>

#### Reveal 

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Transition-Reveal.gif" /></p>

#### Customized

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Transition-Delegate.gif" /></p>

### Expansion Styles

The expansion style describes the behavior when the cell is swiped past a defined threshold.

#### None

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Expansion-None.gif" /></p>

#### Selection

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Expansion-Selection.gif" /></p>

#### Destructive

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Expansion-Destructive.gif" /></p>

#### Customized

<p align="center"><img src="https://raw.githubusercontent.com/jerkoch/SwipeCellKit/develop/Screenshots/Expansion-Delegate.gif" /></p>

## Usage

Set the `delegate` property on `ZASwipeTableCell` or `ZASwipeCollectionCell`:

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZASwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self
    return cell
}
```

Adopt the `SwipeTableViewCellDelegate` protocol:

```objective-c
- (NSArray<ZASwipeAction *> *)view:(UIView<ZASwipeCellParentViewProtocol> *)view editActionsForRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation {
    ZASwipeAction *deleteAction = [[ZASwipeAction alloc] initWithStyle:ZASwipeActionStyleDestructive title:nil handler:^(ZASwipeAction *action, NSIndexPath *indexPath) {
            // handle action by updating models with deletion
        }];

    // customize the action appearance
    deleteAction.image = UIImage(named: "delete")

    return @[deleteAction]
}
```

Optionally, you can implement the `editActionsOptionsForRowAt` method to customize the behavior of the swipe actions:

```objective-c  
- (ZASwipeCellOptions *)view:(UIView<ZASwipeCellParentViewProtocol> *)view editActionsOptionsForRowAtIndexPath:(NSIndexPath *)indexPath forOrientation:(ZASwipeActionsOrientation)orientation {
    ZASwipeCellOptions *options = [[ZASwipeCellOptions alloc] init];
    
    options.expansionStyle = orientation == ZASwipeActionsOrientationLeft ? [ZASwipeExpansionStyle selection] : [ZASwipeExpansionStyle destructive];
    options.transitionStyle = self.defaultOptions.transitionStyle;
    options.buttonSpacing = 11;
    
    return options;
}

```
### Transitions

Three built-in transition styles are provided by `SwipeTransitionStyle`:  

* .border: The visible action area is equally divide between all action buttons.
* .drag: The visible action area is dragged, pinned to the cell, with each action button fully sized as it is exposed.
* .reveal: The visible action area sits behind the cell, pinned to the edge of the table view, and is revealed as the cell is dragged aside.

See [Customizing Transitions](https://github.com/jerkoch/SwipeCellKit/blob/develop/Guides/Advanced.md) for more details on customizing button appearance as the swipe is performed.

### Expansion

Four built-in expansion styles are provided by `SwipeExpansionStyle`:  

* .selection
* .destructive (like Mail.app)
* .destructiveAfterFill (like Mailbox/Tweetbot)
* .fill

Much effort has gone into making `SwipeExpansionStyle` extremely customizable. If these built-in styles do not meet your needs, see [Customizing Expansion](https://github.com/jerkoch/SwipeCellKit/blob/develop/Guides/Advanced.md) for more details on creating custom styles.

The built-in `.fill` expansion style requires manual action fulfillment. This means your action handler must call `SwipeAction.fulfill(style:)` at some point during or after invocation to resolve the fill expansion. The supplied `ExpansionFulfillmentStyle` allows you to delete or reset the cell at some later point (possibly after further user interaction).

The built-in `.destructive`, and `.destructiveAfterFill` expansion styles are configured to automatically perform row deletion when the action handler is invoked (automatic fulfillment).  Your deletion behavior may require coordination with other row animations (eg. inside `beginUpdates` and `endUpdates`). In this case, you can easily create a custom `SwipeExpansionStyle` which requires manual fulfillment to trigger deletion:

```objective-c
ZASwipeCellOptions *options = [[ZASwipeCellOptions alloc] init];
options.expansionStyle = orientation == ZASwipeActionsOrientationLeft ? [ZASwipeExpansionStyle selection] : [ZASwipeExpansionStyle destructive];
```

> **NOTE**: You must call `SwipeAction fulFillWithStyle:` at some point while/after your action handler is invoked to trigger deletion. Do not call `deleteRows` directly.

```objective-c
ZASwipeAction *deleteAction = [[ZASwipeAction alloc] initWithStyle:ZASwipeActionStyleDestructive title:nil handler:^(ZASwipeAction *action, NSIndexPath *indexPath) {
            [self.emails removeObjectAtIndex:indexPath.row];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection: 1]] withRowAnimation:
UITableViewRowAnimationAutomatic];
            [deleteAction fulFillWithStyle:ZAExpansionFulfillmentStyleDelete];
            [self.tableView endUpdates];
}];
```

## Advanced 

See the [Advanced Guide](https://github.com/jerkoch/SwipeCellKit/blob/develop/Guides/Advanced.md) for more details on customization.

## Credits

Created and maintained by [**@jerkoch**](https://twitter.com/jerkoch).

## License

`SwipeCellKit` is released under an [MIT License][mitLink]. See `LICENSE` for details.

