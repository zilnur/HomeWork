import UIKit

class ImagesTableViewCell: UITableViewCell {
    
    var post: TableItem? {
        didSet {
            self.label.text = post?.name
            self.image.image = post?.image
        }
    }
    
    var label: UILabel = {
        let image = UILabel()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        
        [self.label, self.image].forEach(self.contentView.addSubview(_:))
        
        [self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
         self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
         self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
         self.label.heightAnchor.constraint(equalToConstant: 50),
         
         self.image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
         self.image.topAnchor.constraint(equalTo: self.label.bottomAnchor),
         self.image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
         self.image.widthAnchor.constraint(equalToConstant: self.contentView.frame.width - 30),
         self.image.heightAnchor.constraint(equalTo: self.image.widthAnchor),
         self.image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ].forEach{$0.isActive = true}
    }
}
