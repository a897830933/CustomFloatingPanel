import UIKit

class OrientationHandler {
    weak var panel: CustomFloatingPanel?
    
    init(panel: CustomFloatingPanel) {
        self.panel = panel
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func stopMonitoring() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func orientationDidChange() {
        guard let panel = panel else { return }
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait, .portraitUpsideDown:
            adjustLayoutForPortrait()
        case .landscapeLeft, .landscapeRight:
            adjustLayoutForLandscape()
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3) {
            panel.view.layoutIfNeeded()
        }
    }
    
    private func adjustLayoutForPortrait() {}
    private func adjustLayoutForLandscape() {}
    
    deinit {
        stopMonitoring()
    }
}
