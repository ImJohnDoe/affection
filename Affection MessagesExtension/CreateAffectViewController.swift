//
//  CreateAffectViewController.swift
//  Affection MessagesExtension
//
//  Created by Roman Pshichenko on 1/17/21.
//

import UIKit
import Messages

class CreateAffectViewController: UIViewController {
    static let storyboardIdentifier = "CreateAffectViewController"
    var delegate: CreateAffectViewControllerDelegate?

    @IBOutlet weak var reasonTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var ratedImageBtn: UIButton!
    
    var affect: Affect?
    var conversation: MSConversation?
    
    @IBAction func submitAffect(_ sender: AnyObject) {
        self.affect?.reason = self.reasonTF.text!
        delegate?.addAffectForItem(self.affect!, layoutImg: createLayoutImage())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

protocol CreateAffectViewControllerDelegate: class {
    func addAffectForItem(_ item: Affect, layoutImg: UIImage?)
}

extension CreateAffectViewController {
    func createLayoutImage()->UIImage?{
        let size = CGSize(width:self.view.bounds.width, height: self.view.bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
