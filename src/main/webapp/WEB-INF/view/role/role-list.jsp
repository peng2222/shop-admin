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
    <!-- 引入ztree的css文件和js文件 -->
    <link href="<%=request.getContextPath()%>/js/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" />
    <script src="<%=request.getContextPath()%>/js/zTree/js/jquery.ztree.all.min.js"></script>
    <script>

        var ztreeObj;

        var setting = {
            view: {
                //禁止多选
                selectedMulti: false
            },
            data:{
                key: {
                    url: "zhangxuhao"
                },
                //简单JSON数据
                simpleData:{
                    enable:true,
                    pIdKey:"pid"
                }
            },
            check:{
                enable:true
            }
        };
    </script>
    <script>

        //用于存放新增角色DIV的HTML代码的全局变量
        var addRoleDivHTML;

        //用于存放修改角色DIV的HTML代码的全局变量
        var updateRoleDivHTML;

        //用于存放导入excelDIV的HTML代码的全局变量
        var importExcelDivHTML;

        $(function () {

            addRoleDivHTML = $("#addRoleDiv").html();

            updateRoleDivHTML = $("#updateRoleDiv").html();

            importExcelDivHTML = $("#importExcelDiv").html();

            //初始化查询条件面板中的创建时间
            initDateTimePicker("#minCreateDate");
            initDateTimePicker("#maxCreateDate");

            //初始化查询条件面板中的修改时间
            initDateTimePicker("#minUpdateDate");
            initDateTimePicker("#maxUpdateDate");

            //初始化角色表格
            initRoleTable();
        })


        //条件查询
        function search(){
            roleTable.ajax.reload();
        }

        //导出Excel
        function exportExcel(){
            var roleQueryForm = document.getElementById("roleQueryForm");
            //设置form表单的提交地址
            roleQueryForm.action = "<%=request.getContextPath()%>/RoleController/exportExcel.do";
            //通过js代码提交form表单
            roleQueryForm.submit();
        }

        //导出Word
        function exportWord(){
            var roleQueryForm = document.getElementById("roleQueryForm");
            //设置form表单的提交地址
            roleQueryForm.action = "<%=request.getContextPath()%>/RoleController/exportWord.do";
            //通过js代码提交form表单
            roleQueryForm.submit();
        }

        //导出Pdf
        function exportPdf(){
            var roleQueryForm = document.getElementById("roleQueryForm");
            //设置form表单的提交地址
            roleQueryForm.action = "<%=request.getContextPath()%>/RoleController/exportPdf.do";
            //通过js代码提交form表单
            roleQueryForm.submit();
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
                uploadUrl:"<%=request.getContextPath()%>/RoleController/importExcel.do"
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

            importExcelDivHTML = $("#importExcelDiv").html();
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


        var roleTable;
        function initRoleTable(){
            //初始化角色表格
            roleTable = $("#roleTable").DataTable({
                searching:false,
                ordering:false,
                serverSide:true, //开启服务端模式
                lengthMenu:[3,5,10,15],
                processing:true,//是否显示正在处理中
                language:chinese,
                ajax:{
                    url:"<%=request.getContextPath()%>/RoleController/queryRoleList.do",
                    data:function(param){
                        //DataTables在发送ajax请求的时候会发送一些自己的参数，比如说每页显示条数，起始条数等等。。。
                        //通过param这个参数咱们可以设置自己需要传递的参数，比如说条件查询的值
                        param.name = $("#name").val();
                        param.status = $("[name=status]:checked").val();
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
                        data:"status",
                        render:function (data) {
                            return data == 1?"启用":"禁用";
                        }
                    },
                    {data:"remark"},
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
                        render:function(data,type,row){
                            var buttonsHTML = "";
                            buttonsHTML+=     '<div class="btn-group btn-group-xs">';
                            buttonsHTML+=     '<button type="button" onclick="showUpdateRoleDialog(' + data + ')" class="btn btn-primary">';
                            buttonsHTML+=     '<span class="glyphicon glyphicon-pencil"></span>&nbsp;修改';
                            buttonsHTML+=     '</button>';
                            buttonsHTML+=     '<button type="button" onclick="deleteRole(' + data + ')" class="btn btn-danger">';
                            buttonsHTML+=     '<span class="glyphicon glyphicon-trash"></span>&nbsp;删除';
                            buttonsHTML+=     '</button>';
                            if(row.status == 1) {
                                buttonsHTML += '<button type="button" onclick="updateRoleStatus(' + data + ',' + row.status + ')" class="btn btn-warning">';
                                buttonsHTML += '<span class="glyphicon glyphicon-ban-circle"></span>&nbsp;禁用';
                                buttonsHTML += '</button>';
                            }else{
                                buttonsHTML += '<button type="button" onclick="updateRoleStatus(' + data + ',' + row.status + ')" class="btn btn-success">';
                                buttonsHTML += '<span class="glyphicon glyphicon-ok-circle"></span>&nbsp;启用';
                                buttonsHTML += '</button>';
                            }
                            buttonsHTML+=     '</div>';
                            return buttonsHTML;
                        }}
                ]
            });
        }


        //Dialog是对话框的意思
        function showAddRoleDialog() {

            //发起一个查询所有权限的ajax请求
            //发起一个查询所有权限数据的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/PermissionController/queryPermissionList.do",
                dataType:"json",
                success:function(result){
                    if(result.code == 200){

                        //将每个权限对象的url属性的值设为null，防止点击节点时跳转页面
                        // for(var i = 0 ; i < result.data.length ; i ++){
                        //     result.data[i].url = null;
                        // }
                        //使用ztree初始化权限树
                        ztreeObj = $.fn.zTree.init($("#addZtree"),setting,result.data);
                    }else{
                        alert("查询权限失败!");
                    }
                },
                error:function(){
                    alert("查询权限失败!");
                }
            });

            //使用bootbox弹框插件弹出新增角色的对话框
            bootbox.confirm({
                title:"新增角色",
                message:$("#addRoleDiv").children(),
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
                        //获取新增角色表单中的数据
                        param.name = $("#addName").val();
                        param.status = $("[name=addStatus]:checked").val();
                        param.remark = $("#addRemark").val();

                        //获取权限树上被选中的节点数组
                        //因为使用了复选框，不能使用selectedNodes获取被选中的节点数组
                        //得使用getCheckedNodes方法获取被选中的节点数组
                        var checkedNodes = ztreeObj.getCheckedNodes();
                        if(checkedNodes.length > 0){
                            var permissionIds = "";
                            for(var i = 0 ; i < checkedNodes.length ; i ++){
                                permissionIds += checkedNodes[i].id + ",";
                            }
                            permissionIds = permissionIds.substring(0,permissionIds.length-1);
                            param.permissionIds = permissionIds;
                        }

                        //发起一个新增角色的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/RoleController/addRole.do",
                            type:"post",
                            data:param,
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("新增角色失败!");
                                }
                            },
                            error:function(){
                                alert("新增角色失败!");
                            }
                        });
                    }
                    $("#addRoleDiv").html(addRoleDivHTML);
                }
            });
        }


        //修改角色信息
        function showUpdateRoleDialog(id){
            alert(id);
            //发起一个通过id查询单个角色信息的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/RoleController/getRoleById.do",
                data:{id:id},
                dataType:"json",
                success:function(result){
                    if(result.code == 200){


                        var role = result.data;

                        //回显修改角色表单中的数据了
                        $("#updateName").val(role.name);
                        $("#updateRemark").val(role.remark);
                        $("[name=updateStatus][value=" + role.status + "]").prop("checked",true);


                        //发起一个查询所有权限的ajax请求
                        //发起一个查询所有权限数据的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/PermissionController/queryPermissionList.do",
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){

                                    //将权限树上之前角色勾选的权限默认选中
                                    if(role.permissionIds != null && role.permissionIds != ""){
                                        //2,3,5
                                        var permissionIdArr = role.permissionIds.split(",");
                                        //所有权限对象的数组
                                        // [
                                        //     {id:1,name:"所有权限",pid:null,checked:true},
                                        //     {id:2,name:"用户管理",pid:1},
                                        //     {id:3,name:"新增用户",pid:2},
                                        //     {id:4,name:"角色管理",pid:1},
                                        //     {id:5,name:"权限管理",pid:1},
                                        // ]
                                        debugger;
                                        for(var i = 0 ; i < result.data.length ; i ++){
                                            //如果角色已关联权限id数组中包含当前遍历的权限的id,就让当前遍历的权限默认被选中
                                            if(permissionIdArr.indexOf(result.data[i].id+"") != -1){
                                                result.data[i].checked = true;
                                            }
                                        }
                                    }

                                    //使用ztree初始化权限树
                                    ztreeObj = $.fn.zTree.init($("#updateZtree"),setting,result.data);
                                }else{
                                    alert("查询权限失败!");
                                }
                            },
                            error:function(){
                                alert("查询权限失败!");
                            }
                        });


                        //弹出修改角色对话框
                        bootbox.confirm({
                            title:"修改角色",
                            message:$("#updateRoleDiv").children(),
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
                                    //获取修改角色表单中的数据
                                    param.id = role.id;
                                    param.name = $("#updateName").val();
                                    param.remark = $("#updateRemark").val();
                                    param.status = $("[name=updateStatus]:checked").val();

                                    //获取权限树上被选中的节点数组
                                    //因为使用了复选框，不能使用selectedNodes获取被选中的节点数组
                                    //得使用getCheckedNodes方法获取被选中的节点数组
                                    var checkedNodes = ztreeObj.getCheckedNodes();
                                    if(checkedNodes.length > 0){
                                        var permissionIds = "";
                                        for(var i = 0 ; i < checkedNodes.length ; i ++){
                                            permissionIds += checkedNodes[i].id + ",";
                                        }
                                        permissionIds = permissionIds.substring(0,permissionIds.length-1);
                                        param.permissionIds = permissionIds;
                                    }

                                    //发起一个修改药品的ajax请求
                                    $.ajax({
                                        url:"<%=request.getContextPath()%>/RoleController/updateRole.do",
                                        type:"post",
                                        data:param,
                                        dataType:"json",
                                        success:function(result){
                                            if(result.code == 200){
                                                //重新加载表格中的数据
                                                search();
                                            }else{
                                                alert("修改角色失败!");
                                            }
                                        },
                                        error:function(){
                                            alert("修改角色失败!");
                                        }
                                    });


                                }
                                $("#updateRoleDiv").html(updateRoleDivHTML);
                            }
                        });

                    }else{
                        alert("查询角色失败!");
                    }
                },
                error:function(){

                }
            });
        }


        //删除
        function deleteRole(id){
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
                    //如果角色点击了确认按钮
                    if(result){
                        //发起一个删除角色的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/RoleController/deleteRole.do",
                            type:"post",
                            data:{id:id},
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("删除角色失败!");
                                }
                            },
                            error:function(){
                                alert("删除角色失败!");
                            }
                        });
                    }
                }
            });
        }


        //批量删除
        function batchDeleteRole(){
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

                            //发起一个批量删除角色的ajax请求
                            $.ajax({
                                url:"<%=request.getContextPath()%>/RoleController/batchDeleteRole.do",
                                type:"post",
                                data:{ids:idArr},
                                dataType:"json",
                                success:function(result){
                                    if(result.code == 200){
                                        //重新加载表格中的数据
                                        search();
                                    }else{
                                        alert("批量删除角色失败!");
                                    }
                                },
                                error:function(){
                                    alert("批量删除角色失败!");
                                }
                            });
                        }
                    }
                });

            }else{
                alert("请先选择要删除的角色!");
            }
        }

        function updateRoleStatus(id,status){
            //发起一个修改角色状态的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/RoleController/updateRoleStatus.do",
                type:"post",
                data:{id:id},
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        //重新加载表格中的数据
                        search();
                    }else{
                        alert((status==1?"禁用":"启用") + "角色失败!");
                    }
                },
                error:function(){
                    alert((status==1?"禁用":"启用") + "角色失败!");
                }
            });
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

    <!--修改角色的DIV-->
    <div id="updateRoleDiv" style="display: none">
        <!--修改用户的form表单-->
        <form id="updateRoleForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">角色名称</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateName" placeholder="请输⼊角色名称">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">状态</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateStatus" value="1"> 启用
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateStatus" value="2"> 禁用
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">描述:</label>
                <div class="col-sm-10">
                    <textarea class="form-control" id="updateRemark" rows="3"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">权限</label>
                <div class="col-sm-10">
                    <ul id="updateZtree" class="ztree"></ul>
                </div>
            </div>
        </form>
    </div>
    
    <!--新增角色的DIV-->
    <div id="addRoleDiv" style="display: none">
        <!--新增用户的form表单-->
        <form id="addRoleForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">角色名称</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addName" placeholder="请输⼊角色名称">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">状态</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addStatus" value="1"> 启用
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addStatus" value="2"> 禁用
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">描述:</label>
                <div class="col-sm-10">
                    <textarea class="form-control" id="addRemark" rows="3"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">权限</label>
                <div class="col-sm-10">
                    <ul id="addZtree" class="ztree"></ul>
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
            <form class="form-horizontal" role="form" id="roleQueryForm">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">角色名称:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="name" id="name" placeholder="请输⼊角色名称">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">状态:</label>
                                <div class="col-sm-10">
                                    <label class="radio-inline">
                                        <input type="radio" name="status" value="1"> 启用
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="status" value="2"> 禁用
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
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

    <!--角色列表面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                角色列表
            </h3>
        </div>
        <div class="panel-body">
            <div style="margin-bottom:10px">
                <button onclick="showAddRoleDialog()" type="button" class="btn btn-primary">
                    <span class="glyphicon glyphicon-plus"></span>&nbsp;新增
                </button>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button onclick="batchDeleteRole()" type="reset" class="btn btn-danger">
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
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button onclick="exportWord()" type="reset" class="btn btn-success">
                    <span class="glyphicon glyphicon-download-alt"></span>&nbsp;导出Word
                </button>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button onclick="exportPdf()" type="reset" class="btn btn-success">
                    <span class="glyphicon glyphicon-download-alt"></span>&nbsp;导出PDF
                </button>
            </div>

            <table id="roleTable" class="table table-striped table-bordered table-hover table-condensed">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox"/>
                    </th>
                    <th>角色名</th>
                    <th>状态</th>
                    <th>描述</th>
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
