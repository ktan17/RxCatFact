# SwiftUI vs. the Reactive MVVM iOS Architecture

## Overview

Apple's introduction of [SwiftUI](https://developer.apple.com/xcode/swiftui/), alongside the rising popularity of [Flutter](https://flutter.dev), [Jetpack Compose](https://developer.android.com/jetpack/compose), and [React/React Native](https://reactjs.org) (particularly with [hooks](https://reactjs.org/docs/hooks-intro.html)), is an indicator of the future of front-end development: a **declarative style** of programming supplanting the traditional **stateful and object-oriented** one. 

The guiding principle behind these frameworks is relatively simple and elegant: **all views can be modeled as a function of some state**.

<img src="https://lh4.googleusercontent.com/nN_Hd5cQGP4wl8gITbHcMvFK5hVenotB3LCcNGe0rkwik1KM4An2DKTyl42Q7w-AzEm4ACuccfbMROl7H_syvhg0PQoGWYY-89AS-31IcupUIqpZY_33OrF9eP-pabpd8wOwgbmb" width=450px>

<u>Figure 1:</u> State-chan and View-kun. I made this!!!!!!

Take, for example, React: all (class-based) React components must implement a `render()` function that describes what the component should look like. A component can also maintain some notion of state - for example, a button might keep track of how many times it's been clicked so it can display that number to the user. Whenever the state of a component changes, the magic of React takes over and the component is **re-rendered**—the `render()` function is automatically called again and the component is visually updated (the return value of a `render()` can depend on state). This is precisely the reason for the framework's name: **views react to changes in state**. 🤯

In iOS development, this behavior is traditionally implemented using a paradigm known as [functional reactive programming](https://en.wikipedia.org/wiki/Functional_reactive_programming). Libraries such as [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) and [RxSwift](https://github.com/ReactiveX/RxSwift) define a standard interface for events that views may want to react to, such as button taps, incoming network data, or a change in the user's location. They rely heavily on the [Observer pattern](https://en.wikipedia.org/wiki/Observer_pattern), in which views and/or view controllers **observe**/**subscribe** to **observables** and are "notified" appropriately whenever some event of interest occurs. The following pseudocode describes this process:

```swift
class Observable<T> {
  private let subscribeBlocks = Array<T -> Void>() // Array of callbacks with a single generic parameter
  
  func subscribe(block: T -> Void) {
    self.subscribeBlocks.append(block)
  }
  
  /// Notify all observers
  func notify(with event: T) {
    for block in subscribeBlocks {
      block(T) // Execute the callback
    }
  }
}

// Suppose we have an observable bound to a UISwitch and we are broadcasting the event the user switches
// it on or off.
let switchObservable = Observable<Bool>()

// Subscribing looks like...
switchObservable.subscribe { isOn in
  if isOn {
    updateViewSomeWay()
  } else {
    updateViewSomeOtherWay()
  }
}

// Notifying looks like...
switchObservable.notify(true)
```

Again, once you think about how many kinds of UI events there are (especially the fact that they are almost always generated asynchronously), you can begin to understand why the reactive paradigm is so powerful for front-end development. Over many years, the combination of reactive programming with other architecture and design patterns led to the birth of the [MVVM Architectural Pattern](https://en.wikipedia.org/wiki/Model–view–viewmodel). Though my experience is limited (I've only worked at 3 different companies), I claim that MVVM is the most widely-used and accepted architecture in industry right now for iOS development.

MVVM stands for **Model-View-ViewModel**. I won't bore you with the details, but the critical idea of MVVM is that every View Controller owns a View Model that is responsible for handling all business logic. The View Model generates events that the View Controller subscribes to, resulting in an effective decoupling of logic.

<img src="https://lh3.googleusercontent.com/SbPs8IQSJSHIcVyG-lndln2zmtI73WrAXg2n6xe4AE5WP44qCh9aX_kARrQBBCCOZgW3TH1Bt8zINJn96OvecZmzQ0mPBV0w4XEp8ivXSTdSTuzrpSi6lp_4I3vv97sbD_ON_PXi">

<u>Figure 2:</u> Ugly MVVM diagram courtesy of Xamarin

---

### Enter SwiftUI

During WWDC 2019, Apple announced the development of a framework introducing a completely new way of building iOS apps: **SwiftUI**. It leverages many powerful features of Swift such as protocols, function builders, and implicit returns to facilitate a declarative style of building user interfaces, similar to how HTML looks. In many ways, it seems to mimic React; here's a fun diagram I made loosely mapping React concepts to their SwiftUI counterparts:

<img src="https://lh5.googleusercontent.com/V6ee1WRATMPk7bmdvJ4IkS_CtSL6npkgNg9Gi2JJ-7Xz63uLFHSzj3zPeIXtvWYTF4cyz-XDbh35j0dlInDsHqP1Eh8ioC2D-4Wjfb0zXiK_nJbWbac4RXQb7lSshLVTE4ZpSgQb" width=550px>

<u>Figure 3:</u> Figma is objectively the best design software.

SwiftUI is a game-changer for iOS development in many ways, **ditching stateful, object-oriented programming** in favor of a **declarative, functional, and reactive one**. In addition, Apple has developed their own reactive framework called [Combine](https://developer.apple.com/documentation/combine) that integrates seamlessly with SwiftUI. 

To demonstrate, here's how you'd properly add a "Hello, world!" label to the center of a view using the current iOS SDK (programmatically without constraints, because [storyboards and Auto-layout are evil](https://martiancraft.com/img/blog/articles/small/20180226_storyboard_figure1@2x.png)) vs. SwiftUI:

**Current iOS SDK**

```swift
import UIKit

class HelloWorldViewController: UIViewController {
  let label = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    label.text = "Hello, world!"
    view.addSubview(label)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    var labelFrame = CGRect.zero
    labelFrame.size = label.intrinsicContentSize
    labelFrame.origin.x = (view.bounds.width - labelFrame.width) / 2
    labelFrame.origin.y = (view.bounds.height - labelFrame.height) / 2
    
    label.frame = labelFrame
  }
}
```

**SwiftUI**

```swift
import SwiftUI

struct HelloWorldView: View {
  var body: some View {
    Text("Hello, world!")
  }
}
```

Of course, this is just one particular example where SwiftUI is clearly superior to the old way of doing things; I'll discuss its shortcomings as I see them later. But you can easily see why it's such a powerful framework, and I can even prove syllogistically that it's better than React:

1. React is a JavaScript framework.
2. SwiftUI is not a JavaScript framework.
3. SwiftUI is superior to React.

JavaScript bashing aside, I wanted an opportunity to compare both styles of programming side-by-side, so I set out to build... 

**A cat fact generator app.**

## RxCatFact

I stumbled upon the fun cat fact API at https://catfact.ninja a while ago, but never had the opportunity to build a toy app around it. I started by whipping up a quick Figma prototype:

<img src="https://lh4.googleusercontent.com/K1gRoRPuOUKrfTLAD5E7dnpDHkaMzjcBsHlhY9JckIHRMnQTMK1uqi0T2udFECOd0SwaAv8ryUkT7YtWK8NhJtAfa2zG6HV3IJO5jma3xMACoAYqk_nBNWoUzfYrI9GZ1iJkxOWJ" width=300px>

<u>Figure 4:</u> Still unconvinced that Figma is the best?

Here are the key features to implement:

- Tapping the "Generate!" Button causes:
  - The background to fade into another random gorgeous gradient.
  - The cat emoji to change to another random cat emoji.
  - A call to the cat fact API, with the fetched fact displayed in the center box. While we wait for the network call to complete, the contents of the box are replaced with a loading indicator.
- The back button in the bottom left goes to the previous fact.
  - It should be disabled when the app starts, and when there are no more facts to go back to.
- The share button in the bottom right opens a share sheet that allows the user to share the currently displayed fact.
  - It should be disabled when the app starts.
- The middle box will be empty when the app starts.

I implemented the app twice - **once in the "old way" using MVVM and the framework RxSwift, and once in SwiftUI**. If you actually build the app and view it on a simulator/device, you'll see I embedded each inside a TabView. You can swap back and forth between the two. Here's a screenshot from the completed app:

<img src="https://lh6.googleusercontent.com/XY8aSn2bln_8vQoGD0xbOxssYAxUJ--0ToUsLvxjdfpDl-f96WN99FiYsyuk0FgoSyo-Lz-dAB1sTL4doDg1O_mKyS3gIT4qXhuXte-7xp2Rn6K_gBTre36i_nPzDbUPTRmSFb52" width=300px>

<u>Figure 5:</u> I'm running out of witty captions.

Feel free to explore the repo to see both implementations; I tried to mirror them as much as possible. You can find all of the relevant MVVM files in the "**RxSwift**" folder and the SwiftUI files in the "**SwiftUI**" folder. Rather than explain all of the code in unnecessary detail, I thought I'd finish this README by discussing what I think are the real benefits and drawbacks of SwiftUI in its current state.

## Conclusion: Annoying vs Good

I kept a list of things I found both annoying and good while I worked on this, and rather than list each point in detail I've grouped them to form overarching themes and concepts I'd like to discuss. I'll start with the annoying bits so we can end on a good note. 😄😄

### Annoying

#### 1. SwiftUI is still too young.

Any new framework is bound to have its share of kinks and flaws, and SwiftUI is not exempt. While building this app, I ran into many minor inconveniences, the kind that give rise to thoughts like "*Why?*" and "*ew Gross*" (with a capital G) when you eventually fix them. They include:

- Modifier order matters.
- Absolute positioning can be difficult.
- You can't declare constants in Function Builders.
- The `EnvironmentObject` check happens at run-time and can crash your app.
- Transition animations only work on View add/removal.

These kind of problems introduce two main roadblocks to a good development experience: **unnecessary technicalities**, and **ugly workarounds**. I'll elaborate on two of the above points just so you can see what I mean.

---

##### <u>An unnecessary technicality:</u> Modifier order matters.

One of the most notable ways SwiftUI exhibits its functional style is through the way you modify a view's properties. For example, consider the following code snippet:

```swift
// SwiftUI
Rectangle()
  .foregroundColor(.blue)
  .cornerRadius(10)
  .opacity(0.5)

// UIKit
let view = UIView()
view.backgroundColor = .blue
view.layer.cornerRadius = 10
view.alpha = 0.5
```

Each modifier function returns a new instance of that View with the modification applied (and since Views are value-type structs, this isn't terribly inefficient). However, absurdly, **the order in which you apply modifiers can affect the state of the finalized view**. Again, consider the following code snippet:

```swift
VStack {
  Button("Hello, world!") { }
    .frame(width: 100, height: 100)
    .background(Color.red)
  Button("Hello, world!") { }
    .background(Color.red)
    .frame(width: 100, height: 100)
}
```

The buttons merely have the modifier order swapped. So what do you think this will look like? Given the title of this grievance you'll probably guess that **they'll look different, and you would be correct**! Here's what you'll get:

<img src="https://lh4.googleusercontent.com/moE3ATE24KE4AnAKA5VjbXUI-GuqmccK-d7qqBbGkyahdPQ9l-FQskagSjYcEIjmmRNj5OyrNqkZRwHg28EwygYKB0l9-UM_a9MA84iv_txAilAPQPafk36TaVqgFdzyJD9x6xSx" width=200px>

<u>Figure 6:</u> but why tho

Technicalities like this can really make any framework or language **annoying to work with** (think of the difference between the double equals and triple equals in JavaScript) because you need to remember them! Modifier order really should not matter in order to make the SwiftUI development experience as simple, clean, and honestly sensible, as possible. Hopefully edge cases like these are fixed in the future.

---

##### <u>An ugly workaround:</u> Transition animations only work on view add/removal.

SwiftUI has greatly improved the ease of adding animations to views. In the following snippet, the excerpts of code do roughly the same thing:

```swift
// SwiftUI
Rectangle()
  .scaleEffect(isLarge ? 1.5 : 1)
  .animation(.easeInOut)

// UIKit
let animations: () -> Void
if isLarge {
  animations = {
    viewToAnimate.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
  }
} else {
  animations = {
    viewToAnimate.transform = .identity
  }
}

UIView.animate(
  duration: 0.5,
  delay: 0.0,
  options: .curveEaseInOut,
  animations: animations,
  completion: nil
)
```

Pretty neat right? However, there is another subclass of animations called **transitions**. These occur when you want to animate a view from one state to another; for example, suppose you want to fade the background color of a view to red. In UIKit, this might look like:

```swift
UIView.transition(
  with: viewToTransition,
  duration: 0.5,
  options: [.curveEaseInOut, .transitionCrossDissolve],
  animations: {
    viewToTransition.backgroundColor = .red
  },
  completion: nil
)
```

You can achieve the same effect in SwiftUI using the `transition(.opacity)` modifier on a View. However, the fading animation only ever occurs **if the View is being added or removed from the View hierarchy**. In other words, without any workaround, you cannot use the `transition` modifier to fade a view's background color from one to another **because the final state of the transition does not involve the View getting removed from the screen**.

This was an issue for me because I wanted to both fade the background between different gradients and the cat facts from one to another. After a bit of StackOverflow googling I found a **workaround**—to convince SwiftUI that the View being animated to was a completely different one. You can see this in `CatFactView.swift`:

```swift
GradientBackground(colors: outputs.backgroundColors)
  .edgesIgnoringSafeArea(.top)
  .transition(.opacity)
  .id(outputs.backgroundColors.hashValue)
```

The key is the `id` modifier. By assigning the view a new and unique ID value based on the hash of the background colors, SwiftUI is convinced that the same view is actually a different view and the fade animation works perfectly. But you can't help that queasy feeling in your stomach generated by your body's instinctual disgust. Let me put it simply: **this is gross.**

Until SwiftUI matures, workarounds like these will be needed to achieve seemingly trivial behaviors. They detract from the beautiful and concise code aesthetic that SwiftUI strives to promote. Again, hopefully new APIs and features will fix this in the future.

---

#### 2. SwiftUI abstracts a *lot* of iOS development away.

This second and final annoying point comes from my perspective as someone that has helped teach iOS development to new computer science students for four years. As much as I hate storyboards and Auto-layout, I always start my lessons there because it's simple, easy to use, intuitive, and allows you to get *something* working in a matter of minutes. But at least with storyboards, there is a foundation upon which you can segue (ha ha) into **fundamental iOS concepts** such as the View Controller lifecycle, the view hierarchy, the protocol-delegate pattern, etc.

After this experiment, I think I can say that SwiftUI outclasses even storyboards with regards to the ease and speed in which you can build an app. Furthermore, the stickler inside me is really happy that it's pure programming rather than visual construction. However, the functional and declarative style of SwiftUI is so far from the frameworks and processes underlying UIKit and iOS apps in general (which are not going anywhere for a long time) that I **worry for beginners**.

I firmly believe that the fewer black boxes you can have while teaching coding, the better. I'm all too familiar with the slight frustration that appears on my students' faces when I tell them, "Just trust me, it'll work." Of course, some black boxes are necessary—taken to an extreme, it would obviously be ridiculous to start a course on iOS development with understanding how operating systems work. But there are so many powerful features that SwiftUI relies on: function builders, protocols, UIKit interoperability, value-type semantics, that **require a strong understanding of Swift and the way iOS apps already work to fully understand**. My biggest worry with SwiftUI is that it's *so easy* that it provides a poor starting point for someone that really wants to get into iOS development long-term. I will end with the same lame concluding sentence that I have used in the previous section: hopefully, this changes in the future.

### Good

#### 1. Easy to extend and interoperate with UIKit.

Onto the good parts! This first one is fairly short and sweet: it's pretty easy to create adapters for UIKit components that you can add to your SwiftUI views. This is primarily achieved through the `UIViewRepresentable` and `UIViewControllerRepresentable` protocols. You can take a look at `ActivityIndicator.swift` and  `ActivityViewController.swift`  in the repo to see how this works. While Apple continues to work on porting UIKit views to SwiftUI, these protocols serve as a pretty good alternative in the meantime.

#### 2. Easily facilitates a powerful architecture and well-organized codebase.

One of the most notorious questions for any iOS developer is: "What architecture should I use?" Apple's answer to that is [MVC](https://en.wikipedia.org/wiki/Model–view–controller), which stands for Model-View-Controller. The idea is to separate **raw data (models)** from the actual **user-facing views**. The two interact through the **controller** object, which is responsible for reading and updating models and telling views what to display. The problem that arises from this architecture is also called MVC, or **Massive View Controller**. Since the view controllers have so much work to handle, you end up shoving all of your logic (business, data formatting, view updating) inside them and end up with these files that are thousands of lines long. Not very scalable or easy to work with.

Over the years, a number of alternative architectures have risen in popularity: the aforementioned MVVM, [VIPER](https://www.raywenderlich.com/8440907-getting-started-with-the-viper-architecture-pattern), and [Clean Swift](https://clean-swift.com) are some examples. I always found it odd that though all of these are far better than MVC, Apple never changed their tutorials or guides to endorse a different architecture. SwiftUI solves this problem and makes the development process much easier. Now, developers are **strongly persuaded through the actual framework itself to adopt a reactive architecture where state drives views**.

#### 3. It's Swift.

Pun intended. I want this point to end my post, because it really is **the most promising thing I see about SwiftUI**. The iOS development process is far from perfect. It has taken me an extremely long time (4+ years) to become very comfortable with UIKit and the intricate processes that underlie any iOS app. But there were many instances during the development of RxCatFact that I was astounded by how fast and easy it was to code with SwiftUI. **Things that would normally take many lines to code were achievable in a single one** (animation by far is the most impressive). In addition, there are many things that suck in UIKit (like working with attributed strings) that have been greatly improved in SwiftUI.

Out of the many programming languages I've used, Swift has a special place in my heart because I strongly resonate with its mission to make **code readable and succinct** and to make **development easy and enjoyable**. It's incredibly satisfying to write a gorgeous line in Swift that you couldn't in other languages. It's a compiled and statically typed language, meaning you have a powerful compiler that double-checks your code, and you (usually) don't have to worry about run-time crashes caused by silly errors.

SwiftUI brings this philosophy to the entire process of iOS development, and as much as I hate change and relearning things, it is an incredibly exciting and promising framework. Though it is still very immature, if it ends up working it could really **revolutionize** what it means to be an iOS developer. But until then, I'll be happy with my good ol' MVVM, UIKit, and object-oriented programming.

Thanks for reading, and remember: **Cats do not think that they are little people. They think that we are big cats. This influences their behavior in many ways. *Me-wow!***

