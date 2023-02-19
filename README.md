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
