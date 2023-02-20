# SwiftUILists : Building a simple List based app using SwiftUI
Create a simple multiplatform practice app using SwiftUI for Mac, iOS and iPadOS.

## Overview
This is a demo app that showcases how easy it is to spin up a list based app in SwiftUI. There are 4 tab surfaces in this demo:
1. Posts
2. Photos
3. CoreData
4. Grid

It uses `async/ await` concurrency api's for network interaction, and uses the `https://jsonplaceholder.typicode.com` api's as network api source. 
This is a simple REST api, and can be used by developers free of cost for testing their demo apps. 

---

### Posts

To build this surface, I used the `https://jsonplaceholder.typicode.com/posts` api to present the list of posts. The fetch api uses the 
`try await URLSession.shared.data(from: url)` async api to retrieve the data list and then uses a JSONDecoder to map the list into a memory managed
list of objects which have the following structure.

```
struct Post: AbstractModel, Codable, Hashable {
    let userId: Int
    var id: Int
    var title: String
    var body: String
    var isFavorite: Bool? = false
}
```

Once the list is populated, then reloading the data is a very simple step by spinning up a task associated with the main `List` object in the body of the view.

```
.task {
    do {
        if self.feed.posts.isEmpty {
            if let posts = try await network.fetch(.posts) as? [Post] {
                self.feed.posts = posts
            }
        }
    } catch {
        print("Failed to retrieve posts")
    }
}
```

To pass state between the main parent view and the child view that renders the content of each cell, I used `@Binding` property wrapper. This allows changes in both parent and child to reflect in each other. Using this, I was able to mark cells as favorited or now by using the trailing swipe actions. An example of this behavior is shown in this video.

https://user-images.githubusercontent.com/5061719/219969808-3e3790bb-6f75-434f-bec5-8794aa0f95d8.mov

---

### Photos

This is an extension of behavior from Posts tab, and introduces how an ImageCache can be added into the code and used for dynamic loading. You will see use of `async/await` concurrency pattern for network api handling here. 

---

### Core Data

Integrating Core Data in swiftUI is so much more simpler than in native Swift code. This tab was an incremental change that I added on later while playing around with adding Core Data features, and the integration is so much simpler. 

After adding the Core data model file in the project, create a custom subclass of `NSPersistentContainer` and use that as an environment object. This navigation stack introduces the use of `@EnvironmentObject` property wrapper. Please pay note to the fact that there is a subtle difference between the `@Environment` and the `@EnvironmentObject` property wrappers. 

> `@Environment` is a preset list of keypaths that are maintained by the swiftUI environment while`@EnvironmentObject` is user defined and has to conform to `ObservableObject`, the same way as `@StateObject` types need to. 

You would also see the use of `@FetchResults` property wrapper here. This is used to retrieve the list of managed object instances placed in the core data store. 

**NOTE** For FetchResults to work, the managedObjectContext has to be setup in the swiftUI environment. We are doing this step in the `MainApp`

```
WindowGroup {
    Tabs()
        .environmentObject(coreDataInteractor)
        // This setting is needed for @FetchRequest to work in the navigation stack
        .environment(\.managedObjectContext, coreDataInteractor.moc)
}
```        

The Core Data sample list showcases simple mutation functions to add and delete rows from a Core Data model. There is a feature to add one row, delete one row and delete all rows. The title on the top is incremented/ decremented with the count of objects in the store on each mutation operation. The video shows the behavior implemented. 

https://user-images.githubusercontent.com/5061719/219983700-9052505e-c842-40dd-b93e-a876672c6517.mov

---

### Grid

This surface introduces the use of `LazyVGrid` and `LazyHGrid`. These Grid types allow us to build complex interfaces and also allow us to dynamically modify the view layouts based on runtime condition. In this example, you would notice that the view layout changes each time the user comes back from the detail view to the main grid view. I am using a randomElement selection to setup dynamic grid layouts for each selection in the main menu. 

https://user-images.githubusercontent.com/5061719/219984085-b57360b9-9237-43c3-abd1-db34cd1b9e84.mov


