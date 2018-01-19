//
//  PricePlaceHolderTableViewCell.swift
//  WathaqLawyer
//
//  Created by Ahmed Zaky on 1/17/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import Skeleton

class PricePlaceHolderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblServiceName: GradientContainerView!
    @IBOutlet weak var lblServicecoast: GradientContainerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension PricePlaceHolderTableViewCell: GradientsOwner {
    var gradientLayers: [CAGradientLayer] {
        return [lblServiceName.gradientLayer, lblServicecoast.gradientLayer]
    }
}
