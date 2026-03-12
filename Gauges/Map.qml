import QtQuick 2.8
import QtLocation 5.9
import QtPositioning 5.9
import QtQuick.Controls 2.1

Rectangle {
    id: mapItem
    anchors.fill: parent
    property int bearingType: 1
	anchors.margins: 5 
	color: "darkBlue"

    Connections {
        target: Dashboard
        onGpsLatitudeChanged: {
            pos.poschanged()
        }
        onGpsLongitudeChanged: {
            pos.poschanged()
        }
        onGpsbearingChanged: {
            pos.poschanged()
        }
    }
    Rectangle {
        anchors.fill: parent
		anchors.margins: 5 
		color: "darkBlue"
        Plugin {
            id: mapPlugin
            name: "osm"
            PluginParameter {
                name: "osm.useragent"
                value: "PowerTune"
            }
	//MLA
				// https://doc.qt.io/archives/qt-5.15/qmlapplications.html
				// https://doc.qt.io/archives/qt-5.15/qtlocation-qmlmodule.html
				// https://doc.qt.io/archives/qt-5.15/qml-qtlocation-map.html
				// https://doc.qt.io/qt-6/location-plugin-osm.html
				// https://github.com/Elleo/qt-osm-map-providers
				// https://blog.mikeasoft.com/2020/06/22/qt-qml-maps-using-the-osm-plugin-with-api-keys/
				// https://stackoverflow.com/questions/61689939/qtlocation-osm-api-key-required
				// https://www.youtube.com/watch?v=VlRMQWqI0S8
				// https://manage.thunderforest.com/dashboard
				
			PluginParameter { 
				name: "osm.mapping.highdpi_tiles"			// MLA - Works - gets tiles x2
				value: true 
			}
            PluginParameter {
                name: 'osm.mapping.cache.directory'
                value: "/home/pi/maptilescache/"
            }
        }

        Map {
            id: map
            height: parent.height
            width: parent.width //  * 0.775
            plugin: mapPlugin
            zoomLevel: 16
			/*
			0	Atlas			https://a.tile.thunderforest.com/atlas/18/61466/108377.png
			1	CYCLE			https://a.tile.thunderforest.com/cycle/18/61466/108377@2x.png
			2	TRANSPORT		https://a.tile.thunderforest.com/transport/18/61466/108377@2x.png
			3	TRANSPORT-DARK	https://a.tile.thunderforest.com/transport-dark/18/61466/108377@2x.png
			4	LANDSCAPE		https://a.tile.thunderforest.com/landscape/18/61466/108377@2x.png
			5	OUTDOORS		https://a.tile.thunderforest.com/outdoors/18/61466/108377@2x.png

			https://doc.qt.io/archives/qt-5.15/qml-qtlocation-maptype.html#style-prop
			*/
			activeMapType: map.supportedMapTypes[3]
            copyrightsVisible: false
            gesture.enabled: false
            tilt: 0
            bearing: Dashboard.gpsbearing

            // Draw a small red circle for current Vehicle Location
            MapQuickItem {
                id: marker
                anchorPoint.x: 10
                anchorPoint.y: 10
                width: 15
                coordinate: QtPositioning.coordinate(Dashboard.gpsLatitude,
                                                     Dashboard.gpsLongitude)
                sourceItem: Rectangle {
                    id: image
                    width: 20
                    height: width
                    radius: width * 0.5
                    color: "red"
                }
            }
        }
        ComboBox {
            id: maptypeselect
            width: parent.width * 0.16
            height: parent.height * 0.06
			anchors.margins: 5 
            font.pixelSize: mapItem.width * 0.0125
            font.bold: true
            model: ["Atlas", "Cycle", "Transport", "Transport-Dark", "Landscape", "Outdoors"]
			currentIndex: 3 // Selects "Transport-Dark" (index 3)
            delegate: ItemDelegate {
                width: maptypeselect.width
                height: maptypeselect.height
                text: maptypeselect.textRole ? (Array.isArray(
                                                    control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: maptypeselect.currentIndex === index ? Font.DemiBold : Font.Normal
                font.family: maptypeselect.font.family
                font.pixelSize: maptypeselect.font.pixelSize
                highlighted: maptypeselect.highlightedIndex === index
                hoverEnabled: maptypeselect.hoverEnabled
            }
            onCurrentIndexChanged: maptype.change()
        }
		Button {
			id: minuszoom
			width: parent.width * 0.06
			height: width
			anchors.top: maptypeselect.bottom
			anchors.margins: 10
			Component.onCompleted: {
				if(window.width == 800){
					minuszoom.width = parent.width * 0.1
					minuszoom.height = minuszoom.width
				}
			}
			onClicked: {
				map.zoomLevel -= 1
				if(map.zoomLevel < 14){ //if the zoomLevel goes under 14 bring it back to 14
					map.zoomLevel = 14
				}
				map.center = QtPositioning.coordinate(Dashboard.gpsLatitude, Dashboard.gpsLongitude,map.zoomLevel)
			}
			background: Rectangle {
				radius: minuszoom.width
				opacity: 0.3
				color: minuszoom.down ? "darkgrey" : "grey"
				border.color: minuszoom.down ? "grey" : "darkgrey"
				border.width: minuszoom.width / 10
			}
			Image{
				source: "qrc:/graphics/zoomout.png"
				anchors.fill: minuszoom
				width: minuszoom.width
				height: minuszoom.height
				anchors.centerIn: minuszoom.horizontalCenter
			}
		 }
		Button {
			id: pluszoom
			width: parent.width * 0.06
			height: width
			anchors.left: minuszoom.right
			anchors.top: maptypeselect.bottom
			anchors.margins: 10
			Component.onCompleted: {
				if(window.width == 800){
					pluszoom.width = parent.width * 0.1
					pluszoom.height = pluszoom.width
				}
			}
			onClicked: {
				map.zoomLevel += 1
				if(map.zoomLevel > 19){ //if the zoomValue goes above 19 bring it back to 19
					map.zoomLevel = 19
				}
				map.center = QtPositioning.coordinate(Dashboard.gpsLatitude, Dashboard.gpsLongitude,map.zoomLevel)
 			}
			background: Rectangle {
				radius: pluszoom.width
				opacity: 0.3
				color: pluszoom.down ? "darkgrey" : "grey"
				border.color: pluszoom.down ? "grey" : "darkgrey"
				border.width: pluszoom.width / 10
			}
 			Image{
				source: "qrc:/graphics/zoomin.png"
				anchors.fill: pluszoom
				width: pluszoom.width
				height: pluszoom.height
				anchors.centerIn: pluszoom.horizontalCenter
			} 
		}
		Button {
			id: bearingbtn
			width: parent.width * 0.06
			height: width
			anchors.top: minuszoom.bottom
			anchors.margins: 10
			Component.onCompleted: {
				if(window.width == 800){
					bearingbtn.width = parent.width * 0.1
					bearingbtn.height = bearingbtn.width
				}
			}
			onClicked: {
				mapItem.bearingType += 1
				if(mapItem.bearingType > 1){ //toggle the bearingType
					mapItem.bearingType = 0
				}
 			}
			background: Rectangle {
				radius: bearingbtn.width
				opacity: 0.3
				color: bearingbtn.down ? "darkgrey" : "grey"
				border.color: bearingbtn.down ? "grey" : "darkgrey"
				border.width: bearingbtn.width / 10
			}
			contentItem: Item { // Make button graphics change on bearing selection
			 	Image{
					source: "qrc:/graphics/map_north_up.png"
					opacity: mapItem.bearingType * 0.7
					anchors.fill: bearingbtn
					width: bearingbtn.width
					height: bearingbtn.height
					anchors.centerIn: bearingbtn.horizontalCenter
				} 
				Image{
					source: "qrc:/graphics/map_bearing.png"
					opacity: 0.7 - mapItem.bearingType * 0.7
					anchors.fill: bearingbtn
					width: bearingbtn.width
					height: bearingbtn.height
					anchors.centerIn: bearingbtn.horizontalCenter
				} 
			}
		}
		Label {
            id: speedlabel
            text: Dashboard.gpsSpeed
            font.pixelSize: mapItem.width * 0.175
            font.bold: true
            font.family: "Eurostile"
	  		color: "darkgrey"
    	    anchors.left: parent.left
			anchors.top: bearingbtn.bottom
			anchors.margins: 60 
		}
		Label {
            id: localtime
            text: Dashboard.gpsHour12 + ":" + ("0" + Dashboard.gpsMinute60).slice(-2) + ":" + ("0" + Dashboard.gpsSecond60).slice(-2)
            font.pixelSize: mapItem.width * 0.02
            font.bold: true
            font.family: "Eurostile"
	  		color: "darkgrey"
    	    anchors.left: parent.left
			anchors.bottom: parent.bottom
			anchors.margins: 10 
		}
		Label {
            id: fixlabel
            text: "   " + Dashboard.gpsFIXtype + " / " + Dashboard.gpsVisibleSatelites + " Visible Satelites"
            font.pixelSize: mapItem.width * 0.02
            font.bold: true
            font.family: "Eurostile"
	  		color: "darkgrey"
    	    anchors.left: localtime.right
			anchors.bottom: parent.bottom
			anchors.margins: 10 
		}
        Item {
            id: maptype
            function change() {
				if (maptypeselect.textAt(maptypeselect.currentIndex) == "Atlas") 
				{map.activeMapType= map.supportedMapTypes[0]}
				;
				if (maptypeselect.textAt(maptypeselect.currentIndex) == "Cycle") 
				{map.activeMapType= map.supportedMapTypes[1]}
				;
				if (maptypeselect.textAt(maptypeselect.currentIndex) == "Transport") 
				{map.activeMapType= map.supportedMapTypes[2]}
				;
				if (maptypeselect.textAt(maptypeselect.currentIndex) == "Transport-Dark") 
				{map.activeMapType= map.supportedMapTypes[3]}
				;
				if (maptypeselect.textAt(maptypeselect.currentIndex) == "Landscape") 
				{map.activeMapType= map.supportedMapTypes[4]}
				;
				if (maptypeselect.textAt(maptypeselect.currentIndex) == "Outdoors") 
				{map.activeMapType= map.supportedMapTypes[5]}
				;
            }
        }
        Item {
            // update the Map on changes of position or bearing
            id: pos
            function poschanged() {
				if (mapItem.bearingType == 0) { // Bearing Up
						map.center = QtPositioning.coordinate(Dashboard.gpsLatitude, Dashboard.gpsLongitude,map.bearing = Dashboard.gpsbearing)
				}
				;
				if (mapItem.bearingType == 1) { // North Up
						map.center = QtPositioning.coordinate(Dashboard.gpsLatitude, Dashboard.gpsLongitude,map.bearing = 0)
				}
				;
            }
        }
    }
}
