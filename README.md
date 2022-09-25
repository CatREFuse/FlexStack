# FlexStack

A flex layout  (like CSS flex) in SwiftUI with the new `Layout` protocol. Easy usages as `HStack` or `VStack`.


## Basic Usage

```swift

FlexStack {
  // ...Subviews
}

FlexStack(horzontalSpacing: 12, verticalSpacing: 16) {
  // ...Subviews
}

```

## Discussion

**Perfectly compatible with Layout animation**

![FlexStackDemo.gif](https://oss.catrefuse.com/img/FlexStackDemo)


## Compatibility

Same as `Layout` protocol limit.

Tested on `iOS 16.0, *`.

## Todos

- [ ] Optimize for more layout options. Now `FlexStack` works best for subviews with the same ideal height. 

## Installation

Using SPM:
Select File > Swift Packages > Add Package Dependency, then enter the URL of this page.
