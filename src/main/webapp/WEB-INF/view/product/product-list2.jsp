<%--
  Created by IntelliJ IDEA.
  User: mac
  Date: 2019/11/27
  Time: 18:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="../common/static.jsp" />
    <script>

        //用于存放代码的HTML变量
        var addProductDivHTML;

        $(function(){

            addProductDivHTML = $("#addProductForm").html();

        })

        function showAddProductDialog(){
            //发起一个查询品牌的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/BrandController/queryBrandListNoPage.do",
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        var brandSelectHTML = "";
                        for(var i =0; i < result.data.length ; i ++){
                            brandSelectHTML += "<option value='" + result.data[i].id + "' >" + result.data[i].name + "</option>";
                        }
                        $("#addBrandSelect").html(brandSelectHTML);
                    }else{
                        alert("查询品牌失败！");
                    }
                },
                error:function{
                    alert("查询条件失败！");
                }
            });

            abc();

            bootbox.config({
                title:"新增商品",
                massage:$("#addProductDiv").children(),
                buttons:{
                    //設置確定按鈕的文字和樣式
                    confirm: {
                        label: "確認",
                        className: "btn btn-success"
                    },
                    //设置取消按钮的文字和样式
                    cancel:{
                        label:"取消",
                        className:" btn btn-danger "
                    }
                },
                callback:function(result){
                    $("#addProductDiv").html(addProductDivHTML);
                }
            });
        }


        function abc(obj){
            if(obj){
                //nexAll是找下面的兄弟节点
                $(obj).parent().nextAll().remove();
                //找到这个下拉框的父亲前面有几个兄弟
                //如果前面没有兄弟说明是一级分类，如果前面有一个兄弟说明是二级分类，如果前面有两个兄弟说明是三级分类
                var level = $(obj).parent().prevAll().length +1;
                // alert("当前分类是第" + level + "级分类！");
                //如果当前选择的是第三级商品分类，则获取当前商品分类的id,通过商品分类的id将该分类下的所有属性(SKU属性和SPU属性)查询出来
                //alert(obj.value)
                if(level == 3){
                    $.ajax({
                        url:"<%=request.getContextPath()%>/AttributeController/queryAttributeListByClassifyId.do",
                        data:{classifyId:obj.value},
                        dataType:"json",
                        success:function(result){
                           if(result.code == 200){
                               //商品分类所有属性的数组
                               var attributeArr = result.date;
                               //存放SKU属性的数组
                               var skuAttributeArr = [];
                               //存放spu属性的数组
                               var spuAttributeArr = [];
                               for(var i = 0; i < attributeArr.length; i ++){
                                   //如果type==1说明是spu属性
                                   if(attributeArr[i].type == 1){
                                       spuAttributeArr.push(attributeArr[i]);
                                   }else {
                                       skuAttributeArr.push(attributeArr[i]);
                                   }
                               }
                               //初始化新增商品表单中的SPU属性DIV
                               initAddSpuAttributeDiv(spuAttributeArr);
                               //初始化新增商品表单中的SKU属性DIV
                               initAddSkuAttributeDiv(skuAttributeArr);

                           }else {
                               alert("查询属性失败！");
                           }
                        },
                        error:function () {
                            alert("查询属性失败！");
                        }
                    });
                }
            }

            var pid = obj == undefined ? 1:obj.value;

            $.ajax({
                url:"<%=request.getContextPath()%>/ClassifyController/queryClassifyListByPid.do",
                type:"get",
                data:{pid:pid},
                dataType:"json",
                success:function (result) {
                    if(result.data.length < 1){
                        return;
                    }
                    if(result.code == 200){
                        var classifySelectHTML = "<div class='col-sm-4'><select onchange='abc(this)' style='width:100px' class='form-control'><option value='-1'>请选择</option></div>";
                        for(var i = 0 ;i < result.data.length; i ++){
                            classifySelectHTML += "<option value='" + result.data[i].id + "'>" + result.data[i].name + "</option>";
                        }
                        classifySelectHTML +="</select></div>";
                        $("#addClassifyDiv").append(classifySelectHTML);
                    }else {
                        alert("查询品牌失败！");
                    }
                },
                error:function () {
                    alert("查询品牌失败！");
                }
            });
        }


        function initAddSpuAttributeDiv(spuAttributeArr) {
            var addSpuAttributeDivHTML = "";
            //遍历spu属性数组
            for(var i = 0; i < spuAttributeArr.length; i ++){
                addSpuAttributeDivHTML += spuAttributeArr[i].name + ":</div>";
                //先判断当前遍历输入的属性值录入方式(inputType)
                //如果是手动输入(inputType==1)直接显示一个文本框
                //如果是从可选项中选择(inputType==2)这时候咱们再去判断属性选择方式(selectType)
                //如果selectType==3 就把可选项展示成复选框
                //如果selectType==4 就把可选项展示成下拉框
                if(spuAttributeArr[i].inputType == 1){
                    addSpuAttributeDivHTML += "<input type='text'/>";
                }else if(spuAttributeArr[i].inputType == 2){
                    //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                    var valueArr = spuAttributeArr[i].inputList.split(",");
                    for (var j = 0; j < valueArr.length ; j++) {
                        addSpuAttributeDivHTML += "<input type='radio' />" + valueArr[j];
                    }
                }else if(spuAttributeArr[i].inputType == 3){
                    //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                    var valueArr = spuAttributeArr[i].inputList.split(",");
                    for (var j = 0; j < valueArr.length ; j++) {
                        addSpuAttributeDivHTML += "<input type='checkbox' />" + valueArr[j];
                    }
                }else if(spuAttributeArr[i].selectType == 4){
                    addSpuAttributeDivHTML += "<select class='form-control'>";
                    //当前白能力属性的可选项之，多个值之间使用逗号隔开的
                    var valueArr = spuAttributeArr[i].inputList.split(",");
                    for (var j = 0; j < valueArr.length ; j++) {
                        addSpuAttributeDivHTML += "<option value='" + valueArr[j] + "'>" + valueArr[j] + "</option>"
                    }
                    addSpuAttributeDivHTML += "</div>";
                    //如果当前遍历的属性允许新增属性值
                    if(spuAttributeArr[i].addable == 1){
                        addSpuAttributeDivHTML += "<div><input type='text'/><button onclick='addCustomValue(this," + spuAttributeArr[i].selectType + ","+ spuAttributeArr[i].id + ")' type='button' class='btn-link'>新增</button></div>";
                    }
                    addSpuAttributeDivHTML += "<br/>";
                }

            }
            $("#addSouAttributeDiv").html(addSpuAttributeDivHTML);
        }


        function initAddSkuAttributeDiv(skuAttributeArr) {
            var addSkuAttributeDivHTML = "";
            //遍历sku属性的数组
            for (var i = 0; i < skuAttributeArr.length ; i++) {
                addSkuAttributeDivHTML += "<div class='attribute'><div class='attributeName' attributeId='" + skuAttributeArr[i].id + "' attributeName='" + skuAttributeArr[i].name + "'>" + skuAttributeArr[i].name + ":</div><div class='attributeValue'>";
                //先判断当前遍历输入的属性zhi录入方式(inputType)
                //如果是手动输入(inputType==1)直接显示一个文本框
                //如果是从可选项中选择(inputType==2)这时候咱们再去判断属性选择方式(selectType)
                //如果selectType==3 就把可选项展示成复选框
                //如果selectType==4 就把可选项展示成下拉框
                if(skuAttributeArr[i].inputType == 1){
                    addSkuAttributeDivHTML += "<input name='abc' type='text' /></div>";
                }else if(skuAttributeArr[i].selectType == 2){
                    //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                    var valueArr = skuAttributeArr[i].inputList.split(",");
                    var valueIdArr = skuAttributeArr[i].valueIdList.split(",");
                    for (var j = 0; j < valueArr.length ; j++) {
                        addSkuAttributeDivHTML += "<input type='radio' name='abc' valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "' onclick='initSkuTable()' />" + valueArr[j];
                    }
                }else if(skuAttributeArr[i].selectType == 3){
                    //当前遍历属性的可选项值，多个值之间使用逗号隔开
                    var valueArr= skuAttributeArr[i].inputList.split(",");
                    var valueIdArr = skuAttributeArr[i].valueIdList.split(",");
                    for (var j = 0; j < valueArr.length ; j++) {
                        addSkuAttributeDivHTML += "<input type='radio' name='abc' valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "' onclick='initSkuTable()' />" + valueArr[j];
                    }
                }else if(skuAttributeArr[i].selectType == 4){
                    addSkuAttributeDivHTML += "<select class='form-control' name='abc' onchange='initSkuTable() '>";
                    //当前遍历可选项的属性值，多个属性值之间用逗号隔开
                    var valueArr = skuAttributeArr[i].inputList.split(",");
                    var valueIdArr = skuAttributeArr[i].valueIdList.split(",");
                    for (var j = 0; j < valueArr.length ; j++) {
                        addSkuAttributeDivHTML += "<option valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "'>" + valueArr[j] + "</option>";
                    }
                    addSkuAttributeDivHTML += "</select>";
                }
                addSkuAttributeDivHTML += "</div>";
                //如果当前遍历的属性允许新增的属性值
                if(skuAttributeArr[i].addable == 1){
                    addSkuAttributeDivHTML += "<div><input type='text' /><button onclick='addCustomValue(this," + skuAttributeArr[i].selectType + "," + skuAttributeArr[i].id + ")' type='button' class='btn-link'>新增</button></div>";
                }
                addSkuAttributeDivHTML += "</div>";
            }
            $("#addSkuAttributeDiv").html(addSkuAttributeDivHTML);
        }


        function initSkuTable() {
            //用于存放所有SKU属性的数组
            var attributeArr = [];
            //获取SKU属性DIV中的所有属性DIV
            $("#addSkuAttributeDiv .attribute").each(function () {
                //获取属性名称的DIV
                var attributeNameDiv = $(this).find(" .attributeName");
                //获取属性ID
                var attributeId = attributeNameDiv.attr("attributeId");
                //获取属性名
                var attributeName = attributeNameDiv.attr("attributeName");
                //获取该属性选中的属性
                //获取属性值的DIV
                var attributeValueDiv = $(this).find(" .attributeValue");
                //获取属性值DIV中的属性值元素(单选按钮/复选框/文本框/下拉框)
                var attributeValueElementArr = attributeValueDiv.find("[name=abc]");
                //用于存放当前遍历属性选中的属性值的数组
                var valueArr = [];
                attributeValueElementArr.each(function () {
                    //判断当前遍历的属性值元素的类型(是文本框是复选框是单选按钮还是下拉框)
                    var tagName = this.tagName;//INPUT SELECT
                    //如果当前遍历的属性值元素是INPUT类型的
                    if(tagName == "INPUT"){
                        var type = this.type;
                        if(type == "text"){
                            valueArr.push("-1:" + this.value);
                        }else if(type == "radio" && this.checked){
                            valueArr.push($(this).attr("valueId") + ":" + this.value);
                        }else if(type == "checkbox" && this.checked){
                            valueArr.push($(this).attr("valueId") + ":" + this.value);
                        }
                    }else if(tagName == "SELECT"){
                        valueArr.push($(this).find("option:selected").attr("valueId") + ":" + this.value);
                    }
                });

                //创建一个sku属性对象
                var attribute = {};
                attribute.id = attributeId;
                attribute.name = attributeNmae;
                attribute.valueList = valueArr;
                if(attribute.valueList.length > 0){
                    attributeArr.push(attribute);
                }
            });

            console.log(attributeArr);
            if(attributeArr.length > 0){
                //1.开始生成sku表格
                var skuTableHTML = "<table class='table table-striped table-bordered table-hover table-condensed'><thead><tr>";
                //2.生成sku表格的表头
                var valueListArr = [];
                for (var i = 0; i < attributeArr.length ; i++) {
                    skuTableHTML += "<th>" + attributeArr[i].name + "</th>";
                    valueListArr.push(attributeArr[i].valueList);
                }
                skuTableHTML += "<th>库存</th>";
                skuTableHTML += "<th>价格</th>";
                skuTableHTML += "</tr>";
                skuTableHTML += "</thead>";

                //根据所有属性选中值的数组生成笛卡尔积
                var abc = DescartesUtils.descartes(valueListArr);
                console.log(abc);

                //2.生成sku表格中的数据行
                for(var i = 0;i < abc.length; i ++){
                    skuTableHTML += "<tr>";
                    for (var j = 0; j < abc[i].length; j++) {
                        var arr = abc[i][j].split(":");
                        skuTableHTML += "<td valueId='" + arr[0] + "'>" + arr[1] + "</td>";
                    }
                    skuTableHTML += "<td><input type='text' /></td>";
                    skuTableHTML += "<td><input type='text' /></td>";
                    skuTableHTML += "</tr>";
                }
                $("#addSkuTableDiv").html(skuTableHTML);
            }
        }

        function addCustomValue(obj,selectType,attributeId){
            var value = $(obj).prev(":text").val();
            if(value.trim() == ""){
                alert("属性值不能为空");
                return;
            }

            //发起一个查询属性值是否存在的ajax请求
            $.ajax({
                url: "<%=request.getContextPath()%>/AttributeController/attributeValueIsExisted.do",
                type: "get",
                data: {attributeId: attributeId, value: value},
                dataType: "json",
                success:function(result){
                    if(result.code == 200){

                        if(result.data){
                            var attributeListDiv = $(obj).parent().prev("div");
                            if(selectType == 2){
                                attributeListDiv.append("<input type='radio' />" + value);
                            }else if(selectType == 3){
                                attributeListDiv.append("<input type='checkbox' />" + value);
                            }else if(selectType == 4){
                                attributeListDiv.find("select").append("<option value='" + value + "'>" + value + "</option>")
                            }
                            //把用户手动输入的属性值保存到对应属性的可选项中去
                            //发起一个新增商品属性值的ajax请求
                            $.ajax({
                                url:"<%=request.getContextPath()%>/AttributeController/addAttributeValue.do",
                                type:"get",
                                data:{attributeId:attributeId,value:value},
                                dataType:"json",
                                success:function(result){
                                    if(result.code == 200){
                                    }else{
                                        alert("新增属性值失败!");
                                    }
                                },
                                error:function(){
                                    alert("新增属性值失败!");
                                }
                            });
                        }else{
                            alert("属性值已存在!");
                        }
                    }else{
                        alert("新增属性值失败!");
                    }

                },
                error:function () {
                    alert("新增属性值失败");
                }
            });

            $(obj).prev(":text").val("");
        }
    </script>

</head>
<body>

<!--新增商品的DIV-->
<div id="addProductDiv" style="display: none">
    <!--新增商品的form表单-->
    <form id="addProductForm" class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">商品名称</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addName" placeholder="请输⼊商品名称">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">商品标题</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addTitle">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">商品价格</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="addPrice">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">上下架状态</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="addStatus" value="1"> 上架
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addStatus" value="2"> 下架
                </label>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">是否热销</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="addIsHot" value="1"> 是
                </label>
                <label class="radio-inline">
                    <input type="radio" name="addIsHot" value="2"> 否
                </label>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">商品品牌</label>
            <div class="col-sm-10">
                <select id="addBrandSelect" class="form-control">
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">商品分类</label>
            <div class="col-sm-10" id="addClassifyDiv">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">商品关键属性(SPU)</label>
            <div class="col-sm-10" id="addSpuAttributeDiv">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">商品销售属性(SKU)</label>
            <div class="col-sm-10" id="addSkuAttributeDiv">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label"></label>
            <div class="col-sm-10" id="addSkuTableDiv">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">商品主图</label>
            <div class="col-sm-10">
                <!-- 用于存放上传的图片相对路径的隐藏域 -->
                <input type="text" id="addFilePath" />
                <input type="file" class="form-control" name="file" id="addFile">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">商品描述</label>
            <div class="col-sm-10">
                <textarea id="addRemark"></textarea>
            </div>
        </div>
    </form>
</div>

<!-- 引入导航栏 -->
<jsp:include page="../common/nav.jsp" />
<button onclick="showAddProductDialog()" type="button" class="btn btn-primary">
    <span class="glyphicon glyphicon-plus"></span>&nbsp;新增
</button>
</body>
</html>
