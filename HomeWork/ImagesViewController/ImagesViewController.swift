import UIKit

class ImagesViewController: UIViewController {

    let imaagePicker = UIImagePickerController()
    
     let imageTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ImagesTableViewCell.self, forCellReuseIdentifier: String(describing: ImagesTableViewCell.self))
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        self.view.backgroundColor = .white
        self.imaagePicker.delegate = self
        self.imageTable.dataSource = self
        addSubviews()
        let addButton = UIBarButtonItem(title: "Добавить фотографию", style: .done, target: self, action: #selector(toImagePicker))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func toImagePicker() {
        self.present(self.imaagePicker, animated: true)
    }
}

extension ImagesViewController {
    func addSubviews() {
        self.view.addSubview(self.imageTable)
        
        [self.imageTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
         self.imageTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
         self.imageTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
         self.imageTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ].forEach{$0.isActive = true}
    }
}

extension ImagesViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let contents = try! FileManager.default.contentsOfDirectory(at: KeyAndUser.shared.directory,
                                                                    includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        let url = KeyAndUser.shared.directory.appendingPathComponent("data\(contents.count)")
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let data = image.jpegData(compressionQuality: 1.0) else {return}
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        print("\(contents.count)")
        print(KeyAndUser.shared.items.count)
        self.imageTable.reloadData()
        dismiss(animated: true)
    }
}

extension ImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KeyAndUser.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageTable.dequeueReusableCell(withIdentifier: String(describing: ImagesTableViewCell.self), for: indexPath) as? ImagesTableViewCell
        cell?.post = KeyAndUser.shared.items[indexPath.item]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contents = try! FileManager.default.contentsOfDirectory(at: KeyAndUser.shared.directory,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: [.skipsHiddenFiles])
        try? FileManager.default.removeItem(at: contents[indexPath.item])
        self.imageTable.reloadData()
    }
    
}

extension ImagesViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.imageTable.reloadData()
    }
}
