import SwiftUI


/// A panel UI component.
public struct Panel<Item: Identifiable, PanelContent: View>: ViewModifier where Item: Equatable
{
    // Private
    @Binding private var item: Item?
    private let contentBuilder: (_ item: Item) -> PanelContent
    private let onCancel: (() -> Void)?
    
    @State private var content: AnyView = .init(EmptyView())
    @State private var panelHeight = 0.0
    @State private var isPresented = false
    @State private var panelOpenAnimationProgress = 0.0
    
    private var panelSpringResponse: Double {
        self.isPresented ? 0.25 : 0.15
    }
    
    private var backgroundAnimationDuration: Double {
        self.isPresented ? 0.25 : 0.15
    }
    
    // MARK: Initialization
    
    /// Initialize a new instance of `Panel`
    /// - Parameters:
    ///   - isPresented: A binding that determines whether the panel is presented or not.
    ///   - onCancel: A closure called when the panel is cancelled. When this is not nil a cancel
    ///   button will be added to the panel.
    ///   - contentBuilder: A closure returning the content of the panel.
    public init(
        item: Binding<Item?>,
        onCancel: (() -> Void)? = nil,
        @ViewBuilder contentBuilder: @escaping (_ item: Item) -> PanelContent
    )
    {
        self._item = item
        self._isPresented = State(initialValue: item.wrappedValue != nil)
        self.contentBuilder = contentBuilder
        self.onCancel = onCancel
    }
    
    // MARK: Body
    
    public func body(content: Content) -> some View
    {
        ZStack {
            content
            
            ZStack(alignment: .bottom) {
                self.background()
                self.panelContent()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onChange(of: self.item) { item in
                if let item = item
                {
                    // If currently presented, we need to dismiss first
                    if self.isPresented
                    {
                        self.closePanel()
                    }
                    else
                    {
                        self.presentPanel(for: item)
                    }
                }
                else
                {
                    self.closePanel()
                }
            }
        }
        .onAnimationCompletion(with: self.panelOpenAnimationProgress) {
            guard let item = self.item,
                  !self.isPresented else { return }
            self.presentPanel(for: item)
        }
    }
    
    // MARK: Panel management
    
    private func presentPanel(for item: Item)
    {
        self.content = AnyView(self.contentBuilder(item))
        
        Task {
            withAnimation {
                self.isPresented = true
                self.panelOpenAnimationProgress = 1.0
            }
        }
    }
    
    private func closePanel()
    {
        withAnimation {
            self.isPresented = false
            self.panelOpenAnimationProgress = 0.0
        }
    }
    
    // MARK: UI
    
    private func background() -> some View
    {
        Group {
            if self.isPresented
            {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .transition(
                        .opacity.animation(
                            .easeInOut(duration: self.backgroundAnimationDuration)
                        )
                    )
            }
        }
    }
    
    private func panelContent() -> some View
    {
        GeometryReader { proxy in
            ZStack(alignment: .topTrailing) {
                self.content
                    .padding(EdgeInsets(top: 32.0, leading: 24.0, bottom: 32.0, trailing: 24.0))
                
                if let onCancel = self.onCancel
                {
                    Button(
                        action: {
                            self.item = nil
                            onCancel()
                        },
                        label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(.lightGray))
                                .font(.system(size: 20))
                        }
                    )
                    .padding([.top, .trailing], 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .background(
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .fill(Color.white)
                        .preference(
                            key: ViewHeightKey.self,
                            value: proxy.frame(in: .local).size.height
                        )
                }
            )
            .onPreferenceChange(ViewHeightKey.self) {
                self.panelHeight = $0
            }
            .offset(
                x: 0,
                y: self.isPresented ? proxy.size.height - self.panelHeight : proxy.size.height
            )
            // Note:
            // Speed of the "move" transition doesn't appear to change
            // when set. Unsure if bug or on purpose.
            // Hence we animate ourselves.
            .animation(
                .spring(response: self.panelSpringResponse, dampingFraction: 0.9),
                value: self.isPresented
            )
        }
    }
}



// MARK: ViewHeightKey

fileprivate struct ViewHeightKey: PreferenceKey
{
    typealias Value = Double
    static var defaultValue = 0.0
    
    static func reduce(value: inout Value, nextValue: () -> Value)
    {
        value += nextValue()
    }
}



// MARK: Previews

struct PanelSheet_Previews: PreviewProvider
{
    static var previews: some View {
        VStack {
            Text("Hello")
        }
        .modifier(
            Panel(
                item: .constant(PanelItem.wifi),
                onCancel: { },
                contentBuilder: { _ in
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
        )
    }
    
    fileprivate enum PanelItem: String, Identifiable
    {
        case wifi
        var id: String { self.rawValue }
    }
}
