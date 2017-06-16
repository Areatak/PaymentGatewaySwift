//
//  CoinGateway.swift
//  Payment-Gateway-Client
//
//  Created by Alireza Ghias on 3/26/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import StompClient

open class CoinGateway: NSObject, StompClientDelegate {
	let apiKey: String
	let uuid: String
	let url = URL(string: "http://localhost:8080/paymentRequest")
	let stompUrl = URL(string: "http://localhost:8080/listen")
	let session = URLSession(configuration: .default)
	let postString = "apiKey=%@&coin=%@&amount=%d&shareId=%@&mode=IOS&stomp=%@"
	
	required init(_ apiKey: String) {
		self.apiKey = apiKey
		self.uuid = UUID().uuidString
		super.init()
		let client = StompClient(url: stompUrl!)
		_ = client.subscribe("/user/" + uuid + "/queue/received")
		client.delegate = self
		client.connect()
		
		
	}
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	open func request(coinType: CoinTypes, amount: Int, shareId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		request.httpBody = String(format: postString, apiKey, coinType.rawValue, amount, shareId, uuid).data(using: .utf8)
		session.dataTask(with: request, completionHandler: completionHandler)
		
	}
	open func request(coinType: CoinTypes, amount: Int, shareId: String, viewController: UIViewController) {
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		request.httpBody = String(format: postString, apiKey, coinType.rawValue, amount, shareId, uuid).data(using: .utf8)
		session.dataTask(with: request) { (data, response, error) in
			if error == nil {
				if (response as! HTTPURLResponse).statusCode == 200 {
					if let map = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
						let shareId = map["shareId"] as! String
						let seq = map["seq"] as! String
						let address = map["address"] as! String
						let amount = map["amount"] as! Int
						let url = map["url"] as! String
						let qr = map["qr"] as! String
						let controller = UIStoryboard(name: "Gateway", bundle: nil).instantiateViewController(withIdentifier: "GatewayViewController") as! GatewayViewController
						controller.shareId = shareId
						controller.seq = seq
						controller.address = address
						controller.amount = amount
						controller.url = url
						controller.qr = qr
						viewController.present(controller, animated: false, completion: nil)
						
					}
				}
			}
		}
		
	}
	
	func stompClientDidConnected(_ client: StompClient) {
		
	}
	func stompClient(_ client: StompClient, didErrorOccurred error: NSError) {
		
	}
	func stompClient(_ client: StompClient, didReceivedData data: Data, fromDestination destination: String) {
		if let map = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			
			if map["confirmed"] as! Bool {
				NotificationCenter.default.post(name: NSNotification.Name("Confirmed"), object: map)
			} else {
				NotificationCenter.default.post(name: NSNotification.Name("NotConfirmedYet"), object: map)
			}
			
		}
		
		
	}
	
	
	
}
