# Info.plist Configuration

Add this entry to your Info.plist file to enable per-view-controller status bar styling:

```xml
<key>UIViewControllerBasedStatusBarAppearance</key>
<true/>
```

## How to Add to Info.plist

### Method 1: Using Xcode GUI
1. Open your project in Xcode
2. Select the Info.plist file in the Project Navigator
3. Right-click in the file and select "Add Row"
4. Type "UIViewControllerBasedStatusBarAppearance" as the key
5. Set the value to "YES" (Boolean type)

### Method 2: Using Source Code Editor
1. Right-click Info.plist and select "Open As" > "Source Code"
2. Add the XML entry shown above inside the main `<dict>` element
3. Save the file

## What This Does

This setting allows each UIViewController to control its own status bar appearance style through the `preferredStatusBarStyle` property. This is essential for our BaseViewController implementation to work correctly.

When set to `true` (YES):
- Each view controller can specify its own status bar style
- BaseViewController can return `.darkContent` for light backgrounds
- Different screens can have different status bar styles

When set to `false` (NO) - default:
- All view controllers share the same global status bar style
- Cannot customize per-screen
- Our solution won't work properly
