//
//  ViewController.swift
//  TestForMav
//
//  Created by Havic on 7/8/19.
//  Copyright © 2019 Marlon Henry. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,JSONDelegate {

	@IBOutlet weak var myTableVIew: UITableView!
	@IBOutlet weak var counterLbl: UILabel!
	var web = WebService()
	fileprivate var cellIdentifier = "Cell"
	var jsonDel:JSONDelegate?
	var countdownTimer = Timer()
	var totalTime : Double = 100

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		self.web.jsonDel = self

		web.fetchUpcoming()
		web.fetchUpNext()

	}


	func updateTimer() {
		let obj = web.upNextlLaunch


		let dateformat = DateFormatter.iso8601Full
		let date =  dateformat.date(from: (obj?.launch_date_utc)!)
		self.totalTime = Double(date!.timeIntervalSinceNow)
		updateCounter()

	}



	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return web.launch.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
		let currenLaunch = web.launch[indexPath.row]
		cell.textLabel?.text = "Code Name: \(currenLaunch.mission_name)"
		if currenLaunch.mission_id.indices.contains(indexPath.row){
			let currentMissionID = "Mission ID: \(currenLaunch.mission_id[indexPath.row])"
			cell.detailTextLabel?.text = currentMissionID + " "
		}else{
			cell.detailTextLabel?.text =   "Mission ID: Impossible " //See what I did there? lol
		}

		return cell
	}


	func reloadMyTable() {
		myTableVIew.reloadData()
	}
}

extension ViewController {
	fileprivate func updateCounter() {
		countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[unowned self] (Timer) in


			if self.totalTime != 0 {
				self.totalTime -= 1
				self.counterLbl.text = "Next Launch : \(self.timeFormatted(Int(self.totalTime)))"
			} else {
				self.endTimer()
			}
		})
	}

	func endTimer() {
		countdownTimer.invalidate()
	}

	func timeFormatted(_ totalSeconds: Int) -> String {
		let seconds: Int = totalSeconds % 60
		let minutes: Int = (totalSeconds / 60) % 60
		let hours: Int = totalSeconds / 3600
		return String(format: "%02d:%02d:%02d",hours, minutes, seconds)
	}
}


extension DateFormatter {
	static let iso8601Full: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
		formatter.locale = Locale(identifier: "en_US_POSIX")
		return formatter
	}()

	static let yyyyMMdd: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
		formatter.locale = Locale(identifier: "en_US_POSIX")
		return formatter
	}()
	static let hhdda: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone.current
		formatter.locale = Locale(identifier: "en_US_POSIX")
		return formatter
	}()
}

