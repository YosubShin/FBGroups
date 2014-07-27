FBGroups
========

Simple Facebook Group Viewer
------------------

* A sample app made with Swift on iOS8 that utilizes [Facebook Graph API](https://developers.facebook.com/docs/ios) to fetch user's group data and shows it on the UITableViewController.
* It uses CoreData and NSFetchedResultsController to display data on table views.

How to build
------------
* Modify `FBGroups/Info.plist` : Follow instruction at [Facebook API Documentation](https://developers.facebook.com/docs/ios/getting-started#configure)
One needs to add values for keys : `CFBundleURLTypes`, `FacebookDisplayName`, `FacebookAppID`

* FBGroups utilizes , and [Facebook SDK](https://developers.facebook.com/docs/ios) libraries.
In order to build with CocoaPod, type in the Terminal `pod install`, and in order to open the project, open `FBGroups.xcworkspace` instead of `FBGroups.xcodeproj`. More information on using CocoaPod at http://cocoapods.org/.


Updates
------

### Update on July 26th, 2014
* Got rid of '[PureLayout](https://github.com/smileyborg/PureLayout)' because it prevents me from utilizing Storyboard features such as Segue. Also, for the purpose of my app, the AutoLayout feature allows me to achieve the same functionality.
