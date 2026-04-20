import UIKit

protocol BottomSheetViewDelegate: AnyObject {
    func bottomSheetDidTap()
}

class BottomSheetView: UIView {
    weak var delegate: BottomSheetViewDelegate?
    var appearance: FloatingPanelAppearance = FloatingPanelAppearance() {
        didSet { updateAppearance() }
    }
    
    private let contentContainerView = UIView()
    private let grabberView = UIView()
    private let backDropView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(backDropView)
        backDropView.translatesAutoresizingMaskIntoConstraints = false
        backDropView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backDropTapped)))
        
        NSLayoutConstraint.activate([
            backDropView.topAnchor.constraint(equalTo: topAnchor),
            backDropView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backDropView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backDropView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(contentContainerView)
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if appearance.showsGrabberIndicator {
            addGrabber()
        }
    }
    
    private func addGrabber() {
        addSubview(grabberView)
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        grabberView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        grabberView.layer.cornerRadius = 2.5
        
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            grabberView.centerXAnchor.constraint(equalTo: centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 40),
            grabberView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    func setContentView(_ view: UIView) {
        contentContainerView.subviews.forEach { $0.removeFromSuperview() }
        view.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])
    }
    
    private func updateAppearance() {
        layer.cornerRadius = appearance.cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = appearance.backgroundColor
        alpha = appearance.backgroundAlpha
        layer.shadowColor = appearance.shadowColor.cgColor
        layer.shadowOpacity = appearance.shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 8
        backDropView.backgroundColor = appearance.backdropColor.withAlphaComponent(appearance.backdropAlpha)
    }
    
    @objc private func backDropTapped() {
        delegate?.bottomSheetDidTap()
    }
}
