# dials-snapkit

Snaps combines [Dials](https://github.com/aleffert/dials) and [SnapKit](https://github.com/SnapKit/SnapKit) to let you make changes to your autolayout constraints at runtime and then send them back to your code with just one button.

[See it in action](https://aleffert.github.io/snaps/Documentation/snaps-example.html)

## Setup

Snaps works with Dials and SnapKit so you will have to add them to your project first.

Snaps is an unusual project in that it has an iOS component and a desktop component. As such, you can use Cocoapods or Carthage to fetch and version it, but you'll have to perform some additional manual steps afterward.

### Fetch Using Cocoapods

Add the following to your ``Podfile``:
```
pod 'Snaps', '~> 1.0'
```

### Fetch Using Carthage

Add the following to your ``Cartfile``:
```
github "aleffert/Snaps"
```


### Fetch using Submodules

You can also just add Dials as a submodule directly:
```
git submodule add Libraries/Dials git@github.com:aleffert/dials.git
```

### Configuring Snaps in your project

Once you have the files downloaded, you will need to do the following:

1. Find ``Snaps.xcodeproj`` in the Finder and drag it into your project's workspace.
2. Add ``Snaps.framework`` as a library dependency for your iOS app in the "Build Phases" section of the target settings.
3. Still within "Build Phases", find a "Copy Files" build phase whose "Destination" is "Frameworks" (you needed to add this when setting up Dials).
4. Hit the "+" button and add "Snaps.framework" to your Copy Files phase.
5. Go find where you start Dials and add a call to enable snaps:
    Objective-C:
    ```
    [[DLSDials shared] start]
    [[DLSViewsPlugin activePlugin] enableSnaps]
    ```
    Swift:
    ```
    DLSDials.shared()?.start()
    DLSViewsPlugin.activePlugin()?.enableSnaps()
    ```

## Running

The Snaps project adds a new scheme "Dials.app + Snaps" which will build Dials with the Snaps plugin. Just start your iOS app then switch to that scheme and run Dials. Snaps support will be included automatically.

## Usage

1. Choose the "Views" tab in Dials.
2. Click on the view whose constraints you want to edit.
3. Find a constraint and click the edit button.
4. Change the constraint.
5. Hit save.
