package com.fh.util;

import java.io.*;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.*;

public class ExcelUtil {

    /**
     * 通过Java反射解析Excel文件获取数据集合
     * @param inputStream
     * @param cls
     * @param filedNameArr
     * @return
     */
    public static List analysisWorkbook(InputStream inputStream,Class cls,String[] filedNameArr) throws IOException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException, NoSuchFieldException {
        List list = new ArrayList();
        //将Excel文件输入流封装成一个工作簿
        XSSFWorkbook workbook = new XSSFWorkbook(inputStream);
        //获取工作簿中工作表的数量
        int numberOfSheets = workbook.getNumberOfSheets();
        for (int i = 0; i < numberOfSheets; i++) {
            //获取当前循环下标对应的工作表
            XSSFSheet sheet = workbook.getSheetAt(i);
            //获取当前工作表第一行的下标
            int firstRowNum = sheet.getFirstRowNum();
            //获取当前工作表最后一行的下标
            int lastRowNum = sheet.getLastRowNum();
            for (int j = firstRowNum + 1; j <= lastRowNum ; j++) {
                //创建Class对象对应的类的实例化对象
                //注意:传进来的Class对象对应的类必须提供一个公有无参构造函数
                Object obj = cls.getConstructor().newInstance();
                //获取当前循环对应的行
                XSSFRow dateRow = sheet.getRow(j);
                //["id","name","createDate","updateDate"]
                for (int k = 0; k < filedNameArr.length ; k ++) {
                    XSSFCell dataCell = dateRow.getCell(k);
                    Field field = cls.getDeclaredField(filedNameArr[k]);
                    field.setAccessible(true);
                    Class fieldType = field.getType();
                    if(fieldType == int.class || fieldType == Integer.class){
                         field.set(obj,(int)dataCell.getNumericCellValue());
                    }else if(fieldType == double.class || fieldType == Double.class){
                         field.set(obj,dataCell.getNumericCellValue());
                    }else if(fieldType == String.class){
                         field.set(obj,dataCell.getStringCellValue());
                    }else if(fieldType == Date.class){
                         field.set(obj,dataCell.getDateCellValue());
                    }

                }
                list.add(obj);
            }
        }
        return list;
    }


    /**
     * 使用Java反射机制生成工作簿
     * @param dataList
     * @param cls
     * @param headerNameArr
     * @param fieldNameArr
     * @param sheetName
     * @return
     */

    public static XSSFWorkbook generateWorkbook(List dataList,Class cls,String[] headerNameArr,String[] fieldNameArr,String sheetName) throws NoSuchFieldException, IllegalAccessException {
        //创建一个工作簿
        XSSFWorkbook workbook = new XSSFWorkbook();
        //创建一张工作表
        XSSFSheet sheet = workbook.createSheet(sheetName);
        //在工作表中创建表头行
        XSSFRow headerRow = sheet.createRow(0);
        //循环创建表头行中的每一个单元格
        for (int i = 0; i < headerNameArr.length; i++) {
            XSSFCell headerCell = headerRow.createCell(i);
            headerCell.setCellValue(headerNameArr[i]);
        }

        //创建一个日期格式的单元格样式
        XSSFCellStyle cellStyle = workbook.createCellStyle();
        XSSFDataFormat format = workbook.createDataFormat();
        cellStyle.setDataFormat(format.getFormat("yyyy年MM月dd日 HH:mm:ss"));


        //遍历数据集合，循环创建每一个数据行
        for (int i = 0; i < dataList.size(); i++) {
            XSSFRow row = sheet.createRow(i + 1);
            //获取当前遍历对象
            Object obj = dataList.get(i);

            //fieldNameArr:["id","name","createDate","updateDate"]
            for (int j = 0; j < fieldNameArr.length ; j ++) {
                //获取当前遍历对象对应的类的对应的属性
                Field field = cls.getDeclaredField(fieldNameArr[j]);

                //设置暴力访问
                field.setAccessible(true);
                Object value = field.get(obj);
                //获取当前属性的数据类型
                Class fieldType = value.getClass();
                XSSFCell dataCell = row.createCell(j);

                //根据当前遍历属性的数据类型去给创建出来的单元格赋不同类型的值
                if(fieldType == int.class || fieldType == Integer.class){
                    dataCell.setCellValue((Integer)value);
                }else if (fieldType == double.class || fieldType == Double.class){
                    dataCell.setCellValue((Double)value);
                }else if(fieldType == String.class){
                    dataCell.setCellValue((String)value);
                }else if(fieldType == Date.class){
                    dataCell.setCellValue((Date)value);
                    dataCell.setCellStyle(cellStyle);
                }else {
                    dataCell.setCellValue((String)value);
                }

            }
        }
        return workbook;
    }



    public static void excelDownload(XSSFWorkbook wirthExcelWB, HttpServletRequest request,HttpServletResponse response, String fileName) {
        OutputStream out = null;
        try {
        	
        	//解决下载文件名中文乱码问题
        	if(request.getHeader("User-agent").toLowerCase().indexOf("firefox")!=-1){
        		fileName = new String(fileName.getBytes("utf-8"),"iso-8859-1");
        	}else{
        		fileName = URLEncoder.encode(fileName,"utf-8");
        	}
        	
            out = response.getOutputStream();
            // 让浏览器识别是什么类型的文件
            response.reset(); // 重点突出
            response.setCharacterEncoding("UTF-8"); // 重点突出
            response.setContentType("application/x-msdownload");// 不同类型的文件对应不同的MIME类型
                                                                // // 重点突出
            // inline在浏览器中直接显示，不提示用户下载
            // attachment弹出对话框，提示用户进行下载保存本地
            // 默认为inline方式
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
            wirthExcelWB.write(out);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (null != out) {
                try {
                    out.close();
                    out = null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }


}
