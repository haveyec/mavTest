//
//  WebService.swift
//  TestForMav
//
//  Created by Havic on 7/8/19.
//  Copyright © 2019 Marlon Henry. All rights reserved.
//

import Foundation
import Alamofire

protocol JSONDelegate : class {
	func reloadMyTable()
	func updateTimer()
}

class WebService {
	weak var jsonDel:JSONDelegate?

	var launch = [Launch]()
	var upNextlLaunch : Launch!

	struct Root:Codable {
		var launch: [Launch]
		var rocket:Rocket
	}

	struct Launch:Codable {
		var mission_name:String
		var mission_id:[String]
		var launch_date_utc:String?
	}

	struct Rocket:Codable{
		var first_stage:First_stage
		var rocket_name:String
	}

	struct First_stage:Codable {
		var cores:[Core]
	}

	struct Core:Codable {
		var reused:Bool
	}


	func fetchUpcoming(){
		loadThatJson(request: "https://api.spacexdata.com/v3/launches/upcoming") { (result) in
			self.launch = result
		}
	}

	func fetchUpNext(){
		loadThatJson(request: "https://api.spacexdata.com/v3/launches/next") { (result) in
			self.upNextlLaunch = result

		}
	}

	fileprivate func loadThatJson(request:String,completion: @escaping ([Launch])->()){

		Alamofire.request(request).responseJSON {  (response) in

			guard response.error == nil else {return}
			//now here we have the response data that we need to parse
			let jsonData = response.data


			do{
				//created the json decoder
				let decoder = JSONDecoder()

				//using the array to put values
				let result = try decoder.decode([Launch].self, from: jsonData!)
				completion(result)
				self.jsonDel?.reloadMyTable()


			}catch let err{
				print(err)
			}

		}
	}

	fileprivate func loadThatJson(request:String,completion: @escaping (Launch)->()){

		Alamofire.request(request).responseJSON {  (response) in

			guard response.error == nil else {return}
			//now here we have the response data that we need to parse
			let jsonData = response.data


			do{
				//created the json decoder
				let decoder = JSONDecoder()

				//using the array to put values
				let result = try decoder.decode(Launch.self, from: jsonData!)
				completion(result)
				self.jsonDel?.updateTimer()


			}catch let err{
				print(err)
			}

		}
	}

}



