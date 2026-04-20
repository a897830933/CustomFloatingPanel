import UIKit
import CustomFloatingPanel

class AdvancedScrollViewExampleViewController: UIViewController, FloatingPanelDelegate {
    var floatingPanel: CustomFloatingPanel?
    let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "高级示例 - ScrollView"
        
        let titleLabel = UILabel()
        titleLabel.text = "CustomFloatingPanel"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        let button1 = createButton(title: "显示 ScrollView 面板", action: #selector(showScrollViewPanel))
        button1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button1)
        
        NSLayoutConstraint.activate([
            button1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.widthAnchor.constraint(equalToConstant: 180),
            button1.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        statusLabel.text = "准备显示面板"
        statusLabel.textAlignment = .center
        statusLabel.textColor = .secondaryLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func showScrollViewPanel() {
        let contentVC = ScrollViewPanelContentViewController()
        var appearance = FloatingPanelAppearance()
        appearance.cornerRadius = 20
        
        floatingPanel = CustomFloatingPanel(appearance: appearance)
        floatingPanel?.delegate = self
        floatingPanel?.setContentViewController(contentVC)
        floatingPanel?.minHeight = 280
        
        addChild(floatingPanel!)
        view.addSubview(floatingPanel!.view)
        floatingPanel?.didMove(toParent: self)
        floatingPanel?.show(animated: true)
    }
    
    func floatingPanelDidShow(_ panel: CustomFloatingPanel) {
        statusLabel.text = "✅ 面板已显示"
    }
    
    func floatingPanelDidHide(_ panel: CustomFloatingPanel) {
        statusLabel.text = "❌ 面板已隐藏"
    }
}

class ScrollViewPanelContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    private func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
        
        for i in 1...20 {
            let label = UILabel()
            label.text = "滚动内容 #\(i)"
            label.backgroundColor = .systemGray6
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14)
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(label)
        }
    }
}
