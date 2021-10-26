document.querySelectorAll('.sidebar-submenu').forEach(e => {
    e.querySelector('.sidebar-menu-dropdown').onclick = (event) => {
        event.preventDefault()
        e.querySelector('.sidebar-menu-dropdown .dropdown-icon').classList.toggle('active')

        let dropdown_content = e.querySelector('.sidebar-menu-dropdown-content')
        let dropdown_content_lis = dropdown_content.querySelectorAll('li')

        let active_height = dropdown_content_lis[0].clientHeight * dropdown_content_lis.length

        dropdown_content.classList.toggle('active')

        dropdown_content.style.height = dropdown_content.classList.contains('active') ? active_height + 'px' : '0'
    }
})

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


// DARK MODE TOGGLE
let darkmode_toggle = document.querySelector('#darkmode-toggle')

darkmode_toggle.onclick = (e) => {
    e.preventDefault()
    document.querySelector('body').classList.toggle('dark')
    darkmode_toggle.querySelector('.darkmode-switch').classList.toggle('active')
    setDarkChart(document.querySelector('body').classList.contains('dark'))
}

let overlay = document.querySelector('.overlay')
let sidebar = document.querySelector('.sidebar')

document.querySelector('#mobile-toggle').onclick = () => {
    sidebar.classList.toggle('active')
    overlay.classList.toggle('active')
}

document.querySelector('#sidebar-close').onclick = () => {
    sidebar.classList.toggle('active')
    overlay.classList.toggle('active')
}