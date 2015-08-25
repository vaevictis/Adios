//
//  ActionRequestHandler.swift
//  ContentBlocker
//
//  Created by Armand Grillet on 09/08/2015.
//  Copyright © 2015 Armand Grillet. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        if let userDefaults = NSUserDefaults(suiteName: "group.AG.Adios") {
            var rules = "["
            if let adiosList = userDefaults.stringForKey("testAgain") {
                rules += adiosList
            }
            
            // Removing the last coma
            if rules.characters.last! == "," {
                rules = rules.substringToIndex(rules.endIndex.predecessor())
            }
            
            if rules != "[" { // Not empty
                rules += "]" // Closing the table to have a good structure
                // Creation the JSON file
                let blockerListPath = NSTemporaryDirectory().stringByAppendingString("tempBaseContentBlocker.json")
                try! rules.writeToFile(blockerListPath, atomically: true, encoding: NSUTF8StringEncoding)
                
                // Loading the JSON file
                let attachment = NSItemProvider(contentsOfURL: NSURL.fileURLWithPath(blockerListPath))!
                
                let item = NSExtensionItem()
                item.attachments = [attachment]
                
                context.completeRequestReturningItems([item], completionHandler: { (Bool) -> Void in
                    try! NSFileManager().removeItemAtPath(blockerListPath) // Removing the list now that it's been used.
                })
            } else {
                  backToBasics(context)
            }
        } else {
            backToBasics(context)
        }
    }
    
    func backToBasics(context: NSExtensionContext) {
        let attachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("blockerList", withExtension: "json"))!
        
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequestReturningItems([item], completionHandler: nil);
    }
}