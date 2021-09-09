import SwiftUI


public extension View
{
    /// Presents a panel using the given item as a data source for the panel's content.
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the panel. When the item is non-nil
    ///   the panel is presented and populated with the content provided by the `content` parameter.
    ///   - onCancel: A closure called when the panel is cancelled. When this is not nil a cancel
    ///   button will be added to the panel.
    ///   - content: A closure returning the content of the panel.
    func panel<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        onCancel: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (_ item: Item) -> Content
    ) -> some View where Item: Equatable
    {
        self.modifier(
            Panel(
                item: item,
                onCancel: onCancel,
                contentBuilder: content
            )
        )
    }
}
