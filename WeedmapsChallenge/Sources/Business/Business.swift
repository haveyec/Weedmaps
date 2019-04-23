//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import Foundation


struct Businesses: Codable {

	var name:String
	var image_url:String
	var is_closed:Bool
	var location:[String:String]
	var display_phone:String
	var url:String

}
