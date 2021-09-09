import SwiftUI


// Thanks to https://www.avanderlee.com/swiftui/withanimation-completion-callback/
struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic
{
    var animatableData: Value {
        didSet {
            self.callCompletionIfFinished()
        }
    }

    // Private
    private var targetValue: Value
    private var onComplete: () -> Void

    // MARK: Initialization
    
    init(observedValue: Value, onComplete: @escaping () -> Void)
    {
        self.onComplete = onComplete
        self.animatableData = observedValue
        self.targetValue = observedValue
    }
    
    // MARK: Body
    
    func body(content: Content) -> some View { content }
    
    // MARK: Helpers
    
    private func callCompletionIfFinished()
    {
        guard self.animatableData == self.targetValue else { return }
        
        Task {
            self.onComplete()
        }
    }
}



// MARK: View

extension View
{
    func onAnimationCompletion<Value: VectorArithmetic>(
        with value: Value,
        onComplete: @escaping () -> Void
    ) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>>
    {
        self.modifier(
            AnimationCompletionObserverModifier(
                observedValue: value,
                onComplete: onComplete
            )
        )
    }
}
