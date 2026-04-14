import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects 1.0

import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width || 1920
    height: Screen.height || 1080

    // -------------------------------------------------------------------------
    // Responsive Scaling
    // -------------------------------------------------------------------------
    readonly property real scaleFactor: Math.max(0.5, Math.min(width / 1920, height / 1080))
    readonly property real baseUnit: 8 * scaleFactor

    // -------------------------------------------------------------------------
    // Theme Constants (Rose Pine) & Style Tokens
    // -------------------------------------------------------------------------
    readonly property color mPrimary: config.mPrimary || "#c7a1d8"
    readonly property color mOnPrimary: config.mOnPrimary || "#1a151f"
    readonly property color mSurface: config.mSurface || "#1c1822"
    readonly property color mSurfaceVariant: config.mSurfaceVariant || "#262130"
    readonly property color mOnSurface: config.mOnSurface || "#e9e4f0"
    readonly property color mOnSurfaceVariant: config.mOnSurfaceVariant || "#a79ab0"
    readonly property color mError: config.mError || "#e9899d"
    readonly property color mOutline: config.mOutline || "#342c42"

    // Responsive sizes
    readonly property real radiusL: 20 * scaleFactor
    readonly property real fontSizeM: 11 * scaleFactor
    readonly property real fontSizeL: 13 * scaleFactor
    readonly property real fontSizeXL: 16 * scaleFactor
    readonly property real fontSizeXXL: 18 * scaleFactor
    readonly property real fontSizeClock: 42 * scaleFactor

    // Configurable Background
    readonly property string backgroundPath: config.background || "Assets/background.jpg"

    // Fonts
    property font fontMain: Qt.font({
        family: "Noto Sans",
        pixelSize: 14 * scaleFactor
    })

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    readonly property real blurRadius: config.blurRadius || 0

    // -------------------------------------------------------------------------
    // Background
    // -------------------------------------------------------------------------
    Image {
        id: wallpaper
        anchors.fill: parent
        source: root.backgroundPath
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        clip: true
        visible: root.blurRadius <= 0 // Hide if blurred version is shown
    }

    FastBlur {
        anchors.fill: parent
        source: wallpaper
        radius: root.blurRadius
        transparentBorder: false
        visible: root.blurRadius > 0
        cached: true
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0.6) } // Darker top
            GradientStop { position: 0.4; color: Qt.rgba(0,0,0,0.2) }
            GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.7) } // Darker bottom
        }
    }

    // -------------------------------------------------------------------------
    // Top Card: User Info & Time
    // -------------------------------------------------------------------------
    Rectangle {
        id: headerCard
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.12
        anchors.horizontalCenter: parent.horizontalCenter

        width: Math.max(400 * scaleFactor, Math.min(parent.width * 0.70, 550 * scaleFactor))
        height: 120 * scaleFactor
        radius: root.radiusL
        color: root.mSurface
        border.color: Qt.rgba(root.mOutline.r, root.mOutline.g, root.mOutline.b, 0.2)
        border.width: 1 * scaleFactor

        RowLayout {
            id: headerRow
            anchors.fill: parent
            anchors.margins: 16 * scaleFactor
            spacing: 32 * scaleFactor

            // Avatar - Perfect Circle
            Item {
                id: avatarRect
                Layout.preferredWidth: 70 * scaleFactor
                Layout.preferredHeight: 70 * scaleFactor
                Layout.alignment: Qt.AlignVCenter

                width: 70 * scaleFactor
                height: 70 * scaleFactor

                Rectangle {
                    id: avatarMask
                    anchors.fill: parent
                    radius: width / 2
                    visible: false
                }

                Image {
                    anchors.fill: parent
                    source: "Assets/face.png"
                    sourceSize: Qt.size(70 * scaleFactor, 70 * scaleFactor)
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    asynchronous: true

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: avatarMask
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: "transparent"
                    border.color: root.mPrimary
                    border.width: 2 * scaleFactor
                }
            }

            // Text Info
            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 2 * scaleFactor

                Text {
                    text: "Welcome back, Mohi"
                    font.pixelSize: root.fontSizeXXL
                    font.bold: true
                    color: root.mOnSurface
                }

                Text {
                    text: Qt.formatDate(new Date(), "dddd, MMMM d")
                    font.pixelSize: root.fontSizeXL
                    color: root.mOnSurfaceVariant
                }
            }

            Item { Layout.fillWidth: true } // Spacer

            // Clock
            Text {
                text: Qt.formatTime(new Date(), "hh:mm")
                font.pixelSize: root.fontSizeClock
                font.bold: true
                color: root.mOnSurface
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    // -------------------------------------------------------------------------
    // Bottom Card: Password & Controls
    // -------------------------------------------------------------------------
    Rectangle {
        id: bottomCard
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100 * scaleFactor
        anchors.horizontalCenter: parent.horizontalCenter

        width: Math.min(750 * scaleFactor, parent.width * 0.9)
        height: 140 * scaleFactor
        radius: root.radiusL
        color: root.mSurface
        border.color: Qt.rgba(root.mOutline.r, root.mOutline.g, root.mOutline.b, 0.2)
        border.width: 1 * scaleFactor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20 * scaleFactor
            spacing: 15 * scaleFactor

            // Password Field Row
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 50 * scaleFactor
                spacing: 15 * scaleFactor

                // Input Box
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: root.mSurfaceVariant
                    radius: 12 * scaleFactor

                    TextInput {
                        id: passwordBox
                        anchors.fill: parent
                        anchors.margins: 15 * scaleFactor
                        verticalAlignment: Text.AlignVCenter

                        text: ""
                        echoMode: TextInput.Password
                        color: root.mOnSurface
                        font.pixelSize: 14 * scaleFactor

                        focus: true

                        onAccepted: sddm.login(userModel.lastUser, passwordBox.text, sessionList.currentIndex)
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(userModel.lastUser, passwordBox.text, sessionList.currentIndex)
                                event.accepted = true
                            }
                        }
                    }

                    Text {
                        anchors.fill: parent
                        anchors.margins: 15 * scaleFactor
                        verticalAlignment: Text.AlignVCenter
                        text: "Password..."
                        color: Qt.rgba(root.mOnSurfaceVariant.r, root.mOnSurfaceVariant.g, root.mOnSurfaceVariant.b, 0.5)
                        font.pixelSize: 14 * scaleFactor
                        visible: !passwordBox.text && !passwordBox.activeFocus
                    }
                }

                // Login Button
                Controls.Button {
                    Layout.preferredWidth: 100 * scaleFactor
                    Layout.fillHeight: true

                    background: Rectangle {
                        color: parent.down ? Qt.darker(root.mPrimary, 1.2) : root.mPrimary
                        radius: 12 * scaleFactor
                    }

                    contentItem: Text {
                        text: "Login"
                        font.pixelSize: 14 * scaleFactor
                        font.bold: true
                        color: root.mOnPrimary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: sddm.login(userModel.lastUser, passwordBox.text, sessionList.currentIndex)
                }
            }

            // Controls Row
            RowLayout {
                Layout.fillWidth: true
                spacing: 10 * scaleFactor

                // Session List
                Controls.ComboBox {
                   id: sessionList
                   model: sessionModel
                   textRole: "name"
                   currentIndex: sessionModel.lastIndex

                   Layout.preferredWidth: 200 * scaleFactor
                   Layout.preferredHeight: 36 * scaleFactor

                   delegate: Controls.ItemDelegate {
                       width: parent.width
                       text: model.name || ""
                       highlighted: sessionList.highlightedIndex === index
                       contentItem: Text {
                           text: parent.text
                           color: root.mOnSurface
                           font.pixelSize: root.fontSizeM
                           verticalAlignment: Text.AlignVCenter
                       }
                       background: Rectangle {
                           color: parent.highlighted ? root.mSurfaceVariant : "transparent"
                       }
                   }

                   background: Rectangle {
                       color: root.mSurfaceVariant
                       radius: 8 * scaleFactor
                   }

                   contentItem: Text {
                       leftPadding: 10 * scaleFactor
                       text: sessionList.displayText || ""
                       color: root.mOnSurface
                       font.pixelSize: root.fontSizeM
                       verticalAlignment: Text.AlignVCenter
                   }

                   popup: Controls.Popup {
                       y: sessionList.height - 1
                       width: sessionList.width
                       implicitHeight: contentItem.implicitHeight
                       padding: 1 * scaleFactor

                       contentItem: ListView {
                           clip: true
                           implicitHeight: contentHeight
                           model: sessionList.popup.visible ? sessionList.delegateModel : null
                           currentIndex: sessionList.highlightedIndex
                           Controls.ScrollIndicator.vertical: Controls.ScrollIndicator { }
                       }

                       background: Rectangle {
                           border.color: root.mOutline
                           color: root.mSurface
                           radius: 4 * scaleFactor
                       }
                   }
               }

                Item { Layout.fillWidth: true } // Spacer

                // Power Buttons
                Repeater {
                    model: [
                        { text: "Suspend", type: "suspend" },
                        { text: "Reboot", type: "reboot" },
                        { text: "Shutdown", type: "shutdown" }
                    ]

                    delegate: Controls.Button {
                        text: modelData.text
                        Layout.preferredHeight: 36 * scaleFactor
                        Layout.preferredWidth: 100 * scaleFactor

                        background: Rectangle {
                            color: parent.down ? Qt.darker(root.mSurfaceVariant, 1.2) : root.mSurfaceVariant
                            radius: 8 * scaleFactor
                        }

                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: root.fontSizeM
                            color: root.mOnSurface
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            if (modelData.type === "suspend") {
                                sddm.suspend()
                            } else if (modelData.type === "reboot") {
                                sddm.reboot()
                            } else if (modelData.type === "shutdown") {
                                sddm.powerOff()
                            }
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // Error Message
    // -------------------------------------------------------------------------
     Rectangle {
        width: errorMessage.implicitWidth + 40 * scaleFactor
        height: 50 * scaleFactor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: bottomCard.top
        anchors.bottomMargin: 20 * scaleFactor
        radius: root.radiusL
        color: root.mError
        visible: errorMessage.text !== ""

        Text {
            id: errorMessage
            anchors.centerIn: parent
            text: "" // Set by signal
            color: "#1e1418" // mOnError
            font.pixelSize: root.fontSizeM
            font.bold: true
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            passwordBox.text = ""
            errorMessage.text = "Authentication failed"
        }
    }
}
