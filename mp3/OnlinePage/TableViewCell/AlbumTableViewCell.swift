//
//  AlbumTableViewCell.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var labelTitle: UILabel!
    var album: Array<CategoryInfor> = []
    var handleAlbum: ((_ id: String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
       
        CollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.description())
        CollectionView.delegate = self
        CollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension AlbumTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return album.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.description(), for: indexPath) as! CollectionViewCell
            cell.labelTitle.text = album[indexPath.row].name
            cell.imageView.image = UIImage(named: "category")
            cell.imageView.layer.cornerRadius = 50
            cell.imageView.clipsToBounds = true
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            handleAlbum?(album[indexPath.row]._id)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: 150, height: 200)
        }
}
