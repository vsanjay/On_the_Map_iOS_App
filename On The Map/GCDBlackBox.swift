//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by VERDU SANJAY on 23/02/18.
//  Copyright © 2018 VERDU SANJAY. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

