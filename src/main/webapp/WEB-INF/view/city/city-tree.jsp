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

        //用于存放新增城市DIV的HTML代码的全局变量
        var addCityDivHTML;

        //用于存放修改城市DIV的HTML代码的全局变量
        var updateCityDivHTML;

        $(function(){

            addCityDivHTML = $("#addCityDiv").html();

            updateCityDivHTML = $("#updateCityDiv").html();

            //发起一个查询所有城市数据的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/CityController/queryCityList.do",
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        //使用ztree初始化城市树
                        ztreeObj = $.fn.zTree.init($("#ztree"),setting,result.data);
                    }else{
                        alert("查询城市失败!");
                    }
                },
                error:function(){
                    alert("查询城市失败!");
                }
            });
        });


        function showAddCityDialog(){
            //获取城市树上被选中的节点数组
            var selectedNodes = ztreeObj.getSelectedNodes();
            if(selectedNodes.length > 0){
                //获取被选中的节点
                var selectedNode = selectedNodes[0];

                $("#addParentName").val(selectedNode.name);

                bootbox.confirm({
                    title:"新增城市",
                    message:$("#addCityDiv").children(),
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
                            //获取新增城市表单中的数据
                            param.name = $("#addName").val();
                            //新增的这个城市的pid应该是被选中节点的id
                            param.pid = selectedNode.id;
                            //新增的这个城市类型  0代表国家 1代表省份 2代表市 3代表县
                            param.type = $("[name=addType]:checked").val();

                            //发起一个新增城市的ajax请求
                            $.ajax({
                                url:"<%=request.getContextPath()%>/CityController/addCity.do",
                                type:"post",
                                data:param,
                                dataType:"json",
                                success:function(result){
                                    if(result.code == 200){
                                        ztreeObj.addNodes(selectedNode,-1,result.data);
                                    }else{
                                        alert("新增城市失败!");
                                    }
                                },
                                error:function(){
                                    alert("新增城市失败!");
                                }
                            });
                        }
                        $("#addCityDiv").html(addCityDivHTML);
                    }
                });
            }else{
                alert("请先选择父节点!");
            }
        }


        function showUpdateCityDialog(){
            //获取城市树被选中的节点数组
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

                    //回显修改城市表单中的数据
                    $("#updateParentName").val(parentNode.name);
                    $("#updateName").val(selectedNode.name);
                    $("[name=updateType][value=" + selectedNode.type + "]").prop("checked",true);


                    bootbox.confirm({
                        title:"修改城市",
                        message:$("#updateCityDiv").children(),
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
                                //获取修改城市表单中的数据
                                param.id = selectedNode.id;
                                param.name = $("#updateName").val();
                                param.type = $("[name=updateType]:checked").val();



                                //发起一个修改城市的ajax请求
                                $.ajax({
                                    url:"<%=request.getContextPath()%>/CityController/updateCity.do",
                                    type:"post",
                                    data:param,
                                    dataType:"json",
                                    success:function(result){
                                        if(result.code == 200){
                                            selectedNode.name = param.name;
                                            //调用ztree的修改节点的方法
                                            ztreeObj.updateNode(selectedNode);
                                        }else{
                                            alert("修改城市失败!");
                                        }
                                    },
                                    error:function(){
                                        alert("修改城市失败!");
                                    }
                                });
                            }
                            $("#updateCityDiv").html(updateCityDivHTML);
                        }
                    });
                }


            }else{
                alert("请先选择要修改的节点!");
            }
        }

        function deleteCity(){
            //获取城市树被选中的节点数组
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

                                //发起一个删除城市的ajax请求
                                $.ajax({
                                    url: "<%=request.getContextPath()%>/CityController/deleteCity.do",
                                    type: "post",
                                    data: {ids: ids},
                                    dataType: "json",
                                    success: function (result) {
                                        if (result.code == 200) {
                                            //调用ztree树的删除节点方法
                                            ztreeObj.removeNode(selectedNode);
                                        } else {
                                            alert("删除城市失败!");
                                        }
                                    },
                                    error: function () {
                                        alert("删除城市失败!");
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

<!--修改城市的DIV-->
<div id="updateCityDiv" style="display: none">
    <!--修改城市的form表单-->
    <form id="updateCityForm" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">上级名称</label>
            <div class="col-sm-10">
                <input type="text" id="updateParentName" class="form-control" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">城市名称</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="updateName">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">城市类型</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="updateType" value="0"> 国家
                </label>
                <label class="radio-inline">
                    <input type="radio" name="updateType" value="1"> 省份
                </label>
                <label class="radio-inline">
                    <input type="radio" name="updateType" value="2"> 市
                </label>
                <label class="radio-inline">
                    <input type="radio" name="updateType" value="3"> 县
                </label>
                <label class="radio-inline">
                    <input type="radio" name="updateType" value="4"> 乡镇
                </label>
                <label class="radio-inline">
                    <input type="radio" name="updateType" value="5"> 村
                </label>
            </div>
        </div>
    </form>
</div>

<!--新增城市的DIV-->
<div id="addCityDiv" style="display: none">
    <!--新增城市的form表单-->
    <form id="addCityForm" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">上级名称</label>
            <div class="col-sm-10">
                <input type="text" id="addParentName" class="form-control" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">城市名称</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addName">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">城市类型</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="addType" value="0"> 国家
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addType" value="1"> 省份
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addType" value="2"> 市
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addType" value="3"> 县
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addType" value="4"> 乡镇
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addType" value="5"> 村
                </label>
            </div>
        </div>
    </form>
</div>

    <jsp:include page="../common/nav.jsp"></jsp:include>
    <button onclick="showAddCityDialog()" type="button" class="btn btn-primary btn-xs">
        <span class="glyphicon glyphicon-plus"></span>&nbsp;新增
    </button>
    <button onclick="showUpdateCityDialog()" type="button" class="btn btn-primary btn-xs">
        <span class="glyphicon glyphicon-pencil"></span>&nbsp;修改
    </button>
    <button onclick="deleteCity()" type="button" class="btn btn-danger btn-xs">
        <span class="glyphicon glyphicon-minus"></span>&nbsp;删除
    </button>
    <ul id="ztree" class="ztree"></ul>
</body>
</html>
