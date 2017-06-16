//
//  GatewayViewController.swift
//  Payment-Gateway-Client
//
//  Created by Alireza Ghias on 3/26/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class GatewayViewController: UIViewController {
	var seq: String!
	var shareId: String!
	var amount: Int!
	var url: String!
	var qr: String!
	var address: String!
	
	
	var closeTitle: String = "Close"
	var waitTitle: String = "Wait"
	var confirmTitle: String = "Confirmed"
	var notConfirmTitle: String = "Not Confirmed Yet"
	var font = UIFont.systemFont(ofSize: 15)
	
	
	
	@IBOutlet weak var seqLabel: UILabel!
	@IBOutlet weak var waitLabel: UILabel!
	@IBOutlet weak var indicator: UIActivityIndicatorView!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var urlLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var modalView: UIView!
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		modalPresentationStyle = .overCurrentContext
		
		
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		modalPresentationStyle = .overCurrentContext
		
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.modalView.frame.origin = CGPoint(x: self.modalView.frame.origin.x, y: self.view.frame.height)
		self.modalView.isHidden = false
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
			self.modalView.frame.origin = CGPoint(x: self.modalView.frame.origin.x, y: 50)
		}) { (success) in
			self.modalView.frame.origin = CGPoint(x: self.modalView.frame.origin.x, y: 50)
		}
		NotificationCenter.default.addObserver(self, selector: #selector(self.confirmed(_:)), name: NSNotification.Name("Confirmed"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.notConfirmedYet(_:)), name: NSNotification.Name("NotConfirmedYet"), object: nil)
		
	}
	func confirmed(_: NSNotification) {
		indicator.stopAnimating()
		waitLabel.text = confirmTitle
	}
	func notConfirmedYet(_: NSNotification) {
		indicator.color = UIColor.green
		waitLabel.text = notConfirmTitle
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		let blurview = APCustomBlurView(withRadius: 4)
		blurview.frame = self.view.bounds
		view.insertSubview(blurview, at: 0)
		if let data = Data(base64Encoded: qr, options: .ignoreUnknownCharacters) {
			if let image = UIImage(data: data) {
				imageView.image = image
			}
		}
		
		amountLabel.text = String(amount)
		urlLabel.text = url
		waitLabel.text = waitTitle
		seqLabel.text = seq
		closeButton.setTitle(closeTitle, for: .normal)
		amountLabel.font = font
		urlLabel.font = font
		waitLabel.font = font
		closeButton.titleLabel?.font = font
		
		indicator.color = UIColor.blue
		indicator.startAnimating()
    }

	
	@IBAction func onCloseClicked(_ sender: Any) {
		dismiss(animated: false, completion: nil)
	}

}
