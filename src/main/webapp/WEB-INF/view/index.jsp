<%--
  Created by IntelliJ IDEA.
  User: qiaojinghui
  Date: 2019/11/17
  Time: 16:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="common/static.jsp" />
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/dat.gui.min.js"></script>

    <style>
        * {
            user-select: none;
        }

        html, body {
            overflow: hidden;
        }

        body {
            margin: 0;
            position: fixed;
            width: 100%;
            height: 100%;
        }

        canvas {
            width: 100%;
            height: 100%;
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
        }

        .dg {
            opacity: 0.9;
        }

        .dg .property-name {
            overflow: visible;
        }

        .bigFont {
            font-size: 150%;
            color: #8C8C8C;
        }

        .cr.function.appBigFont {
            font-size: 150%;
            line-height: 27px;
            background-color: #2F4F4F;
        }

        .cr.function.appBigFont .property-name {
            float: none;
        }

        .cr.function.appBigFont .icon {
            position: sticky;
            bottom: 27px;
        }
    </style>
</head>
<body style="background-color: #0c0c0c">
    <jsp:include page="common/nav.jsp"></jsp:include>
    <canvas></canvas>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/script.js"></script>

</body>
</html>
