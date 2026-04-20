import UIKit
import CustomFloatingPanel

class BasicUIKitExampleViewController: UIViewController, FloatingPanelDelegate {
    var floatingPanel: CustomFloatingPanel?
    let showPanelButton = UIButton(type: .system)
    let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "CustomFloatingPanel - 基础示例"
        showPanelButton.setTitle("显示浮动面板", for: .normal)
        showPanelButton.backgroundColor = .systemBlue
        showPanelButton.setTitleColor(.white, for: .normal)
        showPanelButton.layer.cornerRadius = 8
        showPanelButton.addTarget(self, action: #selector(showFloatingPanel), for: .touchUpInside)
        showPanelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showPanelButton)
        
        NSLayoutConstraint.activate([
            showPanelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showPanelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            showPanelButton.widthAnchor.constraint(equalToConstant: 150),
            showPanelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        statusLabel.text = "点击按钮显示面板"
        statusLabel.textAlignment = .center
        statusLabel.textColor = .secondaryLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: showPanelButton.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func showFloatingPanel() {
        let contentVC = BasicPanelContentViewController()
        var appearance = FloatingPanelAppearance()
        appearance.cornerRadius = 20
        appearance.backgroundColor = .systemBackground
        appearance.backdropAlpha = 0.4
        appearance.shadowOpacity = 0.2
        
        floatingPanel = CustomFloatingPanel(appearance: appearance)
        floatingPanel?.delegate = self
        floatingPanel?.setContentViewController(contentVC)
        floatingPanel?.minHeight = 250
        
        addChild(floatingPanel!)
        view.addSubview(floatingPanel!.view)
        floatingPanel?.didMove(toParent: self)
        floatingPanel?.show(animated: true)
    }
    
    func floatingPanelWillShow(_ panel: CustomFloatingPanel) {
        statusLabel.text = "面板即将显示..."
    }
    
    func floatingPanelDidShow(_ panel: CustomFloatingPanel) {
        statusLabel.text = "✅ 面板已显示"
    }
    
    func floatingPanelWillHide(_ panel: CustomFloatingPanel) {
        statusLabel.text = "面板即将隐藏..."
    }
    
    func floatingPanelDidHide(_ panel: CustomFloatingPanel) {
        statusLabel.text = "❌ 面板已隐藏"
    }
    
    func floatingPanelWillBeginDragging(_ panel: CustomFloatingPanel) {
        statusLabel.text = "👆 开始拖拽面板"
    }
    
    func floatingPanelDidEndDragging(_ panel: CustomFloatingPanel, withVelocity velocity: CGPoint) {
        statusLabel.text = "✋ 拖拽结束"
    }
    
    func floatingPanel(_ panel: CustomFloatingPanel, didUpdatePositionProgress progress: CGFloat) {
        statusLabel.text = "📊 位置进度: \(Int(progress * 100))%"
    }
}

class BasicPanelContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        titleLabel.text = "浮动面板内容"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "这是一个基础的浮动面板示例。\n\n您可以向下拖拽关闭面板。"
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
