
// Bieu do PIE CHART thể hiện tỉ lệ trạng thái thiết bị
google.charts.load("current", { packages: ["corechart"] });
var arrValue_PieChart = [['Trạng thái', 'Số lượng thiết bị']];
function GetData_PieChart() {
    arrValue_PieChart = [[]];
    $.ajax({
        url: '/Home/GetData_PieChart',
        method: 'GET',
        success: function (response) {
            if (response.result) {
                arrValue_PieChart = [['Trạng thái', 'Số lượng thiết bị']];
                var data = response.result_con;
                for (var i = 0; i < data.length; i++) {
                    arrValue_PieChart.push([data[i].Status_type, data[i].num]);
                }
               
                google.charts.setOnLoadCallback(drawChart);
            }
            else { }
        }
    });
   /* setTimeout(GetData_PieChart, 500000);*/
};
GetData_PieChart();
function drawChart() {
    var data = google.visualization.arrayToDataTable(arrValue_PieChart);

    var options = {
        title: 'Tỉ lệ trạng thái thiết bị',
        pieHole: 0.4,
        colors: ['#5252ff', '#527dff', '#52a8ff', '#52d4ff', '#52ffff', '#a852ff', '#ff7d52', '#ffa852',
            '#7dff52', '#e49307', '#b9c246', '#FFDBDB', '#850101', '#5E1414', '#FFF201', '#FFFCB3', '#A98F00']
    };
    var chart = new google.visualization.PieChart(document.getElementById('piechart'));
    chart.draw(data, options);
}
//END Biểu đồ thể hiện tỉ lệ thiết bị theo trạng thái

// Biểu đồ ngang thể hiện số lượng thiết bị theo phòng ban
google.charts.load('current', { packages: ['corechart', 'bar'] });
var arrValue_HorizontalChart = [['Requestor', 'Total message']];
function GetData_HorizontalChart() {

    $.ajax({
        url: '/Home/GetData_HorizontalChart',
        method: 'GET',
        success: function (response) {
            if (response.result) {
                arrValue_HorizontalChart = [[]];
                arrValue_HorizontalChart = [['đơn vị', 'Tổng TB']];
                var data = response.result_con;
                for (var i = 0; i < data.length; i++) {
                    arrValue_HorizontalChart.push([data[i].name, data[i].num]);
                }
                google.charts.setOnLoadCallback(drawTitleSubtitle);
            }
            else { }
        }
    });
   /* setTimeout(GetData_HorizontalChart, 100000);*/
};
GetData_HorizontalChart();
function drawTitleSubtitle() {
    var data = google.visualization.arrayToDataTable(arrValue_HorizontalChart);
    var materialOptions = {
        chart: {
            title: 'Số lượng thiết bị theo đơn vị',
            subtitle: ''
        },
       // width: auto ,
        height: 400,
        hAxis: {
            title: 'Total Population',
            minValue: 0,
        },
        vAxis: {
            title: 'Requestor'
        },
        bars: 'horizontal'
    };
    var materialChart = new google.charts.Bar(document.getElementById('Chart_Horizontal'));
    materialChart.draw(data, materialOptions);
}
//END Biểu đồ ngang thể hiện số lượng thiết bị theo phòng ban