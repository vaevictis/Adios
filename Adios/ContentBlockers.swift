//
//  ContentBlockers.swift
//  Adios
//
//  Created by Armand Grillet on 25/08/2015.
//  Copyright © 2015 Armand Grillet. All rights reserved.
//

import Foundation
import SafariServices

public class ContentBlockers {
    public class func reload() {
        SFContentBlockerManager.reloadContentBlockerWithIdentifier("AG.Adios.BaseContentBlocker") { (error: NSError?) -> Void in
            if error == nil {
                print("Le base passe")
                SFContentBlockerManager.reloadContentBlockerWithIdentifier("AG.Adios.ContentBlocker") { (otherError: NSError?) -> Void in
                    if error == nil {
                        print("Listes appliquees")
                    } else {
                        print(otherError)
                    }
                }
            } else {
                print(error)
            }
        }
    }
}