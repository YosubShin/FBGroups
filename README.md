FBgroups
========

Simple Facebook Group Viewer
------------------

* A sample app made with Swift on iOS8 that utilizes [Facebook Graph API](https://developers.facebook.com/docs/ios) to fetch user's group data and shows it on the UITableViewController.
* It uses CoreData and NSFetchedResultsController to display data on table views.
* It also utilizes [PureLayout](https://github.com/smileyborg/PureLayout) in order to dynamically vary the height of UITableViewCells regarding the lengths of the group feeds' contents.

How to build
------------
* Modify `FBGroups/Info.plist` : Follow instruction at [Facebook API Documentation](https://developers.facebook.com/docs/ios/getting-started#configure)
One needs to add values for keys : `CFBundleURLTypes`, `FacebookDisplayName`, `FacebookAppID`

* FBGroups utilizes [PureLayout](https://github.com/smileyborg/PureLayout), and [Facebook SDK](https://developers.facebook.com/docs/ios) libraries.
In order to build with CocoaPod, type in the Terminal `pod install`, and in order to open the project, open `FBGroups.xcworkspace` instead of `FBGroups.xcodeproj`. More information on using CocoaPod at http://cocoapods.org/.
