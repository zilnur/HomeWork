import Foundation
import UIKit
import KeychainAccess

struct TableItem {
    var name: String
    var image: UIImage
}

struct KeyAndUser {
    
    static var shared = KeyAndUser()
    
    var items: [TableItem] {
        get {
        let contents = try! FileManager.default.contentsOfDirectory(at: directory,
                                                                    includingPropertiesForKeys: nil,
                                                                    options: [.skipsHiddenFiles])
        var newItems = [TableItem]()
        for content in contents {
            guard let image = try? UIImage(data: Data(contentsOf: content)) else { return [TableItem]() }
            let name = "Image №\(String(describing: contents.firstIndex(of: content)! + 1))"
            let item = TableItem(name: name, image: image)
            newItems.append(item)
        }
        if self.isInOrder == true {
            let returnedItems = newItems.sorted(by: {$0.name < $1.name})
            return returnedItems
        } else {
            let returnedItems = newItems.sorted(by: {$1.name < $0.name})
            return returnedItems
        }
        }
    }
    
    var configNames: String {
        if self.isInOrder == true {
            return "Порядок: A-Z"
        } else {
            return "Порядок: Z-A"
        }
    }
    
    var isInOrder: Bool {
        get {
        if self.userDeafaults.bool(forKey: "isInOrder") == true {
            return true
        } else {
            return false
        }
        }
        set {
            if newValue == true {
                self.userDeafaults.set(true, forKey: "isInOrder")
            } else {
                self.userDeafaults.set(false, forKey: "isInOrder")
            }
        }
    }

    let keychain = Keychain(service: "-.HomeWork")
    let userDeafaults = UserDefaults.standard
    let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
}
