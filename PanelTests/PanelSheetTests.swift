import SnapshotTesting
import SwiftUI
import XCTest
@testable import Panel


class PanelSheetTests: XCTestCase
{
    func testPresentingPanelState()
    {
        assertSnapshot(
            matching: self.panel(item: .wifi),
            as: .image,
            record: false
        )
    }
    
    func testHiddenPanelState()
    {
        assertSnapshot(
            matching: self.panel(item: nil),
            as: .image,
            record: false
        )
    }
    
    // MARK: UI
    
    private func panel(item: PanelItem? = nil) -> some View
    {
        VStack {
            
        }
        .panel(
            item: .constant(item),
            onCancel: { },
            content: { item in
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
                        action: { },
                        label: {
                            Text("Done")
                                .frame(maxWidth: .infinity)
                        }
                    )
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
        )
    }
}



// MARK: Panel item

fileprivate enum PanelItem: String, Identifiable
{
    case wifi
    var id: String { self.rawValue }
}
