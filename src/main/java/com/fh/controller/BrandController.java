package com.fh.controller;

import com.fh.model.Brand;
import com.fh.model.BrandQuery;
import com.fh.model.DataTableResult;
import com.fh.service.BrandService;
import com.fh.util.ExcelUtil;
import org.apache.poi.xssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Controller
@RequestMapping("BrandController")
public class BrandController {

    @Autowired
    private BrandService brandService;

    //跳转到品牌展示页面
    @RequestMapping("toBrandList")
    public String toUserList(){
        return "brand/brand-list";
    }


    //-------------------------------------------导出Excel-----------------------------------------------------

    //导出Excel
    @RequestMapping("exportExcel")
    public void exportExcel(HttpServletRequest request, HttpServletResponse response){
        List<Brand> brandList=brandService.queryBrandListNoPage();

        XSSFWorkbook workbook= new XSSFWorkbook();

        XSSFSheet sheet =workbook.createSheet("品牌列表");

        XSSFRow headerRow=sheet.createRow(0);

        String [] headerNameArr={"品牌id","品牌名称","品牌Logo","创建日期","修改日期"};
        int [] headerWidthArr={9*256,20*256,50*256,30*256,30*256};

        for (int i = 0;i<headerNameArr.length;i++){
            XSSFCell headerCell=headerRow.createCell(i);
            headerCell.setCellValue(headerNameArr[i]);
            sheet.setColumnWidth(i,headerWidthArr[i]);
        }
        XSSFCellStyle cellStyle2=workbook.createCellStyle();
        XSSFDataFormat format=workbook.createDataFormat();
        cellStyle2.setDataFormat(format.getFormat("yyyy年MM月dd日 HH:mm:ss"));
        //5.遍历循环
        for (int i=0;i<brandList.size();i++){
            Brand brand=brandList.get(i);
            XSSFRow dataRow=sheet.createRow(i+1);
            XSSFCell dataCell=dataRow.createCell(0);
            dataCell.setCellValue(brand.getId());
            XSSFCell dataCell2 =dataRow.createCell(1);
            dataCell2.setCellValue(brand.getName());

            XSSFCell filePathCell = dataRow.createCell(2);
            filePathCell.setCellValue(brand.getFilePath());
            XSSFCell createDateCell = dataRow.createCell(3);
            createDateCell.setCellValue(brand.getCreateDate());
            createDateCell.setCellStyle(cellStyle2);
            XSSFCell updateDateCell = dataRow.createCell(4);
            updateDateCell.setCellValue(brand.getUpdateDate());
            updateDateCell.setCellStyle(cellStyle2);
        }
        ExcelUtil.excelDownload(workbook,request,response, UUID.randomUUID().toString() + ".xlsx");
    }


    //导入Excel
    @RequestMapping("importExcel")
    @ResponseBody
    public Map<String,Object> importExcel(@RequestParam("file") MultipartFile file){
        Map<String,Object> result = new HashMap<>();
        try {
            //将用户上传的Excel文件封装成一个工作簿
            XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream());
            //获取工作簿中工作表的数量
            int number = workbook.getNumberOfSheets();
            for (int i = 0; i < number ; i++) {
                //获取当前循环下标对应的工作表
                XSSFSheet sheet = workbook.getSheetAt(i);
                //获取当前工作表中第一行的下标
                int firstRowNum = sheet.getFirstRowNum();
                //获取当前工作表中最后一行的下标
                int lastRowNum = sheet.getLastRowNum();
                List<Brand> brandList = new ArrayList<>();
                for (int j = firstRowNum + 1; j <= lastRowNum ; j ++ ) {
                    //获取当前循环下标对应的行
                    XSSFRow row = sheet.getRow(j);
                    //获取当前行每一个单元格的值
                    //第一个是Id不用获取 下标为0
                    String name = row.getCell(1).getStringCellValue();
                    String filePath = row.getCell(2).getStringCellValue();

                    Brand brand = new Brand();
                    brand.setName(name);
                    brand.setFilePath(filePath);

                    brandList.add(brand);
                }
                brandService.batchAddBrand(brandList);
            }
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //------------------------------------------增删改查----------------------------------------------------

    //分页条件查询品牌信息
    @RequestMapping("queryBrandList")
    @ResponseBody
    public DataTableResult queryBrandList(BrandQuery brandQuery){
        DataTableResult dataTableResult = brandService.queryBrandList(brandQuery);
        return dataTableResult;
    }


    //新增品牌
    @RequestMapping("addBrand")
    @ResponseBody
    public Map<String,Object> addBrand(Brand brand){
        Map<String,Object> result = new HashMap<>();
        try {
            brandService.addBrand(brand);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //修改品牌
    @RequestMapping("updateBrand")
    @ResponseBody
    public Map<String,Object> updateBrand(Brand brand){
        Map<String,Object> result = new HashMap<>();
        try {
            brandService.updateBrand(brand);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //通过ID查询单个品牌
    @RequestMapping("getBrandById")
    @ResponseBody
    public Map<String,Object> getBrandById(Integer id, HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            Brand brand = brandService.getBrandById(id);
            result.put("data",brand);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    @RequestMapping("deleteBrand")
    @ResponseBody
    public Map<String,Object> deleteBrand(Integer id,HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            brandService.deleteBrand(id);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    @RequestMapping("batchDeleteBrand")
    @ResponseBody
    public Map<String,Object> batchDeleteBrand(@RequestParam("ids[]") List<Integer> idList, HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            brandService.batchDeleteBrand(idList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    @RequestMapping("queryBrandListNoPage")
    @ResponseBody
    public Map<String,Object> queryBrandListNoPage(){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Brand> brandList = brandService.queryBrandListNoPage();
            result.put("data",brandList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


}
