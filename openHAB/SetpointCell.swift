// Copyright (c) 2010-2024 Contributors to the openHAB project
//
// See the NOTICE file(s) distributed with this work for additional
// information.
//
// This program and the accompanying materials are made available under the
// terms of the Eclipse Public License 2.0 which is available at
// http://www.eclipse.org/legal/epl-2.0
//
// SPDX-License-Identifier: EPL-2.0

import OpenHABCore
import os.log
import UIKit

class SetpointCell: GenericUITableViewCell {
    @IBOutlet private var downButton: UIButton!
    @IBOutlet private var upButton: UIButton!
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        selectionStyle = .none
        separatorInset = .zero
    }

    override func displayWidget() {
        downButton.addTarget(self, action: #selector(SetpointCell.decreaseValue), for: .touchUpInside)
        upButton.addTarget(self, action: #selector(SetpointCell.increaseValue), for: .touchUpInside)

        super.displayWidget()
    }

    private func handleUpDown(down: Bool) {
        var numberState = widget?.stateValueAsNumberState
        let stateValue = numberState?.value ?? widget.minValue
        let newValue: Double = down ? stateValue - widget.step : stateValue + widget.step

        let limitedNewValue = newValue.clamped(to: widget.minValue ... widget.maxValue)

        guard limitedNewValue != stateValue else {
            // nothing to update, skip sending value
            return
        }

        if numberState != nil {
            numberState?.value = newValue
        } else {
            numberState = NumberState(value: newValue)
        }

        widget.sendItemUpdate(state: numberState)
    }

    @objc
    func decreaseValue(_ sender: Any?) {
        handleUpDown(down: true)
    }

    @objc
    func increaseValue(_ sender: Any?) {
        handleUpDown(down: false)
    }
}
