//
//  TestFactories.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Presentation

func makeErrorAlertModel(message: String) -> AlertModel {
    return AlertModel(title: "Erro", message: message)
}
