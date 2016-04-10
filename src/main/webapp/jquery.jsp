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
                        var headertext= "<tr><td>"+$.i18n.prop('msg_dhlcode')+"</td><td>"+$.i18n.prop('msg_chinapostcode')+"</td></tr>";
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
                        var headertext= "<tr><td>"+$.i18n.prop('msg_bpostcode')+"</td><td>"+$.i18n.prop('msg_emscode')+"</td></tr>";
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
                            }
                        }

                    }
                });
            });

        </script> 

        <script>
            $(function() {
                loadProperties();
            });

            function loadProperties() {
                jQuery.i18n.properties({//å è½½èµæµè§å¨è¯­è¨å¯¹åºçèµæºæä»¶
                    name: 'Messages', //èµæºæä»¶åç§°
                    path: 'bundle/', //èµæºæä»¶è·¯å¾
                    mode: 'map', //ç¨Mapçæ¹å¼ä½¿ç¨èµæºæä»¶ä¸­çå¼
                    callback: function() {//å è½½æååè®¾ç½®æ¾ç¤ºåå®¹
                        //ç¨æ·å
                        $('#msg_title').html($.i18n.prop('msg_title'));
                        $('#msg_dhl').html($.i18n.prop('msg_dhl'));
                        $('#msg_bpost').html($.i18n.prop('msg_bpost'));
                        $('#msg_query').html($.i18n.prop('msg_query'));
                        $('#msg_dhlarrive').html($.i18n.prop('msg_dhlarrive'));
                        $('#msg_dhlcode').html($.i18n.prop('msg_dhlcode'));
                        $('#msg_chinapostcode').html($.i18n.prop('msg_chinapostcode'));
                        $('#msg_dhlnotarrive').html($.i18n.prop('msg_dhlnotarrive'));
                        $('#msg_bpostarrive').html($.i18n.prop('msg_bpostarrive'));
                        $('#msg_bpostcode').html($.i18n.prop('msg_bpostcode'));
                        $('#msg_emscode').html($.i18n.prop('msg_emscode'));
                        $('#msg_bpostnotarrive').html($.i18n.prop('msg_bpostnotarrive'));
                     
                     
                    }
                });
            }

        </script>
        <div class="container">
            <h3><label id="msg_title"></label></h3>
            <div class="form-group">
                <form id="myForm" action="rest/query/post" method="post">
                   <label id="msg_dhl"></label><br/>
                     <TEXTAREA id="dhlcodes" NAME="dhlcodes" ROWS=10 class="form-control"></TEXTAREA>
                     <input x-webkit-speech id="dhlmic" />
                <BR>
                 <label id="msg_bpost"></label><br/>
                <TEXTAREA id="bpostcodes" NAME="bpostcodes" ROWS=10 class="form-control" ></TEXTAREA>
                <input x-webkit-speech id="bpostmic"  />
                <BR>
                <button type="submit" class="btn btn-default"><label id="msg_query"></label></button>
                </form>
        </div>
        <h3>  <label id="msg_dhlarrive"></label></h3>
        <table id="dhlArrived" class="hidden">
            <tr>
                <th><label id="msg_dhlcode"></label></th>
                <th><label id="msg_chinapostcode"></label></th>
            </tr>
        </table>
    
        <h3> <label id="msg_dhlnotarrive"></label> </h3>
        <table id="dhlnotArrived" class="hidden">
            <tr>
                <th><label id="msg_dhlcode"></label></th>
                <th><label id="msg_chinapostcode"></label></th>
            </tr>
        </table>
    
        <br>
        
        <h3> <label id="msg_bpostarrive"></label> </h3>
        <table id="bpostArrived" class="hidden">
            <tr>
                <th><label id="msg_bpostcode"></label></th>
                <th><label id="msg_emscode"></label></th>
            </tr>
        </table>
    
        
        <h3> <label id="msg_bpostnotarrive"></label>  </h3>
        <table id="bpostnotArrived" class="hidden">
            <tr>
               <th><label id="msg_bpostcode"></label></th>
                <th><label id="msg_emscode"></label></th>
            </tr>
        </table>
        </div>
    </body>
</html>
