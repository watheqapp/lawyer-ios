//
//  PriceTableViewCell.swift
//  WathaqLawyer
//
//  Created by Ahmed Zaky on 1/17/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_serviceName: UILabel!
    @IBOutlet weak var lbl_ServiceCoast: UILabel!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
