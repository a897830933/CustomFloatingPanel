import UIKit

class ScrollViewConflictResolver: NSObject, UIGestureRecognizerDelegate {
    weak var panel: CustomFloatingPanel?
    private weak var trackedScrollView: UIScrollView?
    
    init(panel: CustomFloatingPanel) {
        super.init()
        self.panel = panel
    }
    
    func trackScrollView(_ scrollView: UIScrollView) {
        trackedScrollView = scrollView
        if let panGesture = (panel?.view.gestureRecognizers?.first { $0 is UIPanGestureRecognizer }) as? UIPanGestureRecognizer {
            panGesture.delegate = self
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = trackedScrollView, scrollView.gestureRecognizers?.contains(otherGestureRecognizer) == true {
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = trackedScrollView, scrollView.gestureRecognizers?.contains(otherGestureRecognizer) == true, let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        let velocity = panGesture.velocity(in: panGesture.view)
        let contentOffset = scrollView.contentOffset.y
        return contentOffset > 0 && velocity.y > 0
    }
}
