//
//  ViewController.swift
//  HomeWork
//
//  Created by Ильнур Закиров on 22.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let imaagePicker = ImagePickerViewController()
    
    private let imagetable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        return table
    }()
    
    let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    
    var images: [UIImage] = [] {
        didSet {
            imagetable.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.imaagePicker.delegate = self
        self.imagetable.dataSource = self
        addSubviews()
        
        let addButton = UIBarButtonItem(title: "Добавить фотографию", style: .done, target: self, action: #selector(toImagePicker))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func toImagePicker() {
        self.present(self.imaagePicker, animated: true)
    }
}

extension ViewController {
    func addSubviews() {
        self.view.addSubview(self.imagetable)
        
        [self.imagetable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
         self.imagetable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
         self.imagetable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
         self.imagetable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ].forEach{$0.isActive = true}
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let data = image.jpegData(compressionQuality: 1.0) else {return}
            let url = directory.appendingPathComponent("data")
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
        let contents = try! FileManager.default.contentsOfDirectory(at: directory,
                                                                    includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        for i in contents {
            guard let image = try? UIImage(data: Data(contentsOf: i)) else {return}
            images.append(image)
        }
        dismiss(animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imagetable.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as? TableViewCell
        cell?.image.image = images[indexPath.item]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        images.remove(at: indexPath.item)
    }
    
}
