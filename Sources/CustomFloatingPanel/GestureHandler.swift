import UIKit

class GestureHandler: NSObject, UIGestureRecognizerDelegate {
    weak var panel: CustomFloatingPanel?
    let panGesture = UIPanGestureRecognizer()
    let tapGesture = UITapGestureRecognizer()
    
    private var startHeight: CGFloat = 0
    private var startY: CGFloat = 0
    
    init(panel: CustomFloatingPanel) {
        super.init()
        self.panel = panel
        panGesture.addTarget(self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let panel = panel else { return }
        let translation = gesture.translation(in: gesture.view)
        
        switch gesture.state {
        case .began:
            startY = gesture.location(in: gesture.view).y
            startHeight = panel.view.bounds.height
            panel.beginDragging()
            
        case .changed:
            let newHeight = startHeight - translation.y
            let maxHeight = panel.maxHeight
            let minHeight = panel.minHeight
            let boundedHeight = max(minHeight, min(maxHeight, newHeight))
            let progress = (boundedHeight - minHeight) / (maxHeight - minHeight)
            panel.updatePosition(progress: progress)
            
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: gesture.view)
            if velocity.y > 1000 {
                panel.hide(animated: true)
            } else if velocity.y < -500 {
                panel.show(animated: true)
            } else {
                let progress = panel.positionProgress
                if progress < 0.5 {
                    panel.hide(animated: true)
                } else {
                    panel.show(animated: true)
                }
            }
            panel.endDragging(withVelocity: velocity)
            
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        panel?.dismissPanel()
    }
}
