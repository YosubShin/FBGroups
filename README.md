FBgroups
========

Simple Facebook Group Viewer
------------------

Sample app made with iOS that utilizes Facebook Graph API to fetch user's group data and shows it on the UITableViewController.

It also utilizes [PureLayout](https://github.com/smileyborg/PureLayout), and [Facebook SDK](https://developers.facebook.com/docs/ios) libraries.

How to build
------------
* Modify `FBGroups/Info.plist` : Follow instruction at [Facebook API Documentation](https://developers.facebook.com/docs/ios/getting-started#configure)
One needs to add values for keys : `CFBundleURLTypes`, `FacebookDisplayName`, `FacebookAppID`

* FBGroups utilizes [PureLayout](https://github.com/smileyborg/PureLayout), and [Facebook SDK](https://developers.facebook.com/docs/ios) libraries.
In order to build with CocoaPod, type in the Terminal `pod install`, and in order to open the project, open `FBGroups.xcworkspace` instead of `FBGroups.xcodeproj`. More information on using CocoaPod at http://cocoapods.org/.
