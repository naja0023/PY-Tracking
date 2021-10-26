window.onload = function() {
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light2", // "light1", "light2", "dark1", "dark2"
        title: {
            text: "กราฟเรียกรถ"
        },
        axisY: {
            title: "จำนวนการเรียกรถ(ครั้ง)"
        },
        data: [{
            type: "column",
            dataPoints: [{
                y: 100,
                label: "มกราคม"
            }, {
                y: 150,
                label: "กุมภาพันธ์"
            }, {
                y: 120,
                label: "มีนาคม"
            }, {
                y: 180,
                label: "เมษายน"
            }, {
                y: 90,
                label: "พฤษภาคม"
            }, {
                y: 200,
                label: "มิถุนายน"
            }, {
                y: 123,
                label: "กฤกฏาคม"
            }, {
                y: 185,
                label: "สิงหาคม"
            }, {
                y: 240,
                label: "กันยายน"
            }, {
                y: 210,
                label: "ตุลาคม"
            }, {
                y: 80,
                label: "พฤษจิกายน"
            }, {
                y: 190,
                label: "ธันวาคม"
            }, ]
        }]
    });
    chart.render();

}