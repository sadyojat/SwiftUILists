# SwiftUILists : Building a simple List based app using SwiftUI
Create a simple multiplatform practice app using SwiftUI for Mac, iOS and iPadOS.

## Overview
This is a demo app that showcases how easy it is to spin up a list based app in SwiftUI. There are 4 tab surfaces in this demo:
1. Posts
2. Photos
3. CoreData
4. Grid

It uses `async/ await` concurrency api's for network interaction, and uses the `https://jsonplaceholder.typicode.com` api's as network api source. 

https://user-images.githubusercontent.com/5061719/221091642-84310f45-6ad6-472e-9440-6773873ac858.mov


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

> `@Environment` is a preset list of keypaths that are maintained by the swiftUI environment while`@EnvironmentObject` is user defined and has to conform to `ObservableObject`, the same way as `@StateObject` types need to. It is also important to note that `@EnvironmentObject` instances are **NOT** `singletons`. `Singleton` instances are available in memory for the entire app to use, while `@EnvironmentObject` instances are only available within the navigation stack where they are setup. Trying to access an EnvironmentObject in a stack different from one where it is setup, will trigger a **RUNTIME** crash.

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

---

## Optimizations

The initial implementation of the `Post` and `Photos` list extensively used `bindings`. While bindings are very powerful constructs, using bindings to share state across the entire stack eventually carries a lot of overhead, since every small change to a binding object could trigger full list reloads across the stack. This will manifest in slow UI updates/ jitter/ bad user experience. 

To overcome this problem, I moved the codebase to adhere strictly to MVVM design pattern. 

To adapt to this pattern requires the creation of a stateful ViewModel layer from the stateless data model objects. Its important to remember that when we start managing state, we also need direct referencing of the managing object, and hence such stateful model objects are always created as reference types. In addition, since these object state changes have to be propagated thru the stack, remember to conform these to `ObservableObject` protocol. 

An example of how this could be done is shown here in the Photos model

```
struct Photo: AbstractModel, Codable {
    let albumId: Int
    var id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    var isFavorite: Bool? = false
    
    func convertToViewModel() -> PhotoVM {
        PhotoVM(albumId: albumId, id: id, title: title, url: url, thumbnailUrl: thumbnailUrl)
    }
}

class PhotoVM: Identifiable, ObservableObject, Equatable {
    let albumId: Int
    var id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    @Published var isFavorite: Bool = false
    
    init(albumId: Int, id: Int, title: String, url: String, thumbnailUrl: String, isFavorite: Bool = false) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.isFavorite = isFavorite
    }
    
    static func == (_ lhs: PhotoVM, _ rhs: PhotoVM) -> Bool {
        lhs === rhs
    }
}
```
Also **note** the use of `@Published` property wrapper here. We use this to notify subscribers of changes to the isFavorite property. 

With this change, you can now pass the individual viewModel object thru the stack as a `ObservedObject`. Remember that the main difference between the `StateObject` and an `ObservedObject` is that a StateObject is owned and instantiated by the SwiftUI View, while the ObservedObject can be instantiated elsewhere and observed. With this change, any update to the `isFavorite` property is observed by the subscribing SwiftUI type. For instance incase of Photos list, PhotoCellView subscribes to this property change, and automatically marks its favorited icon as opaque when the detail view marks the photo as a favorite. 

This change removes the need for the entire list to refresh to show individual cell updates in the list, making the entire app experience so much more smoother. 

---

## Implementing Search

Search is one of the most common features that an iOS list needs. Search has to be seamless, easy and should not cause UI hitching when it executes. As such SwiftUI provides an inbuilt feature that makes search addition virtually a breeze. All it takes is a block of function calls as shown below. 

`searchable` -> presents the search bar, and provides default cancel and search text bindings
`.onSubmit(of: .search...)` -> is called when the user enters return after typing in the search token
`.onChange` -> is called for changes to the listened @State variable. 

The implementation of search is self explanatory here, not a lot of complex coding, and what used to take a view controller in Swift takes but a few lines in SwiftUI to spin up. 

These commits show an example implementation of search
1. [Commit#1](https://github.com/sadyojat/SwiftUILists/commit/0604f9eb8de0462583d26a1d255d0390e2a85809)
2. [Commit#2](https://github.com/sadyojat/SwiftUILists/commit/95771e1dfb045c3ae56697826e56d37268fdcc37)


```
.searchable(text: $searchText)
.onSubmit(of: .search, {
    presentingList = photoFeed.photoViewModels.filter({ $0.title.lowercased().contains(searchText.lowercased())})
})
.onChange(of: searchText, perform: { newValue in
    if searchText.count == 0 {
        presentingList = photoFeed.photoViewModels
    } else {
        searchWorkItem?.cancel()
        searchWorkItem = DispatchWorkItem(block: {
            presentingList = photoFeed.photoViewModels.filter({ $0.title.lowercased().contains(searchText.lowercased())})
        })
        DispatchQueue.main.async(execute: searchWorkItem!)
    }
})
```

### Search Experience

https://user-images.githubusercontent.com/5061719/221091713-832a5355-d3e6-484e-9d6a-cf36f3d0d8dc.mov

