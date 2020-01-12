package com.fh.util;

import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.UUID;

public class FileUtil {

    /**
     * 通过文件相对路径删除对应的文件
     * @param request
     * @param filePath
     */
    public static void deleteFile(HttpServletRequest request,String filePath){
        //获取项目发布在tomcat下的绝对路径
        String realPath = request.getServletContext().getRealPath("/");
        File file = new File(realPath + "/" + filePath);
        //exists方法用于判断一个文件(文件夹)是否存在，如果存在返回true,否则返回false
        if(file.exists()){
            file.delete();
        }
    }

    public static String uploadFile(HttpServletRequest request, MultipartFile file,String folderName) throws IOException {
        //1.获取项目部署在tomcat下的绝对路径(图片最终要上传的文件夹的绝对路径)
        String folderPath = request.getServletContext().getRealPath(folderName);

        //2.判断图片最终要上传的那个文件夹是否存在
        File folder = new File(folderPath);
        //如果该文件夹不存在则创建该文件夹
        if (!folder.exists()) {
            //创建文件夹
            folder.mkdir();
        }

        //3.给用户上传的图片进行重命名
        //3.1 获取用户上传的文件的后缀名
        //abc.jpg
        String suffix = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
        //3.2 生成一个新的文件名(UUID,时间戳)
        String newFileName = UUID.randomUUID().toString() + suffix;

        //4.调用springMVC自带的方法将用户上传的文件保存到指定的文件夹中
        file.transferTo(new File(folderPath + "/" + newFileName));

        return folderName + "/" + newFileName;
    }

    /**
     * 文件下载
     * @param file
     * @param fileName
     * @param response
     */
    public static void downloadFile(File file, String fileName,HttpServletRequest request, HttpServletResponse response) throws IOException {
        OutputStream os = response.getOutputStream();
        BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
        BufferedOutputStream bos = new BufferedOutputStream(os);
        //解决下载文件名中文乱码问题
        if(request.getHeader("User-Agent").toLowerCase().indexOf("firefox")!=-1){
            fileName = new String(fileName.getBytes("utf-8"),"iso-8859-1");
        }else{
            fileName = URLEncoder.encode(fileName,"utf-8");
        }
        response.reset(); // 重点突出
        response.setCharacterEncoding("UTF-8"); // 重点突出
        response.setContentType("application/x-msdownload");// 不同类型的文件对应不同的MIME类型
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
        //定义一个长度为4096的字节数组
        byte[] bytes = new byte[4096];
        //先读他个4096字节
        int read = bis.read(bytes);
        while(read > 0){
            bos.write(bytes,0,read);
            read = bis.read(bytes);
        }
        bos.close();
        bis.close();
    }
}
