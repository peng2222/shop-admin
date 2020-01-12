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

        //用于存放新增品牌DIV的HTML代码的全局变量
        var addBrandDivHTML;

        //用于存放修改品牌DIV的HTML代码的全局变量
        var updateBrandDivHTML;

        //用于存放导入excelDIV的HTML代码的全局变量
        var importExcelDivHTML;

        $(function () {

            addBrandDivHTML = $("#addBrandDiv").html();

            updateBrandDivHTML = $("#updateBrandDiv").html();

            importExcelDivHTML = $("#importExcelDiv").html();

            //初始化查询条件面板中的创建时间
            initDateTimePicker("#minCreateDate");
            initDateTimePicker("#maxCreateDate");

            //初始化查询条件面板中的修改时间
            initDateTimePicker("#minUpdateDate");
            initDateTimePicker("#maxUpdateDate");

            //初始化品牌表格
            initBrandTable();
        })


        //条件查询
        function search(){
            brandTable.ajax.reload();
        }


        //导出Excel
        function exportExcel(){
            var brandQueryForm = document.getElementById("brandQueryForm");
            //设置form表单的提交地址
            brandQueryForm.action = "<%=request.getContextPath()%>/BrandController/exportExcel.do";
            //通过js代码提交form表单
            brandQueryForm.submit();
        }

        var importExcelDialog;

        //导入Excel
        function importExcel(){

            //使用FileInput初始化导入Excel表单中文件域
            //初始化新增用户表单中的用户图片文件域
            $("#file").fileinput({
                language:"zh",//设置语言选项
                maxFileCount:1,//设置最大上传文件个数
                allowedFileExtensions:["xlsx"],
                //设置文件上传的地址
                uploadUrl:"<%=request.getContextPath()%>/BrandController/importExcel.do"
            });
            //设置文件上传之后的回调函数
            $("#file").on("fileuploaded",function(a,b,c,d){
                //其中b就代表服务器返回的数据
                var result = b.response;
                if(result.code == 200){
                    alert("上传成功");
                    importExcelDialog.modal("hide");
                    $("#importExcelDiv").html(importExcelDivHTML);
                    search();
                }else{
                    alert("文件上传过程中发生异常，请检查文件内容或联系管理员！");
                }
            });


            //弹出导入Excel对话框
            importExcelDialog = bootbox.dialog({
                title:"导入Excel",
                message:$("#importExcelDiv").children()
            });

            $("#importExcelDiv").html(importExcelDivHTML);
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


        var brandTable;
        function initBrandTable(){
            //初始化品牌表格
            brandTable = $("#brandTable").DataTable({
                searching:false,
                ordering:false,
                serverSide:true, //开启服务端模式
                lengthMenu:[3,5,10,15],
                processing:true,//是否显示正在处理中
                language:chinese,
                ajax:{
                    url:"<%=request.getContextPath()%>/BrandController/queryBrandList.do",
                    data:function(param){
                        //DataTables在发送ajax请求的时候会发送一些自己的参数，比如说每页显示条数，起始条数等等。。。
                        //通过param这个参数咱们可以设置自己需要传递的参数，比如说条件查询的值
                        param.name = $("#name").val();
                        param.minCreateDate = $("#minCreateDate").val();
                        param.maxCreateDate = $("#maxCreateDate").val();
                        param.minUpdateDate = $("#minUpdateDate").val();
                        param.maxUpdateDate = $("#maxUpdateDate").val();

                    }
                },
                columns:[
                    {
                        data:"id",
                        render:function(data){
                            return "<input type='checkbox' name='id' value='"+data+"'/>";
                        }
                    },
                    {data:"name"},
                    {
                        data:"filePath",
                        render:function (data) {
                            return "<img width='50' height='50' src='<%=request.getContextPath()%>"+data+"' />";
                        }
                    },
                    {
                        data:"isHot",
                        render:function (data) {
                            return data == 1?"热销":"不热";
                        }
                    },
                    {
                        data:"createDate",
                        render:function(data){
                            return datetimeFormat_2(data);
                        }
                    },
                    {
                        data:"updateDate",
                        render:function(data){
                            return datetimeFormat_2(data);
                        }
                    },
                    {
                        data:"id",
                        render:function(data){
                            var buttonsHTML = "";
                            buttonsHTML+=     '<div class="btn-group btn-group-xs">';
                            buttonsHTML+=     '<button type="button" onclick="showUpdateBrandDialog(' + data + ')" class="btn btn-primary">';
                            buttonsHTML+=     '<span class="glyphicon glyphicon-pencil"></span>&nbsp;修改';
                            buttonsHTML+=     '</button>';
                            buttonsHTML+=     '<button type="button" onclick="deleteBrand(' + data + ')" class="btn btn-danger">';
                            buttonsHTML+=     '<span class="glyphicon glyphicon-trash"></span>&nbsp;删除';
                            buttonsHTML+=     '</button>';
                            buttonsHTML+=     '</div>';
                            return buttonsHTML;
                        }}
                ]
            });
        }


        //Dialog是对话框的意思
        function showAddBrandDialog() {

            //初始化新增用户表单中的用户头像文件域
            $("#addFile").fileinput({
                language:"zh",//设置语言选项
                maxFileCount:1,//设置最大文件上传数
                //设置文件上传的地址
                uploadUrl:"<%=request.getContextPath()%>/UserController/uploadFile.do"
            });
            //设置文件上传之后的回调函数
            $("#addFile").on("fileuploaded",function(a,b,c,d){
                //其中b就代表服务器返回的数据
                var result = b.response;
                if(result.code == 200){
                    //将图片上传后的相对路径放入新增用户表单中的用于存放图片相对路径的隐藏域中
                    $("#addFilePath").val(result.filePath);
                }
            });


            //使用bootbox弹框插件弹出新增品牌的对话框
            bootbox.confirm({
                title:"新增品牌",
                message:$("#addBrandDiv").children(),
                button:{
                    confirm:{
                        label:"确认"
                    },
                    cancel:{
                        label:"取消",
                        className:"btn btn-danger"
                    }
                },
                callback:function (result) {
                    //如果点击了确认按钮
                    if (result){
                        var param = {};
                        //获取新增品牌表单中的数据
                        param.name = $("#addName").val();
                        param.filePath = $("#addFilePath").val();
                        param.isHot = $("[name=addIsHot]:checked").val();

                        //发起一个新增品牌的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/BrandController/addBrand.do",
                            type:"post",
                            data:param,
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("新增品牌失败!");
                                }
                            },
                            error:function(){
                                alert("新增品牌失败!");
                            }
                        });
                    }
                    $("#addBrandDiv").html(addBrandDivHTML);
                }
            });
        }


        //修改品牌信息
        function showUpdateBrandDialog(id){
            alert(id);
            //发起一个通过id查询单个品牌信息的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/BrandController/getBrandById.do",
                data:{id:id},
                dataType:"json",
                success:function(result){
                    if(result.code == 200){

                        
                        //初始化新增用户表单中的用户头像文件域
                        $("#updateFile").fileinput({
                            language:"zh",//设置语言选项
                            maxFileCount:1,//设置最大文件上传数
                            //设置文件上传的地址
                            uploadUrl:"<%=request.getContextPath()%>/UserController/uploadFile.do"
                        });
                        //设置文件上传之后的回调函数
                        $("#updateFile").on("fileuploaded",function(a,b,c,d){
                            //其中b就代表服务器返回的数据
                            var result = b.response;
                            if(result.code == 200){
                                //将图片上传后的相对路径放入新增用户表单中的用于存放图片相对路径的隐藏域中
                                $("#updateFilePath").val(result.filePath);
                            }
                        });

                        var brand = result.data;

                        //回显修改品牌表单中的数据了
                        $("#updateName").val(brand.name);
                        $("#updateFilePath").val(brand.filePath);
                        $("#updateFileImg").attr("src","<%=request.getContextPath()%>" + brand.filePath);
                        $("[name=updateIsHot][value=" + brand.isHot + "]").prop("checked",true);


                        //弹出修改品牌对话框
                        bootbox.confirm({
                            title:"修改品牌",
                            message:$("#updateBrandDiv").children(),
                            buttons:{
                                //設置確定按鈕的文字和樣式
                                confirm:{
                                    label:"確認",
                                    className:"btn btn-success"
                                },
                                //設置取消按鈕的文字和樣式
                                cancel:{
                                    label:"取消",
                                    className:"btn btn-danger"
                                }
                            },
                            callback:function(result){
                                if(result){


                                    var param = {};
                                    //获取修改品牌表单中的数据
                                    param.id = brand.id;
                                    param.name = $("#updateName").val();
                                    param.filePath = $("#updateFilePath").val();
                                    param.isHot = $("[name=updateIsHot]:checked").val();

                                    //发起一个修改药品的ajax请求
                                    $.ajax({
                                        url:"<%=request.getContextPath()%>/BrandController/updateBrand.do",
                                        type:"post",
                                        data:param,
                                        dataType:"json",
                                        success:function(result){
                                            if(result.code == 200){
                                                //重新加载表格中的数据
                                                search();
                                            }else{
                                                alert("修改品牌失败!");
                                            }
                                        },
                                        error:function(){
                                            alert("修改品牌失败!");
                                        }
                                    });


                                }
                                $("#updateBrandDiv").html(updateBrandDivHTML);
                            }
                        });

                    }else{
                        alert("查询品牌失败!");
                    }
                },
                error:function(){

                }
            });
        }


        //删除
        function deleteBrand(id){
            alert(id);
            //弹出一个确认框
            bootbox.confirm({
                title:"删除提示",
                message:"您确定要删除吗?",
                buttons:{
                    //設置確定按鈕的文字和樣式
                    confirm:{
                        label:"確認",
                        className:"btn btn-success"
                    },
                    //設置取消按鈕的文字和樣式
                    cancel:{
                        label:"取消",
                        className:"btn btn-danger"
                    }
                },
                callback:function(result){
                    //如果品牌点击了确认按钮
                    if(result){
                        //发起一个删除品牌的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/BrandController/deleteBrand.do",
                            type:"post",
                            data:{id:id},
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("删除品牌失败!");
                                }
                            },
                            error:function(){
                                alert("删除品牌失败!");
                            }
                        });
                    }
                }
            });
        }


        //批量删除
        function batchDeleteBrand(){
            var idCheckboxes = $("[name=id]:checked");
            if(idCheckboxes.length > 0){
                //弹出一个确认框
                bootbox.confirm({
                    title:"删除提示",
                    message:"您确定要删除吗?",
                    buttons:{
                        //設置確定按鈕的文字和樣式
                        confirm:{
                            label:"確認",
                            className:"btn btn-success"
                        },
                        //設置取消按鈕的文字和樣式
                        cancel:{
                            label:"取消",
                            className:"btn btn-danger"
                        }
                    },
                    callback:function(result){
                        if(result){
                            var idArr = [];
                            idCheckboxes.each(function(){
                                idArr.push(this.value);
                            });

                            //发起一个批量删除品牌的ajax请求
                            $.ajax({
                                url:"<%=request.getContextPath()%>/BrandController/batchDeleteBrand.do",
                                type:"post",
                                data:{ids:idArr},
                                dataType:"json",
                                success:function(result){
                                    if(result.code == 200){
                                        //重新加载表格中的数据
                                        search();
                                    }else{
                                        alert("批量删除品牌失败!");
                                    }
                                },
                                error:function(){
                                    alert("批量删除品牌失败!");
                                }
                            });
                        }
                    }
                });

            }else{
                alert("请先选择要删除的品牌!");
            }
        }



    </script>
</head>
<body>

    <!-- 引入导航栏 -->
    <jsp:include page="../common/nav.jsp" />


    <div id="importExcelDiv" style="display: none">
        <form id="importExcelForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">选择Excel文件</label>
                <div class="col-sm-10">
                    <input type="file" name="file" accept=".xlsx" id="file" />
                </div>
            </div>
        </form>
    </div>

    <!--修改品牌的DIV-->
    <div id="updateBrandDiv" style="display: none">
        <!--修改用户的form表单-->
        <form id="updateBrandForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">品牌名称</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateName" placeholder="请输⼊品牌名称">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">品牌Logo</label>
                <div class="col-sm-10">
                    <!-- 用于存放上传的图片相对路径的隐藏域 -->
                    <input type="text" id="updateFilePath" />
                    <img src="" id="updateFileImg" width="50" height="50">
                    <input type="file" class="form-control" name="file" id="updateFile">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">是否热销</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateIsHot" value="1"> 热销
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateIsHot" value="2"> 不热
                    </label>
                </div>
            </div>
        </form>
    </div>
    
    <!--新增品牌的DIV-->
    <div id="addBrandDiv" style="display: none">
        <!--新增用户的form表单-->
        <form id="addBrandForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">品牌名称</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addName" placeholder="请输⼊品牌名称">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">品牌Logo</label>
                <div class="col-sm-10">
                    <!-- 用于存放上传的图片相对路径的隐藏域 -->
                    <input type="text" id="addFilePath" />
                    <input type="file" class="form-control" name="file" id="addFile">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">是否热销</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addIsHot" value="1"> 热销
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addIsHot" value="2"> 不热
                    </label>
                </div>
            </div>
        </form>
    </div>

    <!-- 查询条件面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                条件查询
            </h3>
        </div>
        <div class="panel-body">
            <form class="form-horizontal" brand="form" id="brandQueryForm">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">品牌名称:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="name" id="name" placeholder="请输⼊品牌名称">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">创建日期:</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <input type="text" name="minCreateDate" id="minCreateDate" class="form-control">
                                        <span class="input-group-addon">--</span>
                                        <input type="text" name="maxCreateDate" id="maxCreateDate" class="form-control">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">修改日期:</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <input type="text" name="minUpdateDate" id="minUpdateDate" class="form-control">
                                        <span class="input-group-addon">--</span>
                                        <input type="text" name="maxUpdateDate" id="maxUpdateDate" class="form-control">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6"></div>
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

    <!--品牌列表面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                品牌列表
            </h3>
        </div>
        <div class="panel-body">
            <div style="margin-bottom:10px">
                <button onclick="showAddBrandDialog()" type="button" class="btn btn-primary">
                    <span class="glyphicon glyphicon-plus"></span>&nbsp;新增
                </button>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button onclick="batchDeleteBrand()" type="reset" class="btn btn-danger">
                    <span class="glyphicon glyphicon-minus"></span>&nbsp;批量删除
                </button>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button onclick="exportExcel()" type="reset" class="btn btn-success">
                    <span class="glyphicon glyphicon-download-alt"></span>&nbsp;导出Excel
                </button>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button onclick="importExcel()" type="reset" class="btn btn-success">
                    <span class="glyphicon glyphicon-upload"></span>&nbsp;导入Excel
                </button>
            </div>

            <table id="brandTable" class="table table-striped table-bordered table-hover table-condensed">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox"/>
                    </th>
                    <th>品牌名</th>
                    <th>品牌Logo</th>
                    <th>是否热销</th>
                    <th>创建日期</th>
                    <th>修改日期</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>

</body>
</html>
