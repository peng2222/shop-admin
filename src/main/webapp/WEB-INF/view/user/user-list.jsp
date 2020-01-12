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

        //用于存放新增用户DIV的HTML代码的全局变量
        var addUserDivHTML;

        //用于存放修改用户DIV的HTML代码的全局变量
        var updateUserDivHTML;

        //用于存放导入excelDIV的HTML代码的全局变量
        var importExcelDivHTML;

        $(function () {

            addUserDivHTML = $("#addUserDiv").html();

            updateUserDivHTML = $("#updateUserDiv").html();

            importExcelDivHTML = $("#importExcelDiv").html();

            //初始化查询条件面板中的出生日期
            initDateTimePicker("#minBirthday","YYYY-MM-DD");
            initDateTimePicker("#maxBirthday","YYYY-MM-DD");

            //初始化查询条件面板中的创建时间
            initDateTimePicker("#minCreateDate");
            initDateTimePicker("#maxCreateDate");

            //初始化查询条件面板中的修改时间
            initDateTimePicker("#minUpdateDate");
            initDateTimePicker("#maxUpdateDate");

            //初始化用户表格
            initUserTable();
        })


        //条件查询
        function search(){
            userTable.ajax.reload();
        }


        //导出Excel
        function exportExcel() {
            var userQueryForm = document.getElementById("userQueryForm")
            //设置form表单的提交地址
            userQueryForm.action="<%=request.getContextPath()%>/UserController/exportExcel.do";
            //通过js代码提交form表单
            userQueryForm.submit();
        }


        var importExcelDialog;

        //导入Excel
        function importExcel() {

            //使用FileInput初始化导入Excel表单中文件域
            //初始化新增用户表单中的用户图片文件域
            $("#file").fileinput({
                language:"zh",//设置语言选项
                maxFileCount:1,//设置最大上传文件个数
                allowedFileExtensions:["xlsx"],
                //设置文件上传的地址
                uploadUrl:"<%=request.getContextPath()%>/UserController/importExcel.do"
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


        var userTable;
        function initUserTable(){
            //初始化用户表格
            userTable = $("#userTable").DataTable({
                searching:false,
                ordering:false,
                serverSide:true, //开启服务端模式
                lengthMenu:[3,5,10,15],
                processing:true,//是否显示正在处理中
                language:chinese,
                ajax:{
                    url:"<%=request.getContextPath()%>/UserController/queryUserList.do",
                    data:function(param){
                        //DataTables在发送ajax请求的时候会发送一些自己的参数，比如说每页显示条数，起始条数等等。。。
                        //通过param这个参数咱们可以设置自己需要传递的参数，比如说条件查询的值
                        param.userName = $("#userName").val();
                        param.realName = $("#realName").val();
                        param.phoneNumber = $("#phoneNumber").val();
                        param.email = $("#email").val();
                        param.sex = $("[name=sex]:checked").val();
                        param.minBirthday = $("#minBirthday").val();
                        param.maxBirthday = $("#maxBirthday").val();
                        param.minCreateDate = $("#minCreateDate").val();
                        param.maxCreateDate = $("#maxCreateDate").val();
                        param.minUpdateDate = $("#minUpdateDate").val();
                        param.maxUpdateDate = $("#maxUpdateDate").val();
                        param.isOTC = $("[name=isOTC]:checked").val();

                    }
                },
                columns:[
                    {
                        data:"id",
                        render:function(data){
                            return "<input type='checkbox' name='id' value='"+data+"'/>";
                        }
                    },
                    {data:"userName"},
                    {data:"realName"},
                    {
                        data:"sex",
                        render:function (data) {
                            return data == 1?"男":"女";
                        }
                    },
                    {data:"email"},
                    {data:"phoneNumber"},
                    {
                        data:"filePath",
                        render:function (data) {
                            return "<img width='50' height='50' src='<%=request.getContextPath()%>"+data+"' />";
                        }
                    },
                    {
                        data:"birthday",
                        render:function(data){
                            return datetimeFormat_3(data);
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
                            return '<div class="btn-group btn-group-xs">'+
                                '<button type="button" onclick="showUpdateUserDialog(' + data + ')" class="btn btn-primary">'+
                                '<span class="glyphicon glyphicon-pencil"></span>&nbsp;修改'+
                                '</button>'+
                                '<button type="button" onclick="deleteUser(' + data + ')" class="btn btn-danger">'+
                                '<span class="glyphicon glyphicon-trash"></span>&nbsp;删除'+
                                '</button>'+
                                '<button type="button" onclick="select(' + data + ')" class="btn btn-info">'+
                                '<span class="glyphicon glyphicon-file"></span>&nbsp;查看附件'+
                                '</button>'+
                                '<button type="button" onclick="resultPassWord(' + data + ')" class="btn btn-danger">'+
                                '<span class="glyphicon glyphicon-refresh"></span>&nbsp;重置密码'+
                                '</button>'+
                                '</div>';
                        }}
                ]
            });
        }


        //Dialog是对话框的意思
        function showAddUserDialog() {

            //发起一个查询所有启用角色的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/RoleController/queryEnableRoleList.do",
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        //将角色数组变成一个个的复选框
                        var roleDivHTML = "";
                        for(var i = 0 ; i < result.data.length ; i ++){
                            roleDivHTML += '<label class="checkbox-inline">';
                            roleDivHTML += '<input type="checkbox" name="addRole" value="' + result.data[i].id + '">' + result.data[i].name;
                            roleDivHTML += '</label>';
                        }
                        $("#addRoleDiv").html(roleDivHTML);
                    }else{
                        alert("查询角色失败!");
                    }
                },
                error:function(){
                    alert("查询角色失败!");
                }
            });

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
            //初始化新增用户表单中的生日
            initDateTimePicker("#addBirthday","YYYY-MM-DD");

            //使用bootbox弹框插件弹出新增用户的对话框
            bootbox.confirm({
                title:"新增用户",
                message:$("#addUserDiv").children(),
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
                        //获取新增用户表单中的数据
                        param.realName = $("#addRealName").val();
                        param.userName = $("#addUserName").val();
                        param.passWord = $("#addPassWord").val();
                        param.email = $("#addEmail").val();
                        param.sex = $("[name=addSex]:checked").val();
                        param.phoneNumber = $("#addPhoneNumber").val();
                        param.filePath = $("#addFilePath").val();
                        param.birthday = $("#addBirthday").val();

                        //获取新增用户表单中被选中的角色复选框
                        var roleCheckboxes = $("[name=addRole]:checked");
                        if(roleCheckboxes.length > 0){
                            var roleIds = "";
                            roleCheckboxes.each(function(i,e){
                                roleIds += this.value + ",";
                            });
                            roleIds = roleIds.substring(0,roleIds.length-1);
                            param.roleIds = roleIds;
                        }

                        //发起一个新增用户的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/UserController/addUser.do",
                            type:"post",
                            data:param,
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("新增用户失败!");
                                }
                            },
                            error:function(){
                                alert("新增用户失败!");
                            }
                        });
                    }
                    $("#addUserDiv").html(addUserDivHTML);
                }
            });
        }


        //修改用户信息
        function showUpdateUserDialog(id){
            alert(id);
            //发起一个通过id查询单个用户信息的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/UserController/getUserById.do",
                data:{id:id},
                dataType:"json",
                success:function(result){
                    if(result.code == 200){


                        //初始化修改用户表单中的用户图片文件域
                        $("#updateFile").fileinput({
                            language:"zh",//设置语言选项
                            maxFileCount:1,//设置最大上传文件个数
                            //设置文件上传的地址
                            uploadUrl:"<%=request.getContextPath()%>/UserController/uploadFile.do"
                        });
                        //设置文件上传之后的回调函数
                        $("#updateFile").on("fileuploaded",function(a,b,c,d){
                            //其中b就代表服务器返回的数据
                            var result = b.response;
                            if(result.code == 200){
                                //将图片上传后的相对路径放入修改用户表单中的用于存放图片相对路径的隐藏域中
                                $("#updateFilePath").val(result.filePath);
                            }
                        });

                        //初始化修改用户表单中的生日
                        initDateTimePicker("#updateBirthday","YYYY-MM-DD");

                        var user = result.data;

                        //回显修改用户表单中的数据了
                        $("#updateRealName").val(user.realName);
                        $("#updateUserName").val(user.userName);
                        $("#updatePassWord").val(user.passWord);
                        $("#updateEmail").val(user.email);
                        $("#updatePhoneNumber").val(user.phoneNumber);
                        $("[name=updateSex][value=" + user.sex + "]").prop("checked",true);
                        $("#updateFilePath").val(user.filePath);
                        $("#updateFileImg").attr("src","<%=request.getContextPath()%>" + user.filePath);
                        $("#updateBirthday").val(datetimeFormat_3(user.birthday));

                        
                        //发起一个查询所有启用角色的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/RoleController/queryEnableRoleList.do",
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //将角色数组变成一个个的复选框
                                    var roleDivHTML = "";
                                    debugger;
                                    for(var i = 0 ; i < result.data.length ; i ++){
                                        roleDivHTML += '<label class="checkbox-inline">';
                                        roleDivHTML += '<input type="checkbox" name="updateRole" value="' + result.data[i].id + '">' + result.data[i].name;
                                        roleDivHTML += '</label>';
                                    }
                                    $("#updateRoleDiv").html(roleDivHTML);

                                    //回显修改用户表单中的角色复选框
                                    // if(user.userRoleList != null && user.userRoleList.length > 0){
                                    //     for(var i = 0 ; i < user.userRoleList.length ; i ++){
                                    //         $("[name=updateRole][value=" + user.userRoleList[i].roleId + "]").prop("checked",true);
                                    //     }
                                    // }
                                    if(user.roleIds != null && user.roleIds != ""){
                                        //将用户已关联的角色id串以逗号进行分割
                                        var roleIdArr = user.roleIds.split(",");
                                        for(var i = 0 ; i < roleIdArr.length ; i ++){
                                            $("[name=updateRole][value=" + roleIdArr[i] + "]").prop("checked",true);
                                        }
                                    }
                                }else{
                                    alert("查询角色失败!");
                                }
                            },
                            error:function(){
                                alert("查询角色失败!");
                            }
                        });
                        //弹出修改用户对话框
                        bootbox.confirm({
                            title:"修改用户",
                            message:$("#updateUserDiv").children(),
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
                                    //获取修改用户表单中的数据
                                    param.id = user.id;
                                    param.realName = $("#updateRealName").val();
                                    param.userName = $("#updateUserName").val();
                                    param.passWord = $("#updatePassWord").val();
                                    param.email = $("#updateEmail").val();
                                    param.sex = $("[name=updateSex]:checked").val();
                                    param.phoneNumber = $("#updatePhoneNumber").val();
                                    param.filePath = $("#updateFilePath").val();
                                    param.birthday = $("#updateBirthday").val();

                                    //获取修改用户表单中被选中的角色复选框
                                    var roleCheckboxes = $("[name=updateRole]:checked");
                                    if(roleCheckboxes.length > 0){
                                        var roleIds = "";
                                        roleCheckboxes.each(function(i,e){
                                            roleIds += this.value + ",";
                                        });
                                        roleIds = roleIds.substring(0,roleIds.length-1);
                                        param.roleIds = roleIds;
                                    }
                                    //发起一个修改用户的ajax请求
                                    $.ajax({
                                        url:"<%=request.getContextPath()%>/UserController/updateUser.do",
                                        type:"post",
                                        data:param,
                                        dataType:"json",
                                        success:function(result){
                                            if(result.code == 200){
                                                //重新加载表格中的数据
                                                search();
                                            }else{
                                                alert("修改用户失败!");
                                            }
                                        },
                                        error:function(){
                                            alert("修改用户失败!");
                                        }
                                    });


                                }
                                $("#updateUserDiv").html(updateUserDivHTML);
                            }
                        });

                    }else{
                        alert("查询用户失败!");
                    }
                },
                error:function(){

                }
            });
        }


        //删除
        function deleteUser(id){
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
                    //如果用户点击了确认按钮
                    if(result){
                        //发起一个删除用户的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/UserController/deleteUser.do",
                            type:"post",
                            data:{id:id},
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("删除用户失败!");
                                }
                            },
                            error:function(){
                                alert("删除用户失败!");
                            }
                        });
                    }
                }
            });
        }


        //批量删除
        function batchDeleteUser(){
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

                            //发起一个批量删除用户的ajax请求
                            $.ajax({
                                url:"<%=request.getContextPath()%>/UserController/batchDeleteUser.do",
                                type:"post",
                                data:{ids:idArr},
                                dataType:"json",
                                success:function(result){
                                    if(result.code == 200){
                                        //重新加载表格中的数据
                                        search();
                                    }else{
                                        alert("批量删除用户失败!");
                                    }
                                },
                                error:function(){
                                    alert("批量删除用户失败!");
                                }
                            });
                        }
                    }
                });

            }else{
                alert("请先选择要删除的用户!");
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


    <!--修改用户的DIV-->
    <div id="updateUserDiv" style="display: none">
        <!--修改用户的form表单-->
        <form id="updateUserForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">真实姓名</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateRealName" placeholder="请输⼊真实姓名">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">用户名</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateUserName" placeholder="请输⼊用户名">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">密码</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updatePassWord" placeholder="请输⼊密码">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">邮箱</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateEmail" placeholder="请输⼊用户邮箱">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">性别</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateSex" value="1"> 男
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateSex" value="2"> 女
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">手机号</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updatePhoneNumber">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">用户头像</label>
                <div class="col-sm-10">
                    <!-- 用于存放上传的图片相对路径的隐藏域 -->
                    <input type="text" id="updateFilePath" />
                    <img src="" id="updateFileImg" width="50" height="50">
                    <input type="file" class="form-control" name="file" id="updateFile">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">生日</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateBirthday">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">角色</label>
                <div class="col-sm-10">
                    <div id="updateRoleDiv">

                    </div>
                </div>
            </div>
        </form>
    </div>


    <!--新增用户的DIV-->
    <div id="addUserDiv" style="display: none">
        <!--新增用户的form表单-->
        <form id="addUserForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">真实姓名</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addRealName" placeholder="请输⼊真实姓名">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">用户名</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addUserName" placeholder="请输⼊用户名">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">用户密码</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addPassWord" placeholder="请输⼊用户密码">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">邮箱</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addEmail" placeholder="请输⼊用户邮箱">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">性别</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addSex" value="1"> 男
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addSex" value="2"> 女
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">手机号</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addPhoneNumber">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">用户头像</label>
                <div class="col-sm-10">
                    <!-- 用于存放上传的图片相对路径的隐藏域 -->
                    <input type="text" id="addFilePath" />
                    <input type="file" class="form-control" name="file" id="addFile">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">生日</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addBirthday">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">角色</label>
                <div class="col-sm-10">
                    <div id="addRoleDiv">

                    </div>
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
            <form class="form-horizontal" role="form" id="userQueryForm">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">用户名:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="userName" id="userName" placeholder="请输⼊用户名称">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">真实姓名:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="realName" id="realName" placeholder="请输⼊真实姓名">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">手机号码:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="phoneNumber" id="phoneNumber" placeholder="请输⼊手机号码">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">邮箱:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="email" id="email" placeholder="请输⼊邮箱地址">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">性别:</label>
                                <div class="col-sm-10">
                                    <label class="radio-inline">
                                        <input type="radio" name="sex" value="1"> 男
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="sex" value="2"> 女
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">出生日期:</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <input type="text" name="minBirthday" id="minBirthday" class="form-control">
                                        <span class="input-group-addon">--</span>
                                        <input type="text" name="maxBirthday" id="maxBirthday" class="form-control">
                                    </div>
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

    <!--用户列表面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                用户列表
            </h3>
        </div>
        <div class="panel-body">
            <div style="margin-bottom:10px">
                <button onclick="showAddUserDialog()" type="button" class="btn btn-primary">
                    <span class="glyphicon glyphicon-plus"></span>&nbsp;新增
                </button>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button onclick="batchDeleteUser()" type="reset" class="btn btn-danger">
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

            <table id="userTable" class="table table-striped table-bordered table-hover table-condensed">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox"/>
                    </th>
                    <th>用户名</th>
                    <th>真实姓名</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>手机号</th>
                    <th>头像</th>
                    <th>出生日期</th>
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
