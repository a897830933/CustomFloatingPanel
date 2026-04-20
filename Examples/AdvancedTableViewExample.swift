import UIKit
import CustomFloatingPanel

class AdvancedTableViewExampleViewController: UIViewController, FloatingPanelDelegate {
    var floatingPanel: CustomFloatingPanel?
    let showPanelButton = UIButton(type: .system)
    let infoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "高级示例 - TableView 集成"
        
        let backgroundLabel = UILabel()
        backgroundLabel.text = "点击下方按钮显示包含 TableView 的浮动面板"
        backgroundLabel.textAlignment = .center
        backgroundLabel.numberOfLines = 0
        backgroundLabel.textColor = .secondaryLabel
        backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundLabel)
        
        NSLayoutConstraint.activate([
            backgroundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            backgroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        showPanelButton.setTitle("显示 TableView 面板", for: .normal)
        showPanelButton.backgroundColor = .systemGreen
        showPanelButton.setTitleColor(.white, for: .normal)
        showPanelButton.layer.cornerRadius = 8
        showPanelButton.addTarget(self, action: #selector(showTableViewPanel), for: .touchUpInside)
        showPanelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showPanelButton)
        
        NSLayoutConstraint.activate([
            showPanelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showPanelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showPanelButton.widthAnchor.constraint(equalToConstant: 180),
            showPanelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        infoLabel.text = "准备就绪"
        infoLabel.textAlignment = .center
        infoLabel.textColor = .secondaryLabel
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: showPanelButton.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func showTableViewPanel() {
        let tableVC = AdvancedPanelTableViewController()
        var appearance = FloatingPanelAppearance()
        appearance.cornerRadius = 24
        appearance.backgroundColor = .systemBackground
        appearance.backdropAlpha = 0.5
        
        floatingPanel = CustomFloatingPanel(appearance: appearance)
        floatingPanel?.delegate = self
        floatingPanel?.setContentViewController(tableVC)
        floatingPanel?.minHeight = 300
        floatingPanel?.trackScrollView(tableVC.tableView)
        
        addChild(floatingPanel!)
        view.addSubview(floatingPanel!.view)
        floatingPanel?.didMove(toParent: self)
        floatingPanel?.show(animated: true)
    }
    
    func floatingPanelDidShow(_ panel: CustomFloatingPanel) {
        infoLabel.text = "✅ TableView 面板已显示"
    }
    
    func floatingPanelDidHide(_ panel: CustomFloatingPanel) {
        infoLabel.text = "❌ 面板已关闭"
    }
    
    func floatingPanel(_ panel: CustomFloatingPanel, didUpdatePositionProgress progress: CGFloat) {
        infoLabel.text = "📊 进度: \(Int(progress * 100))%"
    }
}

class AdvancedPanelTableViewController: UITableViewController {
    let items = Array(1...50).map { "列表项 #\($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .systemBackground
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = items[indexPath.row]
        config.secondaryText = "示例单元格"
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
