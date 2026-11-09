import QtQuick 2.12

Item {
    id: root


    property var dataPoints: [20, 45, 30, 80, 55, 90, 70]
    property var xLabels: ["1", "5", "10", "15", "20", "25", "30"]
    property real maxValue: 100
    property color lineColor: "#2563EB"
    property color areaColor: "#E0E7FF"

    implicitWidth: 600
    implicitHeight: 250

    onDataPointsChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 30

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            if (!root.dataPoints || root.dataPoints.length < 2) return;

            var stepX = width / (root.dataPoints.length - 1);
            var points = [];


            for (var i = 0; i < root.dataPoints.length; i++) {
                points.push({
                    x: i * stepX,
                    y: height - (root.dataPoints[i] / root.maxValue) * height
                });
            }


            ctx.beginPath();
            ctx.moveTo(points[0].x, height);
            for (var j = 0; j < points.length; j++) {
                ctx.lineTo(points[j].x, points[j].y);
            }
            ctx.lineTo(points[points.length - 1].x, height);
            ctx.closePath();

            ctx.fillStyle = root.areaColor;
            ctx.fill();


            ctx.beginPath();
            ctx.moveTo(points[0].x, points[0].y);


            for (var k = 0; k < points.length - 1; k++) {
                var p1 = points[k];
                var p2 = points[k + 1];
                ctx.bezierCurveTo(p1.x + stepX/2, p1.y, p2.x - stepX/2, p2.y, p2.x, p2.y);
            }

            ctx.strokeStyle = root.lineColor;
            ctx.lineWidth = 3;
            ctx.lineJoin = "round";
            ctx.stroke();
        }
    }


    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 20

        Repeater {
            model: root.xLabels
            Text {
                width: parent.width / root.xLabels.length
                text: modelData
                font.pixelSize: 11
                color: "#64748B"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
