import UIKit

class LogInViewController: UIViewController {
    
    let pass: UITextField = {
        let pass = UITextField()
        pass.translatesAutoresizingMaskIntoConstraints = false
        pass.backgroundColor = .lightGray
        return pass
    }()
    
    let enterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }()
    
    var isAccCreated = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonTitle()
    }
    
}

extension LogInViewController {
    func setupViews() {
        [self.pass, self.enterButton].forEach(self.view.addSubview(_:))
        
        [self.pass.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
         self.pass.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
         self.pass.widthAnchor.constraint(equalToConstant: self.view.frame.width - 150),
         self.pass.heightAnchor.constraint(equalToConstant: 50),
         
         self.enterButton.topAnchor.constraint(equalTo: self.pass.bottomAnchor, constant: 50),
         self.enterButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 75),
         self.enterButton.widthAnchor.constraint(equalTo: self.pass.widthAnchor),
         self.enterButton.heightAnchor.constraint(equalToConstant: 50)
        ].forEach {$0.isActive = true}
    }
    
    @objc func createPass() {
        guard let password = pass.text, password.count >= 4 else {
            let alert = UIAlertController(title: "Ошибка", message: "Пароль должен быть больше 4 символов", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertOk)
            self.present(alert, animated: true, completion: nil)
            return}
        
        if KeyAndUser.shared.keychain.allKeys().isEmpty == true {
            KeyAndUser.shared.keychain["login"] = password
            self.pass.text = nil
            self.enterButton.setTitle("Повторите пароль", for: .normal)
        } else {
            guard password == KeyAndUser.shared.keychain["login"] else {
                let alert = UIAlertController(title: "Ошибка", message: "Пароль не совпадает. Создайте заново", preferredStyle: .alert)
                let alertOk = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(alertOk)
                self.present(alert, animated: true, completion: nil)
                KeyAndUser.shared.keychain["login"] = nil
                pass.text = nil
                self.enterButton.setTitle("Создайте пароль", for: .normal)
                return
            }
            KeyAndUser.shared.userDeafaults.set(true, forKey: "isAccCreated")
            print(KeyAndUser.shared.keychain["login"] ?? "")
            let vc = ImagesViewController()
            let naviVC = UINavigationController(rootViewController: vc)
            naviVC.tabBarItem = UITabBarItem(title: "Файлы", image: .init(systemName: "person"), tag: 0)
            
            let configVC = ConfigViewController()
            configVC.tabBarItem = UITabBarItem(title: "Настройки", image: .init(systemName: "more"), tag: 1)
            
            let tab = UITabBarController()
            tab.viewControllers = [naviVC, configVC]
            navigationController?.pushViewController(tab, animated: true)
        }
    }
    
    @objc func tapButton() {
        guard KeyAndUser.shared.userDeafaults.value(forKey: "isAccCreated") != nil else {
            createPass()
            return
        }
        guard let password = pass.text else {return}
        if password == KeyAndUser.shared.keychain["login"] {
            let vc = ImagesViewController()
            let naviVC = UINavigationController(rootViewController: vc)
            naviVC.tabBarItem = UITabBarItem(title: "Файлы", image: .init(systemName: "person"), tag: 0)
            
            let configVC = ConfigViewController()
            configVC.tabBarItem = UITabBarItem(title: "Настройки", image: .init(systemName: "more"), tag: 1)
            
            let tab = UITabBarController()
            tab.viewControllers = [naviVC, configVC]
            navigationController?.pushViewController(tab, animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Неверный пароль", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertOk)
            self.present(alert, animated: true, completion: nil)
            self.pass.text = nil
        }
    }
    
    func setButtonTitle() {
        if KeyAndUser.shared.userDeafaults.value(forKey: "isAccCreated") != nil || KeyAndUser.shared.keychain.allKeys().count != 0 {
            self.enterButton.setTitle("Введите пароль", for: .normal)
        } else {
            self.enterButton.setTitle("Создайте пароль", for: .normal)
        }
    }
}
