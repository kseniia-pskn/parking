//
//  Consts.swift
//  Parking
//
//  Created by Kseniia Piskun on 22.08.2024.
//

import UIKit

struct Consts {
    struct Colors {
        static let selectedZoneColor = UIColor.blue.withAlphaComponent(Consts.Values.defaultAlpha)
        static let availableZoneColor = UIColor.green.withAlphaComponent(Consts.Values.defaultAlpha)
        static let unavailableZoneColor = UIColor.red.withAlphaComponent(Consts.Values.defaultAlpha)
        static let clearColor = UIColor.clear
        static let strokeColor = UIColor.black
    }

    struct Strings {
        static let noZoneSelectedTitle = "No Zone Selected"
        static let noZoneSelectedSubtitle = "Price: --"
        static let startParking = "Start Parking"
        static let endParking = "End Parking"
        static let parkingNotAvailable = "Parking Not Available"
        static let parkingStartedMessage = """
        Parking started in zone %@
        Price: %@%@.
        """
        static let parkingEndedMessage = "Parking ended in zone %@."
        static let parkingNotAvailableMessage = "Parking is not available in this zone."
        static let zoneInfoMessage = """
            Selected Zone: %@
            Price: %@%@
            Coordinates: %.4f, %.4f
            Status: %@
            """
        static let outsideZoneMessage = """
            No zone selected.
            Coordinates: %.4f, %.4f
            Status: Outside of any parking zone.
            """
    }

    struct Values {
        static let strokeLineWidth: CGFloat = 1.0
        static let defaultAlpha: CGFloat = 0.5
    }
}
