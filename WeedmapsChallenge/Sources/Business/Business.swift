//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import Foundation


struct Root:Codable {
	let businesses : [Businesses]
}
struct Businesses: Codable {

	var name:String
	var image_url:String
	var is_closed:Bool
	var display_phone:String
	var url:String

}
