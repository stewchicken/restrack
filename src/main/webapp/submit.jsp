<%@ page pageEncoding="UTF-8" %>
<html>
    <head> 
        <!-- use responsive UI  -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <!-- use local css  -->
        <style type="text/css">
            .hidden{display:none;}

            table{
                border-spacing: 16px 4px;
            }

            td {
                border: 1px solid black;
            }
        </style>
    </head>

    <body>
        <!-- use jquery and jquery form plugin -->
        <script type="text/javascript" src="js/jquery-1.12.3.min.js"></script> 
        <script type="text/javascript" src="js/jquery.form.js"></script> 
        <script type="text/javascript">
            // wait for the DOM to be loaded 
            /*   
             $(document).ready(function() {
             // bind 'myForm' and provide a simple callback function 
             $('#myForm').ajaxForm(function() {
             alert("Thank you for your comment!");
             });
             });
             */
            $(function() {
                // myForm sent post requst to server side, server process it send back result as json
                // it is hooked on jquery jaxForm's callback function
                $('#myForm').ajaxForm({
                    success: function(data) {

                        var headertext = "<tr><td>DHL单号</td><td>中国邮政转运单号</td></tr>";
                        var dhlnotarrivedlen = data.dhlParcels.notarrivedChina.length;
                        var dhlnotarrivedtxt = "";

                        // clean table content before display the new result
                        $("#dhlnotArrived").empty();
                        $("#dhlArrived").empty();
                        if (dhlnotarrivedlen > 0) {
                            for (var i = 0; i < dhlnotarrivedlen; i++) {
                                if (data.dhlParcels.notarrivedChina[i].dhlcode && data.dhlParcels.notarrivedChina[i].chinapostcode) {
                                    dhlnotarrivedtxt += "<tr><td>" + data.dhlParcels.notarrivedChina[i].dhlcode + "</td><td>" + data.dhlParcels.notarrivedChina[i].chinapostcode + "</td></tr>";
                                }
                            }
                            if (dhlnotarrivedtxt != "") {
                                $("#dhlnotArrived").append(headertext);
                                $("#dhlnotArrived").append(dhlnotarrivedtxt).removeClass("hidden");
                            }
                        }

                        var dhlarrivedlen = data.dhlParcels.arrivedChina.length;
                        var dhlarrivedtxt = "";

                        if (dhlarrivedlen > 0) {
                            for (var i = 0; i < dhlarrivedlen; i++) {
                                if (data.dhlParcels.arrivedChina[i].dhlcode && data.dhlParcels.arrivedChina[i].chinapostcode) {
                                    dhlarrivedtxt += "<tr><td>" + data.dhlParcels.arrivedChina[i].dhlcode + "</td><td>" + data.dhlParcels.arrivedChina[i].chinapostcode + "</td></tr>";
                                }
                            }
                            if (dhlarrivedtxt != "") {
                                $("#dhlArrived").append(headertext);
                                $("#dhlArrived").append(dhlarrivedtxt).removeClass("hidden");
                            }
                        }
                        var headertext = "<tr><td>BPOST单号</td><td>EMS邮政转运单号</td></tr>";
                        var bpostarrivedlen = data.bpostParcels.arrivedChina.length;
                        var bpostarrivedtxt = "";

                        $("#bpostArrived").empty();
                        $("#bpostnotArrived").empty();

                        if (bpostarrivedlen > 0) {
                            for (var i = 0; i < bpostarrivedlen; i++) {
                                if (data.bpostParcels.arrivedChina[i].bpostcode && data.bpostParcels.arrivedChina[i].emscode) {
                                    bpostarrivedtxt += "<tr><td>" + data.bpostParcels.arrivedChina[i].dhlcode + "</td><td>" + data.bpostParcels.arrivedChina[i].emscode + "</td></tr>";
                                }
                            }
                            if (bpostarrivedtxt != "") {
                                $("#bpostArrived").append(headertext);
                                $("#bpostArrived").append(bpostarrivedtxt).removeClass("hidden");
                                //$("#dhlArrived").append(dhlarrivedtxt).removeClass("hidden");
                            }
                        }


                        var bpostnotArrivedlen = data.bpostParcels.notarrivedChina.length;
                        var bpostnotarrivedtxt = "";

                        if (bpostnotArrivedlen > 0) {
                            for (var i = 0; i < bpostnotArrivedlen; i++) {
                                if (data.bpostParcels.notarrivedChina[i].bpostcode && data.bpostParcels.notarrivedChina[i].emscode) {
                                    bpostnotarrivedtxt += "<tr><td>" + data.bpostParcels.notarrivedChina[i].bpostcode + "</td><td>" + data.bpostParcels.notarrivedChina[i].emscode + "</td></tr>";
                                }
                            }
                            if (bpostnotarrivedtxt != "") {
                                $("#bpostnotArrived").append(headertext);
                                $("#bpostnotArrived").append(bpostnotarrivedtxt).removeClass("hidden");
                                //$("#dhlArrived").append(dhlarrivedtxt).removeClass("hidden");
                            }
                        }

                    }
                });
            });

        </script> 


        <div class="container">

            <h3>批量包裹查询，包裹号之间用空格分开，后台REST ,前端JQuery，JSON数据</h3>

            <form id="myForm" action="rest/query/post" method="post">
                德国DHL:<br/>
                <TEXTAREA NAME="dhlcodes" ROWS=10 COLS=100></TEXTAREA><BR>
            比利时邮政:<br/>
            <TEXTAREA NAME="bpostcodes" ROWS=10 COLS=100></TEXTAREA><BR>
            <CENTER>
                <INPUT TYPE="SUBMIT" VALUE="查询">
            </CENTER>
        </form>

        <h3> DHL 已到达中国 </h3>
        <table id="dhlArrived" class="hidden">
            <tr>
                <th>DHL 包裹单号</th>
                <th>中国邮政转运号</th>
            </tr>
        </table>
    
        <h3> DHL 还未到到达中国 </h3>
        <table id="dhlnotArrived" class="hidden">
            <tr>
                <th>DHL 包裹单号</th>
                <th>中国邮政转运号</th>
            </tr>
        </table>
    
        <br>
        
        <h3> BPOST 已到达中国 </h3>
        <table id="bpostArrived" class="hidden">
            <tr>
                <th>BPOST 包裹单号</th>
                <th>中国邮政转运号</th>
            </tr>
        </table>
    
        
        <h3> BPOST 还未到到达中国 </h3>
        <table id="bpostnotArrived" class="hidden">
            <tr>
                <th>DHL 包裹单号</th>
                <th>中国邮政转运号</th>
            </tr>
        </table>
        </div>
    </body>
</html>