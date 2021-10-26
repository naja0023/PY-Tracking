$(document).ready(function () {
    var label = ['มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน', 'กรกฏาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม']
    var data = []
    var barColors = ["red", "green", "blue", "orange", "brown"];

    new Chart("myChart", {
        type: "bar",
        data: {
            labels: label,
            datasets: [{
                backgroundColor: barColors,
                data: data
            }]
        },
        options: {
            responsive: true,
            title: {
                display: true, 
                text: 'จำนวนผู้ลงทะเบียนขับรายเดือน',
                fontColor: "#FFF",
            },
            scales: {
                yAxes: [{
                    ticks: {
                        fontColor: "white",
                        // fontSize: 18,
                        // stepSize: 1,


                    }
                }],
                xAxes: [{
                    ticks: {
                        fontColor: "white",
                        // fontSize: 14,
                        // stepSize: 1,

                    }
                }]
            }
        }
    });
});