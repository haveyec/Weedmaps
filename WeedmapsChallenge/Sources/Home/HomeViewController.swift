//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import Alamofire

protocol JSONDelegate {
	func reloadData()
}


class HomeViewController: UIViewController,JSONDelegate {

	// MARK: Properties

	@IBOutlet private var collectionView: UICollectionView!

	private var searchController = UISearchController(searchResultsController: nil)
	private var searchResults = [Businesses]()
	private var searchDataTask: URLSessionDataTask?
	fileprivate let cellReuseIdentifier = "MyCell"
	let ping = Alamofire.NetworkReachabilityManager(host: "www.google.com")
	private let searchEndpoint = "https://api.yelp.com/v3/businesses/search?"
	let locationManager = WMLocationManager()
	@IBOutlet weak var submitBTN: UIButton!
	@IBOutlet weak var searchTxtBx: UITextField!
	var jsonDel:JSONDelegate?


	// MARK: Lifecycle



	func reloadData() {
collectionView.reloadData()
	}

	fileprivate  func networkCall(endPoint endpoint:String){

		let endpointUrl = URL(string: endpoint)
		let headers: HTTPHeaders = [
			"Authorization": "Bearer SpHp4B1tIRGSzhA9IWUCVbfCqHTRwJNTGxIvRR8TA9eP_-m-jm4-HInj2P6OGwW8DrqsFk6SKtXh_DS0aERIecNPPh0m1SoBXQRYUTKLFQUGLvfpHe5kw-EgWNa4XHYx",
			"Accept": "application/json"
		]
		Alamofire.request(endpointUrl!,headers:headers).validate().responseJSON { (response) in
			guard response.error == nil else {return}
			//now here we have the response data that we need to parse
			let jsonData = response.data


			do{
				//created the json decoder
				let decoder = JSONDecoder()

				//using the array to put values
				self.searchResults = try decoder.decode([Businesses].self, from: jsonData!)
				self.jsonDel?.reloadData()


			}catch let err{
				print(err)
			}

		}


	}

	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .green
		locationManager.manager.requestAlwaysAuthorization()
		jsonDel = self


		
	}

	@IBAction func searchBtnPressed(){
		
		//latitude=37.786882&longitude=-122.399972
		//		let searchQ = searchEndpoint + "term=\(searchTxtBx.text)&latitude=\(locationManager.manager.location!.coordinate.latitude)&longitude=-\(locationManager.manager.location!.coordinate.longitude.description)"
		let searchQ = searchEndpoint + "term=\(String(describing: searchTxtBx.text))&latitude=37.786882&longitude=-122.399972"


		networkCall(endPoint: searchQ)
	}


}


// MARK: UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		// IMPLEMENT: Be sure to consider things like network errors
		// and possible rate limiting from the Yelp API. If the user types
		// very quickly, how will you prevent unnecessary requests from firing
		// off? Be sure to leverage the searchDataTask and use it wisely!
	}
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// IMPLEMENT:
		// 1a) Present the user with a UIAlertController (action sheet style) with options
		// to either display the Business's Yelp page in a WKWebView OR bump the user out to
		// Safari. Both options should display the Business's Yelp page details
		let businessOb = searchResults[indexPath.row]
		let alert = UIAlertController(title: "Hey now", message: "How do you want it?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { (alert) in
			//Ask and then open in Safari
			guard let url = URL(string: "") else{return}
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}))
		alert.addAction(UIAlertAction(title: "Open Normal", style: .default, handler: { (alert) in
			//launch webView
			let detailView = HomeDetailViewController()
			detailView.configure(with: businessOb)
			self.navigationController?.pushViewController(detailView, animated: true)
		}))
		present(alert,animated: true)
	}
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// IMPLEMENT:
		return searchResults.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		// IMPLEMENT:
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! BusinessCell
		let businessArr = searchResults[indexPath.row]
		let defaultImage = UIImage()
		cell.name?.text = businessArr.name
		cell.thumbNail.image = defaultImage

		//A little background threading for the image
		DispatchQueue.global(qos: .background).async  {
			let imageString = businessArr.image_url
			let url = URL(string: imageString)

			guard let data:Data = try? Data(contentsOf: url!) else{return}


			//jump to main thread
			DispatchQueue.main.async {
				//set images here
				cell.thumbNail.image = UIImage(data: data)
			}
		}
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		//when you need that scroll to be infinite
		if indexPath.row == searchResults.count-1 {

		}
	}
}

// MARK: UISizeOfCell

extension HomeViewController:UICollectionViewDelegateFlowLayout{
	override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
		let cellSize = CGSize(width: (self.view.bounds.width - 20), height: 100)
		return cellSize
	}
}
