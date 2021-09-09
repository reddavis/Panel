# Panel

A panel component similar to the iOS Airpod battery panel or the Share Wi-Fi password panel. 

![Example](https://cln.sh/YYZHmu/download)

## Requirements

- iOS 15.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/reddavis/Panel", from: "0.9.0")
]
```

## Usage

Panel's API is very similar to SwiftUI's sheet.

```swift
import Panel
import SwiftUI


struct ContentView: View
{
    // Private
    @State private var item: PanelItem? = nil
    
    // MARK: Body
    
    var body: some View {
        VStack {
            Button("Show Wi-Fi panel") {
                self.item = .wifi
            }
        }
        .panel(
            item: self.$item,
            onCancel: { print("cancelled") },
            content: { item in
                switch item
                {
                case .wifi:
                    VStack(spacing: 24) {
                        VStack(spacing: 32) {
                            Text("Wi-Fi Password")
                                .font(.title)
                                .foregroundColor(Color(.darkGray))
                            
                            Image(systemName: "wifi")
                                .font(.system(size: 100))
                                .foregroundColor(Color(.lightGray))
                            
                            Text("Do you want to share the Wi-Fi password for \"Home\" with Pita Bread?")
                                .multilineTextAlignment(.center)
                        }

                        Button(
                            action: { self.item = .success },
                            label: {
                                Text("Done")
                                    .frame(maxWidth: .infinity)
                            }
                        )
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                case .success:
                    VStack(spacing: 24) {
                        VStack(spacing: 32) {
                            Text("Success")
                                .font(.title)
                                .foregroundColor(Color(.darkGray))
                            
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 100))
                                .foregroundColor(.green)
                            
                            Text("Sorted")
                                .font(.title2)
                        }

                        Button(
                            action: { self.item = nil },
                            label: {
                                Text("Close")
                                    .frame(maxWidth: .infinity)
                            }
                        )
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
            }
        )
    }
}


// MARK: Panel item

private extension ContentView
{
    enum PanelItem: String, Identifiable
    {
        case wifi
        case success

        var id: String { self.rawValue }
    }
}

```

## Other Libraries

Check out some of my other libraries:

- [Papyrus](https://github.com/reddavis/Papyrus) - Papyrus aims to hit the sweet spot between saving raw API responses to the file system and a fully fledged database like Realm.
- [RedUx](https://github.com/reddavis/RedUx) - A super simple Swift implementation of the redux pattern making use of Swift 5.5's new async await API's.
- [Kyu](https://github.com/reddavis/Kyu) - A persistent queue system in Swift.
- [FloatingLabelTextFieldStyle](https://github.com/reddavis/FloatingLabelTextFieldStyle) - A floating label style for SwiftUI's TextField.

## License

Whatevs.
