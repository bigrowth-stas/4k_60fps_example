//
//  ViewController.swift
//  Cabbage
//
//  Created by Vito on 2018/7/28.
//  Copyright © 2018 Vito. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DemoItem {
	var title: String
	var action: () -> Void

	init(title: String, action: @escaping () -> Void) {
		self.title = title
		self.action = action
	}
}

class ViewController: UITableViewController {

	var demoItems: [DemoItem] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoCell")
		demoItems.append(DemoItem.init(title: "Five 4k 60fps video Demo", action: { [weak self] in
			guard let strongSelf = self else { return }
			let playerItem = strongSelf.five4kVideoPlayerItem()
			strongSelf.pushToPreviewWithPlayerItem(playerItem)
		}))
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.demoItems.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
		let demoItem = self.demoItems[indexPath.row]
		cell.textLabel?.text = demoItem.title
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let demoItem = demoItems[indexPath.row]
		demoItem.action()
	}

	// MARK: - Demo

	func pushToPreviewWithPlayerItem(_ playerItem: AVPlayerItem) {
		let controller = AVPlayerViewController()
		controller.player = AVPlayer.init(playerItem: playerItem)
		navigationController?.pushViewController(controller, animated: true)
	}

	func five4kVideoPlayerItem() -> AVPlayerItem {
		let renderSize = CGSize(width: 1920, height: 1080)

		let height = renderSize.height / 2
		let width = renderSize.width / 2

		let assets = (1...5).map({ "4k_\($0)" }).map({ Bundle.main.url(forResource: $0, withExtension: "MOV")!}).map({ AVAsset(url: $0) })

		let track1: TrackItem = {
			let resource = AVAssetTrackResource(asset: assets[0])
			resource.selectedTimeRange = CMTimeRange.init(start: CMTime.zero, end: CMTime.init(value: 2400, 600))
			let trackItem = TrackItem(resource: resource)
			trackItem.videoConfiguration.contentMode = .aspectFill
			trackItem.videoConfiguration.frame = CGRect(
				x: 0,
				y: 0, width: width, height: height)
			return trackItem
		}()


		let track2: TrackItem = {
			let resource = AVAssetTrackResource(asset: assets[1])
			resource.selectedTimeRange = CMTimeRange.init(start: CMTime.zero, end: CMTime.init(value: 2400, 600))
			let trackItem = TrackItem(resource: resource)
			trackItem.videoConfiguration.contentMode = .aspectFill
			trackItem.videoConfiguration.frame = CGRect(
				x: width,
				y: 0, width: width, height: height)
			return trackItem
		}()

		let track3: TrackItem = {
			let resource = AVAssetTrackResource(asset: assets[2])
			resource.selectedTimeRange = CMTimeRange.init(start: CMTime.zero, end: CMTime.init(value: 2400, 600))
			let trackItem = TrackItem(resource: resource)
			trackItem.videoConfiguration.contentMode = .aspectFill
			trackItem.videoConfiguration.frame = CGRect(
				x: 0,
				y: height, width: width, height: height)
			return trackItem
		}()

		let track4: TrackItem = {
			let resource = AVAssetTrackResource(asset: assets[3])
			resource.selectedTimeRange = CMTimeRange.init(start: CMTime.zero, end: CMTime.init(value: 2400, 600))
			let trackItem = TrackItem(resource: resource)
			trackItem.videoConfiguration.contentMode = .aspectFill
			trackItem.videoConfiguration.frame = CGRect(
				x: width,
				y: height, width: width, height: height)
			return trackItem
		}()

		let track5: TrackItem = {
			let resource = AVAssetTrackResource(asset: assets[4])
			resource.selectedTimeRange = CMTimeRange.init(start: CMTime.zero, end: CMTime.init(value: 2400, 600))
			let trackItem = TrackItem(resource: resource)
			trackItem.videoConfiguration.contentMode = .aspectFill
			trackItem.videoConfiguration.frame = CGRect(
				x: width/2,
				y: height/2, width: width, height: height)
			return trackItem
		}()

		let trackItems = [track1, track2, track3, track4, track5]

		let timeline = Timeline()
		timeline.videoChannel = trackItems

		timeline.renderSize = renderSize;

		let compositionGenerator = CompositionGenerator(timeline: timeline)
		let playerItem = compositionGenerator.buildPlayerItem()
		return playerItem
	}
}
