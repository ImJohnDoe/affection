//
//  AffectCollectionViewController.swift
//  Affection MessagesExtension
//
//  Created by Roman Pshichenko on 1/17/21.
//

import UIKit
import Messages

private let reuseIdentifier = "Cell"

class AffectCollectionViewController: UICollectionViewController {
    static let storyboardIdentifier = "AffectCollectionViewController"
    
    var delegate: AffectCollectionViewControllerDelegate?
    
    enum AffectCollectionItem {
        case existing(Affect)
        case add
    }
    
    var affectList: [AffectCollectionItem]
    
    required init?(coder aDecoder: NSCoder) {
        self.affectList = [AffectCollectionItem]()
        self.affectList.insert(AffectCollectionItem.add, at: 0)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.affectList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let affectCollectionItem = self.affectList[indexPath.row]
        
        switch affectCollectionItem {
        case .add:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAffectItemCell.reuseId, for: indexPath) as? AddAffectItemCell else { fatalError("failed to find add cell")}
            
//            cell.imageView = UIImageView(image: UIImage(named:"add_rating"))
            return cell
            
        case .existing(let affect):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffectItemCell.reuseId, for: indexPath) as? AffectItemCell else { fatalError("failed to obtain affect cell") }
            
            cell.affectItem = affect
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let affect = self.affectList[indexPath.row]
        
        switch affect {
        case .add:
            delegate?.didSelectRatingsItem()
            return true
        default:
            return false
        }
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
     
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

    }
    */
 
}

protocol AffectCollectionViewControllerDelegate: class {
    func didSelectRatingsItem()
}

extension MessagesViewController: AffectCollectionViewControllerDelegate {
    func didSelectRatingsItem() {
        requestPresentationStyle(.expanded)
    }
}

extension MessagesViewController: CreateAffectViewControllerDelegate {
    fileprivate func composeMessage(with affect: Affect, layoutImg: UIImage?, session: MSSession? = nil) -> MSMessage? {
        var components = URLComponents()
    
        let caption = URLQueryItem(name: "reason", value: affect.reason)
        
        let date = URLQueryItem(name: "date", value: "")
        
        let layout = MSMessageTemplateLayout()
        
        guard let image = layoutImg else { return nil }
        layout.image = image
        
        components.queryItems = [caption, date]
        
        let message = MSMessage(session: session ?? MSSession())
    
        message.url = components.url!
        message.layout = layout

        return message
    }
    
    func addAffectForItem(_ item: Affect, layoutImg: UIImage?) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }

        guard let message = composeMessage(with: item, layoutImg: layoutImg, session: conversation.selectedMessage?.session)
            else { return }
        
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        dismiss()
    }
}
