<%--
  Created by IntelliJ IDEA.
  User: qiaojinghui
  Date: 2019/11/12
  Time: 9:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="../common/static.jsp" />

    <script>


        //用于存放导入excelDIV的HTML代码的全局变量
        var importExcelDivHTML;

        $(function () {

            importExcelDivHTML = $("#importExcelDiv").html();

            //初始化查询条件面板中的创建时间
            initDateTimePicker("#minDate");
            initDateTimePicker("#maxDate");


            //初始化日志表格
            initLogTable();
        })


        //条件查询
        function search(){
            logTable.ajax.reload();
        }


        //初始化日期格式调用的函数
        function initDateTimePicker(selector,abc){
            abc = abc == undefined ? "YYYY-MM-DD HH:mm:ss" : abc;
            $(selector).datetimepicker({
                format:abc,
                locale:"zh-CN",
                showClear:true
            });
        }


        var logTable;
        function initLogTable(){
            //初始化日志表格
            logTable = $("#logTable").DataTable({
                searching:false,
                ordering:false,
                serverSide:true, //开启服务端模式
                lengthMenu:[3,5,10,15],
                processing:true,//是否显示正在处理中
                language:chinese,
                ajax:{
                    url:"<%=request.getContextPath()%>/LogController/queryLogList.do",
                    data:function(param){
                        //DataTables在发送ajax请求的时候会发送一些自己的参数，比如说每页显示条数，起始条数等等。。。
                        //通过param这个参数咱们可以设置自己需要传递的参数，比如说条件查询的值
                        param.username = $("#username").val();
                        param.minDate = $("#minDate").val();
                        param.maxDate = $("#maxDate").val();

                    }
                },
                columns:[
                    {
                        data:"id",
                    },
                    {data:"username"},
                    {
                        data:"createTime",
                        render:function(data){
                            return datetimeFormat_2(data);
                        }
                    },
                    {
                        data:"status",
                        render:function (data) {
                            return data == 1?"成功":"失败";
                        }
                    },
                    {data:"content"},
                    {data:"parameter"},
                    {data:"action"}

                ]
            });
        }

    </script>
</head>
<body>

    <!-- 引入导航栏 -->
    <jsp:include page="../common/nav.jsp" />


    <!-- 查询条件面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                条件查询
            </h3>
        </div>
        <div class="panel-body">
            <form class="form-horizontal" log="form" id="logQueryForm">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">用户名:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  id="username" placeholder="请输⼊日志名称">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">记录日期:</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <input type="text"  id="minDate" class="form-control">
                                        <span class="input-group-addon">--</span>
                                        <input type="text"  id="maxDate" class="form-control">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12" style="text-align:center">
                            <button type="button" class="btn btn-primary" onclick="search()">
                                <span class="glyphicon glyphicon-search"></span>&nbsp;查询
                            </button>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <button type="reset" class="btn btn-danger">
                                <span class="glyphicon glyphicon-refresh"></span>&nbsp;重置
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!--日志列表面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                日志列表
            </h3>
        </div>
        <div class="panel-body">

            <table id="logTable" class="table table-striped table-bordered table-hover table-condensed">
                <thead>
                <tr>
                    <th>Id</th>
                    <th>操作人</th>
                    <th>操作时间</th>
                    <th>状态</th>
                    <th>内容</th>
                    <th>参数</th>
                    <th>方法</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>

</body>
</html>
