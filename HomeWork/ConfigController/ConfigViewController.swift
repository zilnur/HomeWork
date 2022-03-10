import UIKit

class ConfigViewController: UIViewController {
    
    let configTable: UITableView = {
        let table = UITableView()
        table.register(ConfigTableViewCell.self, forCellReuseIdentifier: String(describing: ConfigTableViewCell.self))
        table.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        table.rowHeight = 50
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(self.configTable)
        configTable.dataSource = self
        configTable.delegate = self
        configTable.reloadData()
        
        [self.configTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
         self.configTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
         self.configTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
         self.configTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ].forEach {$0.isActive = true}
    }

}

extension ConfigViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.configTable.dequeueReusableCell(withIdentifier: String(describing: ConfigTableViewCell.self), for: indexPath) as? ConfigTableViewCell
        let cell2 = self.configTable.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        switch indexPath.item {
        case 0:
            cell?.label.text = KeyAndUser.shared.configNames
            return cell ?? UITableViewCell()
        case 1:
            cell2.textLabel?.text = "Сменить пароль"
            return cell2
        default:
            return UITableViewCell()
        }
    }
}

extension ConfigViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            KeyAndUser.shared.isInOrder.toggle()
            print(KeyAndUser.shared.isInOrder)
            print(KeyAndUser.shared.userDeafaults.bool(forKey: "isInOrder"))
            print(KeyAndUser.shared.items)
            self.configTable.reloadData()
        case 1:
            let newPassAlert = UIAlertController(title: "Создание нового пароля", message: "Введите новый пароль", preferredStyle: .alert)
            newPassAlert.addTextField { textfield in
                textfield.placeholder = "Новый пароль"
            }
            let okAlert = UIAlertAction(title: "Ok", style: .default) {alert in
                guard let newPass = newPassAlert.textFields?[0].text, newPass.count >= 4 else {
                    let errorAlert = UIAlertController(title: "Ошибка", message: "Пароль должен быть не менее 4 символов", preferredStyle: .alert)
                    let okAlert = UIAlertAction(title: "Ок", style: .default, handler: nil)
                    errorAlert.addAction(okAlert)
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                KeyAndUser.shared.keychain["login"] = newPass
                let successAlert = UIAlertController(title: "Успешно", message: "Пароль успешно изменён", preferredStyle: .alert)
                let okAlert = UIAlertAction(title: "Ок", style: .default, handler: nil)
                successAlert.addAction(okAlert)
                self.present(successAlert, animated: true, completion: nil)
            }
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            [okAlert,cancelAlert].forEach(newPassAlert.addAction(_:))
            self.present(newPassAlert, animated: true, completion: nil)
        default:
            break
        }
    }
}
