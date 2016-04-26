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

            #dhlmic {
                font-size: 25px;
                width: 25px;
                height: 25px;
                cursor:pointer;
                border: none;
                position: absolute;
                margin-left: 5px;
                outline: none;
                background: transparent;
            }
            #dhlcodes, #dhlmic {float:left;}
            #bpostcodes, #bpostmic {float:left;}

            #bpostmic {
                font-size: 25px;
                width: 25px;
                height: 25px;
                cursor:pointer;
                border: none;
                position: absolute;
                margin-left: 5px;
                outline: none;
                background: transparent;
            }
        </style>
    </head>

    <body>
        <!-- use jquery , jquery i18n and jquery form plugin -->
        <script type="text/javascript" src="js/jquery-1.12.3.min.js"></script> 
		<script type="text/javascript" src="js/jquery.i18n.properties.js"></script>
        <script type="text/javascript" src="js/jquery.form.js"></script> 
		
		<!-- it is for textarea voice input -->
        <script type="text/javascript">
            var dhlmic = document.getElementById('dhlmic');
            dhlmic.onfocus = dhlmic.blur;
            dhlmic.onwebkitspeechchange = function(e) {
                //console.log(e); // SpeechInputEvent
                document.getElementById('dhlcodes').value = dhlmic.value;
            };

            var bpostmic = document.getElementById('bpostmic');
            bpostmic.onfocus = bpostmic.blur;
            bpostmic.onwebkitspeechchange = function(e) {
                //console.log(e); // SpeechInputEvent
                document.getElementById('bpostcodes').value = bpostmic.value;
            };
        </script>
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

                        var headertext = "<tr><td>DHL Parcelcode</td><td>ChinaPost Parcelcode</td></tr>";
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
                        var headertext = "<tr><td>BPOST Parcelcode</td><td>EMS Parcelcode</td></tr>";
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

            <h3>query DHL and BPOST parcels in batch (JQuery + Restful Service )</h3>
            <div class="form-group">
                <form id="myForm" action="rest/query/post" method="post">
                    DHL:<br/>
                     <TEXTAREA id="dhlcodes" NAME="dhlcodes" ROWS=10 class="form-control"></TEXTAREA>
                     <input x-webkit-speech id="dhlmic" />
                <BR>
                BPOST:<br/>
                <TEXTAREA id="bpostcodes" NAME="bpostcodes" ROWS=10 class="form-control" ></TEXTAREA>
                <input x-webkit-speech id="bpostmic"  />
                <BR>
                <button type="submit" class="btn btn-default">Query</button>
                </form>
        </div>
        <h3> DHL arrived China </h3>
        <table id="dhlArrived" class="hidden">
            <tr>
                <th>DHL Parcelcode</th>
                <th>Chinapost Parcelcode</th>
            </tr>
        </table>
    
        <h3> DHL not arrived China </h3>
        <table id="dhlnotArrived" class="hidden">
            <tr>
               <th>DHL Parcelcode</th>
                <th>Chinapost Parcelcode</th>
            </tr>
        </table>
    
        <br>
        
        <h3> BPOST arrived China </h3>
        <table id="bpostArrived" class="hidden">
            <tr>
                <th>BPOST Parcelcode</th>
                <th>EMS Parcelcode</th>
            </tr>
        </table>
    
        
        <h3> BPOST not arrived China </h3>
        <table id="bpostnotArrived" class="hidden">
            <tr>
                <th>DHL Parcelcode</th>
                <th>EMS Parcelcode</th>
            </tr>
        </table>
        </div>
    </body>
</html>
