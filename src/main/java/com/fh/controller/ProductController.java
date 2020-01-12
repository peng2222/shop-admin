package com.fh.controller;

import com.fh.common.LogMsg;
import com.fh.model.DataTableResult;
import com.fh.model.ProductInfo;
import com.fh.model.ProductQuery;
import com.fh.service.ProductService;
import com.fh.util.AliyunOSSUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("ProductController")
public class ProductController {

    @Autowired
    private ProductService productService;

    //跳转到商品展示页面
    @RequestMapping("toProductList")
    public String toProductList(){
        return"product/product-list";
    }

    //新增商品
    @RequestMapping("addProduct")
    @ResponseBody
    @LogMsg("增加商品")
    public Map<String,Object> addProduct(@RequestBody ProductInfo productInfo){
        Map<String,Object> result = new HashMap<>();
        try {
            productService.addProduct(productInfo);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //分页条件查询商品信息
    @RequestMapping("queryProductList")
    @ResponseBody
    public DataTableResult queryProductList(ProductQuery productQuery){
        DataTableResult dataTableResult = productService.queryProductList(productQuery);
        return dataTableResult;
    }


    //通过商品id获取单个商品信息
    @RequestMapping("getProductById")
    @ResponseBody
    public Map<String,Object> getProductById(Integer id){
        Map<String,Object> result = new HashMap<>();
        try {
            ProductInfo productInfo = productService.getProductById(id);
            result.put("data",productInfo);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //修改商品
    @RequestMapping("updateProduct")
    @ResponseBody
    @LogMsg("修改商品")
    public Map<String,Object> updateProduct(@RequestBody ProductInfo productInfo){
        Map<String,Object> result = new HashMap<>();
        try {
            productService.updateProduct(productInfo);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //删除商品
    @RequestMapping("deleteProduct")
    @ResponseBody
    @LogMsg("删除商品")
    public Map deleteProduct(Integer id){
        Map<String,Object> result = new HashMap<>();
        try {
            productService.deleteProduct(id);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //批量删除商品
    @RequestMapping("batchDeleteProduct")
    @ResponseBody
    public Map batchDeleteProduct(@RequestParam("ids[]") List<Integer> idList){
        Map<String,Object> result = new HashMap<>();
        try {
            productService.batchDeleteProduct(idList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    @RequestMapping("uploadFile")
    @ResponseBody
    public Map<String,Object> uploadFile(@RequestParam("file") MultipartFile file, HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            String originalFileName = file.getOriginalFilename();
            String url = AliyunOSSUtil.uploadFile(file.getInputStream(), originalFileName, "images");
            result.put("filePath",url);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

}

