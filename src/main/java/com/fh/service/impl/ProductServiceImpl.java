package com.fh.service.impl;

import com.fh.mapper.ProductMapper;
import com.fh.model.*;
import com.fh.service.ProductAttributeService;
import com.fh.service.ProductService;
import com.fh.service.ProductSkuService;
import com.fh.util.AliyunOSSUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private ProductSkuService productSkuService;

    @Autowired
    private ProductAttributeService productAttributeService;
    @Override
    public void addProduct(ProductInfo productInfo) {
        Product product = productInfo.getProduct();
        productMapper.addProduct(product);
        List<ProductAttribute> productAttributeList = productInfo.getProductAttributeList();
        for(ProductAttribute productAttribute : productAttributeList){
            productAttribute.setProductId(product.getId());
        }
        productAttributeService.batchAddProductAttribute(productAttributeList);
        List<ProductSku> productSkuList = productInfo.getProductSkuList();
        for(ProductSku productSku : productSkuList){
            productSku.setProductId(product.getId());
        }
        productSkuService.batchAddProductSku(productSkuList);
    }

    @Override
    public DataTableResult queryProductList(ProductQuery productQuery) {

        //1.查询总数
        Long count = productMapper.queryProductCount(productQuery);

        //2.查询当前页数据
        List<Product> productList = productMapper.queryProductList(productQuery);

        DataTableResult dataTableResult = new DataTableResult(productQuery.getDraw(),count,count,productList);

        return dataTableResult;

    }

    @Override
    public void deleteProduct(Integer id) {
        productMapper.deleteProduct(id);
        productSkuService.deleteSkuByProductId(id);
        productAttributeService.deleteAttributeByProductId(id);
    }

    @Override
    public void batchDeleteProduct(List<Integer> idList) {
        productMapper.batchDeleteProduct(idList);
        productSkuService.batchDeleteSkuByProductId(idList);
        productAttributeService.batchDeleteAttributeByProductId(idList);
    }

    @Override
    public ProductInfo getProductById(Integer id) {
        Product product = productMapper.getProductById(id);
        List<ProductSku> productSkuList = productSkuService.queryProductSkuListByProductId(id);
        List<ProductAttribute> productAttributeList = productAttributeService.queryProductAttributeListByProductId(id);
        ProductInfo productInfo = new ProductInfo();
        productInfo.setProduct(product);
        productInfo.setProductSkuList(productSkuList);
        productInfo.setProductAttributeList(productAttributeList);
        return productInfo;
    }

    @Override
    public void updateProduct(ProductInfo productInfo) {


        Product product = productInfo.getProduct();

        //1.通过商品ID从数据库获取单个商品信息
        Product oldProduct = productMapper.getProductById(product.getId());
        //如果用户在修改商品时上传了新的商品主图
        if(!product.getFilePath().equals(oldProduct.getFilePath())){
            AliyunOSSUtil.deleteFile(oldProduct.getFilePath());
        }
        productMapper.updateProduct(product);

        //通过商品id删除该商品之前的所有属性
        productAttributeService.deleteProductAttributeByProductId(product.getId());
        //通过商品id删除该商品之前的所有SKU
        productSkuService.deleteProductSkuByProductId(product.getId());

        List<ProductAttribute> productAttributeList = productInfo.getProductAttributeList();
        for(ProductAttribute productAttribute : productAttributeList){
            productAttribute.setProductId(product.getId());
        }
        productAttributeService.batchAddProductAttribute(productAttributeList);
        List<ProductSku> productSkuList = productInfo.getProductSkuList();
        for(ProductSku productSku : productSkuList){
            productSku.setProductId(product.getId());
        }
        productSkuService.batchAddProductSku(productSkuList);
    }
}
