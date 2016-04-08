<%@ page pageEncoding="UTF-8" %>
<html>

    <head> 
        <!-- use responsive UI  -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <!-- use local css  -->
        <style type="text/css">

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

        <h3>JAX-RS @FormQuery Example</h3>

        <form action="rest/query/post" method="post">
            德国DHL:<br/>
            <TEXTAREA id="dhlcodes" NAME="dhlcodes" ROWS=10 COLS=100></TEXTAREA>
            <input x-webkit-speech id="dhlmic"/>
            <BR>
            比利时邮政:<br/>
            <TEXTAREA id="bpostcodes" NAME="bpostcodes" ROWS=10 COLS=100></TEXTAREA>
            <input x-webkit-speech id="bpostmic"/>
            <BR>
            <CENTER>
                <INPUT TYPE="SUBMIT" VALUE="查询">
            </CENTER>
        </form>

    </body>
</html>
