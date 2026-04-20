import UIKit

public protocol FloatingPanelDelegate: AnyObject {
    func floatingPanelWillShow(_ panel: CustomFloatingPanel)
    func floatingPanelDidShow(_ panel: CustomFloatingPanel)
    func floatingPanelWillHide(_ panel: CustomFloatingPanel)
    func floatingPanelDidHide(_ panel: CustomFloatingPanel)
    func floatingPanelWillBeginDragging(_ panel: CustomFloatingPanel)
    func floatingPanelDidEndDragging(_ panel: CustomFloatingPanel, withVelocity velocity: CGPoint)
    func floatingPanel(_ panel: CustomFloatingPanel, didUpdatePositionProgress progress: CGFloat)
}

public extension FloatingPanelDelegate {
    func floatingPanelWillShow(_ panel: CustomFloatingPanel) {}
    func floatingPanelDidShow(_ panel: CustomFloatingPanel) {}
    func floatingPanelWillHide(_ panel: CustomFloatingPanel) {}
    func floatingPanelDidHide(_ panel: CustomFloatingPanel) {}
    func floatingPanelWillBeginDragging(_ panel: CustomFloatingPanel) {}
    func floatingPanelDidEndDragging(_ panel: CustomFloatingPanel, withVelocity velocity: CGPoint) {}
    func floatingPanel(_ panel: CustomFloatingPanel, didUpdatePositionProgress progress: CGFloat) {}
}
