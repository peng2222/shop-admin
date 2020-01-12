<%--
  Created by IntelliJ IDEA.
  User: lichuan
  Date: 2019/11/24
  Time: 14:53
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
            callback:{
                onClick:function(event, treeId, treeNode, clickFlag){
                    if(treeNode.isParent){
                        //如果不是叶子节点
                        //表格隐藏
                        $("#attributePanel").hide();
                        //条件查询隐藏
                        $("#attributeQueryPanel").hide();
                    }else{
                        //如果是叶子节点
                        //显示表格
                        $("#attributePanel").show();
                        //显示条件查询
                        $("#attributeQueryPanel").show();
                        if(attributeTable == undefined){
                            initAttributeTable();
                        }else{
                            attributeTable.ajax.reload();
                        }
                    }
                }
            }
        };

        //用于存放新增属性DIV的HTML代码的全局变量
        var addAttributeDivHTML;
        //用于存放修改属性DIV的HTML代码的全局变量
        var updateAttributeDivHTML;
        $(function(){

            addAttributeDivHTML = $("#addAttributeDiv").html();

            updateAttributeDivHTML = $("#updateAttributeDiv").html();

            //发起一个查询所有分类数据的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/ClassifyController/queryClassifyList.do",
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        //使用ztree初始化分类树
                        ztreeObj = $.fn.zTree.init($("#ztree"),setting,result.data);
                        //获取根节点个数,getNodes获取的是根节点的集合
                        var nodeList = ztreeObj.getNodes();
                        //展开第一个根节点
                        ztreeObj.expandNode(nodeList[0], true);
                    }else{
                        alert("查询分类失败!");
                    }
                },
                error:function(){
                    alert("查询分类失败!");
                }
            });
        });

        function search(){
            attributeTable.ajax.reload();
        }

        var attributeTable;
        function initAttributeTable(){
            attributeTable = $("#attributeTable").DataTable({
                searching:false,
                ordering:false,
                serverSide:true, //开启服务端模式
                lengthMenu:[3,5,10,15],
                processing:true,//是否显示正在处理中
                language:chinese,
                ajax:{
                    url:"<%=request.getContextPath()%>/AttributeController/queryAttributeList.do",
                    data:function(param){
                        //DataTables在发送ajax请求的时候会发送一些自己的参数，比如说每页显示条数，起始条数等等。。。
                        //通过param这个参数咱们可以设置自己需要传递的参数，比如说条件查询的值
                        //【非常重要】在这块需要获取到商品分类树被选中的节点的id(也就是商品分类的id)
                        //然后根据这个商品分类的id去属性表中把categoryId=这个商品分类id的数据查出来！！！
                        param.name = $("#name").val();
                        param.type = $("[name=type]:checked").val();
                        param.selectType = $("[name=selectType]:checked").val();
                        param.inputType = $("[name=inputType]:checked").val();
                        param.addable = $("[name=addable]:checked").val();
                        param.classifyId = ztreeObj.getSelectedNodes()[0].id;
                    }
                },
                columns:[
                    {
                        data:"id",
                        render:function(data){
                            return "<input type='checkbox' name='id' value='"+data+"'/>";
                        }
                    },
                    {
                        data:"name",
                    },
                    {
                        data:"type",
                        render:function(data){
                            return data==1?"SPU属性(关键属性)":"SKU属性(销售属性)";
                        }
                    },
                    {
                        data:"selectType",
                        render:function(data){
                            return data==1?"输入框":data==2?"单选按钮":data==3?"复选框":"下拉框";
                        }
                    },
                    {
                        data:"inputType",
                        render:function(data){
                            return data == 1?"手动输入":"从可选项中选择";
                        }
                    },
                    {
                        data:"addable",
                        render:function(data){
                            return data == 1?"是":"否";
                        }
                    },
                    {
                        data:"id",
                        render:function(data){
                            var buttonsHTML = "";
                            buttonsHTML += '<div class="btn-group btn-group-xs">';
                            buttonsHTML += '<button type="button" onclick="showUpdateAttributeDialog(' + data + ')" class="btn btn-primary">';
                            buttonsHTML += '<span class="glyphicon glyphicon-pencil"></span>&nbsp;修改';
                            buttonsHTML += '</button>';
                            buttonsHTML += '<button type="button" onclick="deleteAttribute(' + data + ')" class="btn btn-danger">';
                            buttonsHTML += '<span class="glyphicon glyphicon-trash"></span>&nbsp;删除';
                            buttonsHTML += '</div>';
                            return buttonsHTML;
                        }}
                ]
            });
        }

        //Dialog是对话框的意思
        function showAddAttributeDialog(){
            //使用bootbox弹框插件弹出新增属性的对话框
            bootbox.confirm({
                title:"新增属性",
                message:$("#addAttributeDiv").children(),
                buttons:{
                    confirm:{
                        label:"确认"
                    },
                    cancel:{
                        label:"取消",
                        className:"btn btn-danger"
                    }
                },
                callback:function(result){
                    //如果点击了确认按钮
                    if(result){
                        var param = {};
                        //获取新增属性表单中的数据
                        param.name = $("#addName").val();
                        param.inputList = $("#addInputList").val();
                        param.type = $("[name=addType]:checked").val();
                        param.selectType = $("[name=addSelectType]:checked").val();
                        param.inputType = $("[name=addInputType]:checked").val();
                        param.addable = $("[name=addAddable]:checked").val();
                        param.classifyId = ztreeObj.getSelectedNodes()[0].id;
                        //发起一个新增属性的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/AttributeController/addAttribute.do",
                            type:"post",
                            data:param,
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("新增属性失败!");
                                }
                            },
                            error:function(){
                                alert("新增属性失败!");
                            }
                        });
                    }
                    $("#addAttributeDiv").html(addAttributeDivHTML);
                }
            });
        }

        //Dialog是对话框的意思
        function showUpdateAttributeDialog(id){
            alert(id);
            //发起一个通过id获取单个属性信息的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/AttributeController/getAttributeById.do",
                type:"post",
                data:{id:id},
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        //回显修改属性表单中的数据
                        var attribute = result.data;
                        $("#updateName").val(attribute.name);
                        $("[name=updateType][value=" + attribute.type + "]").prop("checked",true);
                        $("[name=updateSelectType][value=" + attribute.selectType + "]").prop("checked",true);
                        $("[name=updateInputType][value=" + attribute.inputType + "]").prop("checked",true);
                        $("[name=updateAddable][value=" + attribute.addable + "]").prop("checked",true);
                        $("#updateInputList").val(attribute.inputList);
                        //弹出修改属性对话框
                        bootbox.confirm({
                            title:"修改属性",
                            message:$("#updateAttributeDiv").children(),
                            buttons:{
                                confirm:{
                                    label:"确认"
                                },
                                cancel:{
                                    label:"取消",
                                    className:"btn btn-danger"
                                }
                            },
                            callback:function(result){
                                //如果点击了确认按钮
                                if(result){
                                    //获取修改属性表单中的数据
                                    var param = {};
                                    param.id = attribute.id;
                                    param.name = $("#updateName").val();
                                    param.inputList = $("#updateInputList").val();
                                    param.type = $("[name=updateType]:checked").val();
                                    param.selectType = $("[name=updateSelectType]:checked").val();
                                    param.inputType = $("[name=updateInputType]:checked").val();
                                    param.addable = $("[name=updateAddable]:checked").val();
                                    //发起一个修改属性的ajax请求
                                    $.ajax({
                                        url:"<%=request.getContextPath()%>/AttributeController/updateAttribute.do",
                                        type:"post",
                                        data:param,
                                        dataType:"json",
                                        success:function(result){
                                            if(result.code == 200){
                                                //重新加载表格中的数据
                                                search();
                                            }else{
                                                alert("修改属性失败!");
                                            }
                                        },
                                        error:function(){
                                            alert("修改属性失败!");
                                        }
                                    });
                                }
                                $("#updateAttributeDiv").html(updateAttributeDivHTML);
                            }
                        });
                    }else{
                        alert("查询属性信息失败!");
                    }
                },
                error:function(){
                    alert("查询属性信息失败!");
                }
            });
        }


        function deleteAttribute(id){
            bootbox.confirm({
                title:"删除属性提示",
                message:"您确认要删除吗？",
                buttons:{
                    confirm:{
                        label:"确认"
                    },
                    cancel:{
                        label:"取消",
                        className:"btn btn-danger"
                    }
                },
                callback:function(result){
                    //如果点击了确认按钮
                    if(result){
                        //发起一个删除属性的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/AttributeController/deleteAttribute.do",
                            type:"post",
                            data:{id:id},
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    bootbox.alert({
                                        title:"操作提示",
                                        message:"删除成功!"
                                    });
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("删除属性失败!");
                                }
                            },
                            error:function(){
                                alert("删除属性失败!");
                            }
                        });
                    }
                }
            });
        }

        //批量删除
        function batchDeleteAttribute(){
            //获取所有被选中的复选框数组
            var idCheckboxes = $("[name=id]:checked");
            if(idCheckboxes.length > 0){
                bootbox.confirm({
                    title:"删除属性提示",
                    message:"您确认要删除吗？",
                    buttons:{
                        confirm:{
                            label:"确认"
                        },
                        cancel:{
                            label:"取消",
                            className:"btn btn-danger"
                        }
                    },
                    callback:function(result){
                        //如果点击了确认按钮
                        if(result){
                            var idArr = [];
                            idCheckboxes.each(function(){
                                idArr.push($(this).val());
                            });
                            //发起一个批量删除属性的ajax请求
                            $.ajax({
                                url:"<%=request.getContextPath()%>/AttributeController/batchDeleteAttribute.do",
                                type:"post",
                                data:{ids:idArr},
                                dataType:"json",
                                success:function(result){
                                    if(result.code == 200){
                                        //重新加载表格中的数据
                                        search();
                                    }else{
                                        alert("批量删除属性失败!");
                                    }
                                },
                                error:function(){
                                    alert("批量删除属性失败!");
                                }
                            });
                        }
                    }
                });
            }else{
                alert("请先选择要删除的属性！");
            }

        }
    </script>
</head>
<body>

    <!--修改属性的DIV-->
    <div id="updateAttributeDiv" style="display: none">
        <!--修改属性的form表单-->
        <form id="updateAttributeForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">属性名称</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateName" placeholder="请输⼊属性名称">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">属性类型</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateType" value="1"> SPU属性(关键属性)
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateType" value="2"> SKU属性(销售属性)
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">选择类型</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateSelectType" value="1"> 输入框
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateSelectType" value="2"> 单选按钮
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateSelectType" value="3"> 复选框
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateSelectType" value="4"> 下拉框
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">录入类型</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateInputType" value="1"> 手动输入
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateInputType" value="2"> 从可选项中选择
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">可选值</label>
                <div class="col-sm-10">
                    <textarea id="updateInputList" class="form-control" rows="5"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">加属性值</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateAddable" value="1"> 允许
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateAddable" value="2"> 不允许
                    </label>
                </div>
            </div>
        </form>
    </div>


    <!--新增属性的DIV-->
    <div id="addAttributeDiv" style="display: none">
        <!--新增属性的form表单-->
        <form id="addAttributeForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">属性名称</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addName" placeholder="请输⼊属性名称">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">属性类型</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addType" value="1"> SPU属性(关键属性)
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addType" value="2"> SKU属性(销售属性)
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">选择类型</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addSelectType" value="1"> 输入框
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addSelectType" value="2"> 单选按钮
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addSelectType" value="3"> 复选框
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addSelectType" value="4"> 下拉框
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">录入类型</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addInputType" value="1"> 手动输入
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addInputType" value="2"> 从可选项中选择
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">可选值</label>
                <div class="col-sm-10">
                    <textarea id="addInputList" class="form-control" rows="5"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">加属性值</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addAddable" value="1"> 允许
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addAddable" value="2"> 不允许
                    </label>
                </div>
            </div>
        </form>
    </div>

    <!-- 引入导航栏 -->
    <jsp:include page="../common/nav.jsp" />

    <div class="container" style="width: 100%">
        <div class="row">
            <div class="col-md-3">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h5 lass="panel-title"> 商品分类</h5>
                    </div>
                    <div class="panel panel-body" style="height: 580px">
                        <ul id="ztree" class="ztree"></ul>
                    </div>
                </div>
            </div>

            <div class="col-md-9"  id="attributePanel" style="display: none">
                <div class="row">
                    <div class="col-md-12">
                        <div class="panel panel-primary">

                            <div class="panel-heading">
                                <h5 lass="panel-title"> 商品属性查询</h5>
                            </div>

                            <div class="panel panel-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <form class="form-horizontal" >
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="control-label col-sm-3">属性名称:</label>
                                                        <div class="col-sm-9">
                                                            <input class="form-control" name="name" id="name">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="control-label col-sm-3">选择类型:</label>
                                                        <div class="col-sm-9">
                                                            <label class="radio-inline">
                                                                <input type="radio" name="selectType" value="1"> 输入框
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" name="selectType" value="2"> 单选按钮
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" name="selectType" value="3"> 复选框
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" name="selectType" value="4"> 下拉框
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label">属性类型:</label>
                                                        <div class="col-sm-9">
                                                            <label class="radio-inline">
                                                                <input type="radio" name="type" value="1"> SPU属性(关键属性)
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" name="type" value="2"> SKU属性(销售属性)
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label">录入类型:</label>
                                                        <div class="col-sm-9">
                                                            <label class="radio-inline">
                                                                <input type="radio" name="inputType" value="1"> 手动输入
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" name="inputType" value="2"> 从可选项中选择
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label">手动新增:</label>
                                                        <div class="col-sm-9">
                                                            <label class="radio-inline">
                                                                <input type="radio" name="addable" value="1"> 允许
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" name="addable" value="2"> 不允许
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                </div>
                                            </div>
                                            <div class="row">
                                            <div class="col-sm-12" style="padding-left: 155px">
                                                <div class="form-group">
                                                    <button type="button" class="btn btn-primary" onclick="search()"><span class="glyphicon glyphicon-search"></span> 查询</button>
                                                    <button type="reset" class="btn btn-danger"><span class="glyphicon glyphicon-refresh"></span> 重置</button>
                                                </div>
                                            </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h5 lass="panel-title"> 商品列表展示</h5>
                            </div>
                            <div class="panel panel-body">
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-sm-12" style="padding-left: 50px; padding-bottom: 10px">
                                            <button type="button" class="btn btn-primary" onclick="showAddAttributeDialog()"><span class="glyphicon glyphicon-plus"></span> 新增</button>
                                            <button type="button" class="btn btn-danger" onclick="batchDeleteAttribute()"><span class="glyphicon glyphicon-minus"></span> 批量删除</button>
                                        </div>
                                    </div>
                                </div>
                                <table id="attributeTable" class="table table-striped table-hover table-condensed table-bordered">
                                    <thead class="warning"  align="center">
                                    <th>
                                        <input type="checkbox"  />
                                    </th>
                                    <th style="width: 70px">属性名称</th>
                                    <th style="width: 140px">属性类型</th>
                                    <th style="width: 100px">属性选择类型</th>
                                    <th style="width: 120px">属性值录入类型</th>
                                    <th style="width: 150px">是否允许新增属性值</th>
                                    <th>操作</th>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
