//
//  HomeViewController+TableDataSource.swift
//  CarFit
//
//  Created by Kamaljeet Punia on 29/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit

// MARK: - TABLE VIEW DATA SOURCE
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.noTaskLabel.isHidden = self.viewModel.cleanerFilteredData.count != 0
        return self.viewModel.cleanerFilteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeTableViewCell
        var lastCleanerData:CleanerData?
        if (indexPath.row - 1) >= 0 {
            ///Get previous cleaner data
            lastCleanerData = self.viewModel.cleanerFilteredData[indexPath.row - 1]
        }
        cell.setupCell(currentCleanerData: self.viewModel.cleanerFilteredData[indexPath.row], lastCleanerData: lastCleanerData)
        return cell
    }
}
