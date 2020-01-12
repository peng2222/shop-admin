<%--
  Created by IntelliJ IDEA.
  Role: qiaojinghui
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
                    url: "SSS"
                },
                //简单JSON数据
                simpleData:{
                    enable:true,
                    pIdKey:"pid"
                }
            }
        };

        //用于存放新增权限DIV的HTML代码的全局变量
        var addPermissionDivHTML;

        //用于存放修改权限DIV的HTML代码的全局变量
        var updatePermissionDivHTML;

        $(function(){

            addPermissionDivHTML = $("#addPermissionDiv").html();

            updatePermissionDivHTML = $("#updatePermissionDiv").html();

            //发起一个查询所有权限数据的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/PermissionController/queryPermissionList.do",
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        //使用ztree初始化权限树
                        ztreeObj = $.fn.zTree.init($("#ztree"),setting,result.data);
                    }else{
                        alert("查询权限失败!");
                    }
                },
                error:function(){
                    alert("查询权限失败!");
                }
            });
        });


        function showAddPermissionDialog(){
            //获取权限树上被选中的节点数组
            var selectedNodes = ztreeObj.getSelectedNodes();
            if(selectedNodes.length > 0){
                //获取被选中的节点
                var selectedNode = selectedNodes[0];

                $("#addParentName").val(selectedNode.name);

                bootbox.confirm({
                    title:"新增权限",
                    message:$("#addPermissionDiv").children(),
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
                            //获取新增权限表单中的数据
                            param.name = $("#addName").val();
                            param.type = $("[name=addType]:checked").val();
                            param.url = $("#addUrl").val();
                            //新增的这个权限的pid应该是被选中节点的id
                            param.pid = selectedNode.id;


                            //发起一个新增权限的ajax请求
                            $.ajax({
                                url:"<%=request.getContextPath()%>/PermissionController/addPermission.do",
                                type:"post",
                                data:param,
                                dataType:"json",
                                success:function(result){
                                    if(result.code == 200){
                                        //var newNode = {id:result.data,name:param.name,url:param.url,type:param.type,pid:param.pid};
                                        ztreeObj.addNodes(selectedNode,-1,result.data);
                                    }else{
                                        alert("新增权限失败!");
                                    }
                                },
                                error:function(){
                                    alert("新增权限失败!");
                                }
                            });
                        }
                        $("#addPermissionDiv").html(addPermissionDivHTML);
                    }
                });
            }else{
                alert("请先选择父节点!");
            }
        }


        function showUpdatePermissionDialog(){
            //获取权限树被选中的节点数组
            var selectedNodes = ztreeObj.getSelectedNodes();
            if(selectedNodes.length > 0){



                //获取被选中的节点
                var selectedNode = selectedNodes[0];

                //判断被选中的节点是不是根节点，如果是根节点则不允许修改
                if(selectedNode.pid == null){
                    alert("不允许修改根节点!");
                }else{
                    //获取被选中的节点的父节点
                    var parentNode = selectedNode.getParentNode();

                    //回显修改权限表单中的数据
                    $("#updateParentName").val(parentNode.name);
                    $("#updateName").val(selectedNode.name);
                    $("[name=updateType][value=" + selectedNode.type + "]").prop("checked",true);
                    $("#updateUrl").val(selectedNode.url);

                    bootbox.confirm({
                        title:"修改权限",
                        message:$("#updatePermissionDiv").children(),
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
                                //获取修改权限表单中的数据
                                param.id = selectedNode.id;
                                param.name = $("#updateName").val();
                                param.type = $("[name=updateType]:checked").val();
                                param.url = $("#updateUrl").val();


                                //发起一个修改权限的ajax请求
                                $.ajax({
                                    url:"<%=request.getContextPath()%>/PermissionController/updatePermission.do",
                                    type:"post",
                                    data:param,
                                    dataType:"json",
                                    success:function(result){
                                        if(result.code == 200){
                                            selectedNode.name = param.name;
                                            selectedNode.url = param.url;
                                            selectedNode.type = param.type;
                                            //调用ztree的修改节点的方法
                                            ztreeObj.updateNode(selectedNode);
                                        }else{
                                            alert("修改权限失败!");
                                        }
                                    },
                                    error:function(){
                                        alert("修改权限失败!");
                                    }
                                });
                            }
                            $("#updatePermissionDiv").html(updatePermissionDivHTML);
                        }
                    });
                }


            }else{
                alert("请先选择要修改的节点!");
            }
        }

        function deletePermission(){
            //获取权限树被选中的节点数组
            var selectedNodes = ztreeObj.getSelectedNodes();
            if(selectedNodes.length > 0){

                //获取被选中的节点
                var selectedNode = selectedNodes[0];

                //判断被选中的节点是不是根节点，如果是根节点则不允许修改
                if(selectedNode.pid == null){
                    alert("不允许删除根节点!");
                }else {

                    bootbox.confirm({
                        title: "删除提示",
                        message: "您确认要删除吗？",
                        buttons: {
                            //設置確定按鈕的文字和樣式
                            confirm: {
                                label: "確認",
                                className: "btn btn-success"
                            },
                            //設置取消按鈕的文字和樣式
                            cancel: {
                                label: "取消",
                                className: "btn btn-danger"
                            }
                        },
                        callback: function (result) {
                            if (result) {

                                //获取被选中的节点及其所有后代节点的数组
                                var nodeArr = ztreeObj.transformToArray(selectedNode);
                                var ids = [];
                                for (var i = 0; i < nodeArr.length; i++) {
                                    ids.push(nodeArr[i].id);
                                }

                                //发起一个删除权限的ajax请求
                                $.ajax({
                                    url: "<%=request.getContextPath()%>/PermissionController/deletePermission.do",
                                    type: "post",
                                    data: {ids: ids},
                                    dataType: "json",
                                    success: function (result) {
                                        if (result.code == 200) {
                                            //调用ztree树的删除节点方法
                                            ztreeObj.removeNode(selectedNode);
                                        } else {
                                            alert("删除权限失败!");
                                        }
                                    },
                                    error: function () {
                                        alert("删除权限失败!");
                                    }
                                });
                            }
                        }
                    });
                }

            }else{
                alert("请先选择要删除的节点!");
            }
        }

    </script>
</head>
<body>

<!--修改权限的DIV-->
<div id="updatePermissionDiv" style="display: none">
    <!--修改权限的form表单-->
    <form id="updatePermissionForm" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">上级名称</label>
            <div class="col-sm-10">
                <input type="text" id="updateParentName" class="form-control" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">权限名称</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="updateName">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">权限类型:</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="updateType" value="1"> 菜单
                </label>
                <label class="radio-inline">
                    <input type="radio" name="updateType" value="2"> 按钮
                </label>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">权限URL</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="updateUrl">
            </div>
        </div>
    </form>
</div>

<!--新增权限的DIV-->
<div id="addPermissionDiv" style="display: none">
    <!--新增权限的form表单-->
    <form id="addPermissionForm" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">上级名称</label>
            <div class="col-sm-10">
                <input type="text" id="addParentName" class="form-control" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">权限名称</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addName">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">权限类型:</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="addType" value="1"> 菜单
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addType" value="2"> 按钮
                </label>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">权限URL</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addUrl">
            </div>
        </div>
    </form>
</div>

    <jsp:include page="../common/nav.jsp"></jsp:include>
    <button onclick="showAddPermissionDialog()" type="button" class="btn btn-primary btn-xs">
        <span class="glyphicon glyphicon-plus"></span>&nbsp;新增
    </button>
    <button onclick="showUpdatePermissionDialog()" type="button" class="btn btn-primary btn-xs">
        <span class="glyphicon glyphicon-pencil"></span>&nbsp;修改
    </button>
    <button onclick="deletePermission()" type="button" class="btn btn-danger btn-xs">
        <span class="glyphicon glyphicon-minus"></span>&nbsp;删除
    </button>
    <ul id="ztree" class="ztree"></ul>
</body>
</html>
