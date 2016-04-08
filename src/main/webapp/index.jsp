<%@ page pageEncoding="UTF-8" %>
<html>
    <body>
        <h3>JAX-RS @FormQuery Example</h3>

        <form action="rest/query/post" method="post">
            德国DHL:<br/>
            <TEXTAREA NAME="dhlcodes" ROWS=10 COLS=100></TEXTAREA><BR>
            比利时邮政:<br/>
            <TEXTAREA NAME="bpostcodes" ROWS=10 COLS=100></TEXTAREA><BR>
            <CENTER>
                <INPUT TYPE="SUBMIT" VALUE="查询">
            </CENTER>
        </form>

    </body>
</html>
