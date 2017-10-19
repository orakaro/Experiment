//
//  ViewController.swift
//  Experiment
//
//  Created by orakaro on 2017/10/19.
//  Copyright © 2017 orakaro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UITableViewController {

    private let dataSource = DataSource()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        let upstreamData: Driver<[Int]> = Driver.of([1,2,3,4,5,6,7,8,9])
        
        // Following code is need for Cocoapods
        // tableView.dataSource = nil
        upstreamData
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        super.viewDidLoad()
    }

    class DataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource, UITableViewDelegate {
        
        typealias Element = [Int]
        var data: [Int] = []
        
        func tableView(_ tableView: UITableView, observedEvent: Event<[Int]>) {
            if case .next(let element) = observedEvent {
                data = element
                tableView.reloadData()
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
            cell.label.text = String(data[indexPath.row])
            return cell
        }
        
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
}

