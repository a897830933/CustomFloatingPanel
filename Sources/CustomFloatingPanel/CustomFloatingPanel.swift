import UIKit

public class CustomFloatingPanel: UIViewController {
    public weak var delegate: FloatingPanelDelegate?
    public var appearance: FloatingPanelAppearance {
        didSet { updateAppearance() }
    }
    
    public var minHeight: CGFloat = 100 {
        didSet { updateConstraints() }
    }
    
    public var maxHeight: CGFloat {
        return view.bounds.height - 100
    }
    
    public private(set) var positionProgress: CGFloat = 0.0
    private let bottomSheetView = BottomSheetView()
    private var contentViewController: UIViewController?
    private var gestureHandler: GestureHandler?
    private var scrollViewResolver: ScrollViewConflictResolver?
    private var orientationHandler: OrientationHandler?
    
    private var heightConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    private var isShowing = false
    private var isDragging = false
    
    public init(appearance: FloatingPanelAppearance = FloatingPanelAppearance()) {
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupHandlers()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orientationHandler?.startMonitoring()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        orientationHandler?.stopMonitoring()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        bottomSheetView.delegate = self
        view.addSubview(bottomSheetView)
        setupConstraints()
        updateAppearance()
    }
    
    private func setupConstraints() {
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint = bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        trailingConstraint = bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        bottomConstraint = bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        heightConstraint = bottomSheetView.heightAnchor.constraint(equalToConstant: minHeight)
        
        NSLayoutConstraint.activate([
            leadingConstraint!,
            trailingConstraint!,
            bottomConstraint!,
            heightConstraint!
        ])
    }
    
    private func setupHandlers() {
        gestureHandler = GestureHandler(panel: self)
        bottomSheetView.addGestureRecognizer(gestureHandler!.panGesture)
        bottomSheetView.addGestureRecognizer(gestureHandler!.tapGesture)
        
        scrollViewResolver = ScrollViewConflictResolver(panel: self)
        orientationHandler = OrientationHandler(panel: self)
    }
    
    private func updateAppearance() {
        bottomSheetView.appearance = appearance
        bottomSheetView.setNeedsLayout()
    }
    
    public func setContentViewController(_ viewController: UIViewController) {
        contentViewController?.view.removeFromSuperview()
        contentViewController?.removeFromParent()
        
        contentViewController = viewController
        addChild(viewController)
        bottomSheetView.setContentView(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    public func trackScrollView(_ scrollView: UIScrollView) {
        scrollViewResolver?.trackScrollView(scrollView)
    }
    
    public func show(animated: Bool = true) {
        guard !isShowing else { return }
        delegate?.floatingPanelWillShow(self)
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.heightConstraint?.constant = self.minHeight
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.isShowing = true
                self.delegate?.floatingPanelDidShow(self)
            })
        } else {
            heightConstraint?.constant = minHeight
            isShowing = true
            delegate?.floatingPanelDidShow(self)
        }
    }
    
    public func hide(animated: Bool = true) {
        guard isShowing else { return }
        delegate?.floatingPanelWillHide(self)
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.heightConstraint?.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.isShowing = false
                self.delegate?.floatingPanelDidHide(self)
            })
        } else {
            heightConstraint?.constant = 0
            isShowing = false
            delegate?.floatingPanelDidHide(self)
        }
    }
    
    public static func makePanel(contentViewController: UIViewController, appearance: FloatingPanelAppearance = FloatingPanelAppearance()) -> CustomFloatingPanel {
        let panel = CustomFloatingPanel(appearance: appearance)
        panel.setContentViewController(contentViewController)
        return panel
    }
    
    func updatePosition(progress: CGFloat) {
        positionProgress = progress
        let newHeight = minHeight + (maxHeight - minHeight) * progress
        heightConstraint?.constant = newHeight
        delegate?.floatingPanel(self, didUpdatePositionProgress: progress)
    }
    
    func beginDragging() {
        isDragging = true
        delegate?.floatingPanelWillBeginDragging(self)
    }
    
    func endDragging(withVelocity velocity: CGPoint) {
        isDragging = false
        delegate?.floatingPanelDidEndDragging(self, withVelocity: velocity)
    }
    
    func dismissPanel() {
        hide(animated: true)
    }
    
    private func updateConstraints() {
        setNeedsUpdateConstraints()
    }
}

extension CustomFloatingPanel: BottomSheetViewDelegate {
    func bottomSheetDidTap() {
        dismissPanel()
    }
}
