//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import WebKit


class HomeDetailViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet private var webView: WKWebView!
    
    // MARK: Control
    
    func configure(with business: Businesses) {
        // IMPLEMENT
		if let url = URL(string: business.url) {
			let request = URLRequest(url: url)
			webView.load(request)
		}
    }
}
